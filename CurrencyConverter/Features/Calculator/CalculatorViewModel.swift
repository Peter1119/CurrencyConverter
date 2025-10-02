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
        var currency: String
        var countryName: String
        var exchangeRate: Double
        var inputAmount: String = ""
        var resultText: String = ""
    }

    enum Action {
        case updateAmount(String)
        case convert
    }

    private(set) var state: State

    init(currency: String, countryName: String, exchangeRate: Double) {
        self.state = State(
            currency: currency,
            countryName: countryName,
            exchangeRate: exchangeRate
        )
    }

    func send(_ action: Action) {
        switch action {
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
}
