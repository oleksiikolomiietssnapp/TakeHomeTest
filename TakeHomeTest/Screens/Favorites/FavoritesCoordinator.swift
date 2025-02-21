//
//  FavoritesCoordinator.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import SwiftUI
import UIKit

class FavoritesCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    let api: CoinRankingAPIProtocol

    init(
        navigationController: UINavigationController,
        api: CoinRankingAPIProtocol
    ) {
        self.navigationController = navigationController
        self.api = api
    }

    func start() {
        let favoritesVC = FavoritesViewController()
        favoritesVC.coordinator = self
        navigationController.setViewControllers([favoritesVC], animated: false)
    }

    func showItemDetail(_ coin: Coin) {
        let detailViewModel = CoinDetailViewModel(coin: coin, api: api)
        let detailView = CoinDetailView(viewModel: detailViewModel)
        let detailVC = UIHostingController(rootView: detailView)
        detailVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(detailVC, animated: true)
    }
}
