//
//  TripHistoryTableCell.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//

import UIKit

class TripHistoryTableCell: CoreTableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pickUpLabel: UILabel!
    @IBOutlet weak var dropOffLabel: UILabel!
    @IBOutlet weak var pickuptimeLabel: UILabel!
    @IBOutlet weak var dropofftimeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //MARK:- For Configure Cell with data 
    func configureCell(_ data : Ride) {
        pickUpLabel.text = "\(data.pickup_address?.address ?? "")"
        dropOffLabel.text = "\(data.dropoff_address?.address ?? "")"
        pickuptimeLabel.text = "Start at: \(data.pickup_address?.time ?? "")"
        dropofftimeLabel.text = "End at: \(data.dropoff_address?.time ?? "")"
        distanceLabel.text = "Distance: \(data.distance ?? "")"
    }
    
    
}
