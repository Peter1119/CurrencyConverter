//
//  CurrencyRateRepository.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 10/1/25.
//

import Foundation

protocol CurrencyRateRepository {
    func fetchExchangeRates() async throws -> ExchangeRateInfo
}
