//
//  UpdateFavoriteUseCase.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 10/2/25.
//

import Foundation

protocol UpdateFavoriteUseCase {
    func execute(id: String, isFavorite: Bool) async throws -> [ExchangeRate]
}

struct UpdateFavorite: UpdateFavoriteUseCase {
    private let repository: ExchangeRateRepository

    init(repository: ExchangeRateRepository) {
        self.repository = repository
    }

    func execute(id: String, isFavorite: Bool) async throws -> [ExchangeRate] {
        return try await repository.updateIsFavorite(id, isFavorite: isFavorite)
    }
}

struct MockUpdateFavoriteUseCase: UpdateFavoriteUseCase {
    func execute(id: String, isFavorite: Bool) async throws -> [ExchangeRate] {
        // Mock - 빈 배열 반환
        return []
    }
}
