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
    let api: CoinRankingAPIProtocol

    init(navigationController: UINavigationController, api: CoinRankingAPIProtocol) {
        self.navigationController = navigationController
        self.api = api
    }

    func start() {
        let viewModel = CoinsListViewModel(api: api)
        let coinsListVC = CoinsListViewController(viewModel: viewModel)
        coinsListVC.coordinator = self
        navigationController.setViewControllers([coinsListVC], animated: false)
    }

    func showItemDetail(_ coin: Coin) {
        let detailViewModel = CoinDetailViewModel(coin: coin, api: api)
        let detailView = CoinDetailView(viewModel: detailViewModel)
        let detailVC = UIHostingController(rootView: detailView)
        detailVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(detailVC, animated: true)
    }
}
