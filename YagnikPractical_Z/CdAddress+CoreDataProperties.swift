//
//  CdAddress+CoreDataProperties.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//

import Foundation
import CoreData


extension CdAddress {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CdAddress> {
        return NSFetchRequest<CdAddress>(entityName: "CdAddress")
    }

    @NSManaged public var address: String?
    @NSManaged public var address_id: Int16
    @NSManaged public var area: String?
    @NSManaged public var building_name: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var name: String?
    @NSManaged public var street_address: String?
    @NSManaged public var time: String?
    @NSManaged public var ride: CdRide?
    @NSManaged public var type: Int16

}
