//
//  BadgeBarButtonItem.swift
//  NicooExtension
//
//  Created by 小星星 on 2018/11/15.
//

/*
 Description:
 对UIBarButtonItem的扩展方法
 
 History:
 */

import UIKit

public extension UIBarButtonItem {
    fileprivate struct AssociatedBadgeNumberKey {
        static var badgeNumber = "badgeNumberKey"
    }
    
    var badgeNumber: Int {
        get {
            guard let number: NSNumber = objc_getAssociatedObject(self, &AssociatedBadgeNumberKey.badgeNumber) as? NSNumber else {
                return 0
            }
            return number.intValue
        }
        set(value) {
            objc_setAssociatedObject(self, &AssociatedBadgeNumberKey.badgeNumber, NSNumber(value: value as Int), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if value > 0 {
                self.updateBadgeNumberView()
            } else {
                self.clearBadgeNumberView()
            }
        }
    }
    
    fileprivate func updateBadgeNumberView() {
        let width = self.badgeNumber > 9 ? 20.0 : 10.0
        let image = UIImage(named: "home_barbutton_msg")
        let badgeTextField = UITextField(frame: CGRect(x: (Double)((image?.size.width)!) - (width/2.0) ,y: -5.0  ,width: width,height: 10.0))
        badgeTextField.font = UIFont.systemFont(ofSize: 9)
        badgeTextField.isEnabled = false
        badgeTextField.backgroundColor = .red
        badgeTextField.textColor = .white
        badgeTextField.layer.cornerRadius = 5;
        badgeTextField.textAlignment = .center
        badgeTextField.text = String(self.badgeNumber);
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!)
        button.setImage(image, for: UIControl.State())
        button.addTarget(self.target, action: self.action!, for: .touchUpInside)
        button.addSubview(badgeTextField)
        
        self.customView = button
    }
    
    fileprivate func clearBadgeNumberView() {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!)
        button.setImage(image, for: UIControl.State())
        button.addTarget(self.target, action: self.action!, for:.touchUpInside)
        
        self.customView = button
    }
}

