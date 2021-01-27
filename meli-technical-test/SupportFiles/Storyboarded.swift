//
//  File.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 24/01/21.
//

import UIKit

/// Determines if a view is instantiated from a .storyboard file.
protocol Storyboarded {
    static func instantiate(from storyboard: Storyboards) -> Self
}

/// Default implementation of the protocol.
extension Storyboarded where Self: UIViewController {
    
    /// Creates a ViewController from a .storyboard file
    /// - Parameter storyboard: Storyboard to instantiate
    static func instantiate(from storyboard: Storyboards) -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
