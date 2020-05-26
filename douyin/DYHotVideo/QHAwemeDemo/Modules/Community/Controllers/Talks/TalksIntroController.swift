//
//  TalksIntroController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/17.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class TalksIntroController: QHBaseViewController {

    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "#\(talksModel?.title ?? "")"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.clear
        bar.backButton.isHidden = false
        bar.lineView.isHidden = true
        bar.delegate = self
        return bar
    }()
    private let introllLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()
    var talksModel: TalksModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(navBar)
        view.addSubview(introllLabel)
        layoutPageSubviews()
        if let intro = talksModel?.intro {
            introllLabel.attributedText = TextSpaceManager.getAttributeStringWithString(intro, lineSpace: 5)
        }
    }
    
}

// MARK: - QHNavigationBarDelegate
extension TalksIntroController: QHNavigationBarDelegate  {
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Layout
private extension TalksIntroController {
    func layoutPageSubviews() {
        layoutNavBar()
        layoutIntrolLabel()
        
    }
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
    }
    func layoutIntrolLabel() {
        introllLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(navBar.snp.bottom).offset(15)
        }
    }
}
