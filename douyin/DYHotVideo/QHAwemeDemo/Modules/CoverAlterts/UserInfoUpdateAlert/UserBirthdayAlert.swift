//
//  UserBirthdayAlert.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/12.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class UserBirthdayAlert: UIView {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var popView: UIView!
    var commitActionHandler:((String) ->Void)?
    var cancleActionHandler:(() -> Void)?
    
    var dataStr: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let corners: UIRectCorner = [UIRectCorner.topLeft, UIRectCorner.topRight]
        popView.corner(byRoundingCorners: corners, radii: 5)
        datePicker.maximumDate = Date()
        datePicker.maximumDate = Date.getCurrentDayBeforeYear(year: 18)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        cancleActionHandler?()
    }
    
    @IBAction func sure(_ sender: UIButton) {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        
         let dateStr = dateFormat.string(from: datePicker.date)
        commitActionHandler?(dateStr)
    }
    
    @IBAction func didSelectBirthday(_ sender: UIDatePicker) {
        
        
    }
}
