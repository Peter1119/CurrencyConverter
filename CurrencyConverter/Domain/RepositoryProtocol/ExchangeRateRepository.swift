//
//  CurrencyRateRepository.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 10/1/25.
//

import Foundation

protocol ExchangeRateRepository {
    func fetch() async throws -> ExchangeRateList
}
