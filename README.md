# PA1 — Sistema de ventas e inventario para una tienda de ropa

**Curso:** Programación Avanzada de Base de Datos (30627)  
**Evaluación:** PA1 — Proceso de Aprendizaje 1  
**Motor de base de datos:** Microsoft SQL Server

## Integrantes

| Integrante | Participación |
| --- | --- |
| Andy [completar apellidos] | Modelo de datos, relaciones y diagrama. |
| Lucero [completar apellidos] | Creación de tablas y pruebas de restricciones. |
| Farid [completar apellidos] | Consultas básicas, funciones y agregaciones. |
| Fernando [completar apellidos] | Consultas multitabla, `CASE` y `UNION`. |
| Jorge Campoblanco | Subconsultas, `EXISTS` y documentación. |

> Antes de entregar, completen los nombres y apellidos tal como figuran en la lista del grupo.

## Descripción

Una tienda de ropa necesita organizar sus clientes, categorías, productos y ventas, y consultar la información sin perder la relación entre los datos. El proyecto implementa una base de datos relacional en SQL Server para registrar esas operaciones y responder preguntas sobre productos, inventario y ventas.

## Objetivo

Crear un modelo físico con relaciones y restricciones que preserve la integridad de los registros, insertar datos de prueba y obtener información útil mediante consultas simples, agrupadas, multitabla y subconsultas.

## Desarrollo

Se definieron cinco tablas: `Cliente`, `Categoria`, `Producto`, `Venta` y `DetalleVenta`. Una categoría agrupa productos; un cliente puede tener varias ventas; y `DetalleVenta` relaciona cada venta con los productos comprados. Las claves primarias identifican los registros y las claves foráneas mantienen sus relaciones.

En las tablas se aplicaron `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `DEFAULT` y `CHECK`. Por ejemplo, el DNI es único, el precio debe ser mayor que cero, el stock no puede ser negativo y el estado de una venta solo puede ser `PENDIENTE`, `PAGADA` o `ANULADA`. El archivo de inserciones contempla 9 clientes, 5 categorías, **15 productos**, 12 ventas y 24 detalles de venta. Irene Salazar no tiene ventas, y `Cinturon Clasico` tiene stock 0 para comprobar las consultas que identifican productos agotados.

La arquitectura utilizada es cliente/servidor: SQL Server almacena y procesa los datos, mientras SQL Server Management Studio (SSMS) permite enviar las instrucciones SQL y consultar sus resultados. Se prepararon datos y casos de prueba para observar tanto resultados válidos como el rechazo de registros que incumplen las restricciones.

## Solución propuesta

| Parte | Archivo | Qué permite comprobar |
| --- | --- | --- |
| Modelo físico | [`bd/01_modelo_PA1_TiendaRopa.sql`](bd/01_modelo_PA1_TiendaRopa.sql) y [diagrama](diagrama/modelo_tienda_ropa.png) | Tablas, campos, relaciones y claves. Este script recrea las tablas y se conserva como referencia del modelo. |
| Creación de tablas | [`bd/CREACION DE TABLAS.sql`](bd/CREACION%20DE%20TABLAS.sql) | Definición de las cinco tablas y sus restricciones. |
| Datos de prueba | [`bd/INSERTS.sql`](bd/INSERTS.sql) | Registros relacionados, un cliente sin ventas y un producto con stock 0. |
| Integridad | [`bd/RESTRICCIONES.sql`](bd/RESTRICCIONES.sql) | Intentos de inserción que deben fallar por `UNIQUE`, `CHECK` o `FOREIGN KEY`. |
| Selección y agrupación | [`Consultas básicas/consultas-basicas.sql`](Consultas%20b%C3%A1sicas/consultas-basicas.sql) | `LIKE`, `BETWEEN`, `IN`, funciones de cadena, números y fechas, agregaciones, `GROUP BY` y `HAVING`. |
| Consultas multitabla | [`bd/CONSULTAS AVANZADAS Y UNIONES.sql`](bd/CONSULTAS%20AVANZADAS%20Y%20UNIONES.sql) | `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`, `CASE`, `UNION` y `UNION ALL`. |
| Subconsultas | [`bd/subconsultas_exists.sql`](bd/subconsultas_exists.sql) | Productos con precio superior al promedio y clientes con al menos una venta mediante `EXISTS`; se muestra también una alternativa con `INNER JOIN`. |

Los filtros permiten localizar productos por nombre o rango de precio. Las agregaciones resumen precios y existencias por categoría. `INNER JOIN` reúne registros que sí tienen relación; `LEFT JOIN` permite mostrar incluso a Irene, que no tiene ventas. `CASE` clasifica el stock, incluido el producto agotado. La subconsulta compara cada precio con el promedio de `Producto`, mientras `EXISTS` comprueba si hay alguna venta relacionada con un cliente. La alternativa con `INNER JOIN` también obtiene clientes con ventas, pero necesita `DISTINCT` para evitar repetir a quienes compraron varias veces.

## Cómo ejecutar o revisar el proyecto

1. Abrir Microsoft SQL Server Management Studio y conectarse a una instancia de SQL Server.
2. Crear una base de datos vacía llamada `PA1_TiendaRopa` si todavía no existe. También se incluye [`bd/PA1_TiendaRopa.bak`](bd/PA1_TiendaRopa.bak) como respaldo alternativo para restauración; **no mezclar la restauración con la creación y carga de tablas en la misma base**.
3. En una base vacía, ejecutar **solo** [`bd/CREACION DE TABLAS.sql`](bd/CREACION%20DE%20TABLAS.sql) para crear las tablas. No ejecutar también `01_modelo_PA1_TiendaRopa.sql`: ese archivo contiene otra creación de las mismas tablas y sentencias `DROP TABLE` que eliminan datos existentes.
4. Ejecutar [`bd/INSERTS.sql`](bd/INSERTS.sql) una sola vez, en una base sin esos datos. Sus últimos `SELECT` permiten revisar los registros cargados.
5. Ejecutar los archivos de consultas básicas, avanzadas y subconsultas por separado. Para comprobar el producto agotado, consultar `Producto` con `WHERE Stock = 0` y ejecutar la consulta `CASE` sobre stock del archivo de consultas avanzadas.
6. Ejecutar las instrucciones de [`bd/RESTRICCIONES.sql`](bd/RESTRICCIONES.sql) **por separado**. Los errores de esas inserciones son esperados: demuestran que las restricciones impiden datos inválidos.

**Nota:** editar los archivos SQL del repositorio no modifica por sí solo una base ya cargada ni actualiza el archivo `.bak`. El respaldo debe corresponder a la versión que se presente como final.

## Evidencias

### Diagrama de la base de datos

![Modelo de la tienda de ropa](diagrama/modelo_tienda_ropa.png)

### Consultas básicas y sus resultados

**Búsqueda de productos con LIKE**

![Consulta LIKE](Consultas%20b%C3%A1sicas/Evidencias%20de%20las%20consultas/Consulta%20Like-producto.jpg)

**Productos dentro de un rango de precios con BETWEEN**

![Consulta BETWEEN](Consultas%20b%C3%A1sicas/Evidencias%20de%20las%20consultas/Consulta%20between-producto.jpg)

**Filtro por estado de venta**

![Consulta de estado](Consultas%20b%C3%A1sicas/Evidencias%20de%20las%20consultas/Consulta%20filtro%20estado.jpg)

**Funciones de texto: UPPER, CONCAT y LEN**

![Funciones de texto](Consultas%20b%C3%A1sicas/Evidencias%20de%20las%20consultas/Consulta%20upper-concat-len.jpg)

**Funciones de redondeo: ROUND, CEILING y FLOOR**

![Funciones de redondeo](Consultas%20b%C3%A1sicas/Evidencias%20de%20las%20consultas/consulta%20round-ceiling-floor.jpg)

**Funciones de fecha: DATEPART y DATEDIFF**

![Funciones de fecha](Consultas%20b%C3%A1sicas/Evidencias%20de%20las%20consultas/Consulta%20Datepart-DIFF.jpg)

**Agregaciones: promedio, máximo y mínimo**

![Funciones de agregación](Consultas%20b%C3%A1sicas/Evidencias%20de%20las%20consultas/Consulta%20Precio-promedio-max-min-avg.jpg)

**Agrupación y filtro con HAVING**

![Consulta HAVING](Consultas%20b%C3%A1sicas/Evidencias%20de%20las%20consultas/Consulta%20Having.jpg)

Las consultas de restricciones, uniones, subconsultas y stock 0 están disponibles en sus respectivos scripts. Sus capturas de ejecución se pueden añadir a esta sección cuando el equipo las prepare.

## Conclusiones

El modelo relaciona clientes, productos y ventas mediante claves que permiten consultar los datos sin duplicar su estructura. Las restricciones rechazan registros inválidos y los datos de prueba permiten comprobar casos como un cliente sin ventas y un producto sin existencias. Las consultas con filtros, agrupación, uniones y subconsultas responden preguntas distintas sobre la tienda; comparar `EXISTS` con `INNER JOIN` ayuda a entender por qué una misma necesidad puede resolverse de varias maneras.

## Video de exposición

**Video público de YouTube:** [PEGAR AQUÍ EL ENLACE]

En la exposición se presenta el problema, el modelo, las pruebas de integridad, las consultas y sus resultados. Cada integrante explica su parte y cómo se relaciona con los contenidos trabajados en las sesiones 1 a 4.
