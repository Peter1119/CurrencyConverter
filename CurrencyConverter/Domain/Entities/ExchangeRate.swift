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
        name: String,
        rate: Double,
        isIncreasing: Bool? = nil,
        isFavorite: Bool = false
    ) {
        self.code = code
        self.name = name
        self.rate = rate
        self.isIncreasing = isIncreasing
        self.isFavorite = isFavorite
    }
}
