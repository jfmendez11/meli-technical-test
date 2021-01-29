//
//  K.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 23/01/21.
//

import UIKit

/// K includes all the constants used throughout the project
struct K {
    struct Colors {
        static let header = UIColor(named: "Header")
        static let blue = UIColor(named: "Blue")
        static let myWhite = UIColor(named: "MyWhite")
        static let barTint = UIColor(named: "BarTint")
        static let myShadow = UIColor(named: "MyShadow")
    }
    
    struct Layer {
        static let defaultHeaderCornerRadius: CGFloat = 8
    }
    
    struct ProductView {
        /// Estimated row height of the product detail
        static let estimatedRowHeight: CGFloat = 200
        /// Number of rows in section is one as only 1 cell is showned as the product detail
        static let numberOfRowsInSection = 1
        /// Price not available message
        static let priceNotAvailable = "Precio no disponible"
        /// Link description to see the product on the browser
        static let linkDescription = "Ver en Mercado Libre"
        /// Link description to see the seller profile on the browser
        static let linkDescriptionSeller = "Ver perfil en Mercado Libre"
        /// Maps the label's tag to the label the label text
        static func mapped(item: Item) -> [Int: String] {
            return [
                0: String(item.availableQuantity),
                1: String(item.soldQuantity),
                2: item.condition == "new" ? "Nuevo" : "Usado",
                3: item.isMercadopago ? "Sí" : "No"
            ]
        }
        /// Left inset for the seller's related items collection view
        static let insetLeft: CGFloat = 16
        /// Number of related items available to the user
        static let numberOfRelatedItems = 6
        /// Size of the seller related item collection view cell
        static let relatedItemSize = CGSize(width: 154, height: 226)
        /// Minum spacing between cells
        static let minimumLineSpacingForSectionAt: CGFloat = 8
    }
    
    struct SearchView {
        /// Placeholder when a category is not selected
        static let categoryPlaceholder = "Buscar en "
        /// Placeholder when a category is selected
        static let placeholder = "Buscar en Mercado Libre"
        /// The user has not started typing
        static let notTypedMessage = "¡Escribe el nombre del\nartículo que deseas buscar!"
        static let notTypedEmoji = "🔎"
        /// Not results found by the search
        static let notFoundItem = "¡No encontramos el artículo que estás buscando!\nRevisa que esté bien escrito e intena de nuevo."
        static let notFoundEmoji = "🧐"
        /// Error occured
        static let errorMessage = "¡Ocurrió un errror!\nPorfavor, intenta de nuevo."
        static let errorEmoji = "😰"
        /// Estimated row height for results
        static let estimatedRowHeight: CGFloat = 100
        /// Number of rows when the view is loading
        static let numberOfLoadingCells = 10
    }
    
    struct CategoriesView {
        /// Table header text
        static let headerText = "\tBuscar por categoría"
        /// Estimated header height for categories
        static let estimatedHeaderHeight: CGFloat = 25
    }
}
