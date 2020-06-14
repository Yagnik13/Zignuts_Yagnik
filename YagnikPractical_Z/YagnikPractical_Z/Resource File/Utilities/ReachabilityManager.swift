//
//  ReachabilityManager.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//


import Foundation
import Alamofire

final class ReachabilityManager {
    static let shared = ReachabilityManager()
    
    private let networkManager = NetworkReachabilityManager()!
    
    var networkStatusChanged: ((_ newStatus: NetworkStatus)->Void)?
    var currentStatus: NetworkStatus {
        return networkManager.isReachable ? .reachable : .notReachable
    }
    var isReachable: Bool {
        return networkManager.isReachable
    }
    
    init() {
//        networkManager.startListening()
//        networkManager.listener = { status in
//            self.networkStatusChanged?(status == .notReachable ? .notReachable : .reachable)
//        }
    }
}
