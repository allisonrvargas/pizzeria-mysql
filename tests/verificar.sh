#!/usr/bin/env bash
# Verifica la base "pizzeria" después de ejecutar allis.sql. Uso: tests/verificar.sh
# Variables opcionales: MYSQL_HOST (127.0.0.1), MYSQL_USER (root), MYSQL_PWD (root)
set -u
HOST="${MYSQL_HOST:-127.0.0.1}"; USER="${MYSQL_USER:-root}"; export MYSQL_PWD="${MYSQL_PWD:-root}"
fallos=0
q() { mysql -h "$HOST" -u "$USER" -N -B pizzeria -e "$1"; }
espera() {  # espera <descripción> <valor esperado> <consulta>
  local real; real="$(q "$3")"
  if [ "$real" = "$2" ]; then echo "ok   $1 ($real)"; else echo "FALLA $1: esperado '$2', obtenido '$real'"; fallos=$((fallos+1)); fi
}

# 1. Estructura y datos de ejemplo
espera "11 tablas" 11 "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='pizzeria'"
for t in customer category product ingredient topping combo combo_detail order_header order_detail order_detail_topping; do
  espera "la tabla $t tiene datos" 1 "SELECT COUNT(*) > 0 FROM $t"
done

# 2. Integridad: ningún registro huérfano
espera "pedidos con cliente" 0 "SELECT COUNT(*) FROM order_header o LEFT JOIN customer c USING (customer_id) WHERE c.customer_id IS NULL"
espera "detalles con pedido" 0 "SELECT COUNT(*) FROM order_detail d LEFT JOIN order_header o USING (order_id) WHERE o.order_id IS NULL"
espera "cada detalle es un producto O un combo" 0 "SELECT COUNT(*) FROM order_detail WHERE (product_id IS NULL) = (combo_id IS NULL)"
espera "precios y cantidades positivos" 0 "SELECT COUNT(*) FROM order_detail WHERE quantity <= 0 OR unit_price < 0"

# 3. Resultados de las consultas del proyecto que no dependen de la fecha
espera "productos vendidos por categoría" "Bebida:1,Panzarotti:3,Pizza:4" "SELECT GROUP_CONCAT(CONCAT(category_name,':',total) ORDER BY category_name) FROM (SELECT c.category_name, SUM(od.quantity) AS total FROM order_detail od JOIN product p ON od.product_id=p.product_id JOIN category c ON p.category_id=c.category_id GROUP BY c.category_id, c.category_name) t"
espera "promedio de pizzas por cliente" 2.0000 "SELECT AVG(n) FROM (SELECT SUM(od.quantity) AS n FROM order_detail od JOIN product p ON od.product_id=p.product_id JOIN category c ON p.category_id=c.category_id JOIN order_header oh ON od.order_id=oh.order_id WHERE c.category_name='Pizza' GROUP BY oh.customer_id) t"
espera "adiciones más pedidas" "Salsa de Ajo:3,Extra Queso:2" "SELECT GROUP_CONCAT(CONCAT(topping_name,':',total) ORDER BY total DESC, topping_name SEPARATOR ',') FROM (SELECT t.topping_name, SUM(odt.quantity) AS total FROM order_detail_topping odt JOIN topping t ON odt.topping_id=t.topping_id GROUP BY t.topping_id, t.topping_name) x"

# 4. La consulta 9 (pedidos con bebidas dentro de un combo) debe ejecutarse sin error
if q "SELECT DISTINCT od.order_id, c.combo_name FROM order_detail od JOIN combo c ON od.combo_id = c.combo_id JOIN combo_detail cd ON c.combo_id = cd.combo_id JOIN product p ON cd.product_id = p.product_id JOIN category cat ON p.category_id = cat.category_id WHERE cat.category_name = 'Bebida'" >/dev/null; then echo "ok   consulta 9 se ejecuta"; else echo "FALLA consulta 9"; fallos=$((fallos+1)); fi

# 5. Las restricciones rechazan datos inválidos
if q "INSERT INTO order_header (customer_id, delivery_type) VALUES (999999, 'Pickup')" 2>/dev/null; then echo "FALLA aceptó un pedido de un cliente inexistente"; fallos=$((fallos+1)); else echo "ok   rechaza un pedido de un cliente inexistente"; fi
if q "INSERT INTO order_header (customer_id, delivery_type) SELECT customer_id, 'Delivery' FROM customer LIMIT 1" 2>/dev/null; then echo "FALLA aceptó un tipo de entrega inválido"; fallos=$((fallos+1)); else echo "ok   rechaza un tipo de entrega inválido"; fi

echo; [ "$fallos" -eq 0 ] && echo "Todas las verificaciones pasaron" || { echo "$fallos verificación(es) fallaron"; exit 1; }