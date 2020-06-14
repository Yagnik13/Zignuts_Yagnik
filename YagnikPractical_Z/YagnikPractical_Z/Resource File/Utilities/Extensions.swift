//
//  Extensions.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//

import UIKit
import Alamofire
import GoogleMaps

typealias imageDownloadCompletionBlock = (Bool, UIImage?)->()
fileprivate let imageCache = NSCache<AnyObject, AnyObject>()
let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last!
let temporaryDirectory = NSTemporaryDirectory()

extension UIColor {
    static let appBlack1 = UIColor(named: "appBlack1")!
    static let appDarkGray = UIColor(named: "appDarkGray")!
    static let appGray = UIColor(named: "appGray")!
    static let appGreen = UIColor(named: "appGreen")!
    static let appLightGray = UIColor(named: "appLightGray")!
    static let appLightGray1 = UIColor(named: "appLightGray1")!
    static let appNavyBlue = UIColor(named: "appNavyBlue")!
    static let appPurple = UIColor(named: "appPurple")!
    static let appDarkPink = UIColor(named: "appDarkPink")!
    static let appLightGray2 = UIColor(named: "appLightGray2")!
    static let appTextBlack = UIColor(named: "appTextBlack")!
}

extension UIFont {
    
    class func sFUIDisplayRegular(withSize size: CGFloat = 18) -> UIFont {
        return UIFont(name: "SFUIDisplay-Regular", size: size)!
    }
    
    class func sFUIDisplaySemibold(withSize size: CGFloat = 18) -> UIFont {
        return UIFont(name: "SFUIDisplay-Semibold", size: size)!
    }
    
    class func sFUIDisplayBold(withSize size: CGFloat = 18) -> UIFont {
        return UIFont(name: "SFUIDisplay-Bold", size: size)!
    }
    
    class func cartoGothicStdBook(withSize size: CGFloat = 13) -> UIFont {
        return UIFont(name: "CartoGothicStd-Book", size: size)!
    }
    
    class func circularStdBold(withSize size: CGFloat = 13) -> UIFont {
        return UIFont(name: "CircularStd-Bold", size: size)!
    }
    
    class func sfProTextRegular(withSize size: CGFloat = 13) -> UIFont {
        return UIFont(name: "CircularStd-Bold", size: size)!
    }
}

extension String {
    
    var localized: String {
//        return NSLocalizedString(self, comment: "")
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func toImage(isRenderingModeTemplate mode: Bool = true) -> UIImage {
        return UIImage(named: self)!.withRenderingMode(mode ? .alwaysTemplate : .alwaysOriginal)
    }
    
    var imageWithTemplatedMode: UIImage {
        let img = UIImage(named: self)!.withRenderingMode(.alwaysTemplate)
        return img
    }

    var imageWithOriginalMode: UIImage {
        let img = UIImage(named: self)!.withRenderingMode(.alwaysOriginal)
        return img
    }
    
    var templatedImage: UIImage {
        return UIImage(named: self)!.withRenderingMode(.alwaysTemplate)
    }
    
    var originalImage: UIImage {
        return UIImage(named: self)!.withRenderingMode(.alwaysOriginal)
    }
    
    func flippedImage(doKeepOriginal: Bool = true) -> UIImage {
        let image = (doKeepOriginal ? imageWithOriginalMode : imageWithTemplatedMode)
        return image
        //return languageOfApp == "ar" ? image.imageFlippedForRightToLeftLayoutDirection() : image
    }
    
    var trim: String {
        mutating get {
            self = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            return String(self.filter { !" \n\t\r".contains($0) })
        }
    }
    
    var isNumber: Bool {
        let numberCharacters = CharacterSet.decimalDigits.inverted
        return !self.isEmpty && self.rangeOfCharacter(from: numberCharacters) == nil
    }
    
    var isPhoneNumber: Bool {
        let numberCharacters = CharacterSet(charactersIn: "+1234567890").inverted
        let isMobileNumber = self.rangeOfCharacter(from: numberCharacters) == nil
        return (!self.isEmpty && isMobileNumber) && self.count <= 15 && self.count >= 8
    }
    
    var isPin: Bool {
        return isNumber && self.count == 6
    }
    
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    mutating func dropLastCharacter() {
        self.remove(at: self.index(before: self.endIndex))
    }
    mutating func dropFirstCharacter() {
        self.remove(at: self.index(after: self.startIndex))
    }
    
    mutating func convertToDateString(convertFormat: String, resultFormat: String) {
        let dateFormatter = DateFormatter.MyDateFormatter
        dateFormatter.dateFormat = convertFormat
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = resultFormat
            self = dateFormatter.string(from: date)
        }
    }
    
    mutating func convertToDateString(convertFormat: String, resultDateStyle: DateFormatter.Style = .medium) {
        let dateFormatter = DateFormatter.MyDateFormatter
        dateFormatter.dateFormat = convertFormat
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateStyle = resultDateStyle
            self = dateFormatter.string(from: date)
        }
    }
    
    mutating func convertToDateTimeString(convertFormat: String, resultDateStyle: DateFormatter.Style = .medium, resultTimeStyle: DateFormatter.Style = .medium) {
        let dateFormatter = DateFormatter.MyDateFormatter
        dateFormatter.dateFormat = convertFormat
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateStyle = resultDateStyle
            dateFormatter.timeStyle = resultTimeStyle
            self = dateFormatter.string(from: date)
        }
    }
    
    func convertToDateString(convertFormat: String, resultFormat: String) -> String {
        let dateFormatter = DateFormatter.MyDateFormatter
        dateFormatter.dateFormat = convertFormat
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = resultFormat
            return dateFormatter.string(from: date)
        }
        return self
    }
    
    func getDate(convertFormat: String, apptimeZone: AppTimeZone = .current) -> Date {
        let dateFormatter = DateFormatter.MyDateFormatter
        dateFormatter.dateFormat = convertFormat
        var timeZone: TimeZone!
        if apptimeZone == .current {
            timeZone = TimeZone.current
        } else {
            timeZone = TimeZone(abbreviation: "UTC")!
        }
        dateFormatter.timeZone = timeZone
        if let date = dateFormatter.date(from: self) {
            return date
        }
        print("cannot convert date \(self) from \(convertFormat)")
        return Date()
    }
    
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? self
    }
    var data: Data? {
        return self.data(using: .utf8)
    }
    
    /*func toDisplayDate(convertFormat: AppDateFormat = .date) -> String {
        return self.convertToDateString(convertFormat: convertFormat, resultFormat: .displayDate)
    }*/
    
}

extension Int {
    var data: Data? {
        return "\(self)".data(using: .utf8)
    }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
extension UIView {
    
    func addConstraintsWithFormat(_ format: String, views: UIView...) -> Void {
        var viewsDirectory = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDirectory[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDirectory))
    }
    
    func setGradient(forColors colors: [UIColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.masksToBounds = true
        gradientLayer.cornerRadius = self.layer.cornerRadius
        var colorsToCGColor = [CGColor]()
        for color in colors {
            colorsToCGColor.append(color.cgColor)
        }
        gradientLayer.colors = colorsToCGColor
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func estimatedHeight(ofText text: String, forWidth width: CGFloat, withFontSize font: CGFloat, extraPadding: CGFloat = 16) -> CGFloat {
        let height = CGFloat(Float.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: CGSize(width: width, height: height), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: font)], context: nil)
        return rect.height + extraPadding
    }
    
    class func estimatedHeight(ofText text: String, forWidth width: CGFloat, withFontSize font: CGFloat, extraPadding: CGFloat = 16) -> CGFloat {
        let height = CGFloat(Float.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: CGSize(width: width, height: height), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: font)], context: nil)
        return rect.height + extraPadding
    }
    
    func estimatedTextFrame(ofText text: String, forHeight height: CGFloat, withFont font:UIFont, extraPadding: CGFloat = 16) -> CGRect {
        let width = CGFloat(Float.greatestFiniteMagnitude)
        var rect = text.boundingRect(with: CGSize(width: width, height: height), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font:font], context: nil)
        rect.size.width = rect.width + extraPadding
        rect.size.height = rect.height + extraPadding
        return rect
    }
    
    class func estimatedTextFrame(ofText text: String, forHeight height: CGFloat, withFont font:UIFont, extraPadding: CGFloat = 16) -> CGRect {
        let width = CGFloat(Float.greatestFiniteMagnitude)
        var rect = text.boundingRect(with: CGSize(width: width, height: height), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font:font], context: nil)
        rect.size.width = rect.width + extraPadding
        rect.size.height = rect.height + extraPadding
        return rect
    }
    
    enum ViewSide {
        case Left, Right, Top, Bottom
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .Left: border.frame = CGRect(x: 0, y: frame.minY, width: thickness, height: frame.height); break
        case .Right: border.frame = CGRect(x: 0, y: frame.minY, width: thickness, height: frame.height); break
        case .Top: border.frame = CGRect(x: 0, y: frame.minY, width: frame.width, height: thickness); break
        case .Bottom: border.frame = CGRect(x: 0, y: frame.maxY, width: frame.width, height: thickness); break
        }
        
        layer.addSublayer(border)
    }
    
    func showNoDataFound(withMessage message: String = "No Data Found") {
        removeNoDataFound()
        let label = UILabel()
        label.tag = 12213
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = message
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .darkGray
        label.sizeToFit()
        addSubview(label)
        label.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor).isActive = true
    }
    
    func removeNoDataFound() {
        viewWithTag(12213)?.removeFromSuperview()
    }
    
    @IBInspectable var cornerRadius: Double {
        get {
            return Double(self.layer.cornerRadius)
        }set {
            self.layer.cornerRadius = CGFloat(newValue)
            self.clipsToBounds = true
        }
    }
    
    @IBInspectable var borderWidth: Double {
        get {
            return Double(self.layer.borderWidth)
        }set {
            self.layer.borderWidth = CGFloat(newValue)
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            if let bColor = self.layer.borderColor {
                return UIColor(cgColor: bColor)
            }
            return UIColor.black
        }set {
            self.layer.borderColor  = newValue.cgColor
            self.layer.masksToBounds = true
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    private static let kRotationAnimationKey = "rotationanimationkey"
    func startRotation() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = NSNumber(value: Double.pi * 2)
        rotation.toValue = 0.0
        rotation.duration = 0.7
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: UIView.kRotationAnimationKey)
    }
    
    func endRotation() {
        self.layer.removeAnimation(forKey: UIView.kRotationAnimationKey)
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        self.layer.cornerRadius = radius
        var maskedCorners = CACornerMask()
        if corners == .topLeft {
            maskedCorners = .layerMinXMinYCorner
        } else if corners == .topRight {
            maskedCorners = .layerMaxXMinYCorner
        } else if corners == [.topLeft, .topRight] || corners == [.topRight, .topLeft] {
            maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if corners == .bottomLeft {
            maskedCorners = .layerMinXMaxYCorner
        } else if corners == .bottomRight {
            maskedCorners = .layerMaxXMaxYCorner
        } else if corners == [.bottomLeft, .bottomRight] || corners == [.bottomRight, .bottomLeft] {
            maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        self.layer.maskedCorners = maskedCorners
    }
 
    func startRotation(clockWise: Bool = true) {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation")
        let fromValue = clockWise ? (Double.pi * 2) : 0
        let toValue = clockWise ? 0 : (Double.pi * 2)
        rotation.fromValue = NSNumber(value: fromValue)
        rotation.toValue = NSNumber(value: toValue)
        rotation.duration = 0.7
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: UIView.kRotationAnimationKey)
    }
    
}

extension DateFormatter {
    
    ///DateFormatter with current timezone.
    static let MyDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }()
}

protocol StoryboardInstantiable: class {
    static var storyboardIdentifier: String {get}
    static func instantiateFromStoryboard(storyboard: UIStoryboard) -> Self
}

extension UIViewController: StoryboardInstantiable {
    static var storyboardIdentifier: String {
        let classString = NSStringFromClass(self)
        let components = classString.components(separatedBy: ".")
        assert(components.count > 0, "Failed extract class name from \(classString)")
        return components.last!
    }
    
    class func instantiateFromStoryboard(storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)) -> Self {
        return instantiateFromStoryboard(storyboard: storyboard, type: self)
    }
    
    private class func instantiateFromStoryboard<T: UIViewController>(storyboard: UIStoryboard, type: T.Type) -> T {
        return storyboard.instantiateViewController(withIdentifier: self.storyboardIdentifier) as! T
    }
    
    func setupCustomViewInNavigationBarUI(with navigationController: UINavigationController?, customView: UIView , widthForCustomView: CGFloat) {
        
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        navigationBar.addSubview(customView)
        customView.clipsToBounds = true
        customView.translatesAutoresizingMaskIntoConstraints = false
       
    }
    
    func moveAndResizeImageInNavigationBarUI(for height: CGFloat,with customView : UIView) {
        let coeff: CGFloat = {
            let delta = height - Const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()
        
        let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState
        
        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()
        
        // Value of difference between icons for large and small states
        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor) // 8.0
        let yTranslation: CGFloat = {
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.ImageBottomMarginForSmallState + sizeDiff))))
        }()
        
        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)
        
        customView.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
    
    private struct Const {
        /// Image height/width for Large NavBar state
        static let ImageSizeForLargeState: CGFloat = 44 //50
        /// Margin from right anchor of safe area to right anchor of Image
        static let ImageRightMargin: CGFloat = 10
        
        static let ImageLeftMargin: CGFloat = 10
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
        static let ImageBottomMarginForLargeState: CGFloat = 6
        /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
        static let ImageBottomMarginForSmallState: CGFloat = 6
        /// Image height/width for Small NavBar state
        static let ImageSizeForSmallState: CGFloat = 40 //32
        /// Height of NavBar for Small state. Usually it's just 44
        static let NavBarHeightSmallState: CGFloat = 44
        /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
        static let NavBarHeightLargeState: CGFloat = 96.5
    }
    
}

extension UIBarButtonItem {
    
    @IBInspectable var localizableKey: String {
        get {
            return title ?? ""
        }
        set {
            title = newValue.localized
        }
    }
    
    static let flexibleBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
}

extension UITabBarItem {
    
    @IBInspectable var localizableKey: String {
        get {
            return title ?? ""
        }
        set {
            title = newValue.localized
        }
    }
    
}

extension UINavigationItem {
    
    @IBInspectable var localizableKey: String {
        get {
            return title ?? ""
        }
        set {
            title = newValue.localized
        }
    }
    
}

extension UISearchBar {
    
    @IBInspectable var localizablePlaceHolderKey: String {
        get {
            return placeholder ?? ""
        }
        set {
            placeholder = newValue.localized
        }
    }
    
}

extension UIView {
    
    enum AIEdge:Int {
        case
        Top,
        Left,
        Bottom,
        Right,
        Top_Left,
        Top_Right,
        Bottom_Left,
        Bottom_Right,
        All,
        None
    }
    
    /** Loads instance from nib with the same name. */
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.frame
        container.addSubview(self)
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
    func applyShadow(color:UIColor, opacity:Float, radius: CGFloat, edge: UIView.AIEdge, shadowSpace:CGFloat)    {
        var sizeOffset:CGSize = CGSize.zero
        switch edge {
        case .Top:
            sizeOffset = CGSize(width: 0, height: -shadowSpace) //CGSizeMake(0, -shadowSpace)
        case .Left:
            sizeOffset = CGSize(width: -shadowSpace, height: 0) //CGSizeMake(-shadowSpace, 0)
        case .Bottom:
            sizeOffset = CGSize(width: 0, height: shadowSpace) //CGSizeMake(0, shadowSpace)
        case .Right:
            sizeOffset = CGSize(width: shadowSpace, height: 0) //CGSizeMake(shadowSpace, 0)
            
            
        case .Top_Left:
            sizeOffset = CGSize(width: -shadowSpace, height: -shadowSpace) //CGSizeMake(-shadowSpace, -shadowSpace )
        case .Top_Right:
            sizeOffset = CGSize(width: shadowSpace, height: -shadowSpace) //CGSizeMake(shadowSpace, -shadowSpace)
        case .Bottom_Left:
            sizeOffset = CGSize(width: -shadowSpace, height: shadowSpace) //CGSizeMake(-shadowSpace, shadowSpace)
        case .Bottom_Right:
            sizeOffset = CGSize(width: shadowSpace, height: shadowSpace) //CGSizeMake(shadowSpace, shadowSpace)
            
            
        case .All:
            sizeOffset = CGSize(width: 0, height: 0) //CGSizeMake(0, 0)
        case .None:
            sizeOffset = CGSize.zero
        }
        
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = sizeOffset
        self.layer.shadowRadius = radius
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = false
    }
    
    func apply(cornerRadius radius: CGFloat) {
        DispatchQueue.main.async {
            self.layer.cornerRadius = radius
            self.layer.masksToBounds = true
        }
    }
    
}

extension UIImageView {
    func downloadImage(forURL imageURL: String, placeHolderImage: UIImage? = nil, withName imageName: String = "", completion: imageDownloadCompletionBlock? = nil) {
        self.image = placeHolderImage
        guard let downloadImageURL = URL(string: imageURL) else {
            completion?(false, nil)
            return
        }
        var imageName = imageName
        if imageName.isEmpty {
            imageName = "\((imageURL as NSString).lastPathComponent)"
        }
        
        if let isImagePresent = imageCache.object(forKey: imageName as AnyObject) as? UIImage {
            self.image = isImagePresent
            completion?(true, isImagePresent)
        } else {
            AF.download(downloadImageURL).response { (downloadResponse) in
                if let downloadResponseURL = downloadResponse.fileURL {
                    do {
                        let dataDownloaded = try Data(contentsOf: downloadResponseURL)
                        if let imageDownloaded = UIImage(data: dataDownloaded) {
                            self.image = imageDownloaded
                            imageCache.setObject(imageDownloaded, forKey: imageName as AnyObject)
                            completion?(true, imageDownloaded)
                            return
                        } else {
                            completion?(false, nil)
                            return
                        }
                        
                    } catch {
                        completion?(false, nil)
                        return
                    }
                }
            }
        }
    }
    
    func getImageFromTemporaryDirectory(forImageName imageName: String) -> UIImage? {
        if let cacheImageURL = URL(string: "\(temporaryDirectory)\(imageName)") {
            
            if FileManager.default.fileExists(atPath: cacheImageURL.path) {
                if let data = try? Data(contentsOf: cacheImageURL) {
                    if let img = UIImage(data: data) {
                        return img
                    }
                    return nil
                }
                return nil
            }
        }
        return nil
    }
    
    
}


extension UIView {
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
}

extension Date {
    func getString(inFormat: String, apptimeZone: AppTimeZone = .current) -> String {
        let dateFormatter = DateFormatter.MyDateFormatter
        dateFormatter.dateFormat = inFormat
        var timeZone: TimeZone!
        if apptimeZone == .current {
            timeZone = TimeZone.current
        } else {
            timeZone = TimeZone(abbreviation: "UTC")!
        }
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: self)
    }
    func getString(inFormat dateFormat: AppDateFormat, apptimeZone: AppTimeZone = .current) -> String {
        let dateFormatter = DateFormatter.MyDateFormatter
        //dateFormatter.dateFormat = dateFormat.format
        var timeZone: TimeZone!
        if apptimeZone == .current {
            timeZone = TimeZone.current
        } else {
            timeZone = TimeZone(abbreviation: "UTC")!
        }
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: self)
    }
    var month: String {
        let dateFormatter = DateFormatter.MyDateFormatter
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
    }
    var monthYear: String {
        let dateFormatter = DateFormatter.MyDateFormatter
        dateFormatter.dateFormat = "MM-yyyy"
        return dateFormatter.string(from: self)
    }
    var monthYearLetter: String {
        let dateFormatter = DateFormatter.MyDateFormatter
        dateFormatter.dateFormat = "MMM, yyyy"
        return dateFormatter.string(from: self)
    }
}
struct JSONCodingKeys: CodingKey {
    var stringValue: String
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int?
    
    init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
}


extension KeyedDecodingContainer {
    
    func decode(_ type: Dictionary<String, Any>.Type, forKey key: K) throws -> Dictionary<String, Any> {
        let container = try self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        return try container.decode(type)
    }
    
    func decodeIfPresent(_ type: Dictionary<String, Any>.Type, forKey key: K) throws -> Dictionary<String, Any>? {
        guard contains(key) else {
            return nil
        }
        guard try decodeNil(forKey: key) == false else {
            return nil
        }
        return try decode(type, forKey: key)
    }
    
    func decode(_ type: Array<Any>.Type, forKey key: K) throws -> Array<Any> {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return try container.decode(type)
    }
    
    func decodeIfPresent(_ type: Array<Any>.Type, forKey key: K) throws -> Array<Any>? {
        guard contains(key) else {
            return nil
        }
        guard try decodeNil(forKey: key) == false else {
            return nil
        }
        return try decode(type, forKey: key)
    }
    
    func decode(_ type: Dictionary<String, Any>.Type) throws -> Dictionary<String, Any> {
        var dictionary = Dictionary<String, Any>()
        
        for key in allKeys {
            if let boolValue = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = boolValue
            } else if let stringValue = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = stringValue
            } else if let intValue = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = intValue
            } else if let doubleValue = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = doubleValue
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedDictionary
            } else if let nestedArray = try? decode(Array<Any>.self, forKey: key) {
                dictionary[key.stringValue] = nestedArray
            }
        }
        return dictionary
    }
}

extension UnkeyedDecodingContainer {
    
    mutating func decode(_ type: Array<Any>.Type) throws -> Array<Any> {
        var array: [Any] = []
        while isAtEnd == false {
            // See if the current value in the JSON array is `null` first and prevent infite recursion with nested arrays.
            if try decodeNil() {
                continue
            } else if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            } else if let nestedDictionary = try? decode(Dictionary<String, Any>.self) {
                array.append(nestedDictionary)
            } else if let nestedArray = try? decode(Array<Any>.self) {
                array.append(nestedArray)
            }
        }
        return array
    }
    
    mutating func decode(_ type: Dictionary<String, Any>.Type) throws -> Dictionary<String, Any> {
        
        let nestedContainer = try self.nestedContainer(keyedBy: JSONCodingKeys.self)
        return try nestedContainer.decode(type)
    }
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem as Any, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}

extension MultipartFormData {
    
    func add(key: String, value: Any) {
        if let stringValue = value as? String, let stringValueData = stringValue.data {
            append(stringValueData, withName: key)
        } else if let intValue = value as? Int, let intValueData = "\(intValue)".data {
            append(intValueData, withName: key)
        } else if let cgfloatValue = value as? CGFloat, let cgfloatValueData = "\(cgfloatValue)".data {
            append(cgfloatValueData, withName: key)
        } else if let doubleValue = value as? Double, let doubleValueData = "\(doubleValue)".data {
            append(doubleValueData, withName: key)
        }
    }
    
}

extension UserDefaults {
    open func setStruct<T: Codable>(_ value: T?, forKey defaultName: String){
        let data = try? JSONEncoder().encode(value)
        set(data, forKey: defaultName)
    }
    
    open func structData<T>(_ type: T.Type, forKey defaultName: String) -> T? where T : Decodable {
        guard let encodedData = data(forKey: defaultName) else {
            return nil
        }
        
        return try! JSONDecoder().decode(type, from: encodedData)
    }
    
    open func setStructArray<T: Codable>(_ value: [T], forKey defaultName: String){
        let data = value.map { try? JSONEncoder().encode($0) }
        
        set(data, forKey: defaultName)
    }
    
    open func structArrayData<T>(_ type: T.Type, forKey defaultName: String) -> [T] where T : Decodable {
        guard let encodedData = array(forKey: defaultName) as? [Data] else {
            return []
        }
        
        return encodedData.map { try! JSONDecoder().decode(type, from: $0) }
    }
}

extension GMSMapView {
    
    func getSouthNorthEastLatLong() -> (southEast: CLLocationCoordinate2D, northEast: CLLocationCoordinate2D) {
        let projection = self.projection.visibleRegion()
        let northEastLat = GMSCoordinateBounds(region: projection).northEast.latitude
        let northEastLong = GMSCoordinateBounds(region: projection).northEast.longitude
        
        let southEastLat = GMSCoordinateBounds(region: projection).southWest.latitude
        let southEastLong = GMSCoordinateBounds(region: projection).southWest.longitude
        
        let southEastLatLong = CLLocationCoordinate2D(latitude: southEastLat, longitude: southEastLong)
        let northEastLatLong = CLLocationCoordinate2D(latitude: northEastLat, longitude: northEastLong)
        
        return (southEastLatLong, northEastLatLong)
    }
    
    func updateMap(toLocation location: CLLocation, zoomLevel: Float? = nil) {
        if let zoomLevel = zoomLevel {
            let cameraUpdate = GMSCameraUpdate.setTarget(location.coordinate, zoom: zoomLevel)
            animate(with: cameraUpdate)
        } else {
            animate(toLocation: location.coordinate)
        }
    }
    
}

extension String {
    var toDouble: Double {
        return (self as NSString).doubleValue
    }
}

extension UIImage {
    
    public class func gifImageWithData(data: NSData) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source: source)
    }
    
    public class func gifImageWithURL(gifUrl:String) -> UIImage? {
        guard let bundleURL = NSURL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = NSData(contentsOf: bundleURL as URL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(data: imageData)
    }
    
    public class func gifImageWithName(name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        
        guard let imageData = NSData(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(data: imageData)
    }
    
    class func delayForImageAtIndex(index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(CFDictionaryGetValue(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()), to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()), to: AnyObject.self)
        
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a! < b! {
            let c = a!
            a = b!
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b!
                b = rest
            }
        }
    }
    
    class func gcdForArray(array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(a: val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(index: Int(i), source: source)
            delays.append(Int(delaySeconds * 350.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(array: delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames, duration: Double(duration) / 1000.0)
        
        return animation
    }
}

extension Collection {
    func toJsonString() -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
            guard let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) else {
                print("Can't create string with data.")
                return "{}"
            }
            return jsonString
        } catch let parseError {
            print("json serialization error: \(parseError)")
            return "{}"
        }
    }
}

extension UIViewController {
    func topMostViewController() -> UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}

extension CLLocationCoordinate2D {
    
    func bearing(to point: CLLocationCoordinate2D) -> Double {
        func degreesToRadians(_ degrees: Double) -> Double { return degrees * Double.pi / 180.0 }
        func radiansToDegrees(_ radians: Double) -> Double { return radians * 180.0 / Double.pi }
        
        let fromLatitude = degreesToRadians(latitude)
        let fromLongitude = degreesToRadians(longitude)
        
        let toLatitude = degreesToRadians(point.latitude)
        let toLongitude = degreesToRadians(point.longitude)
        
        let differenceLongitude = toLongitude - fromLongitude
        
        let y = sin(differenceLongitude) * cos(toLatitude)
        let x = cos(fromLatitude) * sin(toLatitude) - sin(fromLatitude) * cos(toLatitude) * cos(differenceLongitude)
        let radiansBearing = atan2(y, x);
        let degree = radiansToDegrees(radiansBearing)
        return (degree >= 0) ? degree : (360 + degree)
    }
}
