//
//  TalksVideoController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/11.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import MJRefresh
import NicooNetwork

class TalksVideoController: QHBaseViewController {

    static let videoItemWidth: CGFloat = (ConstValue.kScreenWdith - 6)/3
    static let videoItemHieght: CGFloat = videoItemWidth * 4/3
    static let videoItemSize: CGSize = CGSize(width: videoItemWidth, height: videoItemHieght)
    
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = videoItemSize
        layout.minimumLineSpacing = 2   // 垂直最小间距
        layout.minimumInteritemSpacing = 0 // 水平最小间距
        layout.sectionInset = UIEdgeInsets(top: 5, left: 1, bottom: 10, right:1)
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
    /// 用于解决滑动跟随问题
    var lastContentOffset: CGFloat = 0
    var headerHeight: CGFloat = 200.0
    var scrollDownToTopHandler:((_ canScroll: Bool)->Void)?
  
    var topicId: Int = 0
    
    /// 排序，默认最新
    var descOrder: String = UserTopicListApi.kCreated_at
    
    private var dataSource = [TopicModel]()
    private var pageNumber: Int = 0
    
    private let viewModel = CommunityViewModel()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(collectionView)
        layoutPageSubviews()
        collectionView.contentInset = UIEdgeInsets(top: UIDevice.current.isiPhoneXSeriesDevices() ? 52 : 44, left: 0, bottom: UIDevice.current.isiPhoneXSeriesDevices() ? 90 : 74, right: 0)
        addViewModelCallBack()
        loadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func loadData() {
        NicooErrorView.removeErrorMeesageFrom(view)
        NicooErrorView.removeErrorMeesageFrom(self.view)
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        let params: [String: Any] = [UserTopicListApi.kTopic_id: topicId, UserTopicListApi.kOrder: descOrder, UserTopicListApi.kIs_recommend: 0, UserTopicListApi.kIs_attention: 0, UserTopicListApi.kType: 1, UserTopicListApi.kUserId: -1]
        viewModel.loadUserTopicList(params)
    }
    
}

// MARK: - Private - Funcs
private extension TalksVideoController {
    
    
    func loadFirstPage() {
        let params: [String: Any] = [UserTopicListApi.kTopic_id: topicId, UserTopicListApi.kOrder: descOrder, UserTopicListApi.kIs_recommend: 0, UserTopicListApi.kIs_attention: 0, UserTopicListApi.kType: 1,UserTopicListApi.kUserId: -1]
        viewModel.loadUserTopicList(params)
    }
    func loadNextPage() {
        let params: [String: Any] = [UserTopicListApi.kTopic_id: topicId, UserTopicListApi.kOrder: descOrder, UserTopicListApi.kIs_recommend: 0, UserTopicListApi.kIs_attention: 0, UserTopicListApi.kType: 1,UserTopicListApi.kUserId: -1]
        viewModel.loadUserTopicListNextPage(params)
    }
    func endRefreshing() {
        collectionView.mj_footer.endRefreshing()
        collectionView.mj_header.endRefreshing()
    }
    
    func addViewModelCallBack() {
        viewModel.topicListApiSuccess = { [weak self] (topiclist, pageNumber, _) in
            guard let strongSelf = self else { return }
            XSProgressHUD.hide(for:strongSelf.view, animated: false)
            strongSelf.pageNumber = pageNumber
            strongSelf.loadListSuccess(topiclist)
        }
        viewModel.topicListApiApiFail = { [weak self] in
            guard let strongSelf = self else { return }
            XSProgressHUD.hide(for:strongSelf.view, animated: false)
            strongSelf.endRefreshing()
            if strongSelf.pageNumber == 0 {
                NicooErrorView.showErrorMessage(.noNetwork, on: strongSelf.view, topMargin: 0, clickHandler: {
                    strongSelf.loadData()
                })
            }
        }
    }
       
    func loadListSuccess(_ listModels: [TopicModel]?) {
        endRefreshing()
        if let dataList = listModels {
            if pageNumber == 1 {
                dataSource = dataList
                if dataList.count == 0 {
                    //加载无数据占位
                    NicooErrorView.showErrorMessage(.noData
                    , "暂无话题视频\n快去参与话题吧", on: view, topMargin: 0) {
                        self.loadData()
                    }
                }
            } else {
                dataSource.append(contentsOf: dataList)
            }
            loadMoreView.isHidden = (dataList.count < TalksListApi.kDefaultCount)
            collectionView.reloadData()
        }
    }
    func getCurrentVC() -> TalksMainController? {
        var next = view.superview
        while (next != nil) {
            let nextResponder = next?.next
            if (nextResponder is TalksMainController) {
                return nextResponder as? TalksMainController
            }
            next = next?.superview
        }
        return nil
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension TalksVideoController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cellForRow(with: indexPath)
        return cell
    }
    
    /// 配置cell
    func cellForRow(with indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AcountVideoCell.cellId, for: indexPath) as! AcountVideoCell
        let model = dataSource[indexPath.row]
        if let videos = model.video, videos.count > 0 {
            cell.collectionBtn.setTitle(" \(getStringWithNumber(videos[0].recommend_count ?? 0))", for: .normal)
            cell.coverPath.kfSetVerticalImageWithUrl(videos[0].cover_path)
            cell.showCoinTips(videos[0].is_coins == 1)
            if let coins = videos[0].coins, coins > 0 {
                cell.coinLable.text = "\(videos[0].coins ?? 0)金币"
            } else {
                cell.coinLable.isHidden = true
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let controller = CommunityPlayController()
        controller.topicModels = self.dataSource
        controller.currentIndex = indexPath.row
        controller.currentPlayIndex = indexPath.row
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
        getCurrentVC()?.present(nav, animated: false, completion: nil)
    }
}

// MARK: - UIScrollViewDelegate
extension TalksVideoController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let height = scrollView.frame.size.height
        let distanceFormBottm = scrollView.contentSize.height - offsetY
        let offset = offsetY - lastContentOffset
        lastContentOffset = offsetY
        if offset > 0 && offsetY > -20 {
            print("上拉行为 == \(offsetY) == \(height)")
            if offsetY > headerHeight {
                scrollDownToTopHandler?(false)
            }
        }
        if offset < 0 && distanceFormBottm > height {
            print("下拉行为 == \(offsetY)")
            if offsetY <= 350 { /// 这个数字不能太大， 也不太小（理论上越大感觉越流畅）
                scrollDownToTopHandler?(true)
            }
        }
    }
}

// MARK: - Layout
private extension TalksVideoController {
    
    func layoutPageSubviews() {
        layoutCollection()
    }
    
    func layoutCollection() {
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
}
