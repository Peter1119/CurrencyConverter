//
//  DefaultExchangeRateRepository.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 10/1/25.
//

import Foundation

final actor DefaultExchangeRateRepository: ExchangeRateRepository {
    private let remoteDataSource: RemoteExchangeRateDataSource
    private let localDataSource: LocalExchangeRateDataSource
    private var cachedRates: [ExchangeRate] = []

    init(
        remoteDataSource: RemoteExchangeRateDataSource,
        localDataSource: LocalExchangeRateDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func fetch() async throws(FetchExchangeRateError) -> [ExchangeRate] {
        if UserDefaultsStorage.shouldUpdateExchangeRate() || cachedRates.isEmpty {
            return try await fetchFromRemote()
        }

        return sortRates(cachedRates)
    }
    
    func getExchangeRate(code: String) async throws -> ExchangeRate {
        if let result = cachedRates.first(where: { $0.code == code }) {
            return result
        } else {
            throw FetchExchangeRateError.invalidData
        }
    }

    func updateIsFavorite(
        _ code: String,
        isFavorite: Bool
    ) async throws -> [ExchangeRate] {
        // 캐시 업데이트
        if let index = cachedRates.firstIndex(where: { $0.code == code }) {
            cachedRates[index].isFavorite = isFavorite
        }

        // Local에 저장
        try await localDataSource.toggleFavorite(code)

        // 정렬 후 반환
        cachedRates = sortRates(cachedRates)
        return cachedRates
    }
    
    private func fetchFromRemote() async throws(FetchExchangeRateError) -> [ExchangeRate] {
        do {
            let remoteData = try await remoteDataSource.fetch().toDomain()

            let previousRates = cachedRates.isEmpty ? try? await localDataSource.loadRates() : cachedRates
            let updatedRates = compareRates(current: remoteData.rates, previous: previousRates)
            let sortedRates = sortRates(updatedRates)

            cachedRates = sortedRates
            try? await localDataSource.saveRates(sortedRates)
            saveNextUpdateTime(remoteData.nextUpdateTime)

            return sortedRates
        } catch {
            throw FetchExchangeRateError.networkError
        }
    }


    private func compareRates(
        current: [ExchangeRate],
        previous: [ExchangeRate]?
    ) -> [ExchangeRate] {
        guard let previous = previous else {
            return current
        }

        return current.map { currentRate in
            let previousData = previous.first { $0.code == currentRate.code }
            let previousRate = previousData?.rate ?? 0
            currentRate.isFavorite = previousData?.isFavorite ?? false

            // 차이가 0.01 이하면 nil, 초과하면 상승/하락 표시
            let difference = abs(currentRate.rate - previousRate)
            if difference > 0.01 {
                currentRate.isIncreasing = currentRate.rate > previousRate
            } else {
                currentRate.isIncreasing = nil
            }

            return currentRate
        }
    }

    private func saveNextUpdateTime(_ nextUpdateTime: Date) {
        UserDefaultsStorage.nextUpdateTime = nextUpdateTime.timeIntervalSince1970.rounded(.up)
    }

    private func sortRates(_ rates: [ExchangeRate]) -> [ExchangeRate] {
        return rates.sorted { lhs, rhs in
            if lhs.isFavorite != rhs.isFavorite {
                return lhs.isFavorite
            }
            return lhs.code < rhs.code
        }
    }
}
