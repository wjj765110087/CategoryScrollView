//
//  ModulesController.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/17.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit

class ModulesController: BaseViewController {
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
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
        collection.register(BannerScrollCell.classForCoder(), forCellWithReuseIdentifier: BannerScrollCell.cellId)
        collection.register(UINib(nibName: "VideoDoubleCollectionCell", bundle: Bundle.main), forCellWithReuseIdentifier: VideoDoubleCollectionCell.cellId)
        collection.register(UINib(nibName: ModulesHeaderView.reuseId, bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ModulesHeaderView.reuseId)
        collection.register(UINib(nibName: HotHeaerView.reuseId, bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HotHeaerView.reuseId)
        collection.mj_header = refreshView
        return collection
    }()
    
    private let commonViewModel = CommonViewModel()
    private let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        print("ChildOneVC --------viewDidLoad")
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        view.addSubview(self.collectionView)
        
        /// 这里不要问我，我也不知道为什么  底部 bottom: 要用 safeAreaTopHeight 才对
        collectionView.contentInset = UIEdgeInsets(top: safeAreaTopHeight, left: 0, bottom: safeAreaTopHeight, right: 0)
        layoutCollectionView()
        addViewModelCallBack()
        loadSystemNotice()
        loadMudulesDatas()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ChildOneVC --------viewWillAppear")
    }
    
    override func loadFirstPage() {
        viewModel.loadMainModulesDatas()
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
    
    /// 系统公告
    private func loadSystemNotice() {
        commonViewModel.loadSystemMsg()
    }
    
    /// 首页模块数据
    private func loadMudulesDatas() {
        NicooErrorView.removeErrorMeesageFrom(view)
        XSProgressHUD.showCustomAnimation(msg: nil, onView: self.view, imageNames: nil, bgColor: UIColor.clear, animated: false)
        viewModel.loadMainModulesDatas()
    }
    
    /// viewmodel 回调
    private func addViewModelCallBack() {
        commonViewModel.loadAppNoticeSuccess = { [weak self] in
            self?.collectionView.reloadData()
        }
        viewModel.loadModulesSucceedHandler = { [weak self] in
            guard let strongSelf = self else { return }
            XSProgressHUD.hide(for: strongSelf.view, animated: false)
            strongSelf.collectionView.reloadData()
            strongSelf.refreshView.endRefreshing()
        }
        viewModel.loadModulesFailedHandler = { [weak self] (msg) in
            guard let strongSelf = self else { return }
            strongSelf.refreshView.endRefreshing()
            NicooErrorView.showErrorMessage(.noNetwork, on: strongSelf.view, topMargin: safeAreaTopHeight + 44, clickHandler: {
                strongSelf.loadMudulesDatas()
            })
            
        }
    }
    
    /// 公告详情
    private func goNoticeVc() {
        let noticesVC = NoticeController()
        getCurrentVC()?.navigationController?.pushViewController(noticesVC, animated: true)
    }
    
    private func clickAd(_ model: AdModel) {
        if model.type ?? .banner_video == .banner_link {
            if let redirect_url = model.redirect_url {
                let url = URL.init(string: redirect_url)
                if let openUrl = url {
                    UIApplication.shared.openURL(openUrl)
                }
            }
        } else {
            var videModel = VideoModel()
            videModel.id = model.video_id
            let videoDetail = VideoDetailViewController()
            videoDetail.model = videModel
            getCurrentVC()?.navigationController?.pushViewController(videoDetail, animated: true)
        }
    }
    
    private func goWeb(_ urlStr: String?) {
        let webvc = WebKitController(url: URL(string: urlStr ?? "")!)
        getCurrentVC()?.navigationController?.pushViewController(webvc, animated: true)
    }

    private func bannerClick(_ model: BannerModel) {
        if model.type ?? .banner_video == .banner_link {
            if let redirect_url = model.redirect_url {
                    goWeb(redirect_url)
            }
        } else if model.type ?? .banner_video == .banner_video {
            var videModel = VideoModel()
            videModel.id = model.video_id
            let videoDetail = VideoDetailViewController()
            videoDetail.model = videModel
            getCurrentVC()?.navigationController?.pushViewController(videoDetail, animated: true)
        } else if model.type ?? .banner_video == .banner_ad {
            goWeb(model.redirect_url)
        } else if model.type ??  .banner_video == .banner_internalLink {
                if let redirect_position = model.redirect_position {
                if redirect_position == .MEMBER_CENTER {
                    ///跳转到会员中心
                    let vip = VipCardController()
                   topVC?.navigationController?.pushViewController(vip, animated: true)
                } else if redirect_position == .TASK_INTERFACE {
                    ///跳转到任务
                    if let delegate =  UIApplication.shared.delegate as? AppDelegate {
                        if let tabBarVC = delegate.window?.rootViewController as? RootTabBarViewController {
                            tabBarVC.selectedIndex  = 3
                        }
                        
                    }
                }  else if redirect_position == .LU_FRIENDLY {
                    ///跳转到撸友交流
                    if let redirect_url = model.redirect_url {
                        UIApplication.shared.openURL(URL.init(string: redirect_url)!)
                    }
                }
            }
        }
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ModulesController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.modules.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let model = viewModel.modules[section]
        if model.client_module == .m_banner {
            return 1
        } else if model.client_module == .m_video {
            return model.m_video_data?.count ?? 0
        } else if model.client_module == .m_ad {
            return model.m_ad_data?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = viewModel.modules[indexPath.section]
        let models = viewModel.modules
        if model.client_module == .m_banner {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerScrollCell.cellId, for: indexPath) as! BannerScrollCell
            var imageNames = [String]()
            for model in models {
                if let baners = model.m_banner_data, baners.count > 0 {
                    
                    for i in baners.enumerated() {
                        imageNames.append(i.element.cover_oss_path ?? "" )
                    }
                    cell.scrollItemClickHandler = { [weak self] (index) in
                        self?.bannerClick(baners[index])
                    }
                }
            }
            cell.setImages(images: imageNames)
            return cell
        } else if model.client_module == .m_video {
            if model.client_style == .video_Normal {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoDoubleCollectionCell.cellId, for: indexPath) as! VideoDoubleCollectionCell
                if let datas = model.m_video_data, datas.count > indexPath.item {
                    cell.setModel(datas[indexPath.item])
                }
                return cell
            } else if model.client_style == .video_Top {
                if indexPath.row == 0 {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotItemTwoCell.cellId, for: indexPath) as! HotItemTwoCell
                    if let datas = model.m_video_data, datas.count > indexPath.item {
                        cell.setModel(datas[indexPath.item])
                    }
                    return cell
                } else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoDoubleCollectionCell.cellId, for: indexPath) as! VideoDoubleCollectionCell
                    if let datas = model.m_video_data, datas.count > indexPath.item {
                        cell.setModel(datas[indexPath.item])
                    }
                    return cell
                }
            } else if model.client_style == .video_Table {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HotItemTwoCell.cellId, for: indexPath) as! HotItemTwoCell
                if let datas = model.m_video_data, datas.count > indexPath.item {
                    cell.setModel(datas[indexPath.item])
                }
                return cell
            }
        } else if model.client_module == .m_ad {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainAdViewCell.cellId, for: indexPath) as! MainAdViewCell
            if let datas = model.m_ad_data, datas.count > indexPath.item {
                cell.setModel(datas[indexPath.item])
            }
            return cell
        }

        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let model = viewModel.modules[indexPath.section]
        if model.client_module == .m_video {
            if let datas = model.m_video_data, datas.count > indexPath.item {
                let videoDetail = VideoDetailViewController()
                videoDetail.model = datas[indexPath.item]
                getCurrentVC()?.navigationController?.pushViewController(videoDetail, animated: true)
            }
        } else if model.client_module == .m_ad {
            if let ads = model.m_ad_data, ads.count > 0 {
                clickAd(ads[indexPath.item])
            }
        }
    }
   
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ModulesController: UICollectionViewDelegateFlowLayout {
    
    /// itemSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let model = viewModel.modules[indexPath.section]
        if model.client_module == .m_banner {
            return BannerScrollCell.itemSize
        } else if model.client_module == .m_video {
            if model.client_style == .video_Normal {  // 九宫格
                return VideoDoubleCollectionCell.itemSize
            } else if model.client_style == .video_Top { // 滑动
                if indexPath.row == 0 {
                    return HotItemTwoCell.itemSize
                } else {
                    return VideoDoubleCollectionCell.itemSize
                }
            } else if model.client_style == .video_Table { // table
                return HotItemTwoCell.itemSize
            }
        } else if model.client_module == .m_ad {
            return MainAdViewCell.itemSize
        }
        return CGSize.zero
    }
    
    /// 边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let model = viewModel.modules[section]
        if model.client_module == .m_video {
           return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        } else if model.client_module == .m_ad {
           return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        }
        return UIEdgeInsets.zero
    }
    
    /// sectionHeader高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let model = viewModel.modules[section]
        if model.client_module == .m_banner || model.client_module == .m_ad {
            return CGSize.zero
        }
        return CGSize(width: screenWidth, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let model = viewModel.modules[section]
        if model.client_module == .m_banner {
            return CGSize(width: screenWidth, height: 50)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView:UICollectionReusableView?
        //是每组的头
        if kind == UICollectionView.elementKindSectionHeader {
            let searchReusable = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ModulesHeaderView.reuseId, for: indexPath) as! ModulesHeaderView
            let model = viewModel.modules[indexPath.section]
            searchReusable.titleLab.text = model.title ?? "老司机必备"
            reusableView = searchReusable
            searchReusable.moreActionHandler = { [weak self] in
                //self?.goCateTypeVc()
                guard let strongSelf = self  else { return }
                let seriesVerbVC = VerbMoreViewController()
                seriesVerbVC.moduleModel = model
                strongSelf.getCurrentVC()?.navigationController?.pushViewController(seriesVerbVC, animated: true)
            }
        } else {
            let searchReusable = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: HotHeaerView.reuseId, for: indexPath) as! HotHeaerView
            searchReusable.setNotice()
            searchReusable.bgButtonClickHandler = { [weak self] in
                self?.goNoticeVc()
            }
            reusableView = searchReusable
        }
        return reusableView!
    }
}

extension ModulesController {
    func layoutCollectionView() {
        let topMargin = isIphoneX ? 41 : 36
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(topMargin)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(0)
        }
    }
}
