//
//  DiscoverRankController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/5.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//  发现人气榜单

import UIKit
import MJRefresh

class DiscoverRankController: QHBaseViewController {
    
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.isHidden = true
        bar.backgroundColor = UIColor.clear
        bar.lineView.backgroundColor = UIColor.clear
        bar.backButton.isHidden = false
        bar.delegate = self
        return bar
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.register(UINib(nibName: "RankCell", bundle: Bundle.main), forCellReuseIdentifier: RankCell.cellId)
        tableView.register(RankSectionHeaderView.classForCoder(), forHeaderFooterViewReuseIdentifier: RankSectionHeaderView.reuseId)
        tableView.mj_header = refreshView
        tableView.mj_footer = loadMoreView
        return tableView
    }()
    
    lazy private var loadMoreView: MJRefreshAutoNormalFooter = {
        weak var weakSelf = self
        let loadmore = MJRefreshAutoNormalFooter(refreshingBlock: {
            weakSelf?.loadRankListDetailNextPage()
        })
        loadmore?.isHidden = true
        loadmore?.stateLabel.font = ConstValue.kRefreshLableFont
        return loadmore!
    }()
    lazy private var refreshView: MJRefreshGifHeader = {
        weak var weakSelf = self
        let mjRefreshHeader = MJRefreshGifHeader(refreshingBlock: {
            weakSelf?.loadRankListDetailData()
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
    
    private lazy var headerView: RankHeaderView = {
        let header = RankHeaderView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 141/375 * screenWidth))
        return header
    }()
    
    var viewModel: DiscoverViewModel = DiscoverViewModel()
    var findRankDetailListModel: FindRankDetailListModel = FindRankDetailListModel()
    var rankDetailList: [FindRankModel] = [FindRankModel]()
    var banners: [FindAdContentModel] = [FindAdContentModel]()
    var rankType: RankType = .week
    var topBackgroundImage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(navBar)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tableView.tableFooterView = UIView()
        layoutPageViews()
        addViewModelCallBack()
        loadData()
        headerView.setImages(images: [topBackgroundImage])
    }
    
    private func loadData() {
        NicooErrorView.removeErrorMeesageFrom(view)
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        loadRankListDetailData()
    }
    
    private func endRefreshing() {
        loadMoreView.endRefreshing()
        refreshView.endRefreshing()
        XSProgressHUD.hide(for: view, animated: false)
    }
    
    private func addViewModelCallBack() {
        
        viewModel.requestRankDetailSuccessHandler = { [weak self] (rankDetailList, pageNumber) in
            guard let strongSelf = self else {return}
            strongSelf.findRankDetailListModel = rankDetailList
            if let data = rankDetailList.data {
                if pageNumber == 1 {
                    strongSelf.rankDetailList = data
                    if data.count == 0 {
                        ///暂无排行详情
                        NicooErrorView.showErrorMessage("暂无排行", on:strongSelf.view , customerTopMargin: safeAreaTopHeight, clickHandler: nil)
                    }
                } else {
                    strongSelf.rankDetailList.append(contentsOf: data)
                }
                
                strongSelf.loadMoreView.isHidden = data.count < DiscoverRankDetailApi.kDefaultCount
            }
           strongSelf.endRefreshing()
           strongSelf.tableView.reloadData()
           
        }
        
        viewModel.requestRankDetailFailureHandler = { [weak self] msg in
            guard let strongSelf = self else {return}
            strongSelf.endRefreshing()
        }
        
    }
}

//MARK: - NetworkRequest
extension DiscoverRankController {
    
    private func loadRankListDetailData() {
        let params = [DiscoverRankDetailApi.kRankType: rankType.rawValue]
         viewModel.loadFindRankDetailData(params)
    }
    
    private func loadRankListDetailNextPage() {
        let params = [DiscoverRankDetailApi.kRankType: rankType.rawValue]
        viewModel.loadRankDetailNextPage(params)
    }
    
    private func loadRankAdData() {
        viewModel.loadRankAdContentData(nil)
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension DiscoverRankController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankDetailList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RankCell.cellId, for: indexPath) as! RankCell
        let model = rankDetailList[indexPath.row]
        cell.rankType = rankType
        cell.setModel(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RankCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: RankSectionHeaderView.reuseId)  as! RankSectionHeaderView
        
        if let updateTime = findRankDetailListModel.update {
            header.label.text = String(format: "更新%@", updateTime)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return RankSectionHeaderView.headerHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playVideoVC = SeriesPlayController()
        var videos = [VideoModel]()
        for rank in rankDetailList {
            if let video = rank.video_model {
                videos.append(video)
                playVideoVC.videos = videos
                playVideoVC.currentIndex = indexPath.row
                playVideoVC.currentPlayIndex = indexPath.row
                playVideoVC.goVerbOrRefreshActionHandler = { [weak self] (isVerb) in
                    if isVerb {
                        let vipvc = InvestController()
                        vipvc.currentIndex = 0
                        self?.navigationController?.pushViewController(vipvc, animated: false)
                    }
                }
            }
        }
        let nav = UINavigationController(rootViewController: playVideoVC)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
}

// MARK: - QHNavigationBarDelegate
extension DiscoverRankController:  QHNavigationBarDelegate  {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}


//MARK: -Layout
private extension DiscoverRankController {
    
    func layoutPageViews() {
        layoutHeaderView()
        layoutNavBar()
        layoutTableView()
    }
    
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(safeAreaTopHeight)
        }
    }
    
    func layoutHeaderView() {
        headerView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(141)
        }
    }
    
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                // Fallback on earlier versions
                make.bottom.equalToSuperview()
            }
        }
    }
}
