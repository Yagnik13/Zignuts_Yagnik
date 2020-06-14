//
//  LoadMoreCollectionReusableView.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//


import UIKit

class LoadMoreCollectionReusableView: CoreCollectionReusableView {

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    func isAnimating() -> Bool {
        return activityIndicator.isAnimating
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
    
}
