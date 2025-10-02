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
        print("🔍 [Repository] 환율 데이터 조회 시작")

        // 1. Local에서 먼저 조회
        do {
            let localRates = try await localDataSource.loadRates()
            print("💾 [Repository] Local 데이터 개수: \(localRates.count)")

            if localRates.isEmpty {
                print("🌐 [Repository] Local 데이터 없음 → Remote에서 조회")

                // 2. Local에 데이터가 없으면 Remote에서 가져오기
                let remoteList = try await remoteDataSource.fetch().toDomain()
                print("✅ [Repository] Remote 데이터 조회 완료: \(remoteList.rates.count)개")

                // 3. Remote 데이터를 Local에 저장
                try await localDataSource.saveRates(remoteList.rates)
                print("💾 [Repository] Remote 데이터를 Local에 저장 완료")

                // 4. Remote 데이터 반환
                return remoteList
            } else {
                print("✅ [Repository] Local 데이터 사용 (\(localRates.count)개)")

                // 5. Local 데이터가 있으면 그대로 반환
                // TODO: Locale 변환 및 즐겨찾기 정보 추가 필요
                return ExchangeRateList(
                    rates: localRates,
                    lastUpdateTime: .now,
                    nextUpdateTime: .now
                )
            }
        } catch {
            print("❌ [Repository] 에러 발생: \(error)")
            throw FetchExchangeRateError.invalidData
        }
    }
}
