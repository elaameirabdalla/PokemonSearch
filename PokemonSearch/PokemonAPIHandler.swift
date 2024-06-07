//
//  PokemonAPIHandler.swift
//  PokemonSearch
//
//  Created by Abdalla Elaameir on 6/6/24.
//

import Foundation


class PokemonAPIHandler {
    
    enum Constant {
        static let pokemonResultsEndpoint = "https://pokeapi.co/api/v2/pokemon?"
        static let pokemonDetailsEndpoint = "https://pokeapi.co/api/v2/pokemon/"
    }
    
    public init(){}
    
    // MARK: Functions for handling main page results
    
    public func getPokemonResults(limit: Int, completion: @escaping (_ success: Bool, _ data: Data?)-> Void) {
        let endpoint = Constant.pokemonResultsEndpoint + "limit=\(limit)"
        let url = URL(string: endpoint)
        
        guard let url = url else {
            return
        }
        
        // Call endpoint
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                completion(true, data)
            }
            else {
                completion(false, nil)
            }
            
        }
        task.resume()
    }
    
    public func handleResults(data: Data) -> [PokemonSearchViewModel] {
        let decoder = JSONDecoder()
        let response = try? decoder.decode(PokemonSearchResponse.self, from: data)
        
        guard let response = response else {
            return []
        }
        let results = response.results.map {
            return PokemonSearchViewModel(name: $0.name)
        }
        
        return results
    }
    
    // MARK: Functions for handling details page for row selection and search
    
    public func searchPokemon(searchTerm: String, completion: @escaping (_ success: Bool, _ data: Data?)-> Void) {
        
        let endpoint = Constant.pokemonDetailsEndpoint + searchTerm
        let url = URL(string: endpoint)
        
        guard let url = url else {
            return
        }
        
        // Call endpoint
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                completion(true, data)
            }
            else {
                completion(false, nil)
            }

        }
        task.resume()
    }
    
    
    public func handleDetails(data: Data) -> PokemonDetailsViewModel? {
        let decoder = JSONDecoder()
        let response = try? decoder.decode(PokemonDetailsResponse.self, from: data)
        
        guard let response = response else {
            return nil
        }
        
        // Transforms types object into List of strings then into comma separated string
        let types: [String] = response.types.map {
            return $0.type.name
        }
        var typesString = ""
        types.forEach { type in
            typesString.append(type + ", ")
        }
        
        // Transforms stats objects into List of tuples with (Stat, stat point) pairs into readable string
        let stats: [(String, Int)] = response.stats.map {
            return ($0.stat.name, $0.base_stat)
        }
        var statsString = ""
        stats.forEach { pair in
            statsString.append(pair.0 + ": " + "\(pair.1), ")
        }
        
        return PokemonDetailsViewModel(id: response.id, name: response.name, weight: response.weight, height: response.height, types: String(typesString.dropLast(2)), stats: String(statsString.dropLast(2)), href: response.sprites.front_default)
    }
    
}
