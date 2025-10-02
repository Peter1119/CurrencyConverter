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
        rates: [String : Double],
        lastUpdateTime: Date,
        nextUpdateTime: Date
    ) {
        let locale: Locale = Locale(identifier: "ko_KR")
        self.rates = rates.map({ (code, rate) in
            let localizedName = locale.localizedString(forCurrencyCode: code) ?? code
            return ExchangeRate(
                code: code,
                name: localizedName,
                rate: rate
            )
        })
        self.lastUpdateTime = lastUpdateTime
        self.nextUpdateTime = nextUpdateTime
    }
}
