//
//  InfoEditCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

class InfoEditCell: UITableViewCell {
    
    static let cellId = "InfoEditCell"
    
    @IBOutlet weak var msglab: UILabel!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var lineView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        lineView.backgroundColor = ConstValue.kAppSepLineColor
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 70))
        view.backgroundColor = UIColor.darkGray
        selectedBackgroundView = view
    }
    
}
