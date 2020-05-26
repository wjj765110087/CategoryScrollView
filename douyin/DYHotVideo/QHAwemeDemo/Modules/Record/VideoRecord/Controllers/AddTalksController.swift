//
//  AddTalksController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/3.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork
import MJRefresh

class AddTalksController: QHBaseViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "添加话题"
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
        table.register(CommunityRecommandCell.classForCoder(), forCellReuseIdentifier: CommunityRecommandCell.cellId)
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
            weakSelf?.headerRefresh()
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
    
    var talksChooseBackHandler:((_ talks: TalksModel)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(navBar)
        view.addSubview(tableView)
        layoutPageSubviews()
        addViewModelCallback()
        loadTalks()
    }
    
    private func loadTalks() {
        NicooErrorView.removeErrorMeesageFrom(view)
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        viewModel.loadTalksList(nil)
    }
    
    private func headerRefresh() {
        viewModel.loadTalksList(nil)
    }
    
    private func loadNextpage() {
        viewModel.loadTalksNextPage(nil)
    }
    
    private func endRefreshing() {
        tableView.mj_header.endRefreshing()
        tableView.mj_footer.endRefreshing()
    }
    
}

// MARK: - Privite Funs
private extension AddTalksController {
    
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
                    strongSelf.viewModel.loadTalksList(nil)
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
                    NicooErrorView.showErrorMessage(.noData, on: view, topMargin: safeAreaTopHeight, clickHandler: nil)
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
extension AddTalksController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CommunityRecommandCell.cellHeight
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommunityRecommandCell.cellId, for: indexPath) as! CommunityRecommandCell
        let model = dataSource[indexPath.item]
        cell.setAddModel(model)
        cell.joinButton.setTitle("添加", for: .normal)
        cell.addTalksClickHandler = { [weak self] in
            self?.talksChooseBackHandler?(model)
            self?.navigationController?.popViewController(animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let talkVc = TalksMainController()
        talkVc.talksModel = dataSource[indexPath.item]
        navigationController?.pushViewController(talkVc, animated: true)
    }
}

// MARK: - Layout
private extension AddTalksController {
    
    func layoutPageSubviews() {
        layoutNavBar()
        layoutTableView()
    }
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
        }
    }
   func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(safeAreaTopHeight)
        }
    }
}


// MARK: - QHNavigationBarDelegate
extension AddTalksController: QHNavigationBarDelegate  {
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}
