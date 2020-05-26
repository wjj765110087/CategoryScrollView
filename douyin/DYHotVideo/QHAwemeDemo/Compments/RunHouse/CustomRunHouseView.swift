//
//  CustomRunHouseView.swift
//  QHAwemeDemo
//
//  Created by mac on 11/26/19.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

/// 一种跑马灯item视图
class CustomRunHouseView: UIView,UIRunHouseItemProtocol {
    
    let label = UILabel()
    
    init() {
        super.init(frame: CGRect.zero)
        self.creatUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func creatUI(){
        self.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.init(r: 153, g: 153, b: 153)
        label.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    func prepareForReuse() {
        label.text = nil
    }
}

