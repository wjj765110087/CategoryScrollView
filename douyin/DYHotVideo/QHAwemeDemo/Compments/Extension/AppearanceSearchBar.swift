//
//  AppearanceSearchBar.swift
//  NicooExtension
//
//  Created by 小星星 on 2018/11/15.
//

/*
 Description:
 对UISearchBar的扩展方法
 
 History:
 */

import UIKit

public extension UISearchBar {
    
    func clearBackground()  {
        let firstSubview = self.subviews[0];
        for subview in firstSubview.subviews {
            if subview.isKind(of: NSClassFromString("UISearchBarBackground")!) {
                subview.removeFromSuperview()
                break
            }
        }
    }
    
    func displayTextFieldFullRoundRectStyle() {
        let textField = self.getSearchTextField()
        textField?.layer.cornerRadius = 4.0
    }
    
    func changeCancelTittleColor(_ color: UIColor) {
        self.tintColor = color
    }
    
    func changeTitleColor(_ color: UIColor) {
        let textField = self.getSearchTextField()
        textField?.textColor = color
    }
    
    func changeTextFieldBackgroundColor(_ color: UIColor) {
        let textField = self.getSearchTextField()
        textField?.backgroundColor = color
    }
    
    func clearSearchText() {
        let textField = self.getSearchTextField()
        textField?.text = ""
    }
    
    func changeCursorColor(_ color: UIColor) {
        for view in self.subviews {
            for subview in view.subviews {
                if let textfield = subview as? UITextField {
                    textfield.tintColor = color
                    return
                }
            }
        }
    }
    
    func changeFont(_ font: UIFont) {
        getSearchTextField()?.font = font
    }
    
    func getSearchTextField() -> UITextField? {
        let firstSubview  = self.subviews[0]
        
        for subview in firstSubview.subviews {
            if subview.isKind(of: NSClassFromString("UISearchBarTextField")!) {
                return subview as? UITextField
            }
        }
        return nil
    }
}

