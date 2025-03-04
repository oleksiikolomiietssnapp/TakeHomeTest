//
//  AppCoordinator.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import UIKit

/// The main coordinator responsible for managing the app's tab-based navigation structure.
/// Handles the creation and coordination of child coordinators for different tabs.
final class AppCoordinator: TabCoordinator {
    // MARK: - Properties

    /// The main navigation controller for the app.
    var navigationController: UINavigationController

    /// The tab bar controller managing different sections of the app.
    var tabBarController: UITabBarController

    /// Array of child coordinators managed by this coordinator.
    var childCoordinators: [Coordinator] = []

    var api: CoinRankingAPIProtocol

    // MARK: - Initialization

    /// Initializes the app coordinator with new navigation and tab bar controllers.
    public init(api: CoinRankingAPIProtocol) {
        self.navigationController = UINavigationController()
        self.tabBarController = UITabBarController()
        self.api = api
    }

    // MARK: - Coordinator Methods

    /// Starts the coordinator by setting up the tab-based navigation structure.
    /// Creates and configures child coordinators for different sections of the app.
    public func start() {
        // Create child coordinators
        let coinsListCoordinator = CoinsListCoordinator(navigationController: UINavigationController(), api: api)
        let favoritesCoordinator = FavoritesCoordinator(navigationController: UINavigationController(), api: api)

        // Store child coordinators
        childCoordinators = [coinsListCoordinator, favoritesCoordinator]

        // Start each coordinator
        coinsListCoordinator.start()
        favoritesCoordinator.start()
        coinsListCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: "Coins",
            image: UIImage(systemName: "list.bullet"),
            selectedImage: UIImage(systemName: "list.bullet.fill")
        )
        favoritesCoordinator.navigationController.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )

        // Sets up the badge observer for the favorites tab.
        FavoritesManager.shared.addObserver { coins in
            if coins.isEmpty {
                favoritesCoordinator.navigationController.tabBarItem.badgeValue = nil
                favoritesCoordinator.navigationController.tabBarItem.accessibilityLabel = "Favorites no items"
            } else {
                favoritesCoordinator.navigationController.tabBarItem.badgeValue = "\(coins.count)"
                favoritesCoordinator.navigationController.tabBarItem.accessibilityLabel = "Favorites \(coins.count) items"
            }
        }

        // Configure tab bar
        tabBarController.viewControllers = [
            coinsListCoordinator.navigationController,
            favoritesCoordinator.navigationController,
        ]
    }
}
