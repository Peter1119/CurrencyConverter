//
//  FetchExchangeRateUseCase.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 10/1/25.
//

import Foundation

protocol FetchExchangeRateUseCase {
    func execute() async throws -> [ExchangeRate]
}

struct FetchExchangeRate: FetchExchangeRateUseCase {
    private let repository: ExchangeRateRepository

    init(repository: ExchangeRateRepository) {
        self.repository = repository
    }

    func execute() async throws -> [ExchangeRate] {
        return try await repository.fetch()
    }
}

struct MockFetchExchangeRateUseCase: FetchExchangeRateUseCase {
    func execute() async throws -> [ExchangeRate] {
        return ExchangeRate.mockData
    }
}
