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
                let fetchRequest: NSFetchRequest<ExchangeRateEntity> = ExchangeRateEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "code == %@", rate.code)

                let existingEntity = try? self.context.fetch(fetchRequest).first

                let entity = existingEntity ?? ExchangeRateEntity(context: self.context)
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

        let favorites = try await getFavorites()
        let result = entities.map { entity in
            let exchangeRate = entity.toDomain()
            exchangeRate.isFavorite = favorites.contains(entity.code)
            return exchangeRate
        }
        return result
    }

    func toggleFavorite(_ code: String) async throws {
        try await context.perform {
            let fetchRequest: NSFetchRequest<FavoriteEntity> = FavoriteEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "code == %@", code)

            let results = try self.context.fetch(fetchRequest)

            if let existing = results.first {
                // 이미 즐겨찾기 → 제거
                self.context.delete(existing)
            } else {
                // 즐겨찾기 추가
                let favorite = FavoriteEntity(context: self.context)
                favorite.code = code
            }

            try self.context.save()
        }
    }

    func getFavorites() async throws -> Set<String> {
        let favorites = try await context.perform {
            let fetchRequest: NSFetchRequest<FavoriteEntity> = FavoriteEntity.fetchRequest()
            let results = try self.context.fetch(fetchRequest)
            return Set(results.compactMap { $0.code })
        }
        return favorites
    }
}
