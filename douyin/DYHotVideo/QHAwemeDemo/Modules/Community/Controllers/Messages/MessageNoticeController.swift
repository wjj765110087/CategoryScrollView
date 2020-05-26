//
//  MessageNoticeController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/3.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//  通知

import UIKit
import MJRefresh
import NicooNetwork

class MessageNoticeController: QHBaseViewController {

    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "通知"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = ConstValue.kViewLightColor
        bar.backButton.isHidden = false
        bar.titleLabel.isHidden = false
        bar.lineView.isHidden = true
        bar.delegate = self
        return bar
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = UIColor.clear
        table.showsVerticalScrollIndicator = false
        table.allowsSelection = true
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(MessageSystemNoticeCell.classForCoder(), forCellReuseIdentifier: MessageSystemNoticeCell.cellId)
        table.mj_header = refreshView
        table.mj_footer = loadMoreView
        return table
    }()
    
    lazy private var loadMoreView: MJRefreshAutoNormalFooter = {
        weak var weakSelf = self
        let loadmore = MJRefreshAutoNormalFooter(refreshingBlock: {
            weakSelf?.loadNextpage()
        })
        loadmore?.setTitle("", for: .idle)
        loadmore?.setTitle("已经到底了", for: .noMoreData)
        loadmore?.stateLabel.font = ConstValue.kRefreshLableFont
        return loadmore!
    }()
    
    lazy private var refreshView: MJRefreshGifHeader = {
        weak var weakSelf = self
        let mjRefreshHeader = MJRefreshGifHeader(refreshingBlock: {
            weakSelf?.firstRefresh()
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
    
    var hasLookMessageHandler: ((_ isLook: Bool)->())?
    
    private lazy var noticeMessageApi: NoticeMessageListApi = {
       let api = NoticeMessageListApi()
       api.paramSource = self
       api.delegate = self
       return api
    }()
    
    private lazy var updateMaxIdApi: UpdateMessageMaxIdApi = {
       let api = UpdateMessageMaxIdApi()
       api.paramSource = self
       api.delegate = self
       return api
    }()
    
    var models: [NoticeMessageModel] = [NoticeMessageModel]()
    var maxId: Int? = 0
    var topId: Int?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(navBar)
        view.addSubview(tableView)
        layoutPageSubViews()
        loadNotice()
    }
    
    private func loadNotice() {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        NicooErrorView.removeErrorMeesageFrom(view)
        _ = noticeMessageApi.loadData()
    }
    
    private func firstRefresh() {
        _ = noticeMessageApi.loadData()
    }
    
    private func loadNextpage() {
        _ = noticeMessageApi.loadNextPage()
    }
    
    private func endRefreshing() {
        tableView.mj_header.endRefreshing()
        tableView.mj_footer.endRefreshing()
    }
    
    private func getMessageMaxId() {
        if models.count > 0 {
            let model = models[0]
            if model.id != nil && maxId != nil {
                if model.id! > maxId! {
                    let _ = updateMaxIdApi.loadData()
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource && UITableViewDelegate
extension MessageNoticeController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageSystemNoticeCell.cellId, for: indexPath) as! MessageSystemNoticeCell
        cell.setModel(model: models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MessageSystemNoticeCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = models[indexPath.row]
        if let type = model.type, let dynamic_type = model.dynamic_type   {
            if type == .follow { ///关注
                if dynamic_type == .imageText {  ///跳转到动态详情
                    goToDynamicDetail(model: model)
                } else if dynamic_type == .video { ///跳转到视频详情
                     goToVideoPlay(model: model)
                }
            } else if type == .topic {          ///话题
                if dynamic_type == .imageText {
                    goToDynamicDetail(model: model)
                } else if dynamic_type == .video {
                    goToVideoPlay(model: model)
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    ///去视频播放详情
    func goToVideoPlay(model: NoticeMessageModel) {
        let playVideoVC = SeriesPlayController()
        if let videoModels = model.alter?.video_model {
            playVideoVC.videos = [videoModels]
            playVideoVC.currentIndex = 0
            playVideoVC.currentPlayIndex = 0
            playVideoVC.goVerbOrRefreshActionHandler = { [weak self] (isVerb) in
                if isVerb {
                    let vipvc = InvestController()
                    vipvc.currentIndex = 0
                    self?.navigationController?.pushViewController(vipvc, animated: false)
                }
            }
        }
        let nav = UINavigationController(rootViewController: playVideoVC)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    ///去动态播放详情
    func goToDynamicDetail(model: NoticeMessageModel) {
        let topicVC = TopicsDetailController()
        topicVC.topicId = model.dynamic_id ?? 0
        self.navigationController?.pushViewController(topicVC, animated: true)
    }
}

// MARK: -  NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension MessageNoticeController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        var params = [String : Any]()
        if manager is NoticeMessageListApi {
            params = [NoticeMessageListApi.kAlias: "NOTICE-MSG"]
            
        }
        if manager is UpdateMessageMaxIdApi {
            if models.count > 0 {
                if let topic_id = models[0].topic_id {
                    params = [UpdateMessageMaxIdApi.kTopic_id: topic_id, UpdateMessageMaxIdApi.kMax_id: maxId ?? 0, UpdateMessageMaxIdApi.kAlias: "NOTICE-MSG"]
                }
            }
        }
        return params
        
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is NoticeMessageListApi {
            if let model = manager.fetchJSONData(MessageReformer()) as? NoticeMessageListModel {
                if let data = model.data, let currentPage = model.current_page {
                    if currentPage == 1 {
                        models = data
                        if data.count == 0 {
                            NicooErrorView.showErrorMessage(.noData,"您还没有消息哦", on: view,topMargin: safeAreaTopHeight + 100) {
                                self.loadNotice()
                            }
                        }
                    } else {
                        models.append(contentsOf: data)
                    }
                    self.loadMoreView.isHidden = data.count < NoticeMessageListApi.kDefaultCount
                    endRefreshing()
                    tableView.reloadData()
                }
            }
        }
        
        if manager is UpdateMessageMaxIdApi {
            
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is NoticeMessageListApi {
           
        }
        
        if manager is UpdateMessageMaxIdApi {
            
        }
    }
}

// MARK: - Layout
extension MessageNoticeController {
    
    private func layoutPageSubViews() {
        layoutNavBar()
        layoutTableView()
    }
    
    private func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(safeAreaTopHeight)
        }
    }
    
    private func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
}

// MARK: - QHNavigationBarDelegate
extension MessageNoticeController: QHNavigationBarDelegate  {
    func backAction() {
        if models.count > 0 {
            var userInfo = [String : Any]()
            userInfo = ["message": 1]
            NotificationCenter.default.post(name: Notification.Name.kLookMessageNotification, object: nil, userInfo: userInfo)
        }
        
        getMessageMaxId()
        
        navigationController?.popViewController(animated: true)
    }
}
