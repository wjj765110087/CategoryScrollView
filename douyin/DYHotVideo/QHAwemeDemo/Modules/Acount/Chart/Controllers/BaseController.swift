//
//  BaseController.swift
//  DouCartoonDemo
//
//  Created by mac on 2019/6/7.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit
import MJRefresh

class BaseController: UIViewController {

    lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = navigationController?.title ?? ""
        bar.backgroundColor = UIColor.clear
        bar.backButton.setImage(UIImage(named: "icon_angle_left_s_"), for: .normal)
        bar.lineView.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)
        bar.delegate = self
        return bar
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
    
    lazy var refreshView: MJRefreshGifHeader = {
        weak var weakSelf = self
        let mjRefreshHeader = MJRefreshGifHeader(refreshingBlock: {
            weakSelf?.loadData()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(navBar)
        layoutNav()
    }
    
    private func layoutNav() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
    }
    
    /// 需要自定义，重写
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    func loadData() {
        
    }
    
    func loadNextPage() {
        
    }
}

// MARK: - CNavigationBarDelegate
extension BaseController: QHNavigationBarDelegate {
    func backAction() {
        back()
    }
}
