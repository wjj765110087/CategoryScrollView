//
//  UserSexAlert.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/12.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class UserSexAlert: UIView {

    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var commitActionHandler:((String) ->Void)?
    var cancleActionHandler:(() -> Void)?
    
    var sex: [String] = ["女","男","不显示"]
    var sexString: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let corners: UIRectCorner = [UIRectCorner.topLeft, UIRectCorner.topRight]
        popView.corner(byRoundingCorners: corners, radii: 5)
        
    }
    
    @IBAction func didClickSure(_ sender: UIButton) {
        commitActionHandler?(sexString)
    }
    
    @IBAction func didClickCancel(_ sender: UIButton) {
        cancleActionHandler?()
    }
}

//MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension UserSexAlert: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sex[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return screenWidth - 36
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        sexString = sex[row]
        
    }
}
