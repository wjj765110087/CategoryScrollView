//
//  CommunityBottomView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/9/30.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class CommunityBottomView: UIView {

    static let height: CGFloat = 40.0

    @IBOutlet weak var talkTipsButton: UIButton!
    @IBOutlet weak var commentTipsBtn: UIButton!
    @IBOutlet weak var shareTipsBtn: UIButton!
    @IBOutlet weak var favorTipsBtn: UIButton!
    
    /// actionId : 1.话题点击 2.评论点击 3.分享点击 4.点赞
    var itemActionHandler:((_ actiionId: Int) ->Void)?
   
    @IBAction func talkTipsBtnClick(_ sender: UIButton) {
        itemActionHandler?(sender.tag)
    }
    
}
