//
//  MyRides.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//

import Foundation
import CoreLocation
import CoreData

struct Ride: Codable {
    
    var ride_id : Int?
    var pickup_address : Address?
    var dropoff_address : Address?
    var status : Status?
    var ride_type: Int?
    var distance : String?
    
    init?(dictionary: StringAny) {
        ride_id = dictionary["ride_id"] as? Int
        distance = dictionary["distance"] as? String
        if let pickupAddressDict = dictionary["pickup_address"] as? StringAny {
            pickup_address = Address(dictionary: pickupAddressDict)
        }
        if let dropOffAddressDict = dictionary["dropoff_address"] as? StringAny {
            dropoff_address = Address(dictionary: dropOffAddressDict)
        }
        
        if let statusDict = dictionary["status"] as? StringAny {
            status = Status(dictionary: statusDict)
        }
    }
    
    init?(_ data: CdRide) {
        ride_id = data.value(forKey: "ride_id") as? Int
        distance = data.value(forKey: "distance") as? String
        if let address = data.value(forKey: "addresses") as? [CdAddress] {
            if address.count > 0 {
                for ind in 0..<address.count {
                    if address[ind].type == 0 {
                        pickup_address = Address(data.value(forKey: "addresses") as! CdAddress)
                    }else {
                        dropoff_address = Address(data.value(forKey: "addresses") as! CdAddress)
                    }
                }
            }
        }
        
        ride_type = data.value(forKey: "ride_type") as? Int
//        status = Status(data.value(forKey: "status") as! CdStatus)
        
    }
    
    func dictionaryRepresentation() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(ride_id, forKey: "ride_id")
        dictionary.setValue(distance, forKey: "distance")
        dictionary.setValue(pickup_address?.dictionaryRepresentation(), forKey: "pickup_address")
        dictionary.setValue(dropoff_address?.dictionaryRepresentation(), forKey: "dropoff_address")
        dictionary.setValue(status?.dictionaryRepresentation(), forKey: "status")
        return dictionary
    }
    
    func getPickUpCoordinates() -> CLLocationCoordinate2D? {
        if let pickupLat = pickup_address?.latitude, let pickupLong = pickup_address?.longitude, !pickupLat.isEmpty, !pickupLong.isEmpty {
            return CLLocationCoordinate2D(latitude: (pickupLat as NSString).doubleValue, longitude: (pickupLong as NSString).doubleValue)
        }
        return nil
    }
    
    func getDropOffCoordinates() -> CLLocationCoordinate2D? {
        if let pickupLat = dropoff_address?.latitude, let pickupLong = dropoff_address?.longitude, !pickupLat.isEmpty, !pickupLong.isEmpty {
            return CLLocationCoordinate2D(latitude: (pickupLat as NSString).doubleValue, longitude: (pickupLong as NSString).doubleValue)
        }
        return nil
    }
    
    func getDistance(pickupLocation : CLLocationCoordinate2D , dropoffLocation : CLLocationCoordinate2D ) -> CLLocationDistance? {
        let fromLocation : CLLocation = CLLocation(latitude:pickupLocation.latitude, longitude:pickupLocation.longitude)
        let toLocation : CLLocation = CLLocation(latitude:dropoffLocation.latitude, longitude:dropoffLocation.longitude)
        
        return toLocation.distance(from: fromLocation)
    }
    
    func getRideType() -> RideType {
        return RideType(rawValue: ride_type ?? 0)!
    }
    mutating func setRideType(to type: RideType) {
        self.ride_type = type.rawValue
    }
}


struct Status: Codable {
  
    var id : Int?
    var name : String?
    var message: String?
    
    init?(dictionary: StringAny) {
        id = dictionary["id"] as? Int
        name = dictionary["name"] as? String
        message = dictionary["message"] as? String
    }

    init?(_ data: CdStatus) {
        id = data.value(forKey: "id") as? Int
        name = data.value(forKey: "name") as? String
        message = data.value(forKey: "message") as? String
    }
    
    func dictionaryRepresentation() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        dictionary.setValue(id, forKey: "id")
        dictionary.setValue(name, forKey: "name")
        dictionary.setValue(message, forKey: "message")
        return dictionary
    }
    
}
