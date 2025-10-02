//
//  ExchangeRate.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 10/2/25.
//

import Foundation

public class ExchangeRate {
    let code: String
    let name: String
    let rate: Double
    var isIncreasing: Bool?
    var isFavorite: Bool

    init(
        code: String,
        rate: Double,
        isIncreasing: Bool? = nil,
        isFavorite: Bool = false
    ) {
        let locale: Locale = Locale(identifier: "ko_KR")
        let localizedName = locale.localizedString(forCurrencyCode: code) ?? code
        self.code = code
        self.name = localizedName
        self.rate = rate
        self.isIncreasing = isIncreasing
        self.isFavorite = isFavorite
    }
}

// MARK: - Mock Data
extension ExchangeRate {
    static var mockData: [ExchangeRate] {
        [
            ExchangeRate(code: "USD", rate: 1300.50, isIncreasing: true, isFavorite: true),
            ExchangeRate(code: "JPY", rate: 9.82, isIncreasing: false, isFavorite: false),
            ExchangeRate(code: "EUR", rate: 1420.75, isIncreasing: true, isFavorite: true),
            ExchangeRate(code: "GBP", rate: 1650.30, isIncreasing: nil, isFavorite: false),
            ExchangeRate(code: "CNY", rate: 182.45, isIncreasing: false, isFavorite: false),
            ExchangeRate(code: "AUD", rate: 865.20, isIncreasing: true, isFavorite: false),
            ExchangeRate(code: "CAD", rate: 950.80, isIncreasing: nil, isFavorite: false),
            ExchangeRate(code: "CHF", rate: 1480.60, isIncreasing: true, isFavorite: false),
            ExchangeRate(code: "HKD", rate: 165.90, isIncreasing: false, isFavorite: false),
            ExchangeRate(code: "SGD", rate: 980.40, isIncreasing: nil, isFavorite: false)
        ]
    }

    static var mockSingle: ExchangeRate {
        ExchangeRate(code: "USD", rate: 1300.50, isIncreasing: true, isFavorite: true)
    }
}
