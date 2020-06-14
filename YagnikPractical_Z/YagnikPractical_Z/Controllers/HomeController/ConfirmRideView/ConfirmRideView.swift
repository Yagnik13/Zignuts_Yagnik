//
//  ConfirmRideView.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//

import UIKit

class ConfirmRideView: CoreView {

    //MARK: - Outlets
    @IBOutlet weak var pickUpAddressLabel: CoreLabel!
    @IBOutlet weak var dropOffAddressLabel: CoreLabel!
    @IBOutlet weak var confirmButton: CoreButton!
    @IBOutlet weak var viewRideButton: CoreButton!
    @IBOutlet weak var contentView: UIView!
    
    //MARK: - Properties
    var rideDetails: Ride? {
        didSet {
            let rideType = (rideDetails?.getRideType() ?? .normal)
            pickUpAddressLabel.text = rideDetails?.pickup_address?.address
            dropOffAddressLabel.text = rideType == .normal ? rideDetails?.dropoff_address?.address : "To your wish".localized
        }
    }
    
    //MARK: - Init Methods
    override func commonInit() {
        super.commonInit()
        contentView = loadNib()
        contentView.fixInView(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyShadow(color: .black, opacity: 0.3, radius: 8, edge: .All, shadowSpace: 5)
    }
}
