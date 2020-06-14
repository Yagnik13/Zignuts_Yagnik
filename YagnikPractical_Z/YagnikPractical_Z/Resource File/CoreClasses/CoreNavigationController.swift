//
//  CoreNavigationController.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//


import UIKit

class CoreNavigationController: UINavigationController {
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var navigationBarTintColor: UIColor = .blue {
        didSet {
            navigationBar.barTintColor = navigationBarTintColor
        }
    }
    var navigationTintColor: UIColor = .blue {
        didSet {
            navigationBar.tintColor = navigationTintColor
        }
    }
    
    var navigationBarTitleColor: UIColor = .white {
        didSet {
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : navigationBarTitleColor]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = .appGreen
            navigationBar.standardAppearance = navBarAppearance
            navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }
}
