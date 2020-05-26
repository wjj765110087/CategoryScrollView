//
//  ScrollSystemAlertCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/4/22.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class ScrollSystemAlertCell: UICollectionViewCell {
    
    static let cellId = "ScrollSystemAlertCell"
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.darkText
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.backgroundColor = UIColor.clear
        textView.isEditable = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(textView)
        layoutTextView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


private extension ScrollSystemAlertCell {
    func layoutTextView() {
        textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
