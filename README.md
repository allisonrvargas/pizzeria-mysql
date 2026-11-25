# 🍕 Base de Datos de una Pizzería · MySQL

[![CI](https://github.com/allisonrvargas/pizzeria-mysql/actions/workflows/ci.yml/badge.svg)](https://github.com/allisonrvargas/pizzeria-mysql/actions/workflows/ci.yml)
[![Licencia: MIT](https://img.shields.io/badge/licencia-MIT-green.svg)](LICENSE)

Base de datos en **MySQL** para una pizzería: clientes, productos, ingredientes, categorías, combos, pedidos y adiciones personalizadas (11 tablas). Incluye el modelo lógico y físico, y consultas para analizar las ventas del negocio.

**Script completo:** [`allis.sql`](allis.sql)

**Temas:** modelado relacional · `JOIN` · `GROUP BY` · funciones de agregación (`SUM`, `COUNT`)

> Proyecto final del módulo de bases de datos · Allison Rocío Vargas Mejía

## Cómo ejecutarlo

Requiere MySQL 8. Con Docker:

```bash
docker run --name pizzeria-mysql -e MYSQL_ROOT_PASSWORD=root -p 3306:3306 -d mysql:8.0
# espera unos segundos a que arranque y luego:
docker exec -i pizzeria-mysql mysql -uroot -proot < allis.sql
```

O con un MySQL local: `mysql -u root -p < allis.sql`. El script crea la base `pizzeria` con sus 11 tablas y los datos de ejemplo; el CI de este repositorio lo ejecuta en cada cambio.

# Diagramas

Modelo lógico y modelo físico 


![Modelo lógico](image.png)


![Modelo físico](image-21.png)




# Consultas realizadas


    1. Productos más vendidos (pizza, panzarottis, bebidas, etc.)

![Resultado de la consulta](image-1.png)


    2. Total de ingresos generados por cada combo

![Resultado de la consulta](image-2.png)

    3. Pedidos realizados para recoger vs. comer en la pizzería
![Resultado de la consulta](image-3.png)

    4. Adiciones más solicitadas en pedidos personalizados
![Resultado de la consulta](image-4.png)

    5. Cantidad total de productos vendidos por categoría
![Resultado de la consulta](image-5.png)

    6. Promedio de pizzas pedidas por cliente
![Resultado de la consulta](image-6.png)

    7. Total de ventas por día de la semana
![Resultado de la consulta](image-7.png)

    8. Cantidad de panzarottis vendidos con extra queso
![Resultado de la consulta](image-8.png)

    9. Pedidos que incluyen bebidas como parte de un combo
![Resultado de la consulta](image-10.png)
No me salio ninguna consulta ya que no se hizo ningun pedido que incluyera bebidas como parte del combo 

    10. Clientes que han realizado más de 5 pedidos en el último mes

![Resultado de la consulta](image-11.png)
No me salio ninguna consulta ya que no se realizaron màs  de 5 pedidos en el ùltimo mes

    11. Ingresos totales generados por productos no elaborados (bebidas, postres, etc.)
![Resultado de la consulta](image-12.png)

    12. Promedio de adiciones por pedido
![Resultado de la consulta](image-13.png)

    13. Total de combos vendidos en el último mes
![Resultado de la consulta](image-14.png)

    14. Clientes con pedidos tanto para recoger como para consumir en el lugar
![Resultado de la consulta](image-15.png)

    15. Total de productos personalizados con adiciones
![Resultado de la consulta](image-16.png)

    16. Pedidos con más de 3 productos diferentes
![Resultado de la consulta](image-17.png)

    17. Promedio de ingresos generados por día
![Resultado de la consulta](image-18.png)

    18. Clientes que han pedido pizzas con adiciones en más del 50% de sus pedidos
![Resultado de la consulta](image-9.png)

    19. Porcentaje de ventas provenientes de productos no elaborados
![Resultado de la consulta](image-19.png)

    20. Día de la semana con mayor número de pedidos para recoger

![Resultado de la consulta](image-20.png)
