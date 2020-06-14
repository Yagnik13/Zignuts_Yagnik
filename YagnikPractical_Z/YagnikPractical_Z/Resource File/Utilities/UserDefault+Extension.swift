//
//  UserDefault+Extension.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//


import Foundation

fileprivate let keyTrucks = "key_trucks"
fileprivate let keyUser = "key_user"
fileprivate let keyMasterData = "key_master_data"
fileprivate let keyDurations = "key_durations"
fileprivate let keyIsOnBoardingCompleted = "key_is_onboarding_completed"
fileprivate let keyIsLocationPermissionAsked = "key_is_location_permission_asked"
fileprivate let keyIsAppLanguage = "key_is_app_language"

extension UserDefaults {
    
    var isLocationPermissionAsked: Bool {
        get {
            return bool(forKey: keyIsLocationPermissionAsked)
        }
        set {
            set(newValue, forKey: keyIsLocationPermissionAsked)
        }
    }
        
}
