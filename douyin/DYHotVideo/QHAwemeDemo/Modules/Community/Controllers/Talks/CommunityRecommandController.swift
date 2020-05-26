//
//  CommunityRecommandController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/2.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//  社区推荐

import UIKit
import NicooNetwork
import MJRefresh

class CommunityRecommandController: QHBaseViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.clear
        table.showsVerticalScrollIndicator = false
        table.allowsSelection = true
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(CommunityRecommandCell.classForCoder(), forCellReuseIdentifier: CommunityRecommandCell.cellId)
        table.mj_header = refreshView
        table.mj_footer = loadMoreView
        //table.bounces = false
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
    
    private let viewModel = CommunityViewModel()
    private var pageNumber: Int = 0
    private var dataSource = [TalksModel]()
    private var actionIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(tableView)
        layoutPageSubviews()
        tableView.contentInset = UIEdgeInsets(top: UIDevice.current.isXSeriesDevices() ? 80 : 53, left: 0, bottom: UIDevice.current.isiPhoneXSeriesDevices() ? 113 : 90 , right: 0)
        addViewModelCallback()
        loadCommunityRecommand()
    }
    
    private func loadCommunityRecommand() {
        NicooErrorView.removeErrorMeesageFrom(view)
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        viewModel.loadTalksList(nil)
    }
    
    private func firstRefresh() {
        viewModel.loadTalksList(nil)
    }
    
    private func loadNextpage() {
        viewModel.loadTalksNextPage(nil)
    }
    /// 加关注
    private func addFollow(_ topicId: Int) {
        let params: [String: Any] = [TalksAddFollowApi.kTalkId: topicId]
        viewModel.loadTalksAddFollow(params)
    }
    /// 取消关注
    private func deleteFollow(_ topicId: Int) {
        let params: [String: Any] = [TalksAddFollowApi.kTalkId: topicId]
        viewModel.loadTalksDelFollow(params)
    }
    
    private func endRefreshing() {
        tableView.mj_header.endRefreshing()
        tableView.mj_footer.endRefreshing()
    }
    
}

// MARK: - Privite Funs
private extension CommunityRecommandController {
    
    func addViewModelCallback() {
        viewModel.talksListApiSuccess = { [weak self] (models, pageNumber) in
            self?.pageNumber = pageNumber
            self?.loadDataSuccess(models)
        }
        viewModel.talksListApiApiFail = { [weak self] in
            guard let strongSelf = self else { return }
            XSProgressHUD.hide(for:strongSelf.view, animated: false)
            strongSelf.endRefreshing()
            if strongSelf.pageNumber == 0 {
                NicooErrorView.showErrorMessage(.noNetwork, on: strongSelf.view, topMargin: safeAreaTopHeight, clickHandler: {
                    strongSelf.loadCommunityRecommand()
                })
            }
        }
        viewModel.talksAddOrDelFollowSuccess = { [weak self] isAdd in
            guard let strongSelf = self else { return }
            strongSelf.dataSource[strongSelf.actionIndex].has_count = isAdd ? .follow : .noFollow
            strongSelf.tableView.reloadRows(at: [IndexPath(row: strongSelf.actionIndex, section: 0)], with: .automatic)
        }
        viewModel.talksAddOrDelFollowFail = { (msg, isAdd) in
            XSAlert.show(type: .error, text: msg)
        }
    }
    func loadDataSuccess(_ listModels: [TalksModel]?) {
        endRefreshing()
        if let dataList = listModels {
            if pageNumber == 1 {
                dataSource = dataList
                if dataList.count == 0 {
                    //加载无数据占位
                    NicooErrorView.showErrorMessage(.noData, on: view, topMargin: safeAreaTopHeight, clickHandler: {
                        self.loadCommunityRecommand()
                    })
                }
            } else {
                dataSource.append(contentsOf: dataList)
            }
            loadMoreView.isHidden = (dataList.count < TalksListApi.kDefaultCount)
            tableView.reloadData()
            XSProgressHUD.hide(for:view, animated: false)
        }
        
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CommunityRecommandController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CommunityRecommandCell.cellHeight
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommunityRecommandCell.cellId, for: indexPath) as! CommunityRecommandCell
        let model = dataSource[indexPath.item]
        cell.setModel(model)
        cell.addTalksClickHandler = { [weak self] in
            self?.actionIndex = indexPath.row
            if model.has_count == nil { return }
            if model.id == nil { return }
            if model.has_count! == .follow {
                self?.deleteFollow(model.id!)
            } else {
                self?.addFollow(model.id!)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let talkVc = TalksMainController()
        talkVc.talksModel = dataSource[indexPath.item]
        talkVc.addFollowOrDelCallBack = {
            self.tableView.reloadData()
        }
        getCurrentVC()?.navigationController?.pushViewController(talkVc, animated: true)
    }
    
     func getCurrentVC() -> CommunityTopicController? {
        var next = view.superview
        while (next != nil) {
            let nextResponder = next?.next
            if (nextResponder is CommunityTopicController) {
                return nextResponder as? CommunityTopicController
            }
            next = next?.superview
        }
        return nil
    }
}

// MARK: - Layout
private extension CommunityRecommandController {
    
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
