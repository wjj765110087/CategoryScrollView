//
//  FeedChatInfoCell.swift
//  DouCartoonDemo
//
//  Created by mac on 2019/6/7.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit

class FeedChatInfoCell: UITableViewCell {

    static let cellId = "FeedChatInfoCell"
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var nicknamelab: UILabel!
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var keyLab: UILabel!
    @IBOutlet weak var remarkLab: UILabel!
    @IBOutlet weak var imgContainer: UIView!
    
    @IBOutlet weak var bottomMargin: NSLayoutConstraint!
    
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    
    var imageClickhandler:((_ index: Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        container.addShadow(radius: 3, opacity: 0.3)
    }

    func setImage(_ images: [String]) {
        if images.count == 0 { return }
        for button in imgContainer.subviews {
            button.removeFromSuperview()
        }
        for i in 0 ..< images.count {
            let imgurl = images[i]
            let btn = UIButton(type: .custom)
            btn.tag = i + 876
            btn.kfSetVerticalImageWithUrl(imgurl)
            btn.addTarget(self, action: #selector(imgClick(_:)), for: .touchUpInside)
            imgContainer.addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.leading.equalTo(75*i)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(65)
            }
        }
    }
    
    
    func setModel(_ model: FeedModel) {
        nicknamelab.text = model.nikename ?? "抖阴客服"
        timeLab.text = model.created_at ?? ""
        if let keys = model.keys, keys.count > 0 {
            let striingKey = NSMutableString()
            for str in keys {
                striingKey.append("\(str) 、")
            }
            keyLab.text = striingKey as String
        }
        remarkLab.text = model.remark ?? ""
        if let imgs = model.cover_url {
            if imgs.count == 0
            {
                imgHeight.constant = 0
                bottomMargin.constant = 0
            } else {
                imgHeight.constant = 65
                bottomMargin.constant = 15
            }
        }
    }
    
    @objc func imgClick(_ sender: UIButton) {
        let index = sender.tag - 876
        imageClickhandler?(index)
    }
    
}
