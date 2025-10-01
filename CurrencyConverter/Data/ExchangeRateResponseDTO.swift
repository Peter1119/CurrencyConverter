//
//  ResponseDTO.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 10/1/25.
//

import Foundation

struct ExchangeRateResponseDTO: Decodable {
    let result: String
    let baseCode: String
    let rates: [String: Double]
    let timeLastUpdateUnix: Int
    let timeNextUpdateUnix: Int

    enum CodingKeys: String, CodingKey {
        case result
        case baseCode = "base_code"
        case rates
        case timeLastUpdateUnix = "time_last_update_unix"
        case timeNextUpdateUnix = "time_next_update_unix"
    }
}

extension ExchangeRateResponseDTO {
    func toDomain() -> ExchangeRateList {
        return ExchangeRateList(
            rates: self.rates,
            lastUpdateTime: Date(timeIntervalSince1970: TimeInterval(self.timeLastUpdateUnix)),
            nextUpdateTime: Date(timeIntervalSince1970: TimeInterval(self.timeNextUpdateUnix))
        )
    }
}
