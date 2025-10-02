//
//  UserDefaultsStorage.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 10/2/25.
//

import Foundation

public enum UserDefaultsStorage {

    enum Key: String {
        case nextUpdateTime
    }

    @UserDefault(key: Key.nextUpdateTime.rawValue, defaultValue: nil)
    public static var nextUpdateTime: TimeInterval?

    public static func shouldUpdateExchangeRate() -> Bool {
        guard let nextUpdateTime = nextUpdateTime else {
            return true
        }
        return Date().timeIntervalSince1970 > nextUpdateTime
    }

    @propertyWrapper
    public struct UserDefault<T> {
        private let key: String
        private let defaultValue: T

        init(key: String, defaultValue: T) {
            self.key = key
            self.defaultValue = defaultValue
        }

        public var wrappedValue: T {
            get {
                return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
            }
            set {
                UserDefaults.standard.set(newValue, forKey: key)
            }
        }
    }
}
