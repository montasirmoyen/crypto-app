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
    @State private var isShowingSearch = false
    @State private var globalMarketCapUSD: Double?
    @State private var marketCapChange24h: Double?

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
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(spacing: 0) {
                    HStack {
                        Text("Markets")
                            .font(.title2)
                            .foregroundColor(.white)
                            .bold()
                            .background(Color.black)
                        
                        Spacer()
                        
                        Button(action: {
                            isShowingSearch = true
                        }) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white)
                                .padding(.trailing, 8)
                                .background(Color.black)
                        }
                        .background(Color.black)
                    }
                    .background(Color.black)
                    .foregroundColor(.white)
                    .padding()
                    
                    if let cap = globalMarketCapUSD {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("Global Market Cap")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text(cap.formatMarketCap())
                                    .font(.subheadline).bold()
                                    .foregroundColor(.white)
                                if let change = marketCapChange24h {
                                    Text("\(change >= 0 ? "+" : "")\(String(format: "%.2f", change))%")
                                        .font(.caption).bold()
                                        .foregroundColor(change >= 0 ? .green : .red)
                                }
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .padding(.vertical)
                        .background(Color.black)
                    }
                    
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
        }
        .onAppear {
            loadMockData()
            // loadMockGlobalData()
        }
        .sheet(isPresented: $isShowingSearch) {
            CoinSearchView()
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
    
    private func loadMockGlobalData() {
        guard let url = Bundle.main.url(forResource: "MockGlobalData", withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return }
        
        struct GlobalResponse: Decodable {
            let market_cap_change_percentage_24h_usd: Double
            let total_market_cap: [String: Double]
        }
        
        do {
            let decoded = try JSONDecoder().decode(GlobalResponse.self, from: data)
            marketCapChange24h = decoded.market_cap_change_percentage_24h_usd
            globalMarketCapUSD = decoded.total_market_cap.values.reduce(0, +)
        } catch {
            print("Failed to decode global market data:", error)
        }
    }
}

#Preview {
    ContentView()
}
