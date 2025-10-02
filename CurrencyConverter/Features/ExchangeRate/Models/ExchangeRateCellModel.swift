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
    var id: String {
        return currency
    }
    let currency: String
    let description: String
    private let rate: Double
    var rateText: String {
        return String(format: "%.4f", rate)
    }
    var trendEmoji: String {
        isIncreasing == nil ? " " : isIncreasing! ? "🔼" : "🔽"
    }
    var isIncreasing: Bool?
    var isFavorite: Bool = false
    var onFavoriteTap: (() -> Void)?

    init(
        currency: String,
        description: String,
        rate: Double,
        isIncreasing: Bool?
    ) {
        self.currency = currency
        self.description = description
        self.rate = rate
        self.isIncreasing = isIncreasing
    }
}

extension ExchangeRateCellModel {
    static var mockData: [ExchangeRateCellModel] {
        return [
            ExchangeRateCellModel(currency: "USD", description: "미국 달러", rate: 1350.50, isIncreasing: .random()),
            ExchangeRateCellModel(currency: "JPY", description: "일본 엔", rate: 9.45, isIncreasing: .random()),
            ExchangeRateCellModel(currency: "EUR", description: "유로", rate: 1450.80, isIncreasing: .random()),
            ExchangeRateCellModel(currency: "GBP", description: "영국 파운드", rate: 1680.25, isIncreasing: .random()),
            ExchangeRateCellModel(currency: "CNY", description: "중국 위안", rate: 187.30, isIncreasing: .random()),
            ExchangeRateCellModel(currency: "AUD", description: "호주 달러", rate: 890.60, isIncreasing: .random()),
            ExchangeRateCellModel(currency: "CAD", description: "캐나다 달러", rate: 980.40, isIncreasing: .random()),
            ExchangeRateCellModel(currency: "CHF", description: "스위스 프랑", rate: 1520.90, isIncreasing: .random()),
            ExchangeRateCellModel(currency: "HKD", description: "홍콩 달러", rate: 172.45, isIncreasing: .random()),
            ExchangeRateCellModel(currency: "SGD", description: "싱가포르 달러", rate: 1005.30, isIncreasing: .random()),
            ExchangeRateCellModel(currency: "NZD", description: "뉴질랜드 달러", rate: 820.75, isIncreasing: .random()),
            ExchangeRateCellModel(currency: "SEK", description: "스웨덴 크로나", rate: 128.60, isIncreasing: .random()),
            ExchangeRateCellModel(currency: "NOK", description: "노르웨이 크로네", rate: 132.90, isIncreasing: .random()),
            ExchangeRateCellModel(currency: "DKK", description: "덴마크 크로네", rate: 194.20, isIncreasing: .random()),
            ExchangeRateCellModel(currency: "THB", description: "태국 바트", rate: 38.75, isIncreasing: .random()),
            ExchangeRateCellModel(currency: "MYR", description: "말레이시아 링깃", rate: 302.15, isIncreasing: .random()),
            ExchangeRateCellModel(currency: "INR", description: "인도 루피", rate: 16.35, isIncreasing: .random()),
            ExchangeRateCellModel(currency: "MXN", description: "멕시코 페소", rate: 78.50, isIncreasing: .random()),
            ExchangeRateCellModel(currency: "BRL", description: "브라질 헤알", rate: 265.80, isIncreasing: .random()),
            ExchangeRateCellModel(currency: "ZAR", description: "남아공 랜드", rate: 72.40, isIncreasing: .random())
        ]
    }
}
