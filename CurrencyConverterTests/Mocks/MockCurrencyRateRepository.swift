//
//  MockCurrencyRateRepository.swift
//  CurrencyConverterTests
//
//  Created by 홍석현 on 10/1/25.
//

import Foundation

// MARK: - Mock Repository
final class MockCurrencyRateRepository: CurrencyRateRepository {
    var fetchCallCount = 0
    var shouldThrowError = false

    init(shouldThrowError: Bool = false) {
        self.shouldThrowError = shouldThrowError
    }

    func fetchExchangeRates() async throws -> ExchangeRateInfo {
        fetchCallCount += 1

        if shouldThrowError {
            throw FetchCurrencyRateError.networkError
        }

        return ExchangeRateInfo(
            rates: [
                "USD": 1.0,
                "KRW": 1300.50,
                "JPY": 148.20
            ],
            lastUpdateTime: Date(),
            nextUpdateTime: Date()
        )
    }
}
