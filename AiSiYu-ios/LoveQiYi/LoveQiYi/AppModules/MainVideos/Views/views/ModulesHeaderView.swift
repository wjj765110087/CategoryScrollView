//
//  ShopHeaderView.swift
//  YellowBook
//
//  Created by mac on 2019/6/29.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit

class ModulesHeaderView: UICollectionReusableView {

    static let reuseId = "ModulesHeaderView"
    
    @IBOutlet weak var titleLab: UILabel!
    
    
    @IBOutlet weak var moreBtn: UIButton!
    
    var moreActionHandler:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    @IBAction func moreAction(_ sender: UIButton) {
        moreActionHandler?()
    }
    
    
}
