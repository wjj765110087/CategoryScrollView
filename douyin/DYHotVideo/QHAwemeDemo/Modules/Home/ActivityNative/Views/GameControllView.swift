//
//  GameControllView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019-12-19.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class GameControllView: UIView {

    
    @IBOutlet weak var cleanButton: UIButton!
    @IBOutlet weak var allInButton: UIButton!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var userCoinsView: UIView!
    @IBOutlet weak var userCoinBgLabel: UILabel!
    
    @IBOutlet weak var userCoinsLabel: UILabel!
    /// actionId: 1.清零。2.全押。3.开始
    var buttonClickHandler:((_ actionId: Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userCoinsView.layer.borderColor = UIColor.white.cgColor
        userCoinsView.layer.borderWidth = 1.0
        userCoinBgLabel.font = UIFont.init(name: "DBLCDTempBlack", size: 18)
        userCoinBgLabel.text = "888888"
        
        userCoinsLabel.font = UIFont.init(name: "DBLCDTempBlack", size: 18)
        userCoinsLabel.text = "0"
        starButton.imageView?.contentMode = .scaleAspectFill
    }
    
    @IBAction func buttonClickHandler(_ sender: UIButton) {

        if sender == cleanButton {
            buttonClickHandler?(1)
        } else if sender == allInButton {
            buttonClickHandler?(2)
        } else if sender == starButton {
            buttonClickHandler?(3)
        }
    }
}
