//
//  CoreTableViewController.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//


import UIKit

class CoreTableViewController: UITableViewController {

    override var prefersStatusBarHidden: Bool {
        return false
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var navigationBarTintColor: UIColor = .blue {
        didSet {
            self.navigationController?.navigationBar.barTintColor = navigationBarTintColor
        }
    }
    var navigationTintColor: UIColor = .blue {
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
    
    func networkStatusChanged(newStatus: NetworkStatus) {
        
    }

}
