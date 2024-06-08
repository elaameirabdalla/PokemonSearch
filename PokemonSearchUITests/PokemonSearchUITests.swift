//
//  PokemonSearchUITests.swift
//  PokemonSearchUITests
//
//  Created by Abdalla Elaameir on 6/6/24.
//

import XCTest
@testable import PokemonSearch

final class PokemonSearchUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testSearchViewControllerUI() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Assert UI components are present and table view is loaded with initial limit of 20
        let searchBar = app.textFields["Search Pokemon Here!"]
        let tableView = app.tables.matching(identifier: "SearchResultsTable")
        let count = tableView.cells.count
        sleep(3)
        
        XCTAssertTrue(searchBar.exists)
        XCTAssertTrue(count == 20)
        
        // Asserts row selection functionality - Tapping cell leads to Pokemon details page
        let cell = tableView.cells.element(boundBy: 0)
        cell.tap()
        sleep(3)
        XCTAssertTrue(app.navigationBars["PokemonSearch.PokemonDetailsView"].exists)
    }

}
