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
    
    func formatMarketCap() -> String {
        let units = ["", "K", "M", "B", "T", "Q"]
        var value = self
        var index = 0
        
        while value >= 1000 && index < units.count - 1 {
            value /= 1000
            index += 1
        }
        
        if index == 0 {
            return String(format: "$%.0f", value)
        } else {
            return String(format: "$%.2f%@", value, units[index])
        }
    }
}
