//
//  Constants.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//


import UIKit
import MessageUI

typealias StringAnyObject = [String: AnyObject]
typealias voidCompletion = (()->Void)
typealias boolCompletion = ((_ success: Bool)->Void)
typealias backgroundFetchCompletion = ((_ status: UIBackgroundFetchResult)->Void)
typealias indexPathBlock = ((_ indexPath: IndexPath)->Void)
typealias StringAny = [String: Any]
typealias StringString = [String: String]
typealias Loading = (showLoader: Bool, showTransparentView: Bool)

typealias CellIdentifiers = Storyboard.CellIdentifiers
typealias SegueIdentifiers = Storyboard.SegueIdentifiers
typealias VCIdentifier = Storyboard.VCIdentifier
typealias Nib = Storyboard.Nib

let appDelegate = UIApplication.shared.delegate as! AppDelegate

enum AppDateFormat {
    
}

enum AppFont : Int {
    ///SFUIDisplay-Regular
    case sfUIDisplayRegular = 0
    ///SFUIDisplay-Semibold
    case sfUIDisplaySemibold = 1
    ///SFUIDisplay-Semibold
    case sfUIDisplaybold = 2
    ///CartoGothicStd-Book
    case cartoGothicStdBook = 3
    ///CircularStd-Bold
    case circularStdBold = 4
    ///SFProText-Regular
    case sfProTextRegular = 5
    
    func getFont(withSize size: CGFloat = 18) -> UIFont {
        switch self {
        case .sfUIDisplayRegular:
            return UIFont.sFUIDisplayRegular(withSize: size)
        case .sfUIDisplaySemibold:
            return UIFont.sFUIDisplaySemibold(withSize: size)
        case .sfUIDisplaybold:
            return UIFont.sFUIDisplayBold(withSize: size)
        case .cartoGothicStdBook:
            return UIFont.cartoGothicStdBook(withSize: size)
        case .circularStdBold:
            return UIFont.circularStdBold(withSize: size)
        case .sfProTextRegular:
            return UIFont.circularStdBold(withSize: size)
        }
    }
}

enum AppTimeZone {
    case current
    case utc
}

enum NetworkStatus {
    case reachable
    case notReachable
}

enum RideStatus: Int, CaseIterable {
    case Incomplete = 0
    case Confirmed = 2
    case Complete = 9
    case confirm
    
    
    var key: Int {
        switch self {
        case .Incomplete: return 0
        case .Confirmed: return 2
        case .Complete: return 9
        case .confirm: return 12
        }
    }
    
    var value: String {
        switch self {
        case .Incomplete: return "Incomplete"
        case .confirm: return "Confirm"
        case .Confirmed: return "Confirmed"
        case .Complete: return "Completed"
        }
    }
    
}

enum RideType: Int {
    case normal = 0
    case open = 1
}

//let PLACEHOLDER_IMAGE = "ic_dummy".imageWithOriginalMode

enum Storyboard {
    
    enum VCIdentifier {
    }
    
    enum SegueIdentifiers {
        static let ShowMyRidesHistoryController = "ShowMyRidesHistoryController"
        static let ShowMyRidesDetailsController = "ShowMyRidesDetailsController"
    }
    
    enum CellIdentifiers {
    }
    
    enum Nib {
    }
    
}


class Constants {
    
    static let GOOGLE_CLIENT_ID = "257425945886-gooppoljm09pbpotu1rc7md4htvv36gm.apps.googleusercontent.com"
    static let GOOGLE_API_KEY = "AIzaSyB1E87XIkBWcHu3bdh0H58pbIWBvqwRDRU"
    //AIzaSyAxIdnHSDORWNjXyi13kvhBAgcc-f76At0
    
    static func withoutAnimationBlock(block: voidCompletion, completion: voidCompletion?) {
        UIView.setAnimationsEnabled(false)
        block()
        UIView.setAnimationsEnabled(true)
        completion?()
    }
    
    static func checkAndAlertNoInterent(on vc: UIViewController) -> Bool {
        if ReachabilityManager.shared.currentStatus == .notReachable {
            CustomAlertController.showAlertWithOk(forTitle: "", message: "No connectivity to internet.Try again.", sender: vc, okCompletion: nil)
            return false
        }
        return true
    }
    
    static func getString(anyValue: Any?) -> String {
        if let val = anyValue {
            if let valString = val as? String {
                return valString
            } else if let valDouble = val as? Double {
                return "\(valDouble)"
            } else if let valInt = val as? Int {
                return "\(valInt)"
            }
        }
        return ""
    }
    
    static func getCurrentDateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"

        let currentDateStr = formatter.string(from: Date())
        print("time :\(currentDateStr)")
        return currentDateStr
    }
    
}

extension UIViewController: MFMessageComposeViewControllerDelegate {
    
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
