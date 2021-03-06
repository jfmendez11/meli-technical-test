//
//  UIView+Utils.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 24/01/21.
//

import UIKit

extension UIView {
    /// Helps create a UIView from a .xib file. Is implemented by CoreView
    @discardableResult
    func fromNib<T: UIView>() -> T? {
        guard let contentView = Bundle(for: type(of: self))
                                .loadNibNamed(
                                    String(describing: type(of: self)), owner: self, options: nil
                                )?.first as? T
        else {
            // xib not loaded, or its top view is of the wrong type
            return nil
        }
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        return contentView
    }
    
    /// Returns the value of class as its viewID.
    /// Used mainly for registering/dequeueing cells.
    class var viewID: String {
        return "\(self)"
    }
    
    /// Adds a shadow to the view
    func sketchShadow() {
        layer.masksToBounds = false
        layer.shadowOpacity = 0.1
        layer.shadowColor = K.Colors.myShadow?.cgColor
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowPath = nil
    }
}
