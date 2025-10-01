//
//  DefaultExchangeRateRepository.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 10/1/25.
//

import Foundation

struct DefaultExchangeRateRepository: ExchangeRateRepository {
    private let baseURL = "https://open.er-api.com/v6/latest"

    func fetch() async throws(FetchExchangeRateError) -> ExchangeRateList {
        let urlString = "\(baseURL)/USD"
        guard let url = URL(string: urlString) else {
            throw FetchExchangeRateError.networkError
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let result = try JSONDecoder().decode(ExchangeRateResponseDTO.self, from: data)
            if result.rates.isEmpty {
                throw FetchExchangeRateError.invalidData
            }
            return result.toDomain()
        } catch let error as FetchExchangeRateError {
            throw error
        } catch is DecodingError {
            throw FetchExchangeRateError.invalidData
        } catch {
            throw FetchExchangeRateError.networkError
        }
    }
}
