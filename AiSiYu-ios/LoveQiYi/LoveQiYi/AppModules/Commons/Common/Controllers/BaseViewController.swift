//
//  BaseViewController.swift
//  BartRootTabBarViewController
//
//  Created by mac on 2019/6/26.
//  Copyright © 2019年 simpsons. All rights reserved.
//

import UIKit
import MJRefresh

class BaseViewController: UIViewController, CNavigationBarDelegate {
    
    lazy var navBar: CNavigationBar = {
        let bar = CNavigationBar()
        bar.titleLabel.text = ""
        bar.backgroundColor = kBarColor
        bar.lineView.backgroundColor = UIColor(r: 244, g: 244, b: 244)
        bar.backButton.isHidden = false
        bar.delegate = self
        return bar
    }()
    var rightBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("编辑", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(kAppDefaultTitleColor, for: .normal)
        button.isHidden = true
        return button
    }()
    lazy var refreshView: MJRefreshGifHeader = {
        weak var weakSelf = self
        let mjRefreshHeader = MJRefreshGifHeader(refreshingBlock: {
            weakSelf?.loadFirstPage()
        })
        var gifImages = [UIImage]()
        for string in ConstValue.refreshImageNames {
            gifImages.append(UIImage(named: string)!)
        }
        mjRefreshHeader?.setImages(gifImages, for: .refreshing)
        mjRefreshHeader?.setImages(gifImages, for: .idle)
        mjRefreshHeader?.stateLabel.font = ConstValue.kRefreshLableFont
        mjRefreshHeader?.lastUpdatedTimeLabel.font = ConstValue.kRefreshLableFont
        return mjRefreshHeader!
    }()
    lazy var loadMoreView: MJRefreshAutoNormalFooter = {
        weak var weakSelf = self
        let loadMore = MJRefreshAutoNormalFooter(refreshingBlock: {
            weakSelf?.loadNextPage()
        })
        loadMore?.stateLabel.font = ConstValue.kRefreshLableFont
        loadMore?.setTitle("", for: .idle)
        loadMore?.setTitle("加载中...", for: .refreshing)
        loadMore?.setTitle("啊，已经到底了", for: .noMoreData)
        return loadMore!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.addSubview(navBar)
        navBar.navBarView.addSubview(rightBtn)
        layoutNavSubviews()
        rightBtn.addTarget(self, action: #selector(rightButtonClick(_:)), for: .touchUpInside)
    }
    
    
    @objc func rightButtonClick(_ sender: UIButton) {
        
    }
    
    func loadFirstPage() {
        
    }
    
    func loadNextPage() {
        
    }
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
}


private extension BaseViewController {
    
    func layoutNavSubviews() {
        layoutNavBar()
        layoutRightBtn()
    }

    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(UIApplication.shared.statusBarFrame.height + 44)
        }
    }
    
    func layoutRightBtn() {
        rightBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(35)
        }
    }
}
