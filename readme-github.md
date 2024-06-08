# Project Overview
Using the PokeAPI, this project displays an initial list of 20 Pokemon, with the ability to swipe up to paginate and load 20 more Pokemon. Clicking on the name of a Pokemon will show the Pokemon's details, including the sprite, stats, type, and other information. Users can also search for pokemon by name, which will directly load their details.

# Libaries Used: 
In this application, I used the library KingFisher to handle asynchronous image downloading and caching. I used it to set the UIImageView with Pokemon sprite images in the Pokemon details page. This library helped simplify the code down to a single line. Assuming the search is done more than once, these images load near-instantly as they are cached and don't need to be downloaded again.

# How to build/run the app:
To build and run this app, steps to be taken include:
* Downloading the project from this repository.
* Open the project in a Swift-supporting IDE (i.e. Xcode, VSCode)
* Build project and run app
* To navigate and use app, simply swipe through list of Pokemon and select Pokemon you wish to view details about. To search for a specific Pokemon, enter the Pokemon's name in the search bar.
* To view additional results, simply swipe up from the bottom of the list to trigger pagination. 

# Architecture: 
I modeled this app to follow **MVC** principles and also include view models. This app contains the main page, **SearchViewController**, responsible for displaying UI like the search bar and tableview containing search results but also dictating the flow of the app, being the main page and having an instance of the model(APIHandler). 

**PokemonAPIHandler** handles all API calls, decoding, general logic, and data transformations to convert responses into their corresponding view models: 
getPokemonResults() -> [PokemonSearchViewModel] for table view cells and searchPokemon() -> PokemonDetailViewModel. 
These models are passed and used to populate UI components on both SearchViewController and PokemonDetailsViewController. 

**PokemonDataModels**: File that contains declarations of all structs used for fetching/decoding JSON from the API call as well as the view models.  

I chose to architect the app this way as I believe it fits the needs of this app and simplified the development process for me. It also provides interpretability, scalability for future features, and solid unit testability.
Having the data from API responses transformed into view models and the views reliant on view models for component population provides a more agile codebase with dependencies flattened out.

# Additional Comments:

  # Potential Improvements:
  Given the scope and simplicity of this project, below are additional improvements I would implement in this app. 
  * Improved UI: Colors scheme, etc.
  * Scroll bar for cleaner swiping
    
