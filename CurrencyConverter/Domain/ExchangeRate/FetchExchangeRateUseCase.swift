//
//  FetchExchangeRateUseCase.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 10/1/25.
//

import Foundation

protocol FetchExchangeRateUseCase {
    func execute() async throws -> [ExchangeRate]
    func getSingleRate(_ code: String) async throws -> ExchangeRate
}

struct FetchExchangeRate: FetchExchangeRateUseCase {
    private let repository: ExchangeRateRepository

    init(repository: ExchangeRateRepository) {
        self.repository = repository
    }

    func execute() async throws -> [ExchangeRate] {
        return try await repository.fetch()
    }
    
    func getSingleRate(_ code: String) async throws -> ExchangeRate {
        try await self.repository.getExchangeRate(code: code)
    }
}

struct MockFetchExchangeRateUseCase: FetchExchangeRateUseCase {
    func execute() async throws -> [ExchangeRate] {
        return ExchangeRate.mockData
    }
    
    func getSingleRate(_ code: String) async throws -> ExchangeRate {
        return .mockSingle
    }
}
