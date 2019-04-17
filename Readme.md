# Aplicación de información de películas

Aplicación de información de películas que utiliza la API de la base de datos de películas (TMDb - https://www.themoviedb.org) para listar películas populares, mejores rankeadas, próximas y buscar películas por títulos.

# Arquitectura de la aplicación y librerías utilizadas
El código de la aplicación sigue el patrón arquitectónico MVVM y utiliza las librerías RxSwift y RxCocoa (https://github.com/ReactiveX/RxSwift) para establecer la comunicación y bindeos necesarios entre views y viewModels.
Para la capa de networking, se utiliza la librería de Alamofire (https://github.com/Alamofire) que también provee algunas clases de utilidad que simplifican el manejo de caché de imagenes.

Las caraterísticas generales del patrón MVVM son las siguientes:

Toda la transformación de datos necesaria para representar los datos del modelo de una aplicación en las vistas (Views) será implementada por los ViewModels y expuestas al ViewController como propiedades. La responsabilidad del ViewController es configurar el binding de las propiedades del viewModel a las views y enviar toda la acción proveniente de una view de nuevo al ViewModel. De esta manera, el estado de la aplicación siempre estará sincronizado entre las Views y los ViewModels.

Las reglas que propone el patrón MVVM son:
1. Todo Modelo es propiedad del ViewModel e ignora la existencia del ViewModel.
2. Todo ViewModel es propiedad del ViewController e ignora la existencia del ViewController.
3. El ViewController es propietario del ViewModel y no debe conocer nada respecto del modelo.

Los beneficios del patrón a desctacar son:
* Provee una buena encapsulación de la lógica de negocios y la transformación de datos del modelo.
* Facilita la creación de test unitarios de buena cobertura.
* Los ViewController resultan más livianos en comparación con el patrón MVC.

## Listado de clases de aplicación agrupados por responsabilidades:
#### ViewControllers: controladores de vistas.
* MovieCollectionViewController: es el componente que muestra los listados de películas populares, mejores rankeadas, próximas. 
* MovieSearchViewController: es el componente que muestra los resultados de la búsqueda por títulos de peliculas
* MovieDetailViewController: es el componente que muestra el detalle de una película

#### Views: se encuentran en el storyboard principal Main.storyboard y dentro de la carpeta Cells/

#### ViewModels: encargados de realizar las consultas sobre el repositorio de peliculas y efectuar el formateo necesario para mostrar los modelos en las diferentes vistas.
* MovieCollectionViewModel
* MovieCollectionItemViewModel
* MovieDetailViewModel
* MovieSearchViewModel
* CastMemberItemViewModel

#### Capa de red: consultas a la API. 
* TMDbService: se define el procolo de consultas a la API.  Observarción: algunos viewmodels en su inicializador reciben una instancia de un objeto que implementa el protocolo TMDbService que define las consultas sobre la DB (de esta forma se injecta la dependencia via inicializador).
* TMDbRepository: es el repositorio de películas, provee una implementación del TMDbService

#### Modelos:
* TMDbMovie: contiene todos los modelos que sirven ademas como DTO (data-transfer objects) para almacenar los datos de la API.


## TODOs:
1. Capa de persistencia y funcionamiento offline.
2. Agregar mas info en el MovieDetailViewController y visualización de videos.
3. Agregar Unit tests.

# Preguntas:

1. En qué consiste el principio de responsabilidad única? Cuál es su propósito?

Establece que cada módulo o clase debe tener responsabilidad sobre una sola parte de la funcionalidad proporcionada por el software, y esta responsabilidad debe estar encapsulada en su totalidad por la clase. 
El propósito de esta regla es que el código quede lo suficientemente modularizado para que cuando se necesite aplicar algún cambio se pueda realizar con la menor cantidad de componentes afectados posible. A su vez, una buena división de responsabilidades resulta en un código mas testeable y seguro.

2. Qué características tiene, según su opinión, un “buen” código o código limpio:

Debe seguir un estilo arquitectónico que contemple:
1. Buena distribución de responsabilidades entre entidades con roles estrictos y siguiendo los principios SOLID.
1. Testeabilidad: poseer fácil predisposición y covertura con Unit-Test lo cuál ayuda a prevenir errores en runtime y a introducir nuevos cambios de forma segura (este punto esta fuertemente ligado al primero).
1. Bajo costo de mantenimiento: facilidad para introducir nuevos cambios.
