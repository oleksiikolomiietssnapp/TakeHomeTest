//
//  TakeHomeTestUITests.swift
//  TakeHomeTestUITests
//
//  Created by Oleksii Kolomiiets on 21.02.2025.
//

import XCTest

final class TakeHomeTestUITests: XCTestCase {
    func testDetails() {
        let app = XCUIApplication()
        app.launch()

        sleep(1) // wait content to load

        // Tap on the coin with the name "Coin Bitcoin"
        app.tables.cells["Coin Bitcoin"].children(matching: .other).element(boundBy: 0).tap()

        let collectionViewsQuery = app.collectionViews

        // Tap on timeframes with a sleep delay between each tap
        collectionViewsQuery.buttons["Timeframe option: 24H"].tap()
        sleep(1)  // Sleep for 1 second between taps

        collectionViewsQuery.buttons["Timeframe option: 1Y"].tap()
        sleep(1)

        collectionViewsQuery.buttons["Timeframe option: 3Y"].tap()
        sleep(1)

        collectionViewsQuery.buttons["Timeframe option: 5Y"].tap()
        sleep(1)

        collectionViewsQuery.buttons["Timeframe option: 3M"].tap()
        sleep(1)

        collectionViewsQuery.buttons["Timeframe option: 7D"].tap()
        sleep(1)

        collectionViewsQuery.buttons["Timeframe option: 30D"].tap()
        sleep(1)

        // Tap on the "Top 100 Coins" button in the navigation bar
        app.navigationBars["Bitcoin"].buttons["Top 100 Coins"].tap()

        let tablesQuery = app.tables
        let element = tablesQuery.cells["Coin Bitcoin"].children(matching: .other).element(boundBy: 1)
        element.swipeLeft()

        // Interact with the "Favorite" button
        let favoriteButton = tablesQuery.buttons["Favorite"]
        favoriteButton.tap()

        element.children(matching: .other).element.swipeLeft()

        // Interact with the "Unfavorite" button
        tablesQuery.buttons["Unfavorite"].tap()

        // Swipe left on the element and tap Favorite again
        element.swipeLeft()
        favoriteButton.tap()

        // Tap on the tab bar button to go to "Favorites 1 items"
        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["Favorites 1 items"].tap()

        // Tap on the coin with the name "Favorite Coin Bitcoin"
        app.tables.cells["Favorite Coin Bitcoin"].children(matching: .other).element(boundBy: 0).tap()

        // Tap on the "Favorites" button in the navigation bar
        app.navigationBars["Bitcoin"].buttons["Favorites"].tap()

        // Swipe on the favorite element and tap Unfavorite
        tablesQuery.cells["Favorite Coin Bitcoin"].children(matching: .other).element(boundBy: 0).swipeLeft()
        tablesQuery.buttons["Unfavorite"].tap()

        // Go back to "Top 100 Coins"
        tabBar.buttons["Top 100 Coins"].tap()
        
        // Locate and tap the sort button
        let sortButton = app.navigationBars["Top 100 Coins"].buttons["sortOptionsButton"]
        XCTAssertTrue(sortButton.exists, "Sort button should exist.")
        sortButton.tap()

        // Select "Best Performance (24h)"
        let bestPerformanceOption = app.buttons["Best Performance (24h)"]
        XCTAssertTrue(bestPerformanceOption.waitForExistence(timeout: 2), "Best Performance option should appear.")
        bestPerformanceOption.tap()

        // Tap the sort button again
        sortButton.tap()

        // Select "Highest Price"
        let highestPriceOption = app.buttons["Highest Price"]
        XCTAssertTrue(highestPriceOption.waitForExistence(timeout: 2), "Highest Price option should appear.")
        highestPriceOption.tap()
    }
}
