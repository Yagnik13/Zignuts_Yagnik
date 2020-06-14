//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//

import UIKit

class AppButton: CoreButton {

    //MARK: - Properties
    @IBInspectable var type: Int = 0 {
        didSet {
            setupAppearance()
        }
    }
    
    @IBInspectable var shadowBorderColor: UIColor = .clear {
        didSet {
            setupAppearance()
        }
    }
    
    @IBInspectable var cornerRadiuss: CGFloat = 6 {
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
        fontSize = 17
        fontFamily = 1
        switch type {
        case 0:
            setTitleColor(UIColor.appGreen, for: .normal)
            layer.borderColor = UIColor.appGreen.cgColor
            layer.borderWidth = 1
            layer.cornerRadius = 8
            break
        case 1:
            backgroundColor = UIColor.appGreen
            setTitleColor(UIColor.white, for: .normal)
            layer.cornerRadius = 8
            break
        case 2:
            fontSize = 20
            backgroundColor = UIColor.appGreen
            setTitleColor(UIColor.white, for: .normal)
            layer.cornerRadius = 8
            break
        case 3:
            fontFamily = 0
            fontSize = 15
            backgroundColor = UIColor.appGreen
            setTitleColor(UIColor.appBlack1, for: .normal)
            layer.cornerRadius = 16
            break
        case 4:
            fontSize = 15
            break
        case 5:
            backgroundColor = UIColor.appNavyBlue
            setTitleColor(UIColor.white, for: .normal)
            layer.cornerRadius = 8
            break
        case 6:
            backgroundColor = UIColor.appPurple
            setTitleColor(UIColor.white, for: .normal)
            layer.cornerRadius = 8
            break
        case 7:
            setTitleColor(UIColor.appGray, for: .normal)
            break
        case 8:
            backgroundColor = UIColor.appGreen
            setTitleColor(UIColor.white, for: .normal)
            layer.cornerRadius = 6
            break
        case 9:
            backgroundColor = .appGreen
            setTitleColor(.white, for: .normal)
            layer.cornerRadius = 6
            break
        case 10:
            borderWidth = 1
            layer.cornerRadius = 6
            backgroundColor = .white
            setTitleColor(.appGreen, for: .normal)
            break
        default:
            break
        }
    }
}
