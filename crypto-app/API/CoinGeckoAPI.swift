//
//  CoinGeckoAPI.swift
//  crypto-app
//
//  Created by Montasir Moyen on 9/27/25.
//

import Foundation

/*

class CoinGeckoAPI {
    static let shared = CoinGeckoAPI()

    private let apiKey = "..."

    func fetchApi() {
        let url = URL(string: "https://api.coingecko.com/api/v3/global")!
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "x-cg-api-key")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error:", error)
                return
            }
            guard let data = data else {
                print("No data")
                return
            }

            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                if let prettyString = String(data: prettyData, encoding: .utf8) {
                    print(prettyString) // nicely formatted JSON
                }
            } catch {
                print("Failed to parse JSON:", error)
            }
        }.resume()
    }
}

*/
