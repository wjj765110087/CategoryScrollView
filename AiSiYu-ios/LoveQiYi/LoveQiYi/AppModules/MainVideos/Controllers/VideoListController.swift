//
//  VideoListController.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/23.
//  Copyright © 2019年 bingdaohuoshan. All rights reserved.
//

import UIKit

class VideoListController: BaseViewController {
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
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
        collection.register(MainAdViewCell.classForCoder(), forCellWithReuseIdentifier: MainAdViewCell.cellId)
        collection.mj_header = refreshView
        collection.mj_footer = loadMoreView
        return collection
    }()
    
    var typeModel: MainTypeModel?
    var sort: String = HotListApi.kSort_new
    
    private var parmas: [String: Any]?
    
    private var dataSource: [VideoAdListModel] = [VideoAdListModel]()
    
    private let viewModel = MainViewModel()
    
    private var currentPage = 0
    
    var firstPageLoad: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        view.addSubview(self.collectionView)
        /// 这里不要问我，我也不知道为什么  底部 bottom: 要用 safeAreaTopHeight 才对
        collectionView.contentInset = UIEdgeInsets(top: safeAreaTopHeight, left: 0, bottom: safeAreaTopHeight + 44, right: 0)
        layoutCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 如果首页切换了  排序方式， 这里需要请求一次
        if let mainvc = getCurrentVC() {
            if  mainvc.searchView.sort != sort {
                firstPageLoad = false
            }
            sort = mainvc.searchView.sort
        }
        parmas = [HotListApi.kSort : sort, HotListApi.kType_id: typeModel?.id ?? 1]
        if !firstPageLoad {
            print("ChildOneVC --------viewWillAppear")
            loadData()
            firstPageLoad = true
        }
    }
    
    private func getCurrentVC() -> MainVedioViewController? {
        var next = view.superview
        while (next != nil) {
            let nextResponder = next?.next
            if (nextResponder is MainVedioViewController) {
                return nextResponder as? MainVedioViewController
            }
            next = next?.superview
        }
        return nil
    }
    
    private func loadData() {
        NicooErrorView.removeErrorMeesageFrom(view)
        loadVideoListDataCallBack()
        viewModel.loadVideoList(parmas)
    }
    
    override func loadFirstPage() {
        viewModel.loadVideoList(self.parmas)
    }
    
    override func loadNextPage() {
        viewModel.loadNextPage()
    }
    
    private func endRefreshing() {
        loadMoreView.endRefreshing()
        refreshView.endRefreshing()
    }
    
    private func loadVideoListDataCallBack() {
        viewModel.videoListSuccessHandler = { [weak self] (models, pageNumber) in
            guard  let strongSelf = self else { return }
            if let dataList = models.data {
                if pageNumber == 1 {
                    strongSelf.dataSource = dataList
                    if dataList.count == 0 {
                        //加载无数据占位
                        NicooErrorView.showErrorMessage(.noData, on: strongSelf.view, topMargin: safeAreaTopHeight + 44, clickHandler: nil)
                    }
                } else {
                    strongSelf.dataSource.append(contentsOf: dataList)
                }
                strongSelf.currentPage = pageNumber
                strongSelf.loadMoreView.isHidden = (dataList.count < HotListApi.kDefaultCount)
                strongSelf.collectionView.reloadData()
                strongSelf.endRefreshing()
               // XSProgressHUD.hide(for: strongSelf.view, animated: false)
            }
        }
        viewModel.videoListFailureHandler = { [weak self] (errorMsg) in
            guard  let strongSelf = self else { return }
            XSProgressHUD.hide(for: strongSelf.view, animated: false)
            if strongSelf.currentPage == 0 {
                NicooErrorView.showErrorMessage(.noNetwork, on: strongSelf.view , topMargin: safeAreaTopHeight + 44, clickHandler: {
                    strongSelf.loadData()
                })
            }
        }
    }
  
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension VideoListController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    /// itemSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = self.dataSource[indexPath.item]
        if model.type == VideoAdFlagType.video {
            return HotItemTwoCell.itemSize
        } else if model.type == VideoAdFlagType.ad {
            return MainAdViewCell.itemSize
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = self.dataSource[indexPath.item]
        if model.type == VideoAdFlagType.video {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotItemTwoCell.cellId, for: indexPath) as! HotItemTwoCell
            if let videoModel = model.video {
                cell.setModel(videoModel)
            }
            return cell
        } else if model.type == VideoAdFlagType.ad {
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainAdViewCell.cellId, for: indexPath) as! MainAdViewCell
            if let adMoodel = model.ad {
                cell.setModel(adMoodel)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let model = self.dataSource[indexPath.item]
        if model.type == VideoAdFlagType.video {
            if let videoModel = model.video {
                let videoDetail = VideoDetailViewController()
                videoDetail.model = videoModel
                getCurrentVC()?.navigationController?.pushViewController(videoDetail, animated: true)
            }
        } else if model.type == VideoAdFlagType.ad {
            if let adMoodel = model.ad {
                if let redirect_url = adMoodel.redirect_url {
                    let url = URL.init(string: redirect_url)
                    if let openUrl = url {
                        UIApplication.shared.openURL(openUrl)
                    }
                }
            }
        }
    }
    
}

// MARK: - Layout
extension VideoListController {
    
    func layoutCollectionView() {
        let topMargin = isIphoneX ? 41 : 36
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(topMargin)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(0)
        }
    }
}
