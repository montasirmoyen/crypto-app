//
//  ContentView.swift
//  crypto-app
//
//  Created by Montasir Moyen on 9/25/25.
//

import SwiftUI

struct ContentView: View {
    @State private var coins: [Coin] = []
    @State private var sortColumn: SortColumn = .rank
    @State private var sortDirection: SortDirection = .descending

    var sortedCoins: [Coin] {
        switch sortColumn {
        case .rank:
            return coins.sorted { (lhs: Coin, rhs: Coin) in
                let leftRank = lhs.marketCapRank ?? 0
                let rightRank = rhs.marketCapRank ?? 0
                return sortDirection == .descending
                    ? leftRank < rightRank
                    : leftRank > rightRank
            }
            
        case .price:
            return coins.sorted { (lhs: Coin, rhs: Coin) in
                let leftPrice = lhs.currentPrice
                let rightPrice = rhs.currentPrice
                return sortDirection == .descending
                    ? leftPrice > rightPrice
                    : leftPrice < rightPrice
            }
            
        case .change7d:
            return coins.sorted { (lhs: Coin, rhs: Coin) in
                let a = lhs.priceChangePercentage7dInCurrency ?? 0
                let b = rhs.priceChangePercentage7dInCurrency ?? 0
                return sortDirection == .descending ? a > b : a < b
            }
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header row
                HStack {
                    Text("Market")
                        .font(.title2)
                        .foregroundColor(.white)
                        .bold()
                        .frame(maxWidth: .infinity)
                }
                .background(Color.black)
                .foregroundColor(.white)
                
                HStack {
                    SortHeader(title: "#", isActive: sortColumn == .rank, direction: sortDirection) {
                        toggleSort(column: .rank)
                    }
                    Spacer()
                    SortHeader(title: "Price", isActive: sortColumn == .price, direction: sortDirection) {
                        toggleSort(column: .price)
                    }
                    Spacer()
                    SortHeader(title: "7d %", isActive: sortColumn == .change7d, direction: sortDirection) {
                        toggleSort(column: .change7d)
                    }
                }
                .background(Color.black)
                .font(.caption)
                .foregroundColor(.gray)

                // Coin list
                List(sortedCoins) { coin in
                    NavigationLink(destination: CoinDetailView(coin: coin)) {
                        CoinRowView(coin: coin)
                            .listRowBackground(Color.black)
                            .background(Color.black)
                    }
                    .listRowBackground(Color.black)
                    .background(Color.black)
                }
                .listStyle(PlainListStyle())
                .background(Color.black)
            }
        }
        .background(Color.black)
        .onAppear {
            loadMockData()
        }
    }

    private func toggleSort(column: SortColumn) {
        if sortColumn == column {
            sortDirection = (sortDirection == .descending) ? .ascending : .descending
        } else {
            sortColumn = column
            sortDirection = .descending
        }
    }

    private func loadMockData() {
        if let url = Bundle.main.url(forResource: "MockCoinData", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode([Coin].self, from: data) {
            coins = decoded
        }
    }
}

#Preview {
    ContentView()
}
