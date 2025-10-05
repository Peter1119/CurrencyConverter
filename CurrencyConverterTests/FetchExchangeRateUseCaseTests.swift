//
//  FetchExchangeRateUseCaseTests.swift
//  CurrencyConverterTests
//
//  Created by 홍석현 on 10/1/25.
//

import Testing
@testable import CurrencyConverter

struct FetchExchangeRateUseCaseTests {

    @Test
    func UseCase가_Repository를_호출하여_환율_정보를_가져온다() async throws {
        // Given
        let mockRepository = MockExchangeRateRepository()
        let sut = FetchExchangeRate(repository: mockRepository)

        // When
        let result = try await sut.execute()

        // Then
        #expect(result.rates.count > 0)
        #expect(mockRepository.fetchCallCount == 1)
    }

    @Test
    func Repository에서_에러가_발생하면_UseCase도_에러를_던진다() async throws {
        // Given
        let mockRepository = MockExchangeRateRepository(shouldThrowError: true)
        let sut = FetchExchangeRate(repository: mockRepository)

        // When & Then
        await #expect(throws: FetchExchangeRateError.self) {
            try await sut.execute()
        }
    }
}
