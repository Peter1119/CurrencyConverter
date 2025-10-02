//
//  FetchExchangeRateUseCase.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 10/1/25.
//

import Foundation

protocol FetchExchangeRateUseCase {
    func execute() async throws -> ExchangeRateList
}

struct FetchExchangeRate: FetchExchangeRateUseCase {
    private let repository: ExchangeRateRepository

    init(repository: ExchangeRateRepository) {
        self.repository = repository
    }

    func execute() async throws -> ExchangeRateList {
        return try await repository.fetch()
    }
}

struct MockFetchExchangeRateUseCase: FetchExchangeRateUseCase {
    func execute() async throws -> ExchangeRateList {
        return ExchangeRateList.mock
    }
}
