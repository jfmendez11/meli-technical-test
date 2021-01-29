//
//  EmptyStateView.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 26/01/21.
//

import UIKit

enum EmptyState {
    case search
    case itemNotFound
    case error
}

class EmptyStateView: CoreView {
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var emptyState: EmptyState = .search {
        didSet {
            switch emptyState {
            case .search:
                emojiLabel.text = K.SearchView.notTypedEmoji
                messageLabel.text = K.SearchView.notTypedMessage
            case .itemNotFound:
                emojiLabel.text = K.SearchView.notFoundEmoji
                messageLabel.text = K.SearchView.notFoundItem
            case .error:
                emojiLabel.text = K.SearchView.errorEmoji
                messageLabel.text = K.SearchView.errorMessage
            }
        }
    }
}
