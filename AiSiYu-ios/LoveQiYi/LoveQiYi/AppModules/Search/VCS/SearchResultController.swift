//
//  SearchResultController.swift
//  DouCartoonDemo
//
//  Created by mac on 2019/6/6.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit
import NicooNetwork
import MJRefresh

class SearchResultController: UIViewController {
    
    private var searchView: SearchHeader = {
        guard let view = Bundle.main.loadNibNamed("SearchHeader", owner: nil, options: nil)?[0] as? SearchHeader else { return SearchHeader() }
        view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: statusBarHeight + 44)
        return view
    }()
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        layout.itemSize = VideoDoubleCollectionCell.itemSize
        layout.minimumLineSpacing = 10
        return layout
    }()
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.white
        collection.showsVerticalScrollIndicator = false
        collection.register(UINib.init(nibName: "VideoDoubleCollectionCell", bundle: Bundle.main), forCellWithReuseIdentifier: VideoDoubleCollectionCell.cellId)
        collection.register(SearchSecHeadView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchSecHeadView.identifier)
        collection.mj_header = refreshView
        collection.mj_footer = loadMoreView
        return collection
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
    private lazy var videolsApi: VideoListApi = {
        let api = VideoListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()

    var videoModels = [VideoModel]()
    var videoName: String?
    var currentPage = 0
    
    var nodataCallBack:(() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(searchView)
        view.addSubview(collectionView)
        layoutpageSubviews()
        searchView.searchTf.text = videoName
        searchView.searchTf.delegate = self
        searchView.cancleAction = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        loadData()
    }
    
    func loadData() {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: self.view, imageNames: nil, bgColor: UIColor.clear, animated: false)
        NicooErrorView.removeErrorMeesageFrom(view)
        let _ = videolsApi.loadData()
    }
    
    func loadNextPage() {
        let _ = videolsApi.loadNextPage()
    }
    
    private func showNodateVC() {
        let nodatavc = SearchNoViewController()
        nodatavc.comicName = videoName
        navigationController?.pushViewController(nodatavc, animated: false)
    }
    
    private func success(_ model: VideoListModel) {
        endRefreshing()
        if let list = model.data, let page = model.current_page {
            if page == 1 {
                videoModels = list
                if videoModels.count == 0 {
                    showNodateVC()
                    return
                }
            } else {
                videoModels.append(contentsOf: list)
            }
            collectionView.mj_footer.isHidden = list.count < VideoListApi.kDefaultCount
            currentPage = page
            collectionView.reloadData()
        }
    }
    
    func endRefreshing() {
        collectionView.mj_footer.endRefreshing()
        collectionView.mj_header.endRefreshing()
    }

}

extension SearchResultController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
         self.navigationController?.popViewController(animated: false)
    }
}

/// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SearchResultController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoDoubleCollectionCell.cellId, for: indexPath) as! VideoDoubleCollectionCell
        let model = videoModels[indexPath.item]
        cell.setModel(model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let model = videoModels[indexPath.item]
        let videoDetail = VideoDetailViewController()
        videoDetail.model = model
        navigationController?.pushViewController(videoDetail, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 45)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView:UICollectionReusableView?
        //是每组的头
        if kind == UICollectionView.elementKindSectionHeader {
            let searchReusable = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchSecHeadView.identifier, for: indexPath) as! SearchSecHeadView
            searchReusable.titleLable.text = "相关视频\(videoModels.count)条"
            reusableView = searchReusable
        }
        return reusableView!
    }
    
}

// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension SearchResultController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        var params = [String: Any]()
        params[VideoListApi.kTitle] = videoName
        return params
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is VideoListApi {
            if let videoLsModel = manager.fetchJSONData(HotReformer()) as? VideoListModel {
                success(videoLsModel)
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        endRefreshing()
        if manager is VideoListApi {
            if currentPage == 0 {
                NicooErrorView.showErrorMessage(.noNetwork, on: view, topMargin: statusBarHeight + 44) {
                    self.loadData()
                }
            }
        }
    }
}


// MARK: - Layout
private extension SearchResultController {
    
    func layoutpageSubviews() {
        layouSearchView()
        layoutTableView()
    }
    func layouSearchView() {
        searchView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(statusBarHeight + 44)
        }
    }
    func layoutTableView() {
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
}
