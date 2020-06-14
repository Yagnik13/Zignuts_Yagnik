//
//  ResponseData.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//

import Foundation

struct AppError: Error {
    
    let code : Int?
    let status : String?
    let message : String?
    let data: Any?
    let error: Error?
    
    func getResponseDictionary() -> StringAny? {
        return data as? StringAny
    }
    func getResponseArryDictionary() -> [StringAny]? {
        return data as? [StringAny]
    }
}

struct CoreResponseData : Codable {
    
    var code : Int?
    var status : String?
    var message : String?
    var exception : String?
    var data : Any?
    var current_page : Int?
    var next_page : Int?
    var total_rows : Int?
    private var ride: Ride?
    private var address: Address?
    private var addresses: [Address]?
    private var rides: [Ride]?
    
    enum CodingKeys: String, CodingKey {
        
        case code = "code"
        case status = "status"
        case message = "message"
        case exception = "exception"
        case data = "data"
        case current_page = "current_page"
        case next_page = "next_page"
        case total_rows = "total_rows"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        exception = try values.decodeIfPresent(String.self, forKey: .exception)
        if let stringAny = try? values.decode(StringAny.self, forKey: .data) {
            data = stringAny
        } else if let stringAny = try? values.decode([Any].self, forKey: .data) {
            data = stringAny
        }
        current_page = try values.decodeIfPresent(Int.self, forKey: .current_page)
        next_page = try values.decodeIfPresent(Int.self, forKey: .next_page)
        total_rows = try values.decodeIfPresent(Int.self, forKey: .total_rows)
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
    
    init() {
        code = nil
        status = nil
        message = nil
        data = nil
        current_page = nil
        next_page = nil
        total_rows = nil
        exception = nil
    }
    
    func getResponseDictionary() -> StringAny? {
        return data as? StringAny
    }
    
    func getResponseArrayDictionary() -> [StringAny]? {
        return data as? [StringAny]
    }
    
    mutating func getRide() -> Ride? {
        if let ride = self.ride {
            return ride
        }
        if let stringAny = getResponseDictionary() {
            ride = Ride(dictionary: stringAny)
            return ride!
        }
        return nil
    }
    
    mutating func getAddresses() -> [Address]? {
        if let addresses = self.addresses {
            return addresses
        }
        if let arrayDictionary = getResponseArrayDictionary() {
            var tempAddresses = [Address]()
            for singleDictionary in arrayDictionary {
                tempAddresses.append(Address(dictionary: singleDictionary)!)
            }
            self.addresses = tempAddresses
            return addresses!
        }
        return nil
    }
    
    mutating func getAddress() -> Address? {
        if let address = self.address {
            return address
        }
        if let addressDict = getResponseDictionary() {
            self.address = Address(dictionary: addressDict)!
            return self.address!
        }
        return nil
    }
    
    mutating func getAllRides() -> [Ride]? {
        if let rides = self.rides {
            return rides
        }
        if let arrayDictionary = getResponseArrayDictionary() {
            var tempRides = [Ride]()
            for singleDictionary in arrayDictionary {
                tempRides.append(Ride(dictionary: singleDictionary)!)
            }
            self.rides = tempRides
            return rides!
        }
        return nil
    }
    
}
