//
//  CoinRowView.swift
//  crypto-app
//
//  Created by Montasir Moyen on 9/27/25.
//

import SwiftUI

struct CoinRowView: View {
    let coin: Coin

    var body: some View {
        HStack {
            // Left side
            HStack(spacing: 12) {
                Text("\(coin.marketCapRank ?? 0)")
                    .foregroundColor(.gray)
                    .frame(width: 40, alignment: .leading)
                    .font(Font.system(size: 15, weight: .bold))

                AsyncImage(url: URL(string: coin.image)) { phase in
                    if let image = phase.image {
                        image.resizable().scaledToFit()
                    } else if phase.error != nil {
                        Color.gray
                    } else {
                        Color.gray.opacity(0.3)
                    }
                }
                .frame(width: 30, height: 30)
                .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text(coin.symbol.uppercased())
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(formatMarketCap(coin.marketCap))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            // Right side
            VStack(alignment: .trailing, spacing: 6) {
                Text(coin.currentPrice.asCurrencyString())
                    .font(.headline)
                    .foregroundColor(.white)

                if let spark = coin.sparklineIn7d?.price {
                    SparklineView(
                        data: spark,
                        isPositive: (coin.priceChangePercentage7dInCurrency ?? 0) >= 0
                    )
                    .frame(width: 72, height: 28)
                } else {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.gray.opacity(0.15))
                        .frame(width: 72, height: 18)
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(Color.clear)
    }

    private func formatMarketCap(_ num: Double) -> String {
        if num >= 1_000_000_000_000 {
            return String(format: "$%.2fT", num / 1_000_000_000_000)
        } else if num >= 1_000_000_000 {
            return String(format: "$%.2fB", num / 1_000_000_000)
        } else if num >= 1_000_000 {
            return String(format: "$%.2fM", num / 1_000_000)
        } else {
            return String(format: "$%.0f", num)
        }
    }
}

struct CoinRowView_Previews: PreviewProvider {
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
        ZStack { Color.black.edgesIgnoringSafeArea(.all) }
        .overlay {
            VStack {
                CoinRowView(coin: sample)
                Spacer()
            }
            .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}
