//
//  MessageZansController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/3.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//  点赞

import UIKit
import MJRefresh
import NicooNetwork

class MessageZansController: QHBaseViewController {

    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "点赞"
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
        table.register(MessageZanCell.classForCoder(), forCellReuseIdentifier: MessageZanCell.cellId)
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
    
    private lazy var praiseMessageApi: PraiseMessageListApi =  {
        let api = PraiseMessageListApi()
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
    
    var models: [PraiseModel] = [PraiseModel]()
    var maxId: Int? = 0
    var id: Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(navBar)
        view.addSubview(tableView)
        layoutPageSubViews()
        loadData()
    }
    
    private func loadData() {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        NicooErrorView.removeErrorMeesageFrom(view)
        _ = praiseMessageApi.loadData()
    }
    
    private func firstRefresh() {
        _ = praiseMessageApi.loadData()
    }
    
    private func loadNextpage() {
        _ = praiseMessageApi.loadNextPage()
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
extension MessageZansController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageZanCell.cellId, for: indexPath) as! MessageZanCell
        cell.setModel(model: models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MessageZanCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = models[indexPath.row]
        if let type = model.type, let alter = model.alter {
            if type == "DYNAMIC" {
                if let type = alter.type {
                    if type == "IMG_TEXT" {
                        goToDynamicDetail(model: model)
                    } else if type == "VIDEO" {
                        gotoVideoDetail(model: model)
                    }
                }
            } else if type == "DY-COMMENT" {
                if let type = alter.type {
                    if type == "IMG_TEXT" {
                        goToDynamicDetail(model: model)
                    } else if type == "VIDEO" {
                        gotoVideoDetail(model: model)
                    }
                }
            } else if type == "VIDEO-COMMENT" {
                if let type = alter.type {
                    if type == "IMG_TEXT" {
                        goToDynamicDetail(model: model)
                    } else if type == "VIDEO" {
                        gotoVideoDetail(model: model)
                    }
                }
            }
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    ///去动态
    func goToDynamicDetail(model: PraiseModel) {
        let topicVC = TopicsDetailController()
        topicVC.topicId = model.alter?.dy_id ?? 0
        self.navigationController?.pushViewController(topicVC, animated: true)
    }
    
    ///去视频
    func gotoVideoDetail(model: PraiseModel) {
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
}

// MARK: -  NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension MessageZansController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        var params = [String : Any]()
        if manager is PraiseMessageListApi {
            params = [PraiseMessageListApi.kAlias: "PRAISE-MSG"]
        }
        
        if manager is UpdateMessageMaxIdApi {
            if models.count > 0 {
                if let id = models[0].id {
                    params = [UpdateMessageMaxIdApi.kTopic_id: id, UpdateMessageMaxIdApi.kMax_id: maxId ?? 0, UpdateMessageMaxIdApi.kAlias: "PRAISE-MSG"]
                }
            }
        }
        return params
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is PraiseMessageListApi {
            if let model = manager.fetchJSONData(MessageReformer()) as? PraiseMessageListModel {
                if let data = model.data, let current_page = model.current_page {
                    if current_page == 1 {
                        if data.count == 0 {
                            NicooErrorView.showErrorMessage(.noData,"你还没有收到点赞哦\n ", on: view,topMargin: safeAreaTopHeight + 100) {
                                self.loadData()
                            }
                        }
                        models = data
                    } else {
                        models.append(contentsOf: data)
                    }
                    loadMoreView.isHidden = data.count < PraiseMessageListApi.kDefaultCount
                }
                endRefreshing()
                tableView.reloadData()
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is PraiseMessageListApi {
            
        }
        
        if manager is UpdateMessageMaxIdApi {
            
        }
    }
}

// MARK: - Layout
extension MessageZansController {
    
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
extension MessageZansController: QHNavigationBarDelegate  {
    func backAction() {
        if models.count > 0 {
            var userInfo = [String : Any]()
            userInfo = ["message": 2]
            NotificationCenter.default.post(name: Notification.Name.kLookMessageNotification, object: nil, userInfo: userInfo)
        }
        
        getMessageMaxId()
        navigationController?.popViewController(animated: true)
    }
}
