//
//  PermissionManager.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//


import UIKit
import UserNotifications
import CoreLocation
import AVFoundation

class PermissionManager: NSObject {
    
    static let manager = PermissionManager()
    private lazy var manager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    private var locationPermisionCompletion: boolCompletion?
    
    enum Permission {
        case pushNotification
        case camera
        case location
    }
    
    enum PermissionStatus {
        case authorized
        case unauthorized
    }
    
    private func checkFor(permission: Permission, completion: ((_ isGranted: Bool) -> Void)?) {
        switch permission {
        case .pushNotification:
            requestPushNotificationPermission { (isAuthorized) in
                completion?((isAuthorized))
            }
            break
        case .camera:
            requestCameraPermission { (isAuthorized) in
                completion?(isAuthorized)
            }
            break
        case .location:
            requestLocationPermission { (isAuthorized) in
                completion?(isAuthorized)
            }
            break
        }
    }
    
    func checkAndAskFor(permission: Permission, completion: ((_ isGranted: Bool) -> Void)? = nil) {
        if checkStatus(forPermission: permission) == .authorized {
            completion?(true)
            return
        }
        self.checkFor(permission: permission, completion: completion)
    }
    
    func checkStatus(forPermission permission: Permission) -> PermissionStatus {
        switch permission {
        case .pushNotification:
            return pushNotificationStatus() ? .authorized : .unauthorized
        case .camera:
            return cameraStatus() ? .authorized : .unauthorized
        case .location:
            return .unauthorized
        }
    }
    
    private func requestPushNotificationPermission(completion: @escaping ((_ isGranted: Bool) -> Void)) {
        let options: UNAuthorizationOptions = [.badge, .alert, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, error) in
            DispatchQueue.main.async {
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                completion((granted))
            }
        }
    }
    
    private func requestCameraPermission(completion: @escaping ((_ isGranted: Bool) -> Void)) {
        AVCaptureDevice.requestAccess(for: .video) { response in
            DispatchQueue.main.async {
                completion(response)
            }
        }
    }
    
    private func requestLocationPermission(completion: @escaping ((_ isGranted: Bool) -> Void)) {
        switch CLLocationManager.authorizationStatus() {
        case .denied:
            completion(false)
            break
        case .authorizedWhenInUse:
            completion(true)
            break
        default:
            manager.requestWhenInUseAuthorization()
            //manager.requestAlwaysAuthorization()
            locationPermisionCompletion = completion
            break
        }
    }
    
    private func cameraStatus() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .authorized
    }
    
    private func pushNotificationStatus() -> Bool {
        return UIApplication.shared.isRegisteredForRemoteNotifications
    }
    
    private func locationStatus() -> Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
}

extension PermissionManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .notDetermined {
            locationPermisionCompletion?(locationStatus())
        }
        
    }
}
