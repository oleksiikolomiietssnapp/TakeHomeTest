//
//  TakeHomeTestUITests.swift
//  TakeHomeTestUITests
//
//  Created by Oleksii Kolomiiets on 21.02.2025.
//

import XCTest

final class TakeHomeTestUITests: XCTestCase {
    func testAppFlows() {
        let app = XCUIApplication()
        app.launch()

        // Initial list loading
        let bitcoinCell = app.tables.cells.matching(identifier: "Coin Bitcoin").firstMatch
        XCTAssertTrue(bitcoinCell.waitForExistence(timeout: 5))
        bitcoinCell.tap()

        // Chart interactions
        let chartCollectionView = app.collectionViews.firstMatch
        XCTAssertTrue(chartCollectionView.waitForExistence(timeout: 5))

        let chartCells = chartCollectionView.cells
        XCTAssertTrue(chartCells.count > 0, "Chart should have cells")

        chartCells.firstMatch.swipeLeft()
        Thread.sleep(forTimeInterval: 1)
        chartCells.firstMatch.press(forDuration: 1.2)

        // Timeframe testing
        let timeframes = ["24H", "1Y", "3Y", "5Y", "3M", "7D", "30D"]
        timeframes.forEach { timeframe in
            chartCollectionView.buttons["Timeframe option: \(timeframe)"].tap()
            Thread.sleep(forTimeInterval: 1)
        }

        // Return to main list
        app.navigationBars["Bitcoin"].buttons["Top 100 Coins"].tap()

        // Favorite functionality testing
        let bitcoinListCell = app.tables.cells["Coin Bitcoin"].children(matching: .other).element(boundBy: 1)
        bitcoinListCell.swipeLeft()

        let favoriteButton = app.tables.buttons["Favorite"]
        favoriteButton.tap()

        bitcoinListCell.children(matching: .other).element.swipeLeft()
        app.tables.buttons["Unfavorite"].tap()

        bitcoinListCell.swipeLeft()
        favoriteButton.tap()

        // Favorites tab navigation
        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["Favorites 1 items"].tap()

        // Check favorite detail
        app.tables.cells["Favorite Coin Bitcoin"].children(matching: .other).element(boundBy: 0).tap()
        app.navigationBars["Bitcoin"].buttons["Favorites"].tap()

        // Remove from favorites
        app.tables.cells["Favorite Coin Bitcoin"].children(matching: .other).element(boundBy: 0).swipeLeft()
        app.tables.buttons["Unfavorite"].tap()

        // Sort testing
        tabBar.buttons["Top 100 Coins"].tap()

        let sortButton = app.navigationBars["Top 100 Coins"].buttons["sortOptionsButton"]
        XCTAssertTrue(sortButton.exists, "Sort button should exist")
        sortButton.tap()

        let bestPerformanceOption = app.buttons["Best Performance (24h)"]
        XCTAssertTrue(bestPerformanceOption.waitForExistence(timeout: 2))
        bestPerformanceOption.tap()

        sortButton.tap()
        let highestPriceOption = app.buttons["Highest Price"]
        XCTAssertTrue(highestPriceOption.waitForExistence(timeout: 2))
        highestPriceOption.tap()
    }
}
