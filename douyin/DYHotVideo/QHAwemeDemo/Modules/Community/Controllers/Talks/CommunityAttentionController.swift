//
//  CommunityAttentionController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/2.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//  社区关注

import UIKit
import NicooNetwork
import MJRefresh

class CommunityAttentionController: QHBaseViewController {

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
        table.register(CommunityAttentionCell.classForCoder(), forCellReuseIdentifier: CommunityAttentionCell.cellId)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(tableView)
        layoutPageSubviews()
        tableView.contentInset = UIEdgeInsets(top: UIDevice.current.isXSeriesDevices() ? 80 : 53, left: 0, bottom: UIDevice.current.isiPhoneXSeriesDevices() ? 83 : 90 , right: 0)
        addViewModelCallback()
        loadCommunityAttention()
    }
    
    private func loadCommunityAttention() {
        NicooErrorView.removeErrorMeesageFrom(view)
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        viewModel.loadTalksCollectList(nil)
    }
    
    private func firstRefresh() {
        viewModel.loadTalksCollectList(nil)
    }
    
    private func loadNextpage() {
        viewModel.loadTalksCollectNextPage(nil)
    }
    
    private func endRefreshing() {
        tableView.mj_header.endRefreshing()
        tableView.mj_footer.endRefreshing()
    }
    
}

// MARK: - Privite Funs
private extension CommunityAttentionController {
    
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
                    strongSelf.loadCommunityAttention()
                })
            }
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
                        self.loadCommunityAttention()
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
extension CommunityAttentionController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CommunityAttentionCell.cellHeight
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommunityAttentionCell.cellId, for: indexPath) as! CommunityAttentionCell
        cell.setModel(dataSource[indexPath.item])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let talkVc = TalksMainController()
        let talks = dataSource[indexPath.item]
        talks.has_count = .follow
        talkVc.talksModel = talks
        talkVc.addFollowOrDelCallBack = {
            self.loadCommunityAttention()
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
private extension CommunityAttentionController {
    
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
