//
//  Double+Utils.swift
//  meli-technical-test
//
//  Created by Juan Felipe Méndez on 25/01/21.
//

import Foundation

extension Double {
    func currencyFormatter() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
