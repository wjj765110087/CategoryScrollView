//
//  LuckCardSucceedAlert.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/26.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class LuckCardSucceedAlert: UIView {

    @IBOutlet weak var contenView: UIView!
    @IBOutlet weak var commitBtn: UIButton!
    @IBOutlet weak var titLabel: UILabel!
    @IBOutlet weak var mesgLabel: UILabel!
    
    @IBOutlet weak var statuImage: UIImageView!
    var commitActionhandler:(() ->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contenView.backgroundColor = UIColor(red: 90/255.0, green: 210/255.0, blue: 144/255.0, alpha: 0.99)
        commitBtn.layer.cornerRadius = 17.5
        commitBtn.layer.borderColor = UIColor.darkText.cgColor
        commitBtn.layer.borderWidth = 1
        commitBtn.layer.masksToBounds = true
        contenView.layer.cornerRadius = 8
        contenView.layer.masksToBounds = true
    }
    
    @IBAction func commitAction(_ sender: UIButton) {
        commitActionhandler?()
    }
    
}
