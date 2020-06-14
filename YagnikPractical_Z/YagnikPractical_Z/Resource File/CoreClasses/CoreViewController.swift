//
//  CoreViewController.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//


import UIKit

class CoreViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return  self is HomeController ? .default : .lightContent
    }
    var navigationBarTintColor: UIColor = .appGreen {
        didSet {
            self.navigationController?.navigationBar.barTintColor = navigationBarTintColor
        }
    }
    var navigationTintColor: UIColor = .white {
        didSet {
            self.navigationController?.navigationBar.tintColor = navigationTintColor
        }
    }
    
    var navigationBarTitleColor: UIColor = .white {
        didSet {
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : navigationBarTitleColor]
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackBarButton()
        if #available(iOS 13.0, *) {
            navigationItem.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    func setupBackBarButton() {
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButton.tintColor = .white
        navigationItem.backBarButtonItem = backBarButton
    }
    
}
