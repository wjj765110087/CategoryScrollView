//
//  UserHeaderView.swift
//  YellowBook
//
//  Created by mac on 2019/6/29.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit

class UserHeaderView: UIView {

    @IBOutlet weak var headerImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var mesgLabel: UILabel!
    @IBOutlet weak var inviteCount: UILabel!
    @IBOutlet weak var readJuan: UILabel!
    @IBOutlet weak var readedCount: UILabel!
    @IBOutlet weak var fakeLayerView: UIView!
    @IBOutlet weak var vipButton: UIButton!
    @IBOutlet weak var inviteCountBtn: UIButton!
    
    var buttonClickHandler:((_ actionId: Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func actionHandler(_ sender: UIButton) {
        buttonClickHandler?(sender.tag)
    }
    
}

class UserInfoView: UIView {
    
    @IBOutlet weak var headerImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var openStatu: UIButton!
    @IBOutlet weak var tipsLabel: UILabel!
    
    
}
