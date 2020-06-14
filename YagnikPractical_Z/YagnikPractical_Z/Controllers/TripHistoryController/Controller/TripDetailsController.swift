//
//  TripDetailsViewController.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 14/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class TripDetailsController: CoreViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var mapView: GMSMapView!
    
    //MARK:- Controls
    private lazy var pickupLocationMarker: GMSMarker = {
        let marker = GMSMarker()
        marker.icon = "ic_no_shadow_green_pin".imageWithOriginalMode
        return marker
    }()
    private lazy var dropoffLocationMarker: GMSMarker = {
        let marker = GMSMarker()
        marker.icon = "ic_no_shadow_pin".imageWithOriginalMode
        return marker
    }()
    
    private var locationSelectionFor: LocationSelection = .pickup
    
    enum LocationSelection {
        case pickup
        case dropOff
    }
    
    var ride = Ride(dictionary: [:])!

    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.isMyLocationEnabled = true
        updateUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationItem.backBarButtonItem?.tintColor = .white
    }
    
    //MARK:- Custom Methods
    private func updateUI() {
        if ride.pickup_address != nil && ride.dropoff_address != nil && Constants.checkAndAlertNoInterent(on: self) {
        if let fromCoordinate = self.ride.getPickUpCoordinates(), let toCoordinate = self.ride.getDropOffCoordinates() {
            self.pickupLocationMarker.map = self.mapView
            self.dropoffLocationMarker.map = self.mapView
            self.pickupLocationMarker.position = fromCoordinate
            self.dropoffLocationMarker.position = toCoordinate
            animateMapView(to: toCoordinate)
            }
        }
    }
    
    private func handleEvent() {
        LocationManager.manager.getUserCurrentLocation = { coordinates in
            let tempLocSelection = self.locationSelectionFor
            self.locationSelectionFor = tempLocSelection
            self.mapView.animate(toLocation: coordinates)
            self.pickupLocationMarker.position = coordinates
            self.animateMapView(to: coordinates)
        }
    }
    
    //MARK:- Animating map 
    private func animateMapView(to coordinates: CLLocationCoordinate2D) {
        let position = GMSCameraPosition.camera(withTarget: coordinates, zoom: 14.0)
        let cameraUpdatePosition = GMSCameraUpdate.setCamera(position)
        self.mapView.animate(with: cameraUpdatePosition)
    }

}
