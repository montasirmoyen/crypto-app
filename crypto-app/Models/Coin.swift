//
//  Coin.swift
//  crypto-app
//
//  Created by Montasir Moyen on 9/27/25.
//

import Foundation

struct Coin: Identifiable, Decodable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let currentPrice: Double
    let marketCap: Double
    let marketCapRank: Int?
    let sparklineIn7d: Sparkline?
    let priceChangePercentage7dInCurrency: Double?
    let totalSupply: Double?
    let circulatingSupply: Double?
    let maxSupply: Double?
    let ath: Double?

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case sparklineIn7d = "sparkline_in_7d"
        case priceChangePercentage7dInCurrency = "price_change_percentage_7d_in_currency"
        case totalSupply = "total_supply"
        case circulatingSupply = "circulating_supply"
        case maxSupply = "max_supply"
        case ath = "ath"
    }

    struct Sparkline: Decodable {
        let price: [Double]
    }
}
