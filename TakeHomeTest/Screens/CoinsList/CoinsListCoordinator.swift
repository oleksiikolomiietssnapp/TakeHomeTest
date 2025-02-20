//
//  CoinsListCoordinator.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import SwiftUI
import UIKit

class CoinsListCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let coinsListVC = CoinsListViewController()
        coinsListVC.coordinator = self
        navigationController.setViewControllers([coinsListVC], animated: false)
    }

    func showItemDetail(_ coin: Coin) {
        let detailViewModel = CoinDetailViewModel(coin: coin)
        let detailView = CoinDetailView(viewModel: detailViewModel)
        let detailVC = UIHostingController(rootView: detailView)
        detailVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(detailVC, animated: true)
    }
}
