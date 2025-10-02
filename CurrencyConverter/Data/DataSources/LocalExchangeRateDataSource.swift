//
//  LocalExchangeRateDataSource.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 10/1/25.
//

import Foundation
import CoreData

protocol LocalExchangeRateDataSource {
    func saveRates(_ rates: [ExchangeRate])
    func loadRates() -> [ExchangeRate]
    func toggleFavorite(_ code: String) async throws
    func getFavorites() async throws -> Set<String>
}

final class DefaultLocalExchangeRateDataSource: LocalExchangeRateDataSource {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func saveRates(_ rates: [ExchangeRate]) {
        // TODO: 구현
    }

    func loadRates() -> [ExchangeRate] {
        // TODO: 구현
        return []
    }

    func toggleFavorite(_ code: String) async throws {
        // TODO: 구현
    }

    func getFavorites() async throws -> Set<String> {
        // TODO: 구현
        return []
    }
}
