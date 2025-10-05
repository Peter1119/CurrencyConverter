//
//  ExchangeRateList.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 10/1/25.
//

import Foundation

public struct ExchangeRateList {
    let rates: [ExchangeRate]
    let lastUpdateTime: Date
    let nextUpdateTime: Date
    
    init(
        rates: [ExchangeRate],
        lastUpdateTime: Date,
        nextUpdateTime: Date
    ) {
        self.rates = rates
        self.lastUpdateTime = lastUpdateTime
        self.nextUpdateTime = nextUpdateTime
    }
}

extension ExchangeRateList {
    static var mock: ExchangeRateList {
        return ExchangeRateList(
            rates: ExchangeRate.mockData,
            lastUpdateTime: .now,
            nextUpdateTime: .now
        )
    }
}
