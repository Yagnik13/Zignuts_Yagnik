//
//  CoreCollectionView.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//


import UIKit

class CoreCollectionView: UICollectionView {

    //MARK: - Controls
    private let collectionRefreshControl = CoreRefreshControl()
    
    //MARK: - Properties
    var didPullToRefresh: ((_ control: UIRefreshControl)->Void)? {
        didSet {
            if didPullToRefresh != nil {
                refreshControl = collectionRefreshControl
                collectionRefreshControl.pulledToRefresh = {
                    self.didPullToRefresh?(self.collectionRefreshControl)
                }
            }
        }
    }
    
    func commonInit() {
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}
