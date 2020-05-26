//
//  MyGiftsController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019-12-23.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import MJRefresh

class MyGiftsController: QHBaseViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "我的奖品"
        bar.titleLabel.textColor = UIColor.init(r: 34, g: 34, b: 34)
        bar.backButton.isHidden = false
        bar.lineView.isHidden = true
        bar.backgroundColor = UIColor.white
        bar.backButton.setImage(UIImage(named: "navBackBlack"), for: .normal)
        bar.delegate = self
        return bar
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UINib.init(nibName: "MyGiftTableCell", bundle: Bundle.main), forCellReuseIdentifier: MyGiftTableCell.cellId)
        tableView.mj_header = refreshView
        tableView.mj_footer = loadMoreView
        return tableView
    }()
    lazy private var loadMoreView: MJRefreshAutoNormalFooter = {
        weak var weakSelf = self
        let loadmore = MJRefreshAutoNormalFooter(refreshingBlock: {
            weakSelf?.loadNextpage()
        })
        loadmore?.isHidden = true
        loadmore?.stateLabel.font = ConstValue.kRefreshLableFont
        return loadmore!
    }()
    lazy private var refreshView: MJRefreshGifHeader = {
        weak var weakSelf = self
        let mjRefreshHeader = MJRefreshGifHeader(refreshingBlock: {
            weakSelf?.loadFirstpage()
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
    
    var giftModelList = [MyGiftModle]()
    
    let viewModel = GameViewModel()
    
    deinit {
        DLog("vc - Gift relase")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(r: 244, g: 244, b: 244)
        view.addSubview(navBar)
        view.addSubview(tableView)
        layoutPageViews()
        addViewModelCallback()
        loadData()
    }
    
    private func loadData() {
        NicooErrorView.removeErrorMeesageFrom(view)
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        viewModel.loadMgGiftListData()
    }
    
    private func loadFirstpage() {
        viewModel.loadMgGiftListData()
    }
    
    private func loadNextpage() {
        viewModel.loadMyGiftListNextPage()
    }
    
    private func addViewModelCallback() {
        viewModel.myGiftListSuccessHandler = { [weak self] (models, pageNumber) in
            guard let strongSelf = self else { return }
            if pageNumber == 1 {
                strongSelf.giftModelList = models
                if models.count == 0 {
                    NicooErrorView.showErrorMessage(.noData, "您还没有奖品 \n快去夺宝吧", on: strongSelf.view, topMargin: safeAreaTopHeight+30) {
                        strongSelf.loadData()
                    }
                }
            } else {
                strongSelf.giftModelList.append(contentsOf: models)
            }
            strongSelf.loadMoreView.isHidden = models.count < GameGiftListApi.kDefaultCount
            strongSelf.tableView.reloadData()
            strongSelf.endRefreshing()
        }
        viewModel.myGiftListFailHandler = { [weak self] (msg, pageNumber) in
            guard let strongSelf = self else { return }
            strongSelf.endRefreshing()
            if pageNumber == 1 {
                NicooErrorView.showErrorMessage(.noData, "数据加载异常，请重试", on: strongSelf.view, topMargin: safeAreaTopHeight+30) {
                    strongSelf.loadData()
                }
            }
        }
    }
    
    private func endRefreshing() {
        loadMoreView.endRefreshing()
        refreshView.endRefreshing()
        XSProgressHUD.hide(for: view, animated: false)
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension MyGiftsController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  giftModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyGiftTableCell.cellId, for: indexPath) as! MyGiftTableCell
        cell.setGiftModel(giftModelList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 123.0
    }
    
}

// MARK: - QHNavigationBarDelegate
extension MyGiftsController: QHNavigationBarDelegate  {
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: -Layout
private extension MyGiftsController {
    
    func layoutPageViews() {
        layoutNavBar()
        layoutTableView()
        
    }
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(safeAreaTopHeight)
        }
    }
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(navBar.snp.bottom)
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
