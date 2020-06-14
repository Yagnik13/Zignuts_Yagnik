//
//  CdStatus+CoreDataProperties.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//

import Foundation
import CoreData


extension CdStatus {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CdStatus> {
        return NSFetchRequest<CdStatus>(entityName: "CdStatus")
    }

    @NSManaged public var id: Int16
    @NSManaged public var message: String?
    @NSManaged public var name: String?
    @NSManaged public var ride: CdRide?

}
