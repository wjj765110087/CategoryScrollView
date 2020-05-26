//
//  IDCardInfoController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/4/17.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class IDCardInfoController: UIViewController {
    
    private lazy var navBar: CNavigationBar = {
        let bar = CNavigationBar()
        bar.titleLabel.text = "身份卡"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = kBarColor
        bar.lineView.backgroundColor = UIColor.clear
        bar.delegate = self
        return bar
    }()
    
    private let imageV: UIImageView = {
        let img = UIImageView()
        img.isUserInteractionEnabled = true
        img.backgroundColor = UIColor.clear
        img.image = UIImage(named: "")
        return img
    }()
    var isCardId: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageV)
        view.addSubview(navBar)
        layoutPageSubviews()
        loadCardView()
    }

    private func loadCardView() {
        guard let card = Bundle.main.loadNibNamed("IDCardView", owner: nil, options: nil)?[0] as? IDCardView else { return }
        view.addSubview(card)
        layoutCardView(card)
        if isCardId {
            navBar.titleLabel.text = "身份卡"
            card.setUpIdCodeUI()
        } else {
            navBar.titleLabel.text = ""
            navBar.backButton.setImage(UIImage(named: "navBackWhite"), for: .normal)
            card.setInviteCodeUI()
        }
    }
    
}

// MARK: - CNavigationBarDelegate
extension IDCardInfoController:  CNavigationBarDelegate  {
    
    func backAction() {
        if isCardId {
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

private extension IDCardInfoController {
    
    func layoutPageSubviews() {
        layoutImgview()
        layoutNavBar()
    }
    
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(statusBarHeight + 44)
        }
    }
    
    func layoutCardView(_ card: IDCardView) {
        card.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom).offset(20
            )
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
    
    func layoutImgview() {
        imageV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
