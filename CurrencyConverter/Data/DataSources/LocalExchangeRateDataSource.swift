//
//  LocalExchangeRateDataSource.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 10/1/25.
//

import Foundation
import CoreData

protocol LocalExchangeRateDataSource {
    func saveRates(_ rates: [ExchangeRate]) async throws
    /// 이전 환율 데이터를 불러옵니다.
    func loadRates() async throws -> [ExchangeRate]
    func toggleFavorite(_ code: String) async throws
    func getFavorites() async throws -> Set<String>
}

final class DefaultLocalExchangeRateDataSource: LocalExchangeRateDataSource {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func saveRates(_ rates: [ExchangeRate]) async throws {
        return try await context.perform {
            for rate in rates {
                let entity = ExchangeRateEntity(context: self.context)
                entity.code = rate.code
                entity.rate = rate.rate
            }
            
            try self.context.save()
        }
    }

    func loadRates() async throws -> [ExchangeRate] {
        let entities = try await context.perform {
            let fetchRequest: NSFetchRequest<ExchangeRateEntity> = ExchangeRateEntity.fetchRequest()
            guard let result = try? self.context.fetch(fetchRequest) else { throw FetchExchangeRateError.invalidData }
            return result
        }
        
        return entities.map { $0.toDomain() }
    }

    func toggleFavorite(_ code: String) async throws {
        // TODO: 구현
    }

    func getFavorites() async throws -> Set<String> {
        // TODO: 구현
        return []
    }
}
