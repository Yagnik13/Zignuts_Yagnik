//
//  Address.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//

import Foundation
import CoreData

struct Address: Codable {
    
    var address_id : Int?
    var name : String?
    var building_name : String?
    var street_address : String?
    var area : String?
    var address : String?
    var latitude : String?
    var longitude : String?
    var time : String?
    
    init?(dictionary: StringAny) {
        address_id = dictionary["address_id"] as? Int
        name = dictionary["name"] as? String
        building_name = dictionary["building_name"] as? String
        street_address = dictionary["street_address"] as? String
        area = dictionary["area"] as? String
        address = dictionary["address"] as? String
        latitude = dictionary["latitude"] as? String
        longitude = dictionary["longitude"] as? String
        time = dictionary["time"] as? String
    }
    
    init?(_ data: CdAddress) {
        address_id = data.value(forKey: "address_id") as? Int
        name = data.value(forKey: "name") as? String
        building_name = data.value(forKey: "building_name") as? String
        street_address = data.value(forKey: "street_address") as? String
        area = data.value(forKey: "area") as? String
        address = data.value(forKey: "address") as? String
        latitude = data.value(forKey: "latitude") as? String
        longitude = data.value(forKey: "longitude") as? String
        time = data.value(forKey: "time") as? String
    }
    
    func dictionaryRepresentation() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(address_id, forKey: "address_id")
        dictionary.setValue(name, forKey: "name")
        dictionary.setValue(building_name, forKey: "building_name")
        dictionary.setValue(street_address, forKey: "street_address")
        dictionary.setValue(area, forKey: "area")
        dictionary.setValue(address, forKey: "address")
        dictionary.setValue(latitude, forKey: "latitude")
        dictionary.setValue(longitude, forKey: "longitude")
        dictionary.setValue(time, forKey: "time")
        return dictionary
    }
    
}
