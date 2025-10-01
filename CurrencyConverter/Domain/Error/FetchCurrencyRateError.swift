//
//  FetchCurrencyRateError.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 10/1/25.
//

import Foundation

enum FetchCurrencyRateError: Error {
    case networkError // 네트워크 문제
    case invalidData // 비어있거나 유효하지 않은 경우
}

extension FetchCurrencyRateError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "네트워크 연결에 실패했습니다."
        case .invalidData:
            return "환율 정보를 불러올 수 없습니다."
        }
    }

    var failureReason: String? {
        switch self {
        case .networkError:
            return "인터넷 연결을 확인해주세요."
        case .invalidData:
            return "서버에서 잘못된 데이터를 받았습니다."
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .networkError:
            return "인터넷 연결을 확인하고 다시 시도해주세요."
        case .invalidData:
            return "잠시 후 다시 시도해주세요."
        }
    }
}
