//
//  CoreView.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//


import UIKit

class CoreView: UIView {

    //MARK: - Properties
    var blockForTapGesture: voidCompletion? {
        didSet {
            if let _ = blockForTapGesture {
                addGestureRecognizer(tapGestureRecognizer)
                isUserInteractionEnabled  = true
            }
        }
    }
    private lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(sender:)))
        return recognizer
    }()

    //MARK: - Methods
    @objc private func handleTapGesture(sender: UITapGestureRecognizer) {
        blockForTapGesture?()
    }
    
    //MARK: - Init Methods
    func commonInit() {
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
    
}
