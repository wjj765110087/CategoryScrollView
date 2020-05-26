//
//  HomeSectionFooterView.swift
//  YUEPAO
//
//  Created by mac on 2019/8/6.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit

class DiscoverSectionHeaderView: UICollectionReusableView {
    
    static let reuseId = "DiscoverSectionHeaderView"
    static let itemSize = CGSize(width: screenWidth, height: 42)
    
    var clickHandler: (() -> ())?
    
    @IBAction func clickHandler(_ sender: UIButton) {
        
        if let clickHandler = clickHandler {
            clickHandler()
        }
    }
}
