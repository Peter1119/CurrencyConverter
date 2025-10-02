//
//  ExchangeRateEntity+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 10/1/25.
//
//

import Foundation
import CoreData


extension ExchangeRateEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExchangeRateEntity> {
        return NSFetchRequest<ExchangeRateEntity>(entityName: "ExchangeRateEntity")
    }

    @NSManaged public var code: String
    @NSManaged public var rate: Double

}

extension ExchangeRateEntity : Identifiable {

}
