//
//  ExchangeRateInfoTests.swift
//  CurrencyConverterTests
//
//  Created by 홍석현 on 10/1/25.
//

import Testing
@testable import CurrencyConverter

struct ExchangeRateInfoTests {

    @Test
    func USD_코드일경우_미국달러_라고_locale되게_나온다() async throws {
        // Given
        let sut = ExchangeRateInfo(
            rates: ["USD": 1.0],
            lastUpdateTime: .now,
            nextUpdateTime: .now
        )

        // When
        let usdInfo = sut.rates.first(where: { $0.code == "USD" })

        // Then
        #expect(usdInfo?.name == "미국 달러")
    }

    @Test
    func JPY_코드일경우_일본엔_이라고_locale되게_나온다() async throws {
        // Given
        let sut = ExchangeRateInfo(
            rates: ["JPY": 148.20],
            lastUpdateTime: .now,
            nextUpdateTime: .now
        )

        // When
        let jpyInfo = sut.rates.first(where: { $0.code == "JPY" })

        // Then
        #expect(jpyInfo?.name == "일본 엔")
    }

    @Test
    func EUR_코드일경우_유로_라고_locale되게_나온다() async throws {
        // Given
        let sut = ExchangeRateInfo(
            rates: ["EUR": 0.85],
            lastUpdateTime: .now,
            nextUpdateTime: .now
        )

        // When
        let eurInfo = sut.rates.first(where: { $0.code == "EUR" })

        // Then
        #expect(eurInfo?.name == "유로")
    }

    @Test
    func 여러_통화_코드가_있을때_각각_올바른_이름으로_변환된다() async throws {
        // Given
        let sut = ExchangeRateInfo(
            rates: [
                "USD": 1.0,
                "JPY": 148.20,
                "KRW": 1300.50,
                "EUR": 0.85
            ],
            lastUpdateTime: .now,
            nextUpdateTime: .now
        )

        // When & Then
        #expect(sut.rates.count == 4)
        #expect(sut.rates.first(where: { $0.code == "USD" })?.name == "미국 달러")
        #expect(sut.rates.first(where: { $0.code == "JPY" })?.name == "일본 엔")
        #expect(sut.rates.first(where: { $0.code == "KRW" })?.name == "대한민국 원")
        #expect(sut.rates.first(where: { $0.code == "EUR" })?.name == "유로")
    }
}
