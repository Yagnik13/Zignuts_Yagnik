//
//  CorePickerTextField.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//

import UIKit

class CorePickerTextField: CoreTextField {

    //MARK: - Controls
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    private var toolBar: CoreToolbar!
    
    //MARK: - Properties
    var dataSource = [[String]]()
    var blockForCancelButtonTap: voidCompletion?
    var blockForDoneButtonTap: ((_ selectedValue: String, _ selectedIndex: Int)->Void)?
    var blockForDidSelect: ((_ selectedValue: String, _ selectedIndex: Int, _ section: Int)->Void)?
    
    //MARK: - Methods
    override func commonInit() {
        super.commonInit()
        toolBar = CoreToolbar.getToolbar(doneTitle: doneButtonTitle,doneCompletion: {
            self.resignFirstResponder()
            if let firstDataSet = self.dataSource.first, firstDataSet.count > 0 {
                let selectedIndex = self.pickerView.selectedRow(inComponent: 0)
                self.blockForDoneButtonTap?((self.dataSource[0][selectedIndex]), selectedIndex)
            } else {
                self.blockForDoneButtonTap?("", 0)
            }
        }, cancelCompletion: {
            self.resignFirstResponder()
            self.blockForCancelButtonTap?()
        })
        toolBar.sizeToFit()
        pickerView.sizeToFit()
        inputView = pickerView
        inputAccessoryView = toolBar
    }

}

extension CorePickerTextField: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource[component].count
    }
    
    /*func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[component][row]
    }*/
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let v = view as? UILabel {
            label = v
        } else {
            label = UILabel()
        }
        label.text = "\(dataSource[component][row])"
        label.textAlignment = .center
        //label.font = AppFont.groteskRegular.getFont(withSize: 19)
        label.numberOfLines = 0
        return label
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width / CGFloat(dataSource.count)
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        blockForDidSelect?((dataSource[component][row]), row, component)
    }
}
