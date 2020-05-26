//
//  SeriesKeyMainController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/10.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class SeriesKeyMainController: QHBaseViewController {

    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = keyMode.title 
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = ConstValue.kViewLightColor
        bar.backButton.isHidden = false
        bar.titleLabel.isHidden = false
        bar.lineView.isHidden = true
        bar.delegate = self
        return bar
    }()
    private lazy var controllers: [UIViewController] = {
        let oneVc = SeriesVideosController()
        oneVc.keyId = keyMode.key_id ?? 0
        oneVc.isHot = false
        let twoVc = SeriesVideosController()
        twoVc.keyId = keyMode.key_id ?? 0
        twoVc.isHot = true
        return [oneVc, twoVc]
    }()
    private lazy var pageView: PageItemView = {
        let view = PageItemView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 40),config: config)
        view.backgroundColor = ConstValue.kViewLightColor
        view.titles = ["最新","最热"]
        return view
    }()
    /// 自定义pageView 设置   /*  --- 更多配置 请查看 PageItemConfig 属性 ---- */
    private lazy var config: PageItemConfig = {
        let pageConfig = PageItemConfig()
        pageConfig.titleColorNormal = UIColor.darkGray
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
    private lazy var pageContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    var keyMode = VideoKey()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        setupUI()
        layoutPageViews()
        pageVc.scrollToIndex = { [weak self] (index) in
            guard let strongSelf = self else { return }
            strongSelf.pageView.scrollTopIndex(index)
        }
        pageView.itemClickHandler = { [weak self] (index) in
            guard let strongSelf = self else { return }
            strongSelf.pageVc.clickItemToScroll(index)
        }
    }
}

//MARK: -设置UI && Layout
extension SeriesKeyMainController {
    
    private func setupUI() {
        view.addSubview(navBar)
        view.addSubview(pageContentView)
        pageContentView.addSubview(pageView)
        addChild(pageVc)
        view.addSubview(pageVc.view)
    }
    
    private func layoutPageViews() {
        layoutNavBar()
        layoutPageContentView()
        layoutPageV()
        layoutPageVCView()
    }
    
    private func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(safeAreaTopHeight)
        }
    }
    
    private func layoutPageContentView() {
        pageContentView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
            make.height.equalTo(40)
        }
    }
    
    private func layoutPageV() {
        pageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func layoutPageVCView() {
        pageVc.view.snp.makeConstraints { (make) in
            make.top.equalTo(pageContentView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - QHNavigationBarDelegate
extension SeriesKeyMainController: QHNavigationBarDelegate  {
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

