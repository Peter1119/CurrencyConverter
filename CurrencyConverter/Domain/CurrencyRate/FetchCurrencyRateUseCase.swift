//
//  FetchCurrencyRateUseCase.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 10/1/25.
//

import Foundation

protocol FetchCurrencyRateUseCase {
    func execute() async throws -> ExchangeRateInfo
}

struct FetchCurrencyRate: FetchCurrencyRateUseCase {
    private let repository: CurrencyRateRepository

    init(repository: CurrencyRateRepository) {
        self.repository = repository
    }

    func execute() async throws -> ExchangeRateInfo {
        return try await repository.fetchExchangeRates()
    }
}
