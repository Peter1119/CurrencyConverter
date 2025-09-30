//
//  ExchangeRateCellModel.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 9/30/25.
//

import Foundation
import Observation

@Observable
class ExchangeRateCellModel {
    var id = UUID().uuidString
    let currency: String
    let description: String
    private let rate: Double
    var rateText: String {
        return String(format: "%.4f", rate)
    }
    var trendEmoji: String {
        isIncreasing ? "🔼" : "🔽"
    }
    var isIncreasing: Bool
    var isFavorite: Bool = false
    var onTap: ((String) -> Void)?

    init(
        currency: String,
        description: String,
        rate: Double,
        isIncreasing: Bool,
        onTap: ((String) -> Void)? = nil
    ) {
        self.currency = currency
        self.description = description
        self.rate = rate
        self.isIncreasing = isIncreasing
        self.onTap = onTap
    }
}
