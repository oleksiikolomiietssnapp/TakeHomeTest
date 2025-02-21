//
//  FavoritesViewController.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 20.02.2025.
//

import SwiftUI
import UIKit

// MARK: - Favorites View Controller
final class FavoritesViewController: UIViewController {
    // MARK: - Types
    private typealias DataSource = UITableViewDiffableDataSource<FavoritesViewModel.Section, Coin>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<FavoritesViewModel.Section, Coin>

    // MARK: - Properties
    weak var coordinator: FavoritesCoordinator?
    private let viewModel = FavoritesViewModel()
    lazy private var emptyStateView = EmptyStateView()
    lazy private var dataSource: DataSource = createDataSource()
    lazy private var tableView = UITableView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    // MARK: - Setup
    private func setupNavigationBar() {
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setupUI() {

        view.backgroundColor = .systemBackground

        // Setup TableView
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.register(CoinTableViewCell.self, forCellReuseIdentifier: "CoinCell")

        // Setup Empty State View
        view.addSubview(emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
        ])
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
            cell.accessibilityLabel = "Favorite Coin \(coin.name)"

            return cell
        }
    }

    // MARK: - Update Data
    private func updateUI(animate: Bool = true) {
        withAnimation(.bouncy) {
            if viewModel.coins.isEmpty {

                tableView.isHidden = true
                emptyStateView.isHidden = false
            } else {
                tableView.isHidden = false
                emptyStateView.isHidden = true
            }
        }
        dataSource.apply(viewModel.snapshot(), animatingDifferences: animate)
    }
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let coin = dataSource.itemIdentifier(for: indexPath) else { return }
        coordinator?.showItemDetail(coin)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration?
    {
        guard let coin = dataSource.itemIdentifier(for: indexPath) else { return nil }

        return SwipeActions.createUnfavoriteConfiguration(style: .destructive) { [weak self] in
            self?.viewModel.removeFavorite(coin)
            self?.updateUI()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}
