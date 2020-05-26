//
//  BuyVideosController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/11/20.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork
import MJRefresh

class BuyVideosController: UIViewController {

    static let videoItemWidth: CGFloat = (ConstValue.kScreenWdith - 34)/3
    static let videoItemHieght: CGFloat = videoItemWidth * 4/3
    static let videoItemSize: CGSize = CGSize(width: videoItemWidth, height: videoItemHieght)
    
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = videoItemSize
        layout.minimumLineSpacing = 2   // 垂直最小间距
        layout.minimumInteritemSpacing = 0 // 水平最小间距
        layout.sectionInset = UIEdgeInsets(top: 5, left: 15, bottom: 10, right:15)
        return layout
    }()
    lazy var collectionView: CustomcollectionView = {
        let collection = CustomcollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.clear
        collection.register(AcountVideoCell.classForCoder(), forCellWithReuseIdentifier: AcountVideoCell.cellId)
        collection.mj_footer = loadMoreView
        collection.mj_header = refreshView
        return collection
    }()
    lazy private var loadMoreView: MJRefreshAutoNormalFooter = {
        weak var weakSelf = self
        let loadmore = MJRefreshAutoNormalFooter(refreshingBlock: {
            weakSelf?.loadNextPage()
        })
        loadmore?.setTitle("", for: .idle)
        loadmore?.setTitle("已经到底了", for: .noMoreData)
        loadmore?.stateLabel.font = ConstValue.kRefreshLableFont
        return loadmore!
    }()
    
    lazy private var refreshView: MJRefreshGifHeader = {
        weak var weakSelf = self
        let mjRefreshHeader = MJRefreshGifHeader(refreshingBlock: {
            weakSelf?.isRefreshOperation = true
            weakSelf?.loadFirstPage()
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
    private lazy var videoApi: UserBuyVideoListApi =  {
        let api = UserBuyVideoListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    /// 用于解决滑动跟随问题
    var headerHeight: CGFloat = 345.0
    var lastContentOffset: CGFloat = 0
    var scrollDownToTopHandler:((_ canScroll: Bool)->Void)?
    
    var buyVideoTotalHandler:((_ total: Int)-> Void)?
    
    /// 选中index
    var selectIndex:Int = 0
    
    var cateModels = [VideoModel]()
    
    var isRefreshOperation = false
    
    /// 用户id
    var userId: Int?
    
    var isUserCenter: Bool = false
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(collectionView)
        layoutPageSubviews()
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        let bottomMarginUser: CGFloat = UIDevice.current.isiPhoneXSeriesDevices() ? 118 : 108
        collectionView.contentInset = UIEdgeInsets(top: UIDevice.current.isiPhoneXSeriesDevices() ? 28 : 12, left: 0, bottom: bottomMarginUser, right: 0)
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
}

// MARK: - Private - Funcs
private extension BuyVideosController {
    
    func loadData() {
        NicooErrorView.removeErrorMeesageFrom(view)
        if !isRefreshOperation {
            XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        } else {
            isRefreshOperation = false
        }
        let _ = videoApi.loadData()
    }
    func loadFirstPage() {
        _ = videoApi.loadData()
    }
    func loadNextPage() {
        let _ = videoApi.loadNextPage()
    }
    func endRefreshing() {
        collectionView.mj_footer.endRefreshing()
        collectionView.mj_header.endRefreshing()
    }
    
    func succeedRequest(_ model: VideoListModel) {
        if let models = model.data, let pageNum = model.current_page {
            if pageNum == 1 {
                cateModels = models
                if cateModels.count == 0 {
                    NicooErrorView.showErrorMessage(.noData, "你还没有购买的视频\n快去购买吧", on: view) {
                        self.loadData()
                    }
                }
                buyVideoTotalHandler?(model.total ?? 0)
            } else {
                cateModels.append(contentsOf: models)
            }
            loadMoreView.isHidden = models.count < UserBuyVideoListApi.kDefaultCount
        }
        endRefreshing()
        collectionView.reloadData()
    }
    
    func failedRequest(_ manager: NicooBaseAPIManager) {
        endRefreshing()
        NicooErrorView.showErrorMessage(.noNetwork, on: view, topMargin: 0, clickHandler: {
            self.loadData()
        })
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension BuyVideosController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cateModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cellForRow(with: indexPath)
        return cell
    }
    
    /// 配置cell
    func cellForRow(with indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AcountVideoCell.cellId, for: indexPath) as! AcountVideoCell
        let model = cateModels[indexPath.row]
        cell.collectionBtn.setTitle(" \(getStringWithNumber(model.recommend_count ?? 0))", for: .normal)
        cell.coverPath.kfSetVerticalImageWithUrl(model.cover_path)
        cell.showCoinTips(false)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let controller = AcountVideoPlayController()
        controller.videos = self.cateModels
        controller.currentIndex = indexPath.row
        controller.currentPlayIndex = indexPath.row
        self.selectIndex = indexPath.row
        controller.goVerbOrRefreshActionHandler = { [weak self] (isVerb) in
            if isVerb {
                let vipvc = InvestController()
                vipvc.currentIndex = 0
                self?.navigationController?.pushViewController(vipvc, animated: false)
            } else {
                self?.collectionView.mj_header.beginRefreshing()
            }
        }
        let nav = QHNavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        getAcountVC()?.present(nav, animated: false, completion: nil)
    }
    func getAcountVC() -> AcountNewController? {
        var next = view.superview
        while (next != nil) {
            let nextResponder = next?.next
            if (nextResponder is AcountNewController) {
                return nextResponder as? AcountNewController
            }
            next = next?.superview
        }
        return nil
    }
}

// MARK: - UIScrollViewDelegate
extension BuyVideosController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let height = scrollView.frame.size.height
        let distanceFormBottm = scrollView.contentSize.height - offsetY
        let offset = offsetY - lastContentOffset
        lastContentOffset = offsetY
        if offset > 0 && offsetY > -20 {
            //DLog("上拉行为 == \(offsetY) == \(height)")
            if offsetY > headerHeight {
                scrollDownToTopHandler?(false)
            }
        }
        if offset < 0 && distanceFormBottm > height {
            //DLog("下拉行为 == \(offsetY)")
            if offsetY <= headerHeight {
                scrollDownToTopHandler?(true)
            }
        }
    }
}

// MARK: - NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate
extension BuyVideosController: NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        return [UserBuyVideoListApi.kTarget_uid : userId ?? 0]
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if let videoList = manager.fetchJSONData(VideoReformer()) as? VideoListModel {
            if manager is UserBuyVideoListApi {
                succeedRequest(videoList)
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        failedRequest(manager)
    }
}


// MARK: - Layout
private extension BuyVideosController {
    
    func layoutPageSubviews() {
        layoutCollection()
    }
    
    func layoutCollection() {
        
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            if #available(iOS 11.0, *) {
                if isUserCenter {
                    make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                } else {
                    make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-44)
                }
            } else {
                if isUserCenter {
                    make.bottom.equalToSuperview()
                } else {
                    make.bottom.equalToSuperview().offset(-44)
                }
            }
        }
    }
    
    
}
