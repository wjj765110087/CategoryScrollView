//
//  MessageSystemNoticeController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/9.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//  系统通知

import UIKit
import MJRefresh
import NicooNetwork

class MessageSystemNoticeController: QHBaseViewController {

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
        table.register(MessageNoticeCell.classForCoder(), forCellReuseIdentifier: MessageNoticeCell.cellId)
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
    
    private lazy var systemMessageNoticeApi: SystemMessageListApi = {
       let api = SystemMessageListApi()
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
    
    var models: [SystemMessageModel] = [SystemMessageModel]()
    var maxId: Int? = 0
    var id: Int? = 0
    
    var hasLookMessageHandler: ((_ isLook: Bool)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(navBar)
        view.addSubview(tableView)
        layoutPageSubViews()
        loadData()
    }
    
    private func loadData() {
        NicooErrorView.removeErrorMeesageFrom(view)
        XSProgressHUD.showCustomAnimation(msg: "获取数据中", onView: view, imageNames: nil, bgColor: nil, animated: false)
        _ = systemMessageNoticeApi.loadData()
    }
    
    private func firstRefresh() {
        _ = systemMessageNoticeApi.loadData()
    }
    
    private func loadNextpage() {
        _ = systemMessageNoticeApi.loadNextPage()
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
extension MessageSystemNoticeController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageNoticeCell.cellId, for: indexPath) as! MessageNoticeCell
        cell.setModel(model: models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100.0
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

//MARK: -  NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension MessageSystemNoticeController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        var params = [String : Any]()
        if manager is SystemMessageListApi {
            params = [SystemMessageListApi.kAlias: "SYSTEM-MSG"]
        }
        if manager is UpdateMessageMaxIdApi {
            if models.count > 0 {
                if let id = models[0].id {
                    params = [UpdateMessageMaxIdApi.kTopic_id: id, UpdateMessageMaxIdApi.kMax_id: maxId ?? 0, UpdateMessageMaxIdApi.kAlias: "SYSTEM-MSG"]
                }
            }
        }
        return params
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is SystemMessageListApi {
            if let model = manager.fetchJSONData(MessageReformer()) as? SystemMessageListModel {
                if let data = model.data, let current_page = model.current_page {
                    if current_page == 1 {
                        if data.count == 0 {
                            NicooErrorView.showErrorMessage(.noData, on: view, topMargin: safeAreaTopHeight + 100) {
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
        if manager is SystemMessageListApi {
            
        }
        if manager is UpdateMessageMaxIdApi {
            
        }
    }
}

// MARK: - Layout
extension MessageSystemNoticeController {
    
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
extension MessageSystemNoticeController: QHNavigationBarDelegate  {
    func backAction() {
        
        getMessageMaxId()
        navigationController?.popViewController(animated: true)
    }
}
