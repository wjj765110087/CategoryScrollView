//
//  HotViewController.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/18.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit

class HotViewController: BaseViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private let flowLayout: UICollectionViewFlowLayout = {
       let layout = UICollectionViewFlowLayout()
       layout.itemSize = CGSize(width: screenWidth, height: 187.0)
       layout.minimumLineSpacing = 10
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
        collection.register(HotAdCell.classForCoder(), forCellWithReuseIdentifier: HotAdCell.cellId)
        collection.mj_header = refreshView
        collection.mj_footer = loadMoreView
        
        return collection
        
    }()
    
    private var viewModel: HotVideoViewModel = HotVideoViewModel()
    
    private var dataSource: [VideoAdListModel] = [VideoAdListModel]()
    
    private var currentPage: Int = 0
    
    var sort: String = VideoListApi.kSort_new
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        view.addSubview(collectionView)
       /// 这里不要问我，我也不知道为什么  底部 bottom: 要用 safeAreaTopHeight 才对
        collectionView.contentInset = UIEdgeInsets(top: safeAreaTopHeight, left: 0, bottom: safeAreaTopHeight + 30, right: 0)
        layoutAllViews()
        refreshHotData(sort)
        navConfig()
    }
    
    func navConfig() {
        navBar.isHidden = true
    }

    private func refreshHotData(_ sort: String) {
        NicooErrorView.removeErrorMeesageFrom(view)
        XSProgressHUD.showCustomAnimation(msg: "获取中...", onView: view, imageNames: nil, bgColor: nil, animated: false)
        loadVideoListData()
        viewModel.loadVideoList(sort)
    }
    
    override func loadFirstPage() {
        viewModel.loadVideoList(viewModel.sortParams)
    }
    
    override func loadNextPage() {
        viewModel.loadNextPage()
    }
    
    private func endRefreshing() {
        loadMoreView.endRefreshing()
        refreshView.endRefreshing()
    }
    
    private func loadVideoListData() {
        viewModel.videoListSuccessHandler = { [weak self] (models, pageNumber) in
            guard  let strongSelf = self else { return }
            if let dataList = models.data, dataList.count != 0 {
                if pageNumber == 1 {
                  strongSelf.dataSource = dataList
                    if dataList.count == 0 {
                        //加载无数据占位
                        NicooErrorView.showErrorMessage(.noData, on: strongSelf.view, topMargin: safeAreaTopHeight, clickHandler: nil)
                    }
                } else {
                    strongSelf.dataSource.append(contentsOf: dataList)
                }
                strongSelf.currentPage = pageNumber
                strongSelf.loadMoreView.isHidden = (dataList.count < VideoListApi.kDefaultCount)
                strongSelf.collectionView.reloadData()
                strongSelf.endRefreshing()
                XSProgressHUD.hide(for: strongSelf.view, animated: false)
            }
        }
        viewModel.videoListFailureHandler = { [weak self] (errorMsg) in
            guard  let strongSelf = self else { return }
            XSProgressHUD.hide(for: strongSelf.view, animated: false)
            if strongSelf.currentPage == 0 {
                NicooErrorView.showErrorMessage(.noNetwork, on: strongSelf.view , topMargin: safeAreaTopHeight, clickHandler: {
                    strongSelf.refreshHotData(strongSelf.viewModel.sortParams)
                })
            }
        }
    }
    
    private func getCurrentVC() -> HotMainController? {
        var next = view.superview
        while (next != nil) {
            let nextResponder = next?.next
            if (nextResponder is HotMainController) {
                return nextResponder as? HotMainController
            }
            next = next?.superview
        }
        return nil
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension HotViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
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
            let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotAdCell.cellId, for: indexPath) as! HotAdCell
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
               let hotVideoDetailVC = VideoDetailViewController()
               hotVideoDetailVC.model = videoModel
               getCurrentVC()?.navigationController?.pushViewController(hotVideoDetailVC, animated: true)
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

extension HotViewController: UICollectionViewDelegateFlowLayout {
    /// itemSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          let model = self.dataSource[indexPath.item]
        if model.type == VideoAdFlagType.video {
           return HotItemTwoCell.itemSize
        } else if model.type == VideoAdFlagType.ad {
           return HotAdCell.itemSize
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10)
    }
}

extension HotViewController {
    
    private func layoutAllViews() {
        layoutCollectionView()
    }

    private func layoutCollectionView() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
