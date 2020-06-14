//
//  CoreTextView.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//


import UIKit

class CoreTextView: UITextView {

    //MARK: - Controls
    private lazy var placeHolderLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.appGray
        //lbl.font = AppFont.groteskRegular.getFont(withSize: 15)
        lbl.textAlignment = .natural
        return lbl
    }()
    private var toolBar: CoreToolbar!
    
    //MARK: - Properties
    private var topInset: CGFloat = 13
    private var leftInset: CGFloat = 14
    @IBInspectable var doneButtonTitle: String = "Done".localized
    @IBInspectable var placeHolderText: String = "" {
        didSet {
            placeHolderLabel.text = placeHolderText.localized
        }
    }
    var blockForTextChange: ((_ text: String)->Void)?
    var blockForEndEditing: ((_ text: String)->Void)?
    
    //MARK: - Setup UI Methods
    private func commonInit() {
        toolBar = CoreToolbar.getToolbar(doneTitle: doneButtonTitle, doShowCancelBarButton: false, doneCompletion: {
            self.resignFirstResponder()
            self.blockForEndEditing?(self.text!)
        }, cancelCompletion: nil)
        toolBar.sizeToFit()
        inputAccessoryView = toolBar
        textContainerInset = UIEdgeInsets(top: topInset-1, left: leftInset-4, bottom: 0, right: 0)
        setupPlaceHolderLabel()
        delegate = self
    }
    
    private func setupPlaceHolderLabel() {
        if !subviews.contains(placeHolderLabel) {
            addSubview(placeHolderLabel)
            addConstraintsWithFormat("H:|-\(topInset)-[v0]-14-|", views: placeHolderLabel)
            addConstraintsWithFormat("V:|-\(leftInset)-[v0]", views: placeHolderLabel)
        }
    }
    
    @IBInspectable var fontFamily: Int = 0 {
        didSet {
            setFont()
        }
    }
    @IBInspectable var fontSize: CGFloat = 15 {
        didSet {
            setFont()
        }
    }
    
    private func setFont () {
        if let selectedFont = AppFont(rawValue: fontFamily) {
            font = selectedFont.getFont(withSize: fontSize)
        }
    }
    
    func bind(callback :@escaping (String) -> ()) {
        self.blockForTextChange = callback
    }
    
    //MARK: - Init Methods
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        commonInit()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

extension CoreTextView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        placeHolderLabel.isHidden = textView.text.count > 0
        blockForTextChange?(textView.text)
    }
    
}
