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

    // MARK: - Initialization

    /// Initializes the app coordinator with new navigation and tab bar controllers.
    public init() {
        self.navigationController = UINavigationController()
        self.tabBarController = UITabBarController()
    }

    // MARK: - Coordinator Methods

    /// Starts the coordinator by setting up the tab-based navigation structure.
    /// Creates and configures child coordinators for different sections of the app.
    public func start() {
        // Create child coordinators
        let coinsListCoordinator = CoinsListCoordinator(navigationController: UINavigationController())
        let favoritesCoordinator = FavoritesCoordinator(navigationController: UINavigationController())

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
            } else {
                favoritesCoordinator.navigationController.tabBarItem.badgeValue = "\(coins.count)"
            }
        }

        // Configure tab bar
        tabBarController.viewControllers = [
            coinsListCoordinator.navigationController,
            favoritesCoordinator.navigationController,
        ]
    }
}
