# Mercadolibre Mobile Test
### By: Juan Felipe Méndez

1. [Ejecutar la aplicación](#ejecutar-la-aplicacion)
2. [Flujo de la aplicación](#flujo-de-la-aplicacion)
3. [Arquitecutra propuesta](#arquitectura-prpuesta)
    3.1. [Modelos](#modelos)
    3.2. [Controladores](#controladores)
    3.3. [Vistas](#vistas)
    3.4. [Networking](#networking)
    3.5. [Otros archivos](#otros-archivos)
4. [Pruebas Unitarias](#pruebas-unitarias)
5. [Dependencias Utilizadas](#dependencias-utilizadas)
6. [Dudas o Preguntas](#dudas-o-preguntas)

## Ejecutar la aplicación

Para ejecutar la aplicación es necesario contar con ```swiftlint``` instalado localmanete. En caso de no contar con el, se puede instalar corriendo el siguiente comando

```brew install swiftlint```

Alternivativamente, se puede remover el script de las configuraciones del proyecto, el cual verifica la existencia del linter y lo ejecuta. Para removerlo es necesario seguir las siguientes instrucciones.

1. Seleccionar el Target ```meli-technical-test```

![select target step](https://github.com/jfmendez11/meli-technical-test/RunScriptDelete/main/select-target.png?raw=true)

2. Ir a la pestaña de ```Build Phases``` y remover el ```Run Script```

![delete run script step](https://github.com/jfmendez11/meli-technical-test/RunScriptDelete/main/delete-run-script.png?raw=true)

Luego de realizar estos pasos, es posible correr la aplicación desde el simulador o un dispositivo físico, sin la necesidad de instalar ```swiftlint```.

**Nota:** Para correr la aplicación es necesario tener instalado Xcode 12.3 mínimo o iOS 14.3 si se corre en un dispositivo físico. Asegurarse de gestionar correctamente el perfil en la sección de Signing and Capabilites.


## Flujo de la aplicación

La aplicación consiste de un ```UINavigationController```, el cual gestiona la navgación entre las diferentes vistas.

La vista incial, carga todas las las categorías de un site (en este caso MLA) y da la posibilidad al usuario de filtrar su búsqueda por categoría. De igual froma, la aplicación permite al usuario cambiar la apariencia de la misma en esta vista (dark mode o light mode).

Luego de seleccionar la categoría, o dar click en barra de búsqueda, se le mostrará al usuario los resultados de la búsqueda con cierta información de los artículos.

Finlamente, es posible observar cada producto más en detalle, al seleccionar el deseado. En esta vista, también se le muestra al usuarios algunos productos del mismo vendedor y de la misma categoría.

## Arquitecutra propuesta

La arquitectura utilizada en el desarrollo de la prueba fue MVC, ya que no es una aplicación muy grande y es la arquitectura propuesta por Apple para el uso de ```UIKit```. De igual forma, se utilizó el delegate pattern para la actualización de vistas con la respuesta de los diferentes servicios consumidos.

### Modelos

En teoría se cuenta con dos modelos, dado que se realizan peticiones a dos endpoints diferentes. No obstante, el modelo con respecto a los ```Items``` está separado en diferentes archivos, para una mayor legibilidad del código.

Los ```Items``` cuentan con toda la información relevante de un producto, es decir, toda la información que es utilizada a través de la aplicación para presentar los productos de la busqueda y el detalle del mismo. Las categorías simplemente cuentan con su ```id``` y ```name```.

Los modelos están disponibles en las siguientes carpetas.
.
  ├── ...
  ├── Models 
  │   ├── Category.swift 
  │   ├── Item.swift 
  │   └── Seller.swift 
  └── ...

Finalmente, todos los modelos se conforman al protocolo ```Codable```.

### Controladores

Cada controlador tiene una instancia de su respectivo modelo y una instancia del ```worker``` que hace las peticiones dependiendo del endpoint, así como una instancia del ```Router```, el cual es el encargado de la navegación entre vistas, principalmente de crear nuevas vistas y agregarlas al stack (ya que volver a la anterior vista la realiza por defecto el ```UINavigationController```).

Los controladores están disponibles en las siguientes carpetas.
.
  ├── ...
  ├── Controllers 
  │   ├── BaseViewController.swift 
  │   ├── CategoriesViewController.swift 
  │   └── SearchViewController.swift 
  │   └── ProductViewController.swift 
  └── ...

Todos los controladores heredan de ```BaseViewController``` el cual contiene toda la configuración común de todos los controladores.

### Vistas

Cada controllador tiene su respectivo archivo ```.storyboard```, los cuales fueron utilizados para crear las vistas. 

Así mismo, se tienen diferentes vistas que fueron utilizadas a través de la aplicación, tales como las celdas de los diferentes ```UITableView``` y  ```UICollectionView```, una vista creada para manejar empty states en las búsquedas y la vista del detalle del producto.

Para el detalle del producto, se utilizó un ```UITableViewCell``` con el fín de aprovechar la utilidad del dimensionamiento automático de las ```UITableView``` ( ```UITableView.automaticDimension```).

Las vistas están disponibles en las siguientes carpetas.
.
  ├── ...
  ├── Views 
  │   ├── Cells
  │             ├── ProductTableViewCell.swift 
  │             ├── ProductTableViewCell.xib 
  │             ├── ProductCollectionViewCell.swift 
  │             ├── ProductCollectionViewCell.xib 
  │   ├── ProductDetail
  │             ├── ProductDetailView.swift 
  │             ├── ProductDetailView.xib 
  │   └── EmptyState
  │             ├── EmptyStateView.swift 
  │             ├── EmptyStateView.xib 
  │   └── Storyboards
  │             ├── LaunchScreen.storyboard 
  │             ├── Categories.storyboard 
  │             ├── Search.storyboard 
  │             ├── Product.storyboard 
  └── ...

### Networking

Para realizar todas las peticiones a los diferente servicios expuestos por el API de MercadoLibre, se utilizaron 2 componentes. El primero es el ```APIClient```. En este, se crean las peticiones con base en un ```Endpoint``` que entra como parámetro y se ejecuta un closure que también entra como parámetro luego de que la petición haya culminado.

Este se puede ver en la siguiente carpeta.

.
  ├── ...
  ├── NetworkManager 
  │   ├── APIClient.swift 
  └── ...

El segundo componente, es precisamente el ```Endpoint```. Este es un protocolo con toda la información relevante del endpoint (método HTTP, ruta, host, scheme, parámetros, tipo de petición). Para cada subpath (```/categories``` y ```/search/q```), se creó un ```enum``` con los diferentes endpoints utilizados en la prueba. A estos, se les configura los parámetros de búsqueda, el tipo de método HTTP y el tipo de petición.

Están visibles en la siguiente carpeta.

.
  ├── ...
  ├── NetworkManager 
  │   ├── API
  │             ├── Endpoint.swift 
  │             ├── SearchAPI.swift 
  │             ├── CategoriesAPI.swift 
  └── ...

Como se mencionó anteriormente, por cada ```Endpoint``` hay un ```worker``` y este es el puente entre los controladores y el ```APIClient```.

Finalmente, se implementó un ```enum``` con posibles errores, ya sean de red, de la peticón o de la decodificación del response al modelo. 

Este se puede observar en la siguiente carpeta.

.
  ├── ...
  ├── NetworkManager 
  │   ├── ServiceError.swift 
  └── ...

### Otros archivos

En las carpetas ```SupportFiles```, ```Utils``` y ```Resources``` se pueden encotnrar diferentes archivos para facilitar el desarrollo de la preuba.

Por un lado, ```SupporFiles``` contiene archivos que ayudan con la creación de controladores y vistas a partir de archivos ```.xib``` y ```.storyboard```.

La carpeta ```Utils``` contiene las extensiones a algunas clases de ```UIKit``` y ```Foundation``` así como el servicio de logs utilizado en el proyecto y las constantes utilizadas en el mismo.

La carpeta ```Resources``` contiene los colores e imágenes utilizadas en el proyecto.

## Pruebas Unitarias

Se realizaron pruebas unitarias a los diferentes modelos establecidos en el proyecto. Para esto se adicionaron unos archivos JSON, con respuestas de Categorías r Ítems, de manera que fuera posible probar las consistencia del modelo.

## Dependencias Utilizadas

Como manejador de dependencias, se utilizó Swift Package Manager (SPM). Con este, se instaló una sola dependencia: ![```SkeletonView```](https://github.com/Juanpe/SkeletonView)

La dependencia es únicamente utilizada para animar las diferentes vistas con un skeleton, mientras las peticiones HTTP responden. Solo es implementado en las vistas que realizas peticiones HTTP.

![SkeletonView Example](https://raw.githubusercontent.com/Juanpe/SkeletonView/develop/Assets/solid.png)

## Dudas o Preguntas

Ante cualquier duda, pregunta o comentario no dude en contactarme vía email.
