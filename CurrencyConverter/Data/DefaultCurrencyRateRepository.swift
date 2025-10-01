//
//  DefaultCurrencyRateRepository.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 10/1/25.
//

import Foundation

struct DefaultCurrencyRateRepository: CurrencyRateRepository {
    private let baseURL = "https://open.er-api.com/v6/latest"

    func fetchExchangeRates() async throws(FetchCurrencyRateError) -> ExchangeRateInfo {
        let urlString = "\(baseURL)/USD"
        guard let url = URL(string: urlString) else {
            throw FetchCurrencyRateError.networkError
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let result = try JSONDecoder().decode(ExchangeRateResponseDTO.self, from: data)
            if result.rates.isEmpty {
                throw FetchCurrencyRateError.invalidData
            }
            return result.toDomain()
        } catch let error as FetchCurrencyRateError {
            throw error
        } catch is DecodingError {
            throw FetchCurrencyRateError.invalidData
        } catch {
            throw FetchCurrencyRateError.networkError
        }
    }
}
