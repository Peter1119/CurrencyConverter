//
//  MockExchangeRateRepository.swift
//  CurrencyConverterTests
//
//  Created by 홍석현 on 10/1/25.
//

import Foundation

// MARK: - Mock Repository
final class MockExchangeRateRepository: ExchangeRateRepository {
    var fetchCallCount = 0
    var shouldThrowError = false

    init(shouldThrowError: Bool = false) {
        self.shouldThrowError = shouldThrowError
    }

    func fetch() async throws -> ExchangeRateList {
        fetchCallCount += 1

        if shouldThrowError {
            throw FetchExchangeRateError.networkError
        }

        return ExchangeRateList(
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
