//
//  FavoriteEntity+CoreDataProperties.swift
//  CurrencyConverter
//
//  Created by 홍석현 on 10/1/25.
//
//

import Foundation
import CoreData


extension FavoriteEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteEntity> {
        return NSFetchRequest<FavoriteEntity>(entityName: "FavoriteEntity")
    }

    @NSManaged public var code: String?

}

extension FavoriteEntity : Identifiable {

}
