//
//  VideoCoinSelectedController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/11/19.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class VideoCoinSelectedController: UIViewController {

    private let coinsSelectedView: VideoCoinSelectedVeiw = {
        guard let coverView = Bundle.main.loadNibNamed("VideoCoinSelectedVeiw", owner: nil, options: nil)?[0] as? VideoCoinSelectedVeiw else { return  VideoCoinSelectedVeiw() }
        return coverView
    }()
    
    var coinsSelectedHandler:((_ coinsPride: Int) ->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(coinsSelectedView)
        layoutCoinView()
        coinsSelectedView.buttonClickHandler = { [weak self] price in
            self?.coinsSelectedHandler?(price)
        }
    }
    
    @objc func closeWindow() {
        dismiss(animated: false, completion: nil)
    }
    
    func layoutCoinView() {
        coinsSelectedView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(30)
            make.height.equalTo(295)
        }
    }

}
