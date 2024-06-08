//
//  PokemonSearchTests.swift
//  PokemonSearchTests
//
//  Created by Abdalla Elaameir on 6/6/24.
//

import XCTest
@testable import PokemonSearch

final class PokemonSearchTests: XCTestCase {
    let apiHandler = PokemonAPIHandler()
    
    func testInitialLoad() throws {
        // This test is used to ensure functionality of initial load.
        // Expects that getPokemonResults() is called, tableView is loaded with results
        
        let successExpectation = expectation(description: "data")
        var resultingData: Data = Data()
        var searchResults: [PokemonSearchViewModel]
        
        // Testing endpoint call
        apiHandler.getPokemonResults(limit: 20) { success, data in
            if success, let fetched = data {
                // fulfill expectation and set data upon success
                resultingData = fetched
                successExpectation.fulfill()
            }
            else {
                XCTAssertFalse(success)
                successExpectation.fulfill()
            }
        }
        // Waits for data
        waitForExpectations(timeout: 5)
        // Asserts searchResults array contains values, meaning data was transformed properly and tableView is loaded
        searchResults = apiHandler.handleResults(data: resultingData)
        XCTAssertTrue(!searchResults.isEmpty)
        
    }
    
    func testPokemonDetails() throws {
        // This test ensures the functionality of the search and selection feature, where a user can search a pokemon by name or select a pokemon(table view cell) and get the correct data.
        
        // Both functionalities make the same API call
        let successExpectation = expectation(description: "data")
        var resultingData: Data = Data()
        var searchResult: PokemonDetailsViewModel?
        let searchTerm = "charmander"
        
        // Makes API call
        apiHandler.searchPokemon(searchTerm: searchTerm) { success, data in
            if success, let fetched = data {
                // fulfill expectation and set data upon success
                resultingData = fetched
                successExpectation.fulfill()
            }
            else {
                XCTAssertFalse(success)
                successExpectation.fulfill()
            }
        }
        
        // Asserts that detail view model is not nil and that it is the corresponding details model for the searched/selected pokemon
        waitForExpectations(timeout: 5)
        searchResult = apiHandler.handleDetails(data: resultingData)
        XCTAssertNotNil(searchResult)
        XCTAssertTrue(searchResult?.name == searchTerm)

    }
    
    func testInvalidSearchTerm() throws {
        // This test, like the other, ensures the functionality of the search feature.
        // In this case, the invalid search term should yield nil for the details view model.
        let successExpectation = expectation(description: "data")
        var resultingData: Data = Data()
        var searchResult: PokemonDetailsViewModel?
        let searchTerm = "invalid"
        
        // Makes API call
        apiHandler.searchPokemon(searchTerm: searchTerm) { success, data in
            if success, let fetched = data {
                // fulfill expectation and set data upon success
                resultingData = fetched
                successExpectation.fulfill()
            }
            else {
                XCTAssertFalse(success)
                successExpectation.fulfill()
            }
        }
        
        // Asserts that detail view model is  nil
        waitForExpectations(timeout: 5)
        searchResult = apiHandler.handleDetails(data: resultingData)
        XCTAssertNil(searchResult)
    }
}
