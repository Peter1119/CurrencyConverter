//
//  DefaultExchangeRateRepository.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 10/1/25.
//

import Foundation

final class DefaultExchangeRateRepository: ExchangeRateRepository {
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
        print("🔍 [Repository] 환율 데이터 조회 시작")

        if UserDefaultsStorage.shouldUpdateExchangeRate() || cachedRates.isEmpty {
            return try await fetchFromRemote()
        }

        return sortRates(cachedRates)
    }


    private func fetchFromRemote() async throws(FetchExchangeRateError) -> [ExchangeRate] {
        do {
            let remoteData = try await remoteDataSource.fetch().toDomain()
            print("🌐 [Repository] Remote 데이터 개수: \(remoteData.rates.count)")

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
            let previousRate = previous.first { $0.code == currentRate.code }?.rate ?? 0
            currentRate.isIncreasing = currentRate.rate == previousRate ? nil : currentRate.rate > previousRate
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
