//
//  IDCardInfoController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/4/17.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class IDCardInfoController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private lazy var cardView: IDCardView = {
        guard let card = Bundle.main.loadNibNamed("IDCardView", owner: nil, options: nil)?[0] as? IDCardView else { return  IDCardView()}
        return card
    }()
    
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "身份卡"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.clear
        bar.lineView.backgroundColor = UIColor.clear
        bar.delegate = self
        return bar
    }()
    var isPresent = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(navBar)
        layoutPageSubviews()
        loadCardView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isPresent && !UserDefaults.standard.bool(forKey: UserDefaults.kSaveIDCard) {
            if let cardImg = self.view.toImage() {
                 UIImageWriteToSavedPhotosAlbum(cardImg, self, nil, nil)
                UserDefaults.standard.set(true, forKey: UserDefaults.kSaveIDCard)
            }
        }
    }

    private func loadCardView() {
        view.addSubview(cardView)
        layoutCardView(cardView)
        if isPresent {
            navBar.backButton.setImage(UIImage(named: "recordClose"), for: .normal)
            navBar.backgroundColor = UIColor.clear
            navBar.titleLabel.textColor = UIColor.white
             navBar.titleLabel.text = ""
            cardView.actionHandler = { [weak self] (id) in
                self?.dismiss(animated: false, completion: nil)
            }
        }
        
    }
    
}

// MARK: - QHNavigationBarDelegate
extension IDCardInfoController:  QHNavigationBarDelegate  {
    
    func backAction() {
        if isPresent {
            dismiss(animated: false, completion: nil)
            return
        }
        navigationController?.popViewController(animated: true)
    }
}

private extension IDCardInfoController {
    func layoutPageSubviews() {
        layoutNavBar()
    }
    
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
    }
    
    func layoutCardView(_ card: IDCardView) {
        card.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
}
