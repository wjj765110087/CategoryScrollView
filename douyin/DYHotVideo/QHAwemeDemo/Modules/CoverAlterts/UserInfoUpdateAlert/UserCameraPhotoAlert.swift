//
//  UserCameraPhotoAlert.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/12.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class UserCameraPhotoAlert: UIView {
    
    var buttonDidClickHandler: ((Int)->())?
    
    @IBAction func didClickCamera(_ sender: UIButton) {
        buttonDidClickHandler?(sender.tag)
    }
    
    @IBAction func didClickPhoto(_ sender: UIButton) {
        buttonDidClickHandler?(sender.tag)
    }
}
