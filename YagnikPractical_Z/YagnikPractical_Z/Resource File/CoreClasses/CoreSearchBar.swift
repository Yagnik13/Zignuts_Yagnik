//
//  CoreSearchBar.swift
//  YagnikPractical_Z
//
//  Created by Yagnik Suthar on 13/06/20.
//  Copyright © 2020 Yagnik Suthar. All rights reserved.
//
//


import UIKit

class CoreSearchBar: UISearchBar {

    var shouldBeginEditing: Bool = true
    var shouldBeginEditingBlock: (() -> (Bool))?
    
    func commonInit(){
        /*if let textFieldInsideUISearchBar = value(forKey: "searchField") as? UITextField {
            textFieldInsideUISearchBar.font = AppFont.groteskRegular.getFont(withSize: 12)
        }*/
        setImage("ic_search".imageWithOriginalMode, for: UISearchBar.Icon.search, state: .normal)
        setImage("ic_cancel".imageWithOriginalMode, for: UISearchBar.Icon.clear, state: .normal)
        delegate = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

}

extension CoreSearchBar: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return shouldBeginEditingBlock?() ?? true
    }
}

class SearchBarContainerView: UIView {
    
    let searchBar: CoreSearchBar
    
    //var onTextChange: ((IDTMSearchBar) -> Void)?
    
    init(customSearchBar: CoreSearchBar) {
        searchBar = customSearchBar
        super.init(frame: CGRect.zero)
        
        //searchBar.delegate = self
        searchBar.placeholder = "Search".localized
        addSubview(searchBar)
    }
    override convenience init(frame: CGRect) {
        self.init(customSearchBar: CoreSearchBar())
        self.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.frame = bounds
    }
}
