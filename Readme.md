# iOS Movies App

A sample app that uses TMDb API (https://www.themoviedb.org) to show popular, upcoming, top rated movies and 
search for movies by titles.

#### Pre-requisites to run the project
* Xcode 10.2.1 and later
* Cocoapod 1.6.1 and later
* Create an account on TMDb and generate an API_KEY, then replace the apiKey constant value on TMDbRequest.swift

# Architecture and libraries
The code follows the MVVM architectural pattern and uses the RxSwift and RxCocoa libraries (https://github.com/ReactiveX/RxSwift) to configure the bindings between views and view models. On the network layer, uses Alamofire library (https://github.com/Alamofire).

The general characteristics of the MVVM pattern are the following:

All the transformation of the data necessary to represent the model's data into the app's views will be implemented by the ViewModels and exposed to the ViewController as properties. The responsibility of ViewController is to bind the properties of viewModel to the views and redirects all the user interactions to the ViewModel. In this way, the state of the application will always be synchronized between the Views and the ViewModels.

The main rules proposed by the MVVM pattern are:
1. Every Model is owned by a ViewModel and ignores the existence of the ViewModel.
2. Every ViewModel is owned by a ViewController and ignores the existence of the ViewController.
3. The ViewController owns the ViewModel and mustn't know anything about the model.

The key benefits of the pattern are:
* Provides a good encapsulation of the business logic and the model's data-transformation.
* Facilitates the creation of unitary tests.
* The ViewControllers are lighter compared to the MVC pattern (so you can avoid the so called `Massive ViewController` problem).

## List of application classes grouped by responsibilities:
#### ViewControllers:
* MovieCollectionViewController: shows the listings of popular movies, top rated and upcoming.
* MovieSearchViewController: shows the results of the search for movie titles.
* MovieDetailViewController: shows the detail of a movie.

#### Views: found in the Main Main Storyboard and within the Cells / folder

#### ViewModels: responsible for making queries using the film repositories and perform the necessary formatting to show the models in the different views.
* MovieCollectionViewModel
* MovieCollectionItemViewModel
* MovieDetailViewModel
* MovieSearchViewModel
* CastMemberItemViewModel

#### Network layer: API queries.
* TMDbService: defines the API query protocol. Important note: some ViewModels receives as initializer's input an instance of an object that implements the TMDbService protocol that defines the queries on the database (in this way the dependency is injected through the initializer).
* TMDbRepository: is the movie repository, provides an implementation of the TMDb service.

#### Persistence layer and offline behaviour:
The offline behavior is provided through the iOS's URLCache class. It is initialized with 20 mb of memory capacity in RAM and with 100 mb on disk. All requests made to the TMDb API are cached by default, and stored with the date validity parameters provided by the same API. In this way, when the device does NOT have an internet connection, requests can be retrieved from the cache.

#### Models:
* TMDbMovie: contains all the models that serve as DTOs (data transfer objects) to store the API data.
