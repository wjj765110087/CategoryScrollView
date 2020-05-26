//
//  CollectionSectionHeaderView.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/19.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit

class CollectionSectionHeaderView: UICollectionReusableView {
    
    static let resuseId = "CollectionSectionHeaderView"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    func setModel(model: SpecialSerialModel) {
        self.titleLabel.text = model.title
        self.subTitleLabel.text = (model.intro == nil || model.intro!.isEmpty) ? "暂无简介" : model.intro
    }
}
