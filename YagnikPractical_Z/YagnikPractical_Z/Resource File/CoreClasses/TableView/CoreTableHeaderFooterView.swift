//
//  CoreTableHeaderFooterView.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//


import UIKit

class CoreTableHeaderFooterView: UITableViewHeaderFooterView {

    //MARK: - Properties
    static var identifier : String {
        return String(describing: self)
    }
    
    static var nib : UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleSelfTap(_:)))
        return recognizer
    }()
    
    var handleTapOnSelf: voidCompletion? {
        didSet {
            if let _ = handleTapOnSelf {
                addGestureRecognizer(tapGestureRecognizer)
            }
        }
    }
    
    //MARK: - Methods
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.endEditing(true)
    }
    
    
    func commonInit() {
    }
    
    
    @objc func handleSelfTap(_ sender: UITapGestureRecognizer) {
        handleTapOnSelf?()
    }
    
    //MARK: - Init Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
}
