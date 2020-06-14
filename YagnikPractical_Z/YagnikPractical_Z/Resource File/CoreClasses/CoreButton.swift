//
//  LCButton.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//


import UIKit

class CoreButton: UIButton {
    
    @IBInspectable var fontFamily: Int = AppFont.sfUIDisplayRegular.rawValue {
        didSet {
            setFont()
        }
    }
    
    @IBInspectable var fontSize: CGFloat = 18 {
        didSet {
            setFont()
        }
    }
    
    @IBInspectable var localizableKey: String = "" {
        didSet {
            setTitle(localizableKey.localized, for: .normal)
        }
    }
    
    var handleTap: (()->Void)? = nil {
        didSet {
            if let _ = handleTap {
                addTarget(self, action: #selector(didTapSelf(_:)), for: .touchUpInside)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        commonInit()
    }
    
    func commonInit() {
        setFont()
    }
    
    private func setFont() {
        if let selectedFont = AppFont(rawValue: fontFamily) {
            titleLabel?.font = selectedFont.getFont(withSize: fontSize)
        }
    }
    
    @objc private func didTapSelf(_ sender: CoreButton) {
        handleTap?()
    }
}
