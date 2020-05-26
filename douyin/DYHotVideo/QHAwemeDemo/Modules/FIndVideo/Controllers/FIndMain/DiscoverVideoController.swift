//
//  DiscoverVideoController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/7.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
// 搜索视频

import UIKit
import MJRefresh
import NicooNetwork

class DiscoverVideoController: QHBaseViewController {

    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DiscoverSearchVideoCell.classForCoder(), forCellWithReuseIdentifier: DiscoverSearchVideoCell.cellId)
        collectionView.register(SearchVideoNoDataHeader.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchVideoNoDataHeader.reuseId)
        collectionView.mj_header = refreshView
        collectionView.mj_footer = loadMoreView
        return collectionView
    }()
    
    private lazy var loadMoreView: MJRefreshAutoNormalFooter = {
         weak var weakSelf = self
        let loadMore = MJRefreshAutoNormalFooter.init(refreshingBlock: {
            weakSelf?.loaaNextPage()
        })
        loadMore?.setTitle("", for: .idle)
        loadMore?.setTitle("已经到底了", for: .noMoreData)
        loadMore?.isHidden = true
        return loadMore!
    }()
    
    private lazy var refreshView: MJRefreshGifHeader = {
       weak var weakSelf = self
        let refreshView = MJRefreshGifHeader.init(refreshingBlock: {
            weakSelf?.fristRefresh()
        })
        var gifImages = [UIImage]()
        for string in ConstValue.refreshImageNames {
            gifImages.append(UIImage(named: string)!)
        }
        refreshView?.setImages(gifImages, for: .refreshing)
        refreshView?.setImages(gifImages, for: .idle)
        refreshView?.stateLabel.font = ConstValue.kRefreshLableFont
        refreshView?.lastUpdatedTimeLabel.font = ConstValue.kRefreshLableFont
        return refreshView!
    }()
    
    private lazy var searchVideoApi: SearchVideoApi = {
       let api = SearchVideoApi()
       api.paramSource = self
       api.delegate = self
       return api
    }()
    
    private lazy var videoListApi: VideoListApi = {
       let api = VideoListApi()
       api.paramSource = self
       api.delegate = self
       return api
    }()
    
    var searchKey: String?
    
    var models: [VideoModel] = [VideoModel]()
    
    var isRecommend: Bool = false
    
    var viewModel: VideoViewModel = VideoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.contentInset = UIEdgeInsets(top: UIDevice.current.isXSeriesDevices() ? 80 : 44 , left: 0, bottom:UIDevice.current.isXSeriesDevices() ? 83 : 49, right: 0)
        layoutPageSubViews()
        loadData()
    }
    
    func loadData() {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        NicooErrorView.removeErrorMeesageFrom(view)
        let _ = searchVideoApi.loadData()
    }
    
    func fristRefresh() {
        let _ = searchVideoApi.loadData()
    }
    
    func loaaNextPage() {
        let _ = searchVideoApi.loadNextPage()
    }
    
    func endRefreshing() {
        collectionView.mj_header.endRefreshing()
        collectionView.mj_footer.endRefreshing()
        XSProgressHUD.hide(for: view, animated: true)
    }
    
    func loadReCommentVideoData() {
        isRecommend = true
        let _ =  videoListApi.loadData()
    }
}

// MARK: - UICollectionViewDataSource && UICollectionViewDelegate
extension DiscoverVideoController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverSearchVideoCell.cellId, for: indexPath) as! DiscoverSearchVideoCell
        cell.setModel(model: models[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchVideoNoDataHeader.reuseId, for: indexPath) as! SearchVideoNoDataHeader
        header.label.text = "未搜索到任何相关内容"
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playVideoVC = SeriesPlayController()
        playVideoVC.videos = models
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
        let nav = QHNavigationController(rootViewController: playVideoVC)
        nav.modalPresentationStyle = .fullScreen
        self.getCurrentVC()?.present(nav, animated: true, completion: nil)
    }

    private func getCurrentVC() -> DiscoverSearchResultController? {
        var next = view.superview
        while (next != nil) {
            let nextResponder = next?.next
            if (nextResponder is DiscoverSearchResultController) {
                return nextResponder as? DiscoverSearchResultController
            }
            next = next?.superview
        }
        return nil
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DiscoverVideoController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return PlayCategoryCell.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if isRecommend {
            return SearchVideoNoDataHeader.headerSize
        }
        return CGSize.zero
    }
}

// MARK: - NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate
extension DiscoverVideoController: NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate {
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, animated: true)
        var params: [String : Any] = [String : Any]()
        if manager is SearchVideoApi {
            params =  [SearchVideoApi.kKeywords : searchKey as Any]
        }
        
        if manager is VideoListApi {
            params = [VideoListApi.kPlay_count: VideoListApi.kDefaultPlay_count, VideoListApi.kUpdateded_at: VideoListApi.kDefaultCreat_at]
        }

        return params
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: true)
        if manager is SearchVideoApi {
            if let model = manager.fetchJSONData(SearchReformer()) as? VideoListModel {
                if let data = model.data, let currentPage = model.current_page {
                    if currentPage == 1 {
                        models = data
                        if data.count == 0 {
                            loadReCommentVideoData()
                        }
                    } else {
                        models.append(contentsOf: data)
                    }
                    loadMoreView.isHidden = data.count < SearchVideoApi.kDefaultCount
                }
                endRefreshing()
                collectionView.reloadData()
            }
        }
        
        if manager is VideoListApi {
            if let model = manager.fetchJSONData(VideoReformer()) as? VideoListModel {
                if let data = model.data, let currentPage = model.current_page {
                    if currentPage == 1 {
                        models = data
                    } else {
                        models.append(contentsOf: data)
                    }
                    loadMoreView.isHidden = data.count < SearchVideoApi.kDefaultCount
                }
                endRefreshing()
                collectionView.reloadData()
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: true)
        if manager is SearchVideoApi {
            
        }
        
        if manager is VideoListApi {

        }
    }
}

// MARK: - Layout
extension DiscoverVideoController {
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
