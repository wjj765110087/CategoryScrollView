//
//  XSAltert.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/24.
//  Copyright © 2018年 pro5. All rights reserved.
//

import Foundation
import MBProgressHUD

class XSAlert: NSObject {
    enum AlertType {
        case success
        case info
        case error
        case warning
        case nono
        case text
    }
    
    class func show(type: AlertType, text: String) {
        if let window = UIApplication.shared.delegate?.window {
            var image = UIImage(named: "Alert_success")
            switch type {
            case .success:
                image = UIImage(named: "Alert_success")
            case .info:
                image = UIImage(named: "Alert_info")
            case .error:
                image = UIImage(named: "Alert_error")
            case .warning:
                image = UIImage(named: "Alert_warning")
            case .nono:
                image = UIImage(named: "Alert_nono")
            case .text:
                image = UIImage()
            }
            let hud = MBProgressHUD.showAdded(to: window! , animated: true)
            hud.backgroundColor = UIColor.lightGray.withAlphaComponent(0.05)
            hud.mode = .customView
            hud.customView = UIImageView(image:image)
            hud.label.text = text
            hud.label.font = UIFont.systemFont(ofSize: 14)
            hud.hide(animated: true, afterDelay: 2.0)
        }
    }
}

