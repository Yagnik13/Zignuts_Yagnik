//
//  CoreRefreshControl.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//


import UIKit

class CoreRefreshControl: UIRefreshControl {

    var pulledToRefresh: voidCompletion!
    
    func commonInit() {
        addTarget(self, action: #selector(refreshStart), for: .valueChanged)
    }
    
    @objc private func refreshStart() {
        pulledToRefresh()
    }
    
    //MARK: - Init Methods
    override init() {
        super.init()
        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

}
