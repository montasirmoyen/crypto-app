import SwiftUI

struct CoinSearchView: View {
    @State private var searchText: String = ""
    @State private var coins: [Coin] = []
    @Environment(\.dismiss) private var dismiss

    private var filteredCoins: [Coin] {
        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.isEmpty { return coins }
        return coins.filter { coin in
            coin.name.localizedCaseInsensitiveContains(text) ||
            coin.symbol.localizedCaseInsensitiveContains(text)
        }
    }

    var body: some View {
        NavigationView {
            List(filteredCoins) { coin in
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
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search coins")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .background(Color.black)
        .onAppear { loadMockData() }
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
    CoinSearchView()
}
