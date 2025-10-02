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
    
    init(
        remoteDataSource: RemoteExchangeRateDataSource,
        localDataSource: LocalExchangeRateDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func fetch() async throws(FetchExchangeRateError) -> ExchangeRateList {
        throw FetchExchangeRateError.invalidData
    }
}
