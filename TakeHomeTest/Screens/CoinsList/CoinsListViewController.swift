//
//  CoinsListViewController.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import SwiftUI
import UIKit

// MARK: - Views
final class CoinsListViewController: UIViewController {
    // MARK: - Types
    private typealias DataSource = UITableViewDiffableDataSource<CoinsListViewModel.Section, Coin>

    // MARK: - Properties
    weak var coordinator: CoinsListCoordinator?
    private var viewModel: CoinsListViewModel
    private let refreshControl = UIRefreshControl()
    lazy private var tableView = UITableView()
    lazy private var dataSource: DataSource = createDataSource()

    // MARK: - Initialization
    init(viewModel: CoinsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        loadInitialData()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground

        // TableView setup
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.register(CoinTableViewCell.self, forCellReuseIdentifier: "CoinCell")
    }

    private func loadInitialData() {
        Task {
            await viewModel.loadNextPage()
            updateUI()
        }
    }

    private func createDataSource() -> DataSource {
        DataSource(tableView: tableView) { tableView, indexPath, coin in
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "CoinCell", for: indexPath
                ) as? CoinTableViewCell
            else {
                return UITableViewCell()
            }

            cell.contentConfiguration = UIHostingConfiguration {
                CoinCellView(coin: coin)
            }
            cell.accessibilityLabel = "Coin \(coin.name)"

            return cell
        }
    }

    private func setupNavigationBar() {
        title = "Top 100 Coins"
        navigationController?.navigationBar.prefersLargeTitles = true

        let menu = UIMenu(title: "Sort Options", children: [
            UIAction(
                title: "Highest Price",
                image: UIImage(systemName: "chart.line.uptrend.xyaxis")
            ) { [weak self] _ in
                self?.viewModel.sortCoins(by: .price)
                self?.updateUI()
            },
            UIAction(
                title: "Best Performance (24h)",
                image: UIImage(systemName: "timer")
            ) { [weak self] _ in
                self?.viewModel.sortCoins(by: .performance24h)
                self?.updateUI()
            }
        ])

        let barButton = UIBarButtonItem(
            title: "Sort Options",
            image: UIImage(systemName: "arrow.up.arrow.down"),
            primaryAction: nil,
            menu: menu
        )

        // accessibility identifier for UI testing
        barButton.accessibilityIdentifier = "sortOptionsButton"

        navigationItem.rightBarButtonItem = barButton
    }

    // MARK: - Update Data
    private func updateUI(animate: Bool = true) {
        dataSource.apply(viewModel.snapshot(), animatingDifferences: animate)
    }

}

extension CoinsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let coin = viewModel.coins[indexPath.row]
        coordinator?.showItemDetail(coin)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let threshold = tableView.contentSize.height - 100 - scrollView.frame.size.height

        guard position > threshold else { return }

        Task { @MainActor in
            if await viewModel.loadNextPage() {
                // Update UI with new data
                updateUI()
            }
        }
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard let coin = dataSource.itemIdentifier(for: indexPath) else { return nil }

        let configuration: UISwipeActionsConfiguration

        if viewModel.isFavorite(coin) {
            configuration = SwipeActions.createUnfavoriteConfiguration { [weak self] in
                self?.removeFromFavorite(coin)
            }
        } else {
            configuration = SwipeActions.createFavoriteConfiguration { [weak self] in
                    self?.addToFavoritesItem(coin)
                }
        }

        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }

    private func removeFromFavorite(_ item: Coin) {
        viewModel.addToFavorite(item)
        updateUI()
    }

    private func addToFavoritesItem(_ item: Coin) {
        viewModel.addToFavorite(item)
        updateUI()
    }
}
