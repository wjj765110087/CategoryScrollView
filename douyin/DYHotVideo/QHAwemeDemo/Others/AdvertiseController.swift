//
//  AdvertiseController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/21.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class AdvertiseController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var adUrl = ""
    var adClickOrShowToEndHandler:(() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        addAdvertisement(adUrl)
       // self.adClickOrShowToEndHandler?()
    }
    
    /// 启动广告
    func addAdvertisement(_ url: String) {
        let advertisement = AdvertisementView(frame: nil, duration: 5, delay: 0, adUrl: url, isHiddenSkipBtn: false, isIgnoreCache: false, placeholderImage: UIImage(named: "screenCan"), completion: { (isClickDetail) in
            DLog("广告展示完毕=\(isClickDetail)")
            self.adClickOrShowToEndHandler?()
           
        }) { (isClickDetail) in
            if !isClickDetail {
                DLog("点击了跳过广告 =\(isClickDetail)")
                self.adClickOrShowToEndHandler?()
            }
        }
        advertisement.advertiseDetailClickHandler = {
             DLog("点击了广告页面 ")
             self.advertiseClick()
            self.adClickOrShowToEndHandler?()
            self.dismiss(animated: true, completion: nil)
           
        }
        advertisement.backgroundColor = UIColor.clear
        view.addSubview(advertisement)
    }
    
    func advertiseClick() {
         DLog("主流程不变， 跳到外部广告链接")
        guard let adHref = UserDefaults.standard.url(forKey: UserDefaults.kAdHrefUrl) else { return }
        if #available(iOS 10, *) {
            UIApplication.shared.open(adHref, options: [:],
                                      completionHandler: {
                                        (success) in
            })
        } else {
            UIApplication.shared.openURL(adHref)
        }
    }

}
