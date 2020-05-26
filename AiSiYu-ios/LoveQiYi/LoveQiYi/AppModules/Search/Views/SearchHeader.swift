//
//  SearchHeader.swift
//  DouCartoonDemo
//
//  Created by mac on 2019/6/3.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit

class SearchHeader: UIView {

    @IBOutlet weak var barView: UIView!
    
    @IBOutlet weak var grayFakeView: UIView!
    
    @IBOutlet weak var searchTf: UITextField!
    
    @IBOutlet weak var cancleBtn: UIButton!
    var cancleAction:(() -> ())?
    
    @IBAction func cancleAction(_ sender: UIButton) {
        cancleAction?()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        searchTf.setValue(UIColor.lightGray, forKeyPath: "_placeholderLabel.textColor")
    }
    
}

class NotDataTipsView: UIView {
    
    private let searchImg: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "GlobalNOData")
        return image
    }()
    private var nodateLable: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.text = "未搜索到任何相关内容"
        return lable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nodateLable)
        addSubview(searchImg)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutPageSubviews() {
        nodateLable.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview().offset(10)
        }
        searchImg.snp.makeConstraints { (make) in
            make.trailing.equalTo(nodateLable.snp.leading).offset(-5)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
    }
}
