//
//  DiscoverRecommendController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/5.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//  发现的推荐控制器

import UIKit
import MJRefresh

class DiscoverRecommendController: QHBaseViewController {
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(BannerScrollCell.classForCoder(), forCellWithReuseIdentifier: BannerScrollCell.cellId)
        collectionView.register(DiscoverRankCell.classForCoder(), forCellWithReuseIdentifier: DiscoverRankCell.cellId)
        collectionView.register(PlayCategoryCell.classForCoder(), forCellWithReuseIdentifier: PlayCategoryCell.cellId)
        let headerNib = UINib(nibName: "DiscoverSectionHeaderView", bundle: Bundle.main)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DiscoverSectionHeaderView.reuseId)
        collectionView.mj_header = refreshView
        collectionView.mj_footer = loadMoreView
        return collectionView
    }()
    
    lazy private var loadMoreView: MJRefreshAutoNormalFooter = {
        weak var weakSelf = self
        let loadMore = MJRefreshAutoNormalFooter(refreshingBlock: {
            weakSelf?.loadVideoListNextPage()
        })
        loadMore?.isHidden = true
        loadMore?.stateLabel.font = ConstValue.kRefreshLableFont
        return loadMore!
    }()
    lazy private var refreshView: MJRefreshGifHeader = {
        weak var weakSelf = self
        let mjRefreshHeader = MJRefreshGifHeader(refreshingBlock: {
            weakSelf?.loadAllDatas()
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
    
    var viewModel: DiscoverViewModel = DiscoverViewModel()
    
    var videoList: [FindVideoModel] = [FindVideoModel]()
    var rankList: [FindRankModel] = [FindRankModel]()
    var banners: [FindAdContentModel] = [FindAdContentModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.contentInset = UIEdgeInsets(top: UIDevice.current.isiPhoneXSeriesDevices() ? 108 : (74 + 8), left: 0, bottom: UIDevice.current.isiPhoneXSeriesDevices() ? 128 : 108, right: 0)
        layoutPageSubViews()
        addVideoListDataCallBack()
        loadAllDatas()
    }
    
    func loadAllDatas() {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        loadVideoListData()
        loadRankListData()
        loadAdContentData()
    }
    
    private func addVideoListDataCallBack() {
        viewModel.requestVidoListSuccessHandler = { [weak self] (videoList, pageNum) in
            guard let strongSelf = self else {return}
            if let data = videoList.data {
                if pageNum == 1 {
                    strongSelf.videoList = data
                    if data.count == 0 {
                        //显示暂无视频分类
                    }
                } else {
                    strongSelf.videoList.append(contentsOf: data)
                }
                 strongSelf.loadMoreView.isHidden = data.count < DiscoveryVideoListApi.kDefaultCount
            }
            strongSelf.endRefreshing()
            strongSelf.collectionView.reloadSections([2])
        }
        viewModel.requestVideoListFailureHandler = { [weak self] msg in
            guard let strongSelf = self else { return }
            strongSelf.endRefreshing()
        }
        
        viewModel.requestRankListSuccessHandler = { [weak self] rankList in
            guard let strongSelf = self else {return}
            strongSelf.rankList = rankList
            strongSelf.collectionView.reloadSections([1])
        }
        viewModel.requestAdContentSuccessHandler = { [weak self] banners in
            guard let strongSelf = self else {return}
            strongSelf.banners = banners
            strongSelf.collectionView.reloadSections([0])
        }
    }
    
    private func endRefreshing() {
        XSProgressHUD.hide(for: view, animated: false)
        collectionView.mj_header.endRefreshing()
        collectionView.mj_footer.endRefreshing()
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

//MARK: - 广告也跳转
extension DiscoverRecommendController {
    
    private func bannerClick(_ model: FindAdContentModel) {
        if model.type ?? .banner_video == .banner_link {
            goWeb(model.redirect_url)
        } else if model.type ?? .banner_video == .banner_video {
            
        } else if model.type ?? .banner_video == .banner_ad {
            goWeb(model.redirect_url)
        } else if model.type ??  .banner_video == .banner_internalLink {
            if let redirect_position = model.redirect_position {
                if redirect_position == .MEMBER_RECHARGE_DETAIL { /// 会员中心
                    ///跳转到会员中心
                    let vip = InvestController()
                    vip.currentIndex = 0
                    getCurrentVC()?.navigationController?.pushViewController(vip, animated: true)
                } else if redirect_position == .TOPIC_DETAIL { ///话题详情
                    let talkMainVC = TalksMainController()
                    talkMainVC.talksModel = model.topic_detail_model ?? TalksModel()
                    getCurrentVC()?.navigationController?.pushViewController(talkMainVC, animated: true)
                }  else if redirect_position == .DY_WALLET { ///我的钱包
                    let walletvc =  WalletMainNewController()
                    getCurrentVC()?.navigationController?.pushViewController(walletvc, animated: true)
                } else if redirect_position == .VIDEO_CAT_DETAIL { ///视频分类详情
                    ///跳到最新最热的
                    let seriesKeyMainVC =  SeriesKeyMainController()
                    var seriesKeymodel = VideoKey()
                        seriesKeymodel.key_id = model.key_id ?? 0
                        getCurrentVC()?.navigationController?.pushViewController(seriesKeyMainVC, animated: true)
                }
            }
        }
    }
    
    private func goWeb(_ urlStr: String?) {
        if let urlstr = urlStr {
            if let url = URL(string: urlstr) {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

//MARK: - LoadData
extension DiscoverRecommendController {
    
    private func loadVideoListData() {
        viewModel.loadFindVideoListData(nil)
    }
    
    private func loadVideoListNextPage() {
        viewModel.loadFindVideoListNextPage(nil)
    }
    
    private func loadRankListData() {
       viewModel.loadFindRankList(nil)
    }
    
    private func loadAdContentData() {
        viewModel.loadAdContentData(nil)
    }
}

// MARK: - UICollectionViewDataSource && UICollectionViewDelegate
extension DiscoverRecommendController: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return banners.count > 0 ? 1 : 0
        } else if section == 1 {
            return rankList.count > 0 ? 1 : 0
        } else if section == 2 {
            return videoList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerScrollCell.cellId, for: indexPath) as! BannerScrollCell
            if banners.count > 0 {
                 cell.setModel(models: banners)
                 cell.scrollItemClickHandler = { [weak self] (index) in
                    guard let strongSelf = self else {return}
                    DLog("---------------------------------------------------------------")
                    strongSelf.bannerClick(strongSelf.banners[index])
                }
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscoverRankCell.cellId, for: indexPath) as! DiscoverRankCell
            cell.setModel(rankList: rankList)
            cell.didClickRankHandler = { [weak self] index in
                guard let strongSelf = self else {return}
                let discoverRankVC = DiscoverRankController()
                discoverRankVC.rankType = strongSelf.rankList[index].type ?? .week
                discoverRankVC.topBackgroundImage = strongSelf.rankList[index].title_background_img ?? ""
                strongSelf.getCurrentVC()?.navigationController?.pushViewController(discoverRankVC, animated: true)
            }
            return cell
        } else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlayCategoryCell.cellId, for: indexPath) as! PlayCategoryCell
            let model = videoList[indexPath.row]
            cell.setModel(model: model)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            ///跳到最新最热的
            let seriesKeyMainVC =  SeriesKeyMainController()
            var seriesKeymodel = VideoKey()
            let model = videoList[indexPath.row]
            seriesKeymodel.title = model.keys_title
            seriesKeymodel.key_id = model.key_id ?? 0
            seriesKeyMainVC.keyMode = seriesKeymodel
            getCurrentVC()?.navigationController?.pushViewController(seriesKeyMainVC, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DiscoverRecommendController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return banners.count > 0 ? BannerScrollCell.itemSize : CGSize.zero
        } else if indexPath.section == 1 {
            return  rankList.count > 0 ? DiscoverRankCell.itemSize : CGSize.zero
        } else if indexPath.section == 2 {
            return PlayCategoryCell.itemSize
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 2 {
            return 5.0
        }
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 2 {
            return 5.0
        }
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return  rankList.count > 0 ?  CGSize(width: screenWidth, height: 42) : CGSize.zero
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return banners.count > 0 ? UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10) : UIEdgeInsets.zero
        } else if section == 1 {
            return UIEdgeInsets.zero
        } else if section == 2 {
            return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        }
        return UIEdgeInsets.zero
    }
    
    /// 组头组尾
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reuseableView = UICollectionReusableView()
        if indexPath.section == 1 {
            if kind == UICollectionView.elementKindSectionHeader {
                let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DiscoverSectionHeaderView.reuseId, for: indexPath) as! DiscoverSectionHeaderView
                reuseableView = sectionHeaderView
                return reuseableView
            }
        }
        return reuseableView
    }
}

// MARK: - Layout
extension DiscoverRecommendController {
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

