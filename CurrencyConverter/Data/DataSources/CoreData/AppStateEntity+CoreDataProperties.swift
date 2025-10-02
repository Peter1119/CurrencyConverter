//
//  AppStateEntity+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 10/2/25.
//

import Foundation
import CoreData

extension AppStateEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppStateEntity> {
        return NSFetchRequest<AppStateEntity>(entityName: "AppStateEntity")
    }

    @NSManaged public var lastScreen: String
    @NSManaged public var lastCurrencyCode: String?
}
