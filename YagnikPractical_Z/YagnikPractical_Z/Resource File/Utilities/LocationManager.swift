//
//  LocationManager.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//


import UIKit
import CoreLocation
import GoogleMaps

final class LocationManager: NSObject {
    
    static let manager = LocationManager()
    
    private let gmsGeocoder = GMSGeocoder()
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    
    var lastLocation: CLLocation?
    var locations: [CLLocation] = []
    var previousLocation: CLLocation?
    
    var getUserCurrentLocation: ((_ coordinates: CLLocationCoordinate2D)->Void)? {
        didSet {
            self.locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            }
        }
    }
    var getUserLocation: ((_ coordinates: CLLocationCoordinate2D)->Bool)? {
        didSet {
            self.locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
                locationManager.startMonitoringSignificantLocationChanges()
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    func getAddress(from coordinates: CLLocationCoordinate2D, completion: ((_ gmsAddress: GMSAddress?, _ address: Address?, _ error: Error?)->Void)?) {
        gmsGeocoder.reverseGeocodeCoordinate(coordinates, completionHandler: { (response, error) in
            if let err = error {
                print(err.localizedDescription)
                completion?(nil, nil, err)
            } else if let resultAddress = response?.firstResult() {
                var address = Address(dictionary: [:])!
                address.latitude = "\(coordinates.latitude)"
                address.longitude = "\(coordinates.longitude)"
                address.address = resultAddress.lines?.joined(separator: ", ")
                completion?(resultAddress, address, nil)
            }
        })
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }

        guard let location = locations.first else { return }
        guard location.timestamp.timeIntervalSinceNow < 10 || location.horizontalAccuracy > 0 else {
            print("invalid location received")
            return
        }
        
        self.locations.append(location)
        previousLocation = lastLocation
        lastLocation = location
        print("location = \(location.coordinate.latitude) \(location.coordinate.longitude)")
        
        getUserCurrentLocation?(locValue)
        if getUserLocation == nil || !(getUserLocation?(locValue) ?? false) {
            manager.stopUpdatingLocation()
            manager.stopMonitoringSignificantLocationChanges()
        }
    }
}
