//
//  DiscoverCategoryController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/7.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//  发现其他类别的控制器

import UIKit
import MJRefresh
import NicooNetwork

class DiscoverCategoryController: QHBaseViewController {
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(DiscoverSearchVideoCell.classForCoder(), forCellWithReuseIdentifier: DiscoverSearchVideoCell.cellId)
        collectionView.mj_header = refreshView
        collectionView.mj_footer = loadMoreView
        return collectionView
    }()
    
    lazy private var loadMoreView: MJRefreshAutoNormalFooter = {
        weak var weakSelf = self
        let loadmore =  MJRefreshAutoNormalFooter(refreshingBlock: {
            weakSelf?.loadNextPage()
        })
        loadmore?.isHidden = true
        loadmore?.stateLabel.font = ConstValue.kRefreshLableFont
        return loadmore!
    }()
    lazy private var refreshView: MJRefreshGifHeader = {
        weak var weakSelf = self
        let mjRefreshHeader = MJRefreshGifHeader(refreshingBlock: {
            weakSelf?.loadFristPageData()
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
    
    private lazy var videoApi: VideoListApi =  {
        let api = VideoListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    var key_id: Int = 0
    
    var videoList: VideoListModel = VideoListModel()
    var videos = [VideoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.contentInset = UIEdgeInsets(top: UIDevice.current.isiPhoneXSeriesDevices() ? 110 : (74 + 8), left: 0, bottom: UIDevice.current.isiPhoneXSeriesDevices() ? 128 : 88, right: 0)
        layoutPageSubViews()
        loadData()
    }
    
    func loadData() {
        NicooErrorView.removeErrorMeesageFrom(self.view)
        let _ = videoApi.loadData()
    }
    
    func endRefreshing() {
        collectionView.mj_header.endRefreshing()
        collectionView.mj_footer.endRefreshing()
    }
    
    func loadFristPageData() {
        let _ = videoApi.loadData()
    }
    
    func loadNextPage() {
        let _ = videoApi.loadNextPage()
    }
    
   override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        DLog("videoModel-\(videos)")
//        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource && UICollectionViewDelegate
extension DiscoverCategoryController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverSearchVideoCell.cellId, for: indexPath) as! DiscoverSearchVideoCell
        let model = videos[indexPath.row]
        cell.setModel(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playVideoVC = SeriesPlayController()
        playVideoVC.videos = videos
        playVideoVC.currentIndex = indexPath.row
        playVideoVC.currentPlayIndex = indexPath.row
        playVideoVC.goVerbOrRefreshActionHandler = { [weak self] (isVerb) in
            if isVerb {
                let vipvc = InvestController()
                vipvc.currentIndex = 0
                self?.getCurrentVC()?.navigationController?.pushViewController(vipvc, animated: false)
            } else {
                self?.collectionView.mj_header.beginRefreshing()
            }
        }
        let nav = UINavigationController(rootViewController: playVideoVC)
        nav.modalPresentationStyle = .fullScreen
        self.getCurrentVC()?.present(nav, animated: true, completion: nil)
    }
    
    private func getCurrentVC() -> DiscoverViewController? {
        var next = view.superview
        while (next != nil) {
            let nextResponder = next?.next
            if (nextResponder is DiscoverViewController) {
                return nextResponder as? DiscoverViewController
            }
            next = next?.superview
        }
        return nil
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DiscoverCategoryController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return PlayCategoryCell.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
}

// MARK: - NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate
extension DiscoverCategoryController: NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        var params = [String: Any]()
        params[VideoListApi.key_id] = key_id
        return params
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        if manager is VideoListApi   {
            if let videoListModel = manager.fetchJSONData(VideoReformer()) as? VideoListModel {
                self.videoList = videoListModel
                if let data = videoListModel.data, let currentPage = videoListModel.current_page {
                    if currentPage == 1 {
                        videos = data
                        if data.count == 0 {
                            NicooErrorView.showErrorMessage(.noData, on: view, topMargin: safeAreaTopHeight) {
                                self.loadData()
                            }
                        }
                    } else {
                        videos.append(contentsOf: data)
                    }
                     self.loadMoreView.isHidden = data.count < VideoListApi.kDefaultCount
                }
            }
            endRefreshing()
            collectionView.reloadData()
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        endRefreshing()
        if manager is VideoListApi  {
            NicooErrorView.showErrorMessage(.noNetwork, on: view, topMargin: safeAreaTopHeight) {
                 self.loadData()
            }
        }
    }
}

// MARK: - Layout
extension DiscoverCategoryController {
    private func layoutPageSubViews() {
        layoutCollectionView()
    }
    
    private func layoutCollectionView() {
        collectionView.snp.makeConstraints { (make) in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
}
