//
//  RemoteExchangeRateDataSource.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 10/1/25.
//

import Foundation

protocol RemoteExchangeRateDataSource {
    func fetch() async throws -> ExchangeRateResponseDTO
}

struct DefaultRemoteExchangeRateDataSource: RemoteExchangeRateDataSource {
    private let baseURL = "https://open.er-api.com/v6/latest"

    func fetch() async throws -> ExchangeRateResponseDTO {
        let urlString = "\(baseURL)/USD"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(ExchangeRateResponseDTO.self, from: data)
    }
}
