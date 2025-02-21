//
//  SceneDelegate.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import OSLog
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Create a new UIWindow using the windowScene's frame
        let window = UIWindow(windowScene: windowScene)
        window.frame = windowScene.coordinateSpace.bounds

        // Attempt to retrieve the API key from the Info.plist
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "CoinRankingAPIKey") as? String else {
            // Log a debug message if the API key is not set
            os_log(.debug, "API key is not set. Please ensure the API_KEY is configured properly.")
            return
        }

        // Initialize the API configuration with the provided API key for development environment
        let apiConfiguration = ApiConfiguration.development(apiKey: apiKey)

        // Initialize the NetworkService with the configured API settings
        let networkService = NetworkService(configuration: apiConfiguration)

        // Create an instance of CoinRankingAPI using the network service
        let api = CoinRankingAPI(networkService: networkService)

        // Initialize the AppCoordinator with the CoinRankingAPI instance
        coordinator = AppCoordinator(api: api)
        coordinator?.start()

        // Set the root view controller to the tab bar controller from the coordinator
        window.rootViewController = coordinator?.tabBarController

        // Make the window visible and set it as the key window
        window.makeKeyAndVisible()

        // Assign the window to the window property
        self.window = window
    }
}
