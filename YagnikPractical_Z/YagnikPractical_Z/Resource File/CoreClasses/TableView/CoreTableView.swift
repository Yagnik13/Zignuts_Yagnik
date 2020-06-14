//
//  CoreTableView.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//


import UIKit

class CoreTableView: UITableView {

    //MARK: - Controls
    private let collectionRefreshControl = CoreRefreshControl()
    
    //MARK: - Properties
    var didPullToRefresh: ((_ control: UIRefreshControl)->Void)? {
        didSet {
            if didPullToRefresh != nil {
                refreshControl = collectionRefreshControl
                collectionRefreshControl.tintColor = .white
                collectionRefreshControl.pulledToRefresh = {
                    self.didPullToRefresh?(self.collectionRefreshControl)
                }
            }
        }
    }
    var blockForTouchesBegan: ((_ touches: Set<UITouch>, _ event: UIEvent?)->Void)?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        blockForTouchesBegan?((touches), event)
    }
    //MARK: - Init Methods
    func commonInit() {
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}
