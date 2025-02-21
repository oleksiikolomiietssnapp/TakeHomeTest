//
//  FavoriteAction.swift
//  TakeHomeTest
//
//  Created by Oleksii Kolomiiets on 21.02.2025.
//

import UIKit

enum SwipeActions {
    static func createFavoriteAction(handler: @escaping () -> Void) -> UIContextualAction {
        let action = UIContextualAction(
            style: .normal,
            title: "Favorite"
        ) { _, _, completion in
            handler()
            completion(true)
        }

        action.image = UIImage(systemName: "heart")
        action.backgroundColor = .systemBlue
        return action
    }

    static func createUnfavoriteAction(
        style: UIContextualAction.Style,
        handler: @escaping () -> Void
    ) -> UIContextualAction {
        let action = UIContextualAction(
            style: style,
            title: "Unfavorite"
        ) { _, _, completion in
            handler()
            completion(true)
        }

        action.image = UIImage(systemName: "heart.slash")
        action.backgroundColor = style == .destructive ? .systemRed : .systemGray
        return action
    }

    static func createFavoriteConfiguration(handler: @escaping () -> Void) -> UISwipeActionsConfiguration {
        let action = createFavoriteAction(handler: handler)
        return UISwipeActionsConfiguration(actions: [action])
    }

    static func createUnfavoriteConfiguration(
        style: UIContextualAction.Style = .normal,
        handler: @escaping () -> Void
    ) -> UISwipeActionsConfiguration {
        let action = createUnfavoriteAction(style: style, handler: handler)
        return UISwipeActionsConfiguration(actions: [action])
    }
}
