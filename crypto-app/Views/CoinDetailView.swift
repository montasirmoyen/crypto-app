//
//  CoinDetailView.swift
//  crypto-app
//
//  Created by Montasir Moyen on 9/27/25.
//

import SwiftUI

struct CoinDetailView: View {
    let coin: Coin
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingSearch = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 8) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 0) {
                        AsyncImage(url: URL(string: coin.image)) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 28, height: 28)
                        
                        Text("  " + coin.symbol.uppercased())
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        isShowingSearch = true
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(coin.name)
                            .font(.title2).bold()
                            .foregroundColor(.white)
                        
                        if let rank = coin.marketCapRank {
                            Text("#\(rank)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    HStack {
                        Text(coin.currentPrice.asCurrencyString())
                            .font(.title).bold()
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        if let change = coin.priceChangePercentage7dInCurrency {
                            Text("\(change >= 0 ? "+" : "")\(String(format: "%.2f", change))%")
                                .font(.subheadline).bold()
                                .foregroundColor(change >= 0 ? .green : .red)
                        }
                    }
                }
                .padding(.horizontal)
                
                SparklineView(
                    data: coin.sparklineIn7d?.price ?? [],
                    isPositive: (coin.priceChangePercentage7dInCurrency ?? 0) >= 0
                )
                .background(Color.gray.opacity(0.1))
                .frame(height: 200)
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.vertical)
                                
                VStack {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        StatCell(title: "Market Cap", value: formatCurrency(coin.marketCap))
                        StatCell(title: "Total Supply", value: formatSupply(coin.totalSupply, symbol: coin.symbol))
                        
                        StatCell(title: "Circulating Supply", value: formatSupply(coin.circulatingSupply, symbol: coin.symbol))
                        StatCell(title: "Max Supply", value: formatSupply(coin.maxSupply, symbol: coin.symbol))
                        
                        StatCell(title: "All Time High", value: formatCurrency(coin.ath))
                        StatCell(title: "Market Cap Rank", value: "#\(coin.marketCapRank ?? 0)")
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
            }
            .background(Color.black.ignoresSafeArea())
            .sheet(isPresented: $isShowingSearch) {
                CoinSearchView()
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct CoinDetailView_Previews: PreviewProvider {
    static var sample = Coin(
        id: "bitcoin",
        symbol: "btc",
        name: "Bitcoin",
        image: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png",
        currentPrice: 109421,
        marketCap: 2_181_045_385_224,
        marketCapRank: 1,
        sparklineIn7d: Coin.Sparkline(price: [115874.83, 115751.86, 115743.81, 115760.45, 109385.55, 109468.93, 109433.85]),
        priceChangePercentage7dInCurrency: -5.43,
        totalSupply: 235235235,
        circulatingSupply: 235235235,
        maxSupply: 235235235,
        ath: 235235235,
    )
    
    static var previews: some View {
        CoinDetailView(coin: sample)
    }
}

struct StatCell: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension CoinDetailView {
    func formatCurrency(_ value: Double?) -> String {
        guard let value else { return "N/A" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
    
    func formatSupply(_ value: Double?, symbol: String) -> String {
        guard let value else { return "N/A" }
        if value >= 1_000_000 {
            return String(format: "%.2fM %@", value / 1_000_000, symbol.uppercased())
        } else {
            return "\(Int(value)) \(symbol.uppercased())"
        }
    }
}

