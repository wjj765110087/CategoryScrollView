//
//  SeriesVideosController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/3.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import MJRefresh

class SeriesVideosController: UIViewController {
    
    
    let scalePresentAnimation = ScalePresentAnimation()
    let scaleDismissAnimation = ScaleDismissAnimation()
    
    static let videoItemWidth: CGFloat = (ConstValue.kScreenWdith - 20)/3
    static let videoItemHieght: CGFloat = videoItemWidth * 1.35 + 35
    static let videoItemSize: CGSize = CGSize(width: videoItemWidth, height: videoItemHieght)
  
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = videoItemSize
        layout.minimumLineSpacing = 15   // 垂直最小间距
        layout.minimumInteritemSpacing = 5.0 // 水平最小间距
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        return layout
    }()
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.clear
        collection.showsVerticalScrollIndicator = false
        collection.register(VideoThridItemCell.classForCoder(), forCellWithReuseIdentifier: VideoThridItemCell.cellId)
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
    
    private let viewModel = VideoViewModel()
    
    var user: UserInfoModel?
    
    var keyId: Int = 0
    /// 用于首页跳转到系列
    var keys: [VideoKey]?
    /// 用于发现跳转到系列
    var keyCateModel: VideoCategoryModel?
    /// 用于请求videoList
    var params = [String: Any]()
    /// 选中index
    var selectIndex:Int = 0
    /// 是否弹出了播放器
    var isCoverPlayer = false
    
    /// 是否最热
    var isHot: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(collectionView)
        collectionView.contentInset = UIEdgeInsets(top: UIDevice.current.isiPhoneXSeriesDevices() ? 88 : 53, left: 0, bottom: UIDevice.current.isiPhoneXSeriesDevices() ? 83 : 46, right: 0)
        layoutPageSubviews()
        addViewModelCallBack()
        if isHot {
            params = [VideoListApi.key_id: keyId, VideoListApi.kPlay_count: "desc"]
        } else {
            params = [VideoListApi.key_id: keyId, VideoListApi.kUpdateded_at: "desc"]
        }
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func loadData() {
        NicooErrorView.removeErrorMeesageFrom(view)
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        viewModel.params = self.params
        viewModel.loadData()
    
    }
    private func loadFirstPage() {
        viewModel.loadData()
    }
    
    private func loadNextPage() {
        viewModel.loadNextPage()
    }

    private func addViewModelCallBack() {
        viewModel.requestListSuccessHandle = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.endRefreshing()
            strongSelf.collectionView.reloadData()
            XSProgressHUD.hide(for: strongSelf.view, animated: false)
        }
        viewModel.requestMoreListSuccessHandle = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.endRefreshing()
            if !strongSelf.isCoverPlayer {
                 strongSelf.collectionView.reloadData()
            }
        }
        viewModel.requestFailedHandle = { [weak self] (msg) in
            guard let strongSelf = self else { return }
            strongSelf.endRefreshing()
            XSAlert.show(type: .error, text: "数据走丢了。")
            XSProgressHUD.hide(for: strongSelf.view, animated: false)
        }
    }
    
    private func endRefreshing() {
        collectionView.mj_header.endRefreshing()
        collectionView.mj_footer.endRefreshing()
    }
    
    private func getCurrentVC() -> SeriesKeyMainController? {
        var next = view.superview
        while (next != nil) {
            let nextResponder = next?.next
            if (nextResponder is SeriesKeyMainController) {
                return nextResponder as? SeriesKeyMainController
            }
            next = next?.superview
        }
        return nil
    }
    
}

// MARK: - QHNavigationBarDelegate
extension SeriesVideosController:  QHNavigationBarDelegate  {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SeriesVideosController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getVideoList().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cellForRow(with: indexPath)
        return cell
    }
    
    /// 配置cell
    func cellForRow(with indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoThridItemCell.cellId, for: indexPath) as! VideoThridItemCell
        if viewModel.getVideoList().count > indexPath.row {
            let model = viewModel.getVideoList()[indexPath.row]
            cell.videoImageView.kfSetVerticalImageWithUrl(model.cover_path)
            cell.videoNameLable.text = model.title ?? ""
            cell.collectionBtn.setTitle(" \(getStringWithNumber(model.recommend_count ?? 0))", for: .normal)
            if let iscoin = model.is_coins, iscoin == 1 {
                cell.coinLable.isHidden = false
                if let coins = model.coins, coins > 0 {
                    cell.coinLable.text = "\(model.coins ?? 0)金币"
                } else {
                    cell.coinLable.isHidden = true
                }
            } else {
                cell.coinLable.isHidden = true
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        selectIndex = indexPath.row
        let controller = PresentPlayController()
        controller.viewModelForPlay = self.viewModel
        controller.currentIndex = selectIndex
        controller.currentPlayIndex = selectIndex
        controller.goVerbOrRefreshActionhandler = { [weak self] (isVerb) in
            if isVerb {
                let vipvc = InvestController()
                vipvc.currentIndex = 0
                self?.getCurrentVC()?.navigationController?.pushViewController(vipvc, animated: false)
            } else {
                self?.collectionView.mj_header.beginRefreshing()
            }
        }
        let nav = QHNavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        getCurrentVC()?.present(nav, animated: false, completion: nil)
    }
}

// MARK: - Layout
private extension SeriesVideosController {
    
    func layoutPageSubviews() {
        layoutCollection()
    }
    func layoutCollection() {
        collectionView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
   
}
