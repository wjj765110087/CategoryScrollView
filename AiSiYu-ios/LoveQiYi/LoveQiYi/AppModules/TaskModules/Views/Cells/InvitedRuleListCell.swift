//
//  InvitedRuleListCell.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/18.
//  Copyright © 2019年 bingdaohuoshan. All rights reserved.
//

import UIKit

class InvitedRuleListCell: UITableViewCell {
    
    static let cellId = "InvitedRuleListCell"

    @IBOutlet weak var ruleIcon: UIImageView!
    @IBOutlet weak var inviteCount: UILabel!
    @IBOutlet weak var timeForWelfare: UILabel!
    @IBOutlet weak var doneTaskBtn: UIButton!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var centerImage: UIImageView!
    var doneTaskClick:(()->Void)?
    
    private var ruleModel: RuleModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        doneTaskBtn.setBackgroundImage(UIColor.creatImageWithColor(color: kAppDefaultTitleColor, size: CGSize(width: 70, height: 30)), for: .normal)
        doneTaskBtn.setBackgroundImage(UIColor.creatImageWithColor(color: kBarColor, size: CGSize(width: 70, height: 30)), for: .selected)
        //doneTaskBtn.addShadow(radius: 2, opacity: 0.6)
    }
    
    func setModel(_ rules: RuleModel, index: Int) {
        let i = index % 3
        ruleIcon.backgroundColor = [UIColor(r: 255, g: 191, b: 26), UIColor(r: 255, g: 120, b: 94), UIColor(r:40, g: 136, b: 255)][i]
        centerImage.image = UIImage(named: "rulesIcon")
        inviteCount.text = "累计邀请 \(rules.person ?? 0)人"
        timeForWelfare.attributedText = TextSpaceManager.configColorString(allString: "不限次数看 \(rules.day ?? 0)天", attribStr: "\(rules.day ?? 0)天", kAppDefaultTitleColor, UIFont.systemFont(ofSize: 14))
        doneTaskBtn.isSelected = rules.sign == 1
        ruleModel = rules
        
    }
    
    @IBAction func doneTask(_ sender: UIButton) {
        if (ruleModel?.sign ?? 0) == 0 {
            doneTaskClick?()
        }
    }
}
