//
//  CalculatorViewModel.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 9/30/25.
//

import Foundation
import Observation

@Observable
final class CalculatorViewModel {
    struct State {
        var currency: String = ""
        var countryName: String = ""
        var exchangeRate: Double = 0
        var inputAmount: String = ""
        var resultText: String = ""
        var shouldPopViewController: Bool = false
    }

    enum Action {
        case loadExchangeRate(String)
        case updateAmount(String)
        case convert
    }

    private(set) var state: State
    private let fetchExchangeRateUseCase: FetchExchangeRateUseCase

    init(fetchExchangeRateUseCase: FetchExchangeRateUseCase, currencyCode: String) {
        self.fetchExchangeRateUseCase = fetchExchangeRateUseCase
        self.state = State(currency: currencyCode)
    }

    // 기존 사용 호환성을 위한 convenience init
    convenience init(currency: String, countryName: String, exchangeRate: Double) {
        fatalError("Use init(fetchExchangeRateUseCase:currencyCode:) instead")
    }

    func send(_ action: Action) async {
        switch action {
        case .loadExchangeRate(let currencyCode):
            await loadExchangeRate(currencyCode)

        case .updateAmount(let amount):
            state.inputAmount = amount

        case .convert:
            guard let amount = Double(state.inputAmount) else {
                state.resultText = "올바른 금액을 입력하세요"
                return
            }
            let result = amount * state.exchangeRate
            state.resultText = String(format: "%.2f KRW", result)
        }
    }

    private func loadExchangeRate(_ currencyCode: String) async {
        // 캐시된 데이터 조회 (네트워크 호출 없이)
        guard let rate = try? await fetchExchangeRateUseCase.getSingleRate(currencyCode) else {
            // 데이터 없으면 뒤로가기
            state.shouldPopViewController = true
            return
        }

        state.currency = rate.code
        state.countryName = rate.name
        state.exchangeRate = rate.rate
    }
}
