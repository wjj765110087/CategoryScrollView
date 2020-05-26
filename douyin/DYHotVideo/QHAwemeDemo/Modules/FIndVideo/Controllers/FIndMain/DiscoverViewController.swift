//
//  DiscoverViewController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/5.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//  发现控制器主页面

import UIKit

class DiscoverViewController: QHBaseViewController {

    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.isHidden = true
        bar.backgroundColor = ConstValue.kViewLightColor
        bar.backButton.isHidden = true
        bar.lineView.isHidden = true
        bar.delegate = self
        return bar
    }()
    private lazy var discoverSearchView: DiscoverSearchView = {
       let view = DiscoverSearchView(frame: .zero)
       view.backgroundColor = ConstValue.kViewLightColor
        
       return view
    }()
    private lazy var pageView: PageItemView = {
        let view = PageItemView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 40),config: config)
        view.backgroundColor = ConstValue.kViewLightColor
        view.titles = [""]
        return view
    }()
    
    /// 自定义pageView 设置   /*  --- 更多配置 请查看 PageItemConfig 属性 ---- */
    private lazy var config: PageItemConfig = {
        let pageConfig = PageItemConfig()
        pageConfig.leftRightMargin = 0
        pageConfig.titleColorNormal = UIColor(r: 153, g: 153, b: 153)
        pageConfig.titleColorSelected = UIColor.white
        pageConfig.titleFontNormal = UIFont.systemFont(ofSize: 15)
        pageConfig.titleFontSelected = UIFont.boldSystemFont(ofSize: 16)
        pageConfig.lineColor = UIColor.clear
        pageConfig.lineImage = UIImage(named: "pageLineBg")
        pageConfig.lineSize = CGSize(width: 33, height: 6)
        pageConfig.lineViewLocation = .center
        return pageConfig
    }()
    
    var pageVc: VCPageController = VCPageController()
    
    var viewModel: DiscoverViewModel = DiscoverViewModel()
    var titleList: [FindVideoTitleModel] = [FindVideoTitleModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLoadTitleListCallBack()
        loadTitleData()
    }
    
    private func setUpUIWithDatas(titleListArr: [FindVideoTitleModel]) {
        var titles = [String]()
        var controllers = [UIViewController]()
        for titleModel in titleList {
            if let title  = titleModel.keys_title {
                titles.append(title)
            }
            if titleModel.key_id == -1 { ///是推荐
                let recommendVC = DiscoverRecommendController()
                controllers.append(recommendVC)
            } else if titleModel.key_id == -2 {
                let diyVC = DiscoverDIYController()
                controllers.append(diyVC)
            } else {
                let categoryVC = DiscoverCategoryController()
                categoryVC.key_id = titleModel.key_id ?? 0
                controllers.append(categoryVC)
            }
        }
    
        pageView.titles = titles
        pageVc.controllers = controllers
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(navBar)
        navBar.navBarView.addSubview(discoverSearchView)
        view.addSubview(pageView)
        addChild(pageVc)
        view.addSubview(pageVc.view)
        layoutPageSubViews()
        
        discoverSearchView.didClickSearchHandler = { [weak self] in
            guard let strongSelf = self else {return}
            let searchVC = SearchMainController()
            let nav = QHNavigationController(rootViewController: searchVC)
            nav.modalPresentationStyle = .fullScreen
            strongSelf.present(nav, animated: true, completion: nil)
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
    
    private func addLoadTitleListCallBack() {
        viewModel.requestTitleListSuccessHandler = { [weak self] (titleList, pageNum) in
            guard let strongSelf = self else {return}
            if let data = titleList.data, data.count > 0 {
                
                var DIYModel = FindVideoTitleModel()
                DIYModel.key_id = -2
                DIYModel.keys_title = "原创"
                DIYModel.id = 0
                DIYModel.keys_cover = ""
                DIYModel.updated_at = ""
                strongSelf.titleList.insert(DIYModel, at: 0)
                
                var recommendModel = FindVideoTitleModel()
                recommendModel.key_id = -1
                recommendModel.keys_title = "推荐"
                recommendModel.id = 0
                recommendModel.keys_cover = ""
                recommendModel.updated_at = ""
                strongSelf.titleList.insert(recommendModel, at: 0)
                
                strongSelf.titleList.append(contentsOf: data)
            
                strongSelf.setUpUIWithDatas(titleListArr: strongSelf.titleList)
            }
        }
        
        viewModel.requestTitleListFailureHandler = { [weak self] msg in
            guard let strongSelf = self else {return}
           
        }
    }
}

//MARK: -网络请求
extension DiscoverViewController {
    
    private func loadTitleData() {
        let param = [String : Any]()
        viewModel.loadTitleListData(param)
    }
    
}

//MARK: -Event
extension DiscoverViewController {
    
    @objc func searchBtnClick() {
        
    }
}

// MARK: - Layout
extension DiscoverViewController {
    
    private func layoutPageSubViews() {
        layoutNavBar()
        layoutPageItemView()
        layoutDiscoverSearchView()
        layoutPageVCView()
    }
    
    private func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(safeAreaTopHeight)
        }
    }
    
    private func layoutPageItemView() {
        pageView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
            make.height.equalTo(40)
        }
    }
    
    private func layoutDiscoverSearchView() {
        discoverSearchView.snp.makeConstraints { (make) in
            make.leading.trailing.centerY.equalToSuperview()
            make.height.equalTo(36)
        }
    }
    
    private func layoutPageVCView() {
        let bottomHeight: CGFloat = UIDevice.current.isXSeriesDevices() ? 83 : 49
        let height: CGFloat = screenHeight - 40 - safeAreaTopHeight - bottomHeight
        pageVc.view.snp.makeConstraints { (make) in
            make.top.equalTo(pageView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(height)
        }
    }
    
}

// MARK: - QHNavigationBarDelegate
extension DiscoverViewController:  QHNavigationBarDelegate  {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

