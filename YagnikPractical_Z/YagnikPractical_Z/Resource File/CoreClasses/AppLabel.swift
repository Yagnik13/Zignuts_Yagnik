//
//  AppLabel.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//

import Foundation
import UIKit

class AppLabel: CoreLabel {
    
    //MARK: - Properties
    @IBInspectable var type: Int = 0 {
        didSet {
            setupAppearance()
        }
    }
    
    
    //MARK - Other Methods
    override func commonInit() {
        setupAppearance()
        super.commonInit()
    }
    
    private func setupAppearance() {
        switch type {
        case 0:
            fontFamily = 1
            fontSize = 30
            textColor = UIColor.appBlack1
            break
        case 1:
            fontFamily = 0
            fontSize = 17
            textColor = UIColor.appBlack1
            break
        case 2:
            fontFamily = 0
            fontSize = 17
            textColor = UIColor.appGray
            break
        case 3:
            fontFamily = 1
            fontSize = 32
            textColor = UIColor.appBlack1
            break
        case 4:
            fontFamily = 1
            fontSize = 24
            textColor = UIColor.appBlack1
            break
        case 5:
            fontFamily = 1
            fontSize = 24
            textColor = UIColor.appGray
            break
        case 6:
            fontFamily = 0
            fontSize = 13
            textColor = UIColor.appDarkGray
            break
        case 7:
            fontFamily = 0
            fontSize = 17
            textColor = UIColor.appNavyBlue
            break
        case 8:
            fontFamily = 1
            fontSize = 13
            textColor = UIColor.appGray
            break
        case 9:
            fontFamily = 0
            fontSize = 15
            textColor = UIColor.appGray
            break
        case 10:
            fontFamily = 2
            fontSize = 15
            textColor = UIColor.appNavyBlue
            break
        case 11:
            fontFamily = 1
            fontSize = 20
            textColor = UIColor.appNavyBlue
            break
        case 12:
            fontFamily = 1
            fontSize = 15
            textColor = UIColor.appLightGray1
            break
        case 13:
            fontFamily = 2
            fontSize = 24
            textColor = UIColor.appNavyBlue
            break
        case 14:
            fontFamily = 0
            fontSize = 15
            textColor = UIColor.appGray
            break
        case 15:
            fontFamily = 1
            fontSize = 19
            textColor = UIColor.white
            break
        case 16:
            fontFamily = 0
            fontSize = 32
            textColor = UIColor.appNavyBlue
            break
        case 17:
            fontFamily = 1
            fontSize = 17
            textColor = UIColor.appBlack1
            break
        default:
            break
        }
    }
}
