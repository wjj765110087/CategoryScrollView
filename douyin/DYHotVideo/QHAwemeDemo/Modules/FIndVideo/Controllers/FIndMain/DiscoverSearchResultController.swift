//
//  DiscoverSearchResultController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/8.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//  发现搜索结果页

import UIKit

class DiscoverSearchResultController: QHBaseViewController {
    private var searchView: SearchHeader = {
        guard let view = Bundle.main.loadNibNamed("SearchHeader", owner: nil, options: nil)?[0] as? SearchHeader else { return SearchHeader() }
        view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: statusBarHeight + 44)
        return view
    }()
    private lazy var controllers: [UIViewController] = {
        let oneVc = DiscoverTrendsController()
        oneVc.searchKey = searchkey
        let twoVc = DiscoverVideoController()
        twoVc.searchKey = searchkey
        let threeVc = DiscoverUserController()
        threeVc.searchKey = searchkey
        let fourVc = DiscoverTopicController()
        fourVc.searchKey = searchkey
        return [oneVc, twoVc, threeVc, fourVc]
    }()
    
    private lazy var pageView: PageItemView = {
        let view = PageItemView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 40),config: config)
        view.backgroundColor = UIColor.clear
        view.titles = ["动态","视频","用户","话题"]
        return view
    }()
    
    /// 自定义pageView 设置   /*  --- 更多配置 请查看 PageItemConfig 属性 ---- */
    private lazy var config: PageItemConfig = {
        let pageConfig = PageItemConfig()
        pageConfig.titleColorNormal = UIColor(r: 153, g: 153, b: 153)
        pageConfig.titleColorSelected = UIColor.white
        pageConfig.titleFontNormal = UIFont.systemFont(ofSize: 15)
        pageConfig.titleFontSelected = UIFont.boldSystemFont(ofSize: 16)
        pageConfig.lineColor = UIColor.clear
        pageConfig.lineImage = UIImage(named: "pageLineBg")
        pageConfig.lineSize = CGSize(width: 33, height: 6)
        pageConfig.lineViewLocation = .center
        pageConfig.isAverageWith = true
        return pageConfig
    }()
    
    private lazy var pageVc: VCPageController = {
        let pageVC = VCPageController()
        pageVC.controllers = controllers
        return pageVC
    }()
    
    var searchkey: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchView)
        view.addSubview(pageView)
        addChild(pageVc)
        view.addSubview(pageVc.view)
        layoutPageSubViews()
        searchView.searchTf.text = searchkey
        searchView.searchTf.delegate = self
        searchView.cancleAction = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        pageVc.scrollToIndex = { [weak self] index in
            guard let strongSelf = self else {return}
            strongSelf.pageView.scrollTopIndex(index)
        }
        pageView.itemClickHandler = { [weak self] index in
            guard let strongSelf = self else {return}
            strongSelf.pageVc.clickItemToScroll(index)
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension DiscoverSearchResultController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.navigationController?.popViewController(animated: false)
    }
}

// MARK: - Layout
extension DiscoverSearchResultController {
    
    private func layoutPageSubViews() {
        layoutDiscoverSearchView()
        layoutPageItemView()
        layoutPageVCView()
    }
    private func layoutPageItemView() {
        pageView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom)
            make.height.equalTo(40)
        }
    }
    
    private func layoutDiscoverSearchView() {
        searchView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(statusBarHeight + 44)
        }
    }
    private func layoutPageVCView() {
        pageVc.view.snp.makeConstraints { (make) in
            make.top.equalTo(pageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}


