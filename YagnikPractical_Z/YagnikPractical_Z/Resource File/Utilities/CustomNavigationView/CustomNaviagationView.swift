//
//  CustomNaviagationView.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//


import UIKit

class CustomNaviagationView: UIView {

    //MARK: - Outlets
    @IBOutlet var button: CoreButton!
    
    //MARK: - Property
    
    //MARK: - Blocks
    
    //MARK: - Custom Methods
    class func fromNib() -> CustomNaviagationView {
        return Bundle.main.loadNibNamed(String(describing: CustomNaviagationView.self), owner: nil, options: nil)![0] as! CustomNaviagationView
    }
}
