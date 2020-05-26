//
//  SeriesVerbViewController.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/19.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit
import NicooNetwork
import MJRefresh

///首页更多
class VerbMoreViewController: BaseViewController {

    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: screenWidth, height: 187.0)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.white
        collection.allowsSelection = true
        collection.showsVerticalScrollIndicator = false
        collection.register(HotItemTwoCell.classForCoder(), forCellWithReuseIdentifier: HotItemTwoCell.cellId)
        
        collection.mj_header = refreshView
        collection.mj_footer = loadMoreView
        
        return collection
    }()
    
    ///更多的API
    private lazy var moudlesMoreApi: ModulesMoreApi = {
        let api = ModulesMoreApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    
    ///接收从模块控制器中获取的model
    var moduleModel: ModuleModel = ModuleModel()
    
    ///接收从模块控制器中获取的参数
    var requestParams: [String: Any]?
    
    var dataSource: [VideoModel] = [VideoModel]()
    
    var currentPage: Int = 0
    
    var model: VideoListModel = VideoListModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.addSubview(collectionView)
        layoutPageSubViews()
        configNavBar()
        loadData()
    }
    
    private func configNavBar() {
        navBar.isHidden = false
        navBar.backButton.isHidden = false
        navBar.titleLabel.text = self.moduleModel.title ?? ""
    }
    
    func loadData() {
        requestParams = [ModulesMoreApi.kModule_id: moduleModel.id ?? 0]
        NicooErrorView.removeErrorMeesageFrom(self.view)
        XSProgressHUD.showCustomAnimation(msg: nil, onView: self.view, imageNames: nil, bgColor: UIColor.clear, animated: false)
        let _ =  moudlesMoreApi.loadData()
    }
    
    override func loadFirstPage() {
        let _ = moudlesMoreApi.loadData()
    }
    
    override func loadNextPage() {
        let _ = moudlesMoreApi.loadNextPage()
    }
    
    func endRefreshing() {
        refreshView.endRefreshing()
        loadMoreView.endRefreshing()
    }

    func returnSuccessData(model: VideoListModel, pageNumber:Int) {
        self.model = model
        if let moreList = model.data {
            if pageNumber == 1 {
                if moreList.count == 0 {
                    ///显示没有数据的占位图
                    NicooErrorView.showErrorMessage(.noData, on: self.view, topMargin: safeAreaTopHeight + 30, clickHandler: nil)
                }
                self.dataSource = moreList
            } else {
                self.dataSource.append(contentsOf: moreList)
            }
            self.currentPage = pageNumber
            self.loadMoreView.isHidden = moreList.count < ModulesMoreApi.kDefaultCount
            self.collectionView.reloadData()
            self.endRefreshing()
            XSProgressHUD.hide(for: self.view, animated: true)
        }
    }
}

extension VerbMoreViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotItemTwoCell.cellId, for: indexPath) as! HotItemTwoCell
        cell.setModel(self.dataSource[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let videoDetailVC = VideoDetailViewController()
        let model = self.dataSource[indexPath.item]
        videoDetailVC.model = model
        self.navigationController?.pushViewController(videoDetailVC, animated: true)
    }
}

extension VerbMoreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return HotItemTwoCell.itemSize
    }
    
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 10, bottom: 10, right: 10)
    }
}

///网络请求的回调
extension VerbMoreViewController: NicooAPIManagerCallbackDelegate,NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        if manager is ModulesMoreApi {
            return requestParams
        }
        return nil
    }
 
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: self.view, animated: true)
        NicooErrorView.showErrorMessage(.noNetwork, on: self.view, topMargin: safeAreaTopHeight + 30, clickHandler: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loadData()
        })
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        if manager is ModulesMoreApi {
            if let model = manager.fetchJSONData(MainReformer()) as? VideoListModel {
                returnSuccessData(model: model, pageNumber: moudlesMoreApi.pageNumber)
            }
        }
    }
}

extension VerbMoreViewController {
    
    private func layoutPageSubViews() {
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(navBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
