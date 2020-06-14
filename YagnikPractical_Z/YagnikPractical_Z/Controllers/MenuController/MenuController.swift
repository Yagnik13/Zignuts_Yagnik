//
//  MenuController.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//

import UIKit
import SideMenuSwift

class MenuController: CoreViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: CoreTableView!
    @IBOutlet weak var selectionMenuTrailingConstraint: NSLayoutConstraint!
    
    //MARK:- Properties
    private var menuOptions: [MenuOption] = [.history]
    
    //MARK:- Controls
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

//MARK:- SideMenuControllerDelegate Methods
extension MenuController : SideMenuControllerDelegate {
    func sideMenuController(_ sideMenuController: SideMenuController, animationControllerFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BasicTransitionAnimator(options: .transitionFlipFromLeft, duration: 0.6)
    }
}

extension MenuController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MenuCell
        cell.titleLabel.text = menuOptions[indexPath.row].loclizedText
        cell.menuImageView.image = menuOptions[indexPath.row].image
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var homeController: HomeController?
        if let homeNavVC = sideMenuController?.contentViewController as? HomeNavigationController, let homeVC = homeNavVC.children.first as? HomeController {
            homeController = homeVC
        }
        let currentOption = menuOptions[indexPath.row]
        switch currentOption {
            case .home:
//                homeController?.performSegue(withIdentifier: SegueIdentifiers.PresentRatingNavVC, sender: nil)
                break
            case .history:
                homeController?.performSegue(withIdentifier: SegueIdentifiers.ShowMyRidesHistoryController, sender: nil)
                break
            
        }
        sideMenuController?.hideMenu()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

class MenuCell: UITableViewCell {
    @IBOutlet weak var titleLabel: CoreLabel!
    @IBOutlet weak var menuImageView: UIImageView!
}

enum MenuOption {
    case home
    case history
    
    var loclizedText: String {
        switch self {
        case .home:
            return "Home".localized
        case .history:
            return "History".localized
        }
    }
    
    var image: UIImage {
        switch self {
        case .home:
            return "ic_home".imageWithOriginalMode
        case .history:
            return "ic_history".imageWithOriginalMode
        }
    }
}
