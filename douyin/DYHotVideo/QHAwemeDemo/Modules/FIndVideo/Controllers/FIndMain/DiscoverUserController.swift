//
//  DiscoverUserController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/7.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//  搜索用户

import UIKit
import MJRefresh
import NicooNetwork

class DiscoverUserController: QHBaseViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    lazy var searchNoDataHeader: SearchOtherNoDataHeaderView = SearchOtherNoDataHeaderView.init(frame: .zero)
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.clear
        table.showsVerticalScrollIndicator = false
        table.allowsSelection = true
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(UINib(nibName: "AttListCell", bundle: Bundle.main), forCellReuseIdentifier: AttListCell.cellId)
        table.register(SearchOtherNoDataHeader.classForCoder(), forHeaderFooterViewReuseIdentifier: SearchOtherNoDataHeader.reuseId)
        table.mj_header = refreshView
        table.mj_footer = loadMoreView
        return table
    }()
    lazy private var loadMoreView: MJRefreshAutoNormalFooter = {
        weak var weakSelf = self
        let loadmore = MJRefreshAutoNormalFooter(refreshingBlock: {
            weakSelf?.loadNextPage()
            weakSelf?.loadRecommandNextPage()
        })
        loadmore?.setTitle("", for: .idle)
        loadmore?.setTitle("已经到底了", for: .noMoreData)
        loadmore?.stateLabel.font = ConstValue.kRefreshLableFont
        return loadmore!
    }()
    
    lazy private var refreshView: MJRefreshGifHeader = {
        weak var weakSelf = self
        let mjRefreshHeader = MJRefreshGifHeader(refreshingBlock: {
            weakSelf?.fristRefresh()
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
    
    private lazy var searchUserApi: SearchUserApi = {
         let api = SearchUserApi()
         api.paramSource = self
         api.delegate = self
         return api
    }()
    
    private lazy var recommandUserApi: RecommandUserApi = {
        let api = RecommandUserApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
        
    var searchKey: String?
    var models: [FlowUsers] = [FlowUsers]()
    var userViewModel: UserInfoViewModel = UserInfoViewModel()
    
    var currentIndex: Int = 0
    
    var isSearchHasResult: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(tableView)
        layoutPageSubviews()
        tableView.contentInset = UIEdgeInsets(top: UIDevice.current.isXSeriesDevices() ? safeAreaTopHeight: 44 , left: 0, bottom: UIDevice.current.isXSeriesDevices() ? 83 : 49, right: 0)
        loadData()
    }
    
    private func endRefreshing() {
        refreshView.endRefreshing()
        loadMoreView.endRefreshing()
    }
    
    ///精彩推荐
    private func loadRecommandUserData() {
        let _ = recommandUserApi.loadData()
    }
    
    private func loadRecommandNextPage() {
        let _ = recommandUserApi.loadNextPage()
    }
}

// MARK: - Privite Funs
private extension DiscoverUserController {
    
    func loadData() {
        NicooErrorView.removeErrorMeesageFrom(view)
        let _ = searchUserApi.loadData()
    }
    
    func fristRefresh() {
        let _ = searchUserApi.loadData()
    }
    
    func loadNextPage() {
        let _ = searchUserApi.loadNextPage()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension DiscoverUserController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AttListCell.cellId) as! AttListCell
        let model = models[indexPath.row]
        cell.setDiscoverSearchUserModel(model)
        cell.didClickFollowHandler = { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.currentIndex = indexPath.row
            strongSelf.addFollowOrCancel(model: model)
        }
        cell.didClickAvatarHandler = {[weak self] in
            guard let strongSelf = self else {return}
            let userVC = UserMCenterController()
            let user = UserInfoModel()
            user.nikename = model.nikename
            user.cover_path = model.cover_path
            user.id = model.id
            userVC.user = user
            strongSelf.getCurrentVC()?.navigationController?.pushViewController(userVC, animated: true)
        }
        return cell
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
            user.cover_path = model.cover_path
            user.nikename = model.nikename
            userCenter.user = user
            getCurrentVC()?.navigationController?.pushViewController(userCenter, animated: true)
        } else {
            let userinfoEditVC = UserInfoEditController()
            getCurrentVC()?.navigationController?.pushViewController(userinfoEditVC, animated: true)
        }
    }
    
    private func getCurrentVC() -> DiscoverSearchResultController? {
        var next = view.superview
        while (next != nil) {
            let nextResponder = next?.next
            if (nextResponder is DiscoverSearchResultController) {
                return nextResponder as? DiscoverSearchResultController
            }
            next = next?.superview
        }
        return nil
    }
    
    func reloadCurrentIndexFocusStatu(_ statu: FocusVideoUploader) {
        if let cell = self.tableView.cellForRow(at: IndexPath.init(item: currentIndex, section: 0)) as? AttListCell {
            let model = self.models[currentIndex]
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
            cell.setDiscoverSearchUserModel(model)
            tableView.reloadData()
        }
    }
    
    func addFollowOrCancel(model: FlowUsers) {
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
extension DiscoverUserController {
    
    private func userAddFollowCallBack() {
        
        userViewModel.followAddOrCancelSuccessHandler = { [weak self] isAdd, model in
            guard let strongSelf = self else {return}
            let modela = strongSelf.models[strongSelf.currentIndex]
            if isAdd {
                if modela._realation?.flag == .notRelate {
                    modela._realation?.flag = .myFollow
                } else if modela._realation?.flag == .follwMe {
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
            strongSelf.tableView.reloadData()
        }
    }
}

/// MARK: - NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate
extension DiscoverUserController: NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        XSProgressHUD.showCustomAnimation(msg: "", onView: view, imageNames: nil, bgColor: nil, animated: true)
        var params = [String : Any]()
        if manager is SearchUserApi {
            if searchKey != nil {
                 params = [SearchUserApi.kw: searchKey! as Any]
            }
        }
        return params
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is SearchUserApi {
            if let userSearchList = manager.fetchJSONData(SearchReformer()) as? SearchUserListModel {
                if let data = userSearchList.data, let current_page = userSearchList.current_page {
                    if current_page == 1 {
                        models = data
                    } else {
                        models.append(contentsOf: data)
                    }
                    if models.count == 0 {
                        ///获取推荐用户的列表
                        loadRecommandUserData()
                        searchNoDataHeader.frame = CGRect.init(x: 0, y: 0, width: 0, height: 100)
                        tableView.tableHeaderView = searchNoDataHeader
                        isSearchHasResult = false
                    } else {
                        isSearchHasResult = true
                        searchNoDataHeader.frame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
                        tableView.tableHeaderView = nil
                    }
                    loadMoreView.isHidden = (models.count < SearchUserApi.kDefaultCount)
                    endRefreshing()
                    tableView.reloadData()
                }
            }
        }
        
        if manager is RecommandUserApi {
            if let userSearchList = manager.fetchJSONData(SearchReformer()) as? SearchUserListModel {
                if let data = userSearchList.data, let current_page = userSearchList.current_page {
                    if current_page == 1 {
                        models = data
                        if data.count == 0 {
                           
                        }
                    } else {
                        models.append(contentsOf: data)
                    }
                    loadMoreView.isHidden = (models.count < SearchUserApi.kDefaultCount)
                    endRefreshing()
                    tableView.reloadData()
                }
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        endRefreshing()
        if manager is SearchUserApi {
            
        }
        if manager is RecommandUserApi  {
            
        }
    }
}


// MARK: - Layout
private extension DiscoverUserController {
    
    func layoutPageSubviews() {
        layoutTableView()
    }
    
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
            make.leading.trailing.top.equalToSuperview()
        }
    }
}
