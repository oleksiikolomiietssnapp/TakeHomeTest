//
//  SceneDelegate.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

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

        // Create window with the windowScene's frame
        let window = UIWindow(windowScene: windowScene)
        window.frame = windowScene.coordinateSpace.bounds

        coordinator = AppCoordinator()
        coordinator?.start()

        window.rootViewController = coordinator?.tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }
}
