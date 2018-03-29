//
//  City+CoreDataProperties.swift
//  
//
//  Created by George Kyrylenko on 29.03.2018.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var city: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}
