//
//  MessageFansController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/3.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//  粉丝消息

import UIKit
import MJRefresh
import NicooNetwork

class MessageFansController: QHBaseViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "粉丝"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = ConstValue.kViewLightColor
        bar.backButton.isHidden = false
        bar.titleLabel.isHidden = false
        bar.lineView.isHidden = true
        bar.delegate = self
        return bar
    }()
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.clear
        table.showsVerticalScrollIndicator = false
        table.allowsSelection = true
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(MessageFansCell.classForCoder(), forCellReuseIdentifier: MessageFansCell.cellId)
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
    
    private lazy var fansMessageApis: FansMessageListApi =  {
        let api = FansMessageListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    private lazy var updateMaxIdApi: UpdateMessageMaxIdApi = {
        let api = UpdateMessageMaxIdApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    
    var userViewModel: UserInfoViewModel = UserInfoViewModel()
  
    var models: [FansMessageModel] = [FansMessageModel]()
    var maxId: Int? = 0
    var id: Int?
    
    var currentIndex: Int = 0
    
    override func viewDidLoad() {
         super.viewDidLoad()
         view.backgroundColor = ConstValue.kVcViewColor
         view.addSubview(navBar)
         view.addSubview(tableView)
         layoutPageSubViews()
         loadData()
        
    }
}

// MARK: - 网络数据请求
extension MessageFansController {
    
    private func loadData() {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        NicooErrorView.removeErrorMeesageFrom(view)
        _ = fansMessageApis.loadData()
    }
    
    private func firstRefresh() {
        _ = fansMessageApis.loadData()
    }
    
    private func loadNextpage() {
        _ = fansMessageApis.loadNextPage()
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
extension MessageFansController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageFansCell.cellId, for: indexPath) as! MessageFansCell
        let model = models[indexPath.row]
        cell.setModel(model: model)
        cell.didClickAttentionHandler = { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.currentIndex = indexPath.row
            strongSelf.addFollowOrCancel(model: model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MessageFansCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        self.currentIndex = indexPath.row
        let model = models[indexPath.row]
        if model.id != UserModel.share().userInfo?.id { // 不是自己
            let userCenter = UserMCenterController()
            
            userCenter.followOrCancelBackHandler = { [weak self] (focusStatu) in
                guard let strongSelf = self else {return}
                strongSelf.reloadCurrentIndexFocusStatu(focusStatu)
            }
            
            let user = UserInfoModel()
            user.id = model.id
            user.cover_path = model.user?.cover_path
            user.nikename = model.user?.nikename
            userCenter.user = user
            navigationController?.pushViewController(userCenter, animated: true)
        } else {
            let userinfoEditVC = UserInfoEditController()
            navigationController?.pushViewController(userinfoEditVC, animated: true)
        }
    }
    
    func reloadCurrentIndexFocusStatu(_ statu: FocusVideoUploader) {
        if let cell = self.tableView.cellForRow(at: IndexPath.init(item: currentIndex, section: 0)) as? MessageFansCell {
            var model = self.models[currentIndex]
            if statu == .focus {
                if model._realation?.flag == .notRelate ||  model._realation?.flag == .follwMe { //无关系，我的粉丝
                    model._realation?.flag = .myFollow
                }
            } else {
                if model._realation?.flag == .myFollow {
                    model._realation?.flag = .notRelate
                } else if model._realation?.flag == .followEachOther {
                    model._realation?.flag = .follwMe
                }
            }
            cell.setModel(model: model)
            tableView.reloadData()
        }
    }
    
    func addFollowOrCancel(model: FansMessageModel) {
        if let realation = model._realation {
            if let flag = realation.flag {
                if flag == .notRelate || flag == .follwMe { //无关系，我的粉丝
                    userAddFollowCallBack()
                    userViewModel.loadAddFollowApi([UserAddFollowApi.kUserId: model._realation?.uid ?? 0, UserAddFollowApi.kSelfId: UserModel.share().userInfo?.id ?? 0])
                } else if flag == .followEachOther || flag == .myFollow { //互相关注了 ， 我关注了他
                    userAddFollowCallBack()
                    userViewModel.loadCancleFollowApi([UserAddFollowApi.kUserId: model._realation?.uid ?? 0, UserAddFollowApi.kSelfId: UserModel.share().userInfo?.id ?? 0])
                } else if flag == .isMySelf { //是自己
                    
                }
            }
        }
    }
}

//MARK: -关注和取消关注的回调
extension MessageFansController {
    
    private func userAddFollowCallBack() {
        
        userViewModel.followAddOrCancelSuccessHandler = { [weak self] isAdd, model in
            guard let strongSelf = self else {return}
            var modela = strongSelf.models[strongSelf.currentIndex]
            if isAdd {
                if modela._realation?.flag == .notRelate {   ///无关系
                    modela._realation?.flag = .myFollow  ///
                } else if modela._realation?.flag == .follwMe { ///
                    modela._realation?.flag = .followEachOther
                }
                strongSelf.models[strongSelf.currentIndex] = modela
                
            } else {
                if modela._realation?.flag == .followEachOther {
                    modela._realation?.flag = .follwMe
                } else if modela._realation?.flag == .follwMe {
                    modela._realation?.flag = .notRelate
                } else if modela._realation?.flag == .myFollow {
                    modela._realation?.flag = .notRelate
                }
                strongSelf.models[strongSelf.currentIndex] = modela
            }
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
            }
        }
        
        userViewModel.followOrCancelFailureHandler = { (isAdd, msg) in
            XSAlert.show(type: .error, text: msg)
        }
    }
}

// MARK: -  NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension MessageFansController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        var params = [String : Any]()
        if manager is FansMessageListApi {
            params = [FansMessageListApi.kAlias: "FOLLOWER-MSG"]
        }
        
        if manager is UpdateMessageMaxIdApi {
            if models.count > 0 {
                if let id = models[0].id {
                    params = [UpdateMessageMaxIdApi.kTopic_id: id, UpdateMessageMaxIdApi.kMax_id: maxId ?? 0, UpdateMessageMaxIdApi.kAlias: "FOLLOWER-MSG"]
                }
            }
        }
        
        return params
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is FansMessageListApi {
            if let model = manager.fetchJSONData(MessageReformer()) as? FansMessageListModel {
                if let data = model.data, let current_page = model.current_page {
                    if current_page == 1 {
                        if data.count == 0 {
                            NicooErrorView.showErrorMessage(.noData,"你还没有粉丝\n 快去发布视频吸引粉丝吧！", on: view,topMargin: safeAreaTopHeight + 100) {
                                self.loadData()
                            }
                        }
                        models = data
                    } else {
                        models.append(contentsOf: data)
                    }
                    loadMoreView.isHidden = data.count < CommentMessageListApi.kDefaultCount
                }
                endRefreshing()
                tableView.reloadData()
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is FansMessageListApi {
            
        }
        
        if manager is UpdateMessageMaxIdApi {
            
        }
    }
}

// MARK: - Layout
extension MessageFansController {
    
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
extension MessageFansController: QHNavigationBarDelegate  {
    func backAction() {
        if models.count > 0 {
            var userInfo = [String : Any]()
            userInfo = ["message": 4]
            NotificationCenter.default.post(name: Notification.Name.kLookMessageNotification, object: nil, userInfo: userInfo)
        }
        getMessageMaxId()
        navigationController?.popViewController(animated: true)
    }
}
