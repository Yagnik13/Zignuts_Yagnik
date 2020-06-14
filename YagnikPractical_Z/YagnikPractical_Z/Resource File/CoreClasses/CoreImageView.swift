//
//  CoreImageView.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//


import UIKit

class CoreImageView: UIImageView {

    var handleSelfTap: voidCompletion? = nil {
        didSet {
            if let _ = handleSelfTap {
                isUserInteractionEnabled = true
                addGestureRecognizer(tapGestureRecognizer)
            }
        }
    }
    
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleSelfTap(_:)))
        return recognizer
    }()
    
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
        
    }
    
    @objc private func handleSelfTap(_ sender: UITapGestureRecognizer) {
        handleSelfTap?()
    }
    
}

