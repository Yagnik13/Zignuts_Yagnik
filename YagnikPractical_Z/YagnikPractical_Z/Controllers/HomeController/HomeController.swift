//
//  HomeController.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//

import UIKit
import GoogleMaps
import CoreLocation
import SideMenuSwift
import CoreData

class HomeNavigationController: CoreNavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuController?.delegate = self
    }
}

extension HomeNavigationController: SideMenuControllerDelegate {
    func sideMenuController(_ sideMenuController: SideMenuController, willShow viewController: UIViewController, animated: Bool) {
        self.view.endEditing(true)
    }
    func sideMenuController(_ sideMenuController: SideMenuController, didShow viewController: UIViewController, animated: Bool) {
        self.view.endEditing(true)
    }
}

class HomeController: CoreViewController {
    
    //MARK:- Outlets
    ///Will act as back button if rideStatus is confirm else menu button
    @IBOutlet weak var menuButton: CoreButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var confirmRideView: ConfirmRideView!
    @IBOutlet weak var cancelRideButton: CoreButton!
    @IBOutlet weak var pickupDropOffButton: CoreButton!
    @IBOutlet weak var coordinatesStackView: UIStackView!
    @IBOutlet weak var pickupDropoffImageView: UIImageView!
    @IBOutlet var confirmRideViewBottomConstraintToSafeArea: NSLayoutConstraint!
    @IBOutlet var confirmRideViewTopConstraintToSuperView: NSLayoutConstraint!
    @IBOutlet var menuButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var cancelButtonTrailingToSuperview: NSLayoutConstraint!
    @IBOutlet var cancelButtonLeadingToSuperview: NSLayoutConstraint!
    
    var rideID = 0
    
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
    
    //MARK:- Properties
    private var keepUpdatingCurrentLocation: Bool = true
    
    enum LocationSelection {
        case pickup
        case dropOff
    }
    private var ride = Ride(dictionary: [:])!
    private var locationSelectionFor: LocationSelection = .pickup
    private var rideStatus: RideStatus = .Incomplete
    var loctionSelectedBlock: ((_ for: LocationSelection, _ address: Address?)->Void)?
    
    private var aryRides = [Ride]()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDetailFromCoreData()
        handleEvent()
        menuButton.tintColor = .black
        
        mapView.isMyLocationEnabled = true
        self.updateView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension HomeController {
    
    //MARK:- Custom Methods
    private func handleEvent() {
        menuButton.handleTap = {
            if self.rideStatus == .confirm {
                self.mapView.clear()
                self.updateRideStatus(to: .Incomplete)
                self.updateUI()
            } else {
                if self.locationSelectionFor == .dropOff && self.rideStatus == .Incomplete {
                    self.mapView.clear()
                    self.locationSelectionFor = .pickup
                    self.updateUI()
                } else {
                    self.sideMenuController?.revealMenu()
                }
            }
        }
        
        pickupDropOffButton.handleTap = {
            func getAddress(for position: CLLocationCoordinate2D, completion: ((_ address: Address?)->Void)?) {
                LocationManager.manager.getAddress(from: position) { (gmsAddress, address, err) in
                    if let error = err {
                        print("getAddress: \(error.localizedDescription)")
                    }
                    completion?(address)
                }
            }
            //MARK:- Pickup Location
            if self.locationSelectionFor == .pickup {
                //put condition for internet check as per QA's decision.
                if Constants.checkAndAlertNoInterent(on: self)  {
                    getAddress(for: self.mapView.projection.coordinate(for: self.mapView.center)) { (address) in
                        if let pickupAddress = address {
                            //TODO Pickup location
                            self.ride.pickup_address = pickupAddress
                            self.locationSelectionFor = .dropOff
                            self.updateUI()
                            self.ride.pickup_address?.time = Constants.getCurrentDateTime()
                        }
                    }
                }
            } else {
                //MARK:- Dropoff Location
                if self.ride.dropoff_address == nil {
                    getAddress(for: self.mapView.projection.coordinate(for: self.mapView.center)) { (address) in
                        if let dropoff_address = address {
                            self.ride.dropoff_address = dropoff_address
                            self.updateUI()
                        }
                    }
                } else {
                    self.ride.setRideType(to: .normal)
                    self.ride.dropoff_address?.time = Constants.getCurrentDateTime()
                    self.checkAndConfirmRide()
                }
            }
        }
        
        //MARK:- Cancel Button Action
        confirmRideView.confirmButton.handleTap = {
            if Constants.checkAndAlertNoInterent(on: self) {
                self.updateRideStatus(to: .Complete)
            }
        }
        
        //MARK:- View ride Button Action
        confirmRideView.viewRideButton.handleTap = {
            if Constants.checkAndAlertNoInterent(on: self) {
                //TODO: Show in details page
                self.updateRideStatus(to: .Complete)
                let detailsVC = TripDetailsController.instantiateFromStoryboard()
                detailsVC.ride = self.ride
                self.ride = Ride(dictionary: [:])!
                self.navigationController?.pushViewController(detailsVC, animated: true)
            }
        }
        
        //MARK:- For Current Location
        LocationManager.manager.getUserCurrentLocation = { coordinates in
            let tempLocSelection = self.locationSelectionFor
            self.locationSelectionFor = tempLocSelection
            self.mapView.animate(toLocation: coordinates)
            self.pickupLocationMarker.position = coordinates
            self.animateMapView(to: coordinates)
        }
    }
    
    //MARK:- For UI Managment
    private func updateUI() {
        var markerCoordinates: CLLocationCoordinate2D!
        if locationSelectionFor == .pickup {
            if let coordinates = ride.getPickUpCoordinates() {
                markerCoordinates = coordinates
            } else {
                markerCoordinates = mapView.camera.target
            }
            pickupLocationMarker.position = markerCoordinates
        } else {
            if let coordinates = ride.getDropOffCoordinates() {
                markerCoordinates = coordinates
            } else {
                markerCoordinates = mapView.camera.target
            }
            dropoffLocationMarker.position = markerCoordinates
        }
        if (rideStatus != .Incomplete && rideStatus != .confirm) {
            menuButton.setImage("ic_menu".imageWithTemplatedMode, for: .normal)
        } else {
            menuButton.setImage("\(locationSelectionFor == .pickup ? "ic_menu" : "ic_search_back_2")".imageWithTemplatedMode, for: .normal)
        }
        pickupDropOffButton.setTitle(locationSelectionFor == .pickup ? "Start Trip".localized : "End Trip".localized, for: .normal)
        pickupDropoffImageView.image = "\(locationSelectionFor == .pickup ? "ic_green_pin" : "ic_location_selection_pin")".imageWithOriginalMode
        animateMapView(to: markerCoordinates)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        self.view.endEditing(true)
    }
    
    //MARK:- For Checking and confirming ride
    private func checkAndConfirmRide() {
        if ride.pickup_address != nil && ride.dropoff_address != nil && Constants.checkAndAlertNoInterent(on: self) {
            if let fromCoordinate = self.ride.getPickUpCoordinates(), let toCoordinate = self.ride.getDropOffCoordinates() {
                self.updateRideStatus(to: .confirm)
                self.pickupLocationMarker.map = self.mapView
                self.dropoffLocationMarker.map = self.mapView
                self.pickupLocationMarker.position = fromCoordinate
                self.dropoffLocationMarker.position = toCoordinate
                print(self.rideID)
                self.rideID += 1
                self.ride.ride_id = self.rideID
                self.confirmRideView.rideDetails = self.ride
                if let distance = self.ride.getDistance(pickupLocation: toCoordinate, dropoffLocation: fromCoordinate) {
                    let dis = distance / 1000
                    let diff = "\(String(format:"%.02f", dis)) KM"
                    print(diff)
                    self.ride.distance = diff
                }
                saveInCoreData(rideDetails: self.ride)
            }
            
        }
    }
    
    //MARK:- For Update ride status
    func updateRideStatus(to newStatus: RideStatus, withTempData data: StringAny? = nil) {
        self.view.endEditing(true)
        rideStatus = newStatus
        switch rideStatus {
        case .Incomplete:
            menuButtonLeadingConstraint.constant = 16
            menuButton.setImage("\(locationSelectionFor == .pickup ? "ic_menu" : "ic_search_back_2")".imageWithTemplatedMode, for: .normal)
            cancelButtonTrailingToSuperview.isActive = false
            cancelButtonLeadingToSuperview.isActive = true
            confirmRideViewBottomConstraintToSafeArea.isActive = false
            confirmRideViewTopConstraintToSuperView.isActive = true
            coordinatesStackView.isHidden = false
            pickupDropoffImageView.isHidden = false
            break
        case .confirm:
            menuButtonLeadingConstraint.constant = 16
            menuButton.setImage("\(locationSelectionFor == .pickup ? "ic_menu" : "ic_search_back_2")".imageWithTemplatedMode, for: .normal)
            confirmRideViewTopConstraintToSuperView.isActive = false
            confirmRideViewBottomConstraintToSafeArea.isActive = true
            coordinatesStackView.isHidden = true
            pickupDropoffImageView.isHidden = true
            break
        case .Confirmed:
            menuButtonLeadingConstraint.constant = 16
            menuButton.setImage("ic_menu".imageWithOriginalMode, for: .normal)
            cancelButtonLeadingToSuperview.isActive = false
            cancelButtonTrailingToSuperview.isActive = true
            coordinatesStackView.isHidden = true
            pickupDropoffImageView.isHidden = true
            break
        case .Complete:
            menuButton.setImage("ic_menu".imageWithOriginalMode, for: .normal)
            confirmRideViewBottomConstraintToSafeArea.isActive = false
            confirmRideViewTopConstraintToSuperView.isActive = true
            cancelButtonTrailingToSuperview.isActive = false
            cancelButtonLeadingToSuperview.isActive = true
            coordinatesStackView.isHidden = false
            pickupDropoffImageView.isHidden = false
            self.mapView.clear()
            locationSelectionFor = .pickup
            self.updateUI()
            break
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    //MARK:- For animating map
    private func animateMapView(to coordinates: CLLocationCoordinate2D) {
        let position = GMSCameraPosition.camera(withTarget: coordinates, zoom: 16.0)
        let cameraUpdatePosition = GMSCameraUpdate.setCamera(position)
        self.mapView.animate(with: cameraUpdatePosition)
    }
    
    //MARK:- For Update UI
    func updateView() {
        if let status = ride.status?.id {
            let rideStatuses = RideStatus.allCases
            for singleRideStatus in rideStatuses {
                self.locationSelectionFor = .dropOff
                self.updateUI()
                self.updateRideStatus(to: singleRideStatus)
                if singleRideStatus.key == status {
                    self.rideStatus = singleRideStatus
                    if self.rideStatus != .Incomplete {
                        //                        self.drawPolyline()
                    } else {
                        if self.ride.ride_id != nil {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            }
                        }
                    }
                    break
                }
            }
        }
    }
    
    //MARK:- For Reset Ride
    private func resetRide() {
        self.ride = Ride(dictionary: [:])!
        if let coordinates = self.mapView.myLocation?.coordinate {
            self.animateMapView(to: coordinates)
        }
        self.updateRideStatus(to: .Incomplete)
    }
}

extension HomeController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if rideStatus == .Incomplete {
            LocationManager.manager.getAddress(from: position.target) { (gmsAddress, address, error) in
                if let err = error {
                    print("GetAddress error: \(err.localizedDescription)")
                } else if let address = address {
                    if self.locationSelectionFor == .pickup {
                        self.ride.pickup_address = address
                    } else {
                        self.ride.dropoff_address = address
                    }
                }
            }
        }
    }
        
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let _ = mapView.projection.coordinate(for: mapView.center)
        let _ = mapView.getSouthNorthEastLatLong()
    }
    
}


//MARK:- Core Data Save Method
extension HomeController {
    
    func saveInCoreData(rideDetails : Ride) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "CdRide", in: managedContext)!
        
        let rideObj = NSManagedObject(entity: entity,insertInto: managedContext)
        rideObj.setValue(rideDetails.ride_id, forKey: "ride_id")
        rideObj.setValue(rideDetails.ride_type, forKey: "ride_type")
        rideObj.setValue(rideDetails.distance, forKey: "distance")
        
        let addressEntity = NSEntityDescription.entity(forEntityName: "CdAddress", in: managedContext)!
        
        //--- for pickup
        
        let pickupAddress = NSManagedObject(entity: addressEntity,insertInto: managedContext)
        pickupAddress.setValue(rideDetails.ride_id, forKey: "address_id")
        pickupAddress.setValue(rideDetails.pickup_address?.address, forKey: "address")
        pickupAddress.setValue(rideDetails.pickup_address?.latitude, forKey: "latitude")
        pickupAddress.setValue(rideDetails.pickup_address?.longitude, forKey: "longitude")
        pickupAddress.setValue(rideDetails.pickup_address?.time, forKey: "time")
        pickupAddress.setValue(0, forKey: "type")
        pickupAddress.setValue(rideObj, forKey: "ride")
        
        //--- for dropoff
        
        let dropoffAddress = NSManagedObject(entity: addressEntity,insertInto: managedContext)
        
        dropoffAddress.setValue(rideDetails.ride_id, forKey: "address_id")
        dropoffAddress.setValue(rideDetails.dropoff_address?.address, forKey: "address")
        dropoffAddress.setValue(rideDetails.dropoff_address?.latitude, forKey: "latitude")
        dropoffAddress.setValue(rideDetails.dropoff_address?.longitude, forKey: "longitude")
        dropoffAddress.setValue(rideDetails.dropoff_address?.time, forKey: "time")
        dropoffAddress.setValue(1, forKey: "type")
        dropoffAddress.setValue(rideObj, forKey: "ride")
        
        let statusEntity = NSEntityDescription.entity(forEntityName: "CdStatus", in: managedContext)!
        
        let statusObj = NSManagedObject(entity: statusEntity,insertInto: managedContext)
        statusObj.setValue(rideDetails.status?.id, forKey: "id")
        statusObj.setValue(rideDetails.status?.name, forKey: "name")
        statusObj.setValue(rideDetails.status?.message, forKey: "message")
        
        statusObj.setValue(rideObj, forKey: "ride")

        do {
            try context.save()
            print("saved successfully")
            fetchDetailFromCoreData()
        } catch {
            print("Failed saving")
        }
    }
    
    //MARK:- For Checking data is saved or not
    func fetchDetailFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CdRide>(entityName: "CdRide")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let rides = try managedContext.fetch(fetchRequest) as [CdRide]
            
            if rides.count < 0 {
                return
            }
            
            self.rideID = rides.count
            
            if let ride = rides.last {
                print(ride)
            }

        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}
