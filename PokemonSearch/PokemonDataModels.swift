//
//  PokemonDataModels.swift
//  PokemonSearch
//
//  Created by Abdalla Elaameir on 6/6/24.
//

import Foundation


// MARK: Structs to represent decoded data from general search response (when app loads initially and upon pagination)

struct PokemonSearchResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case count
        case results
    }
    let count: Int
    let results: [PokemonEntry]
    
}

struct PokemonEntry: Codable {
    enum CodingKeys: String, CodingKey {
        case name
    }
    let name: String
}

// MARK: Structs to represent decoded data from Pokeman detail response (by name search/selection)

struct PokemonDetailsResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case height
        case id
        case name
        case stats
        case types
        case weight
        case sprites
    }
    
    let height: Int
    let id: Int
    let name: String
    let stats: [PokeStat]
    let types: [PokeType]
    let weight: Int
    let sprites: Sprite
}

struct Sprite: Codable {
    enum CodingKeys: String, CodingKey {
        case front_default
    }
    let front_default: String
}

struct PokeStat: Codable {
    enum CodingKeys: String, CodingKey {
        case base_stat
        case stat
    }
    let base_stat: Int
    let stat: StatName
}

struct StatName: Codable {
    enum CodingKeys: String, CodingKey {
        case name
    }
    let name: String

}

struct PokeType: Codable {
    enum CodingKeys: String, CodingKey {
        case type
    }
    let type: TypeName
}

struct TypeName: Codable {
    enum CodingKeys: String, CodingKey {
        case name
    }
    let name: String

}
// MARK: Structs represention ViewModels, used to populate PokemonSearchCells and PokemonDetailsViewController fields/outlets

public struct PokemonSearchViewModel {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

public struct PokemonDetailsViewModel {
    let id: Int
    let name: String
    let weight: Int
    let height: Int
    let types: String
    let stats: String
    let href: String
    
    init(id: Int, name: String, weight: Int, height: Int, types: String, stats: String, href: String) {
        self.id = id
        self.name = name
        self.weight = weight
        self.height = height
        self.types = types
        self.stats = stats
        self.href = href
    }
}


