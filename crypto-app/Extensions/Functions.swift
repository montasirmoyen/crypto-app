//
//  Functions.swift
//  crypto-app
//
//  Created by Montasir Moyen on 10/2/25.
//

import Foundation

extension Double {
    func asCurrencyString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        
        if self >= 1 {
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
        } else {
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 8
        }
        
        return formatter.string(from: NSNumber(value: self)) ?? "$\(self)"
    }
}
