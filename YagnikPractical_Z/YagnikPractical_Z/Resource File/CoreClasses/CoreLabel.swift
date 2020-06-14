//
//  LCLabel.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//


import UIKit

class CoreLabel: UILabel {
    
    //MARK: - Inspectable Properties
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
            text = localizableKey.localized
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
            font = selectedFont.getFont(withSize: fontSize)
        }
    }
    
}

class InsetLabel: CoreLabel {
    
    @IBInspectable var topInset: CGFloat = 2
    @IBInspectable var bottomInset: CGFloat = 2
    @IBInspectable var leftInset: CGFloat = 2
    @IBInspectable var rightInset: CGFloat = 2
    
    //MARK: - Methods
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
}
