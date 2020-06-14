//
//  CdRide+CoreDataProperties.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//

import Foundation
import CoreData


extension CdRide {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CdRide> {
        return NSFetchRequest<CdRide>(entityName: "CdRide")
    }

    @NSManaged public var ride_id: Int16
    @NSManaged public var ride_type: Int16
    @NSManaged public var distance: String
    @NSManaged public var address: CdAddress?
    @NSManaged public var status: CdStatus?

}
