//
//  AdjectiveController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/18.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

//import UIKit
//import NicooNetwork
//import MJRefresh
//
//class AdjectiveController: QHBaseViewController {
//
//    private lazy var navBar: QHNavigationBar = {
//        let bar = QHNavigationBar()
//        bar.titleLabel.text = "明细"
//        bar.titleLabel.textColor = UIColor.white
//        bar.backgroundColor = ConstValue.kViewLightColor
//        bar.backButton.isHidden = false
//        bar.titleLabel.isHidden = false
//        bar.lineView.isHidden = true
//        bar.delegate = self
//        return bar
//    }()
//
//    private lazy var tableView: UITableView = {
//        let table = UITableView(frame: .zero, style: .plain)
//        table.backgroundColor = UIColor.clear
//        table.showsVerticalScrollIndicator = false
//        table.allowsSelection = true
//        table.delegate = self
//        table.dataSource = self
//        table.separatorStyle = .none
//        table.register(MessageSystemNoticeCell.classForCoder(), forCellReuseIdentifier: MessageSystemNoticeCell.cellId)
//        table.mj_header = refreshView
//        table.mj_footer = loadMoreView
//        return table
//    }()
//
//    lazy private var loadMoreView: MJRefreshAutoNormalFooter = {
//        weak var weakSelf = self
//        let loadmore = MJRefreshAutoNormalFooter(refreshingBlock: {
//            weakSelf?.loadNextpage()
//        })
//        loadmore?.setTitle("", for: .idle)
//        loadmore?.setTitle("已经到底了", for: .noMoreData)
//        loadmore?.stateLabel.font = ConstValue.kRefreshLableFont
//        return loadmore!
//    }()
//
//    lazy private var refreshView: MJRefreshGifHeader = {
//        weak var weakSelf = self
//        let mjRefreshHeader = MJRefreshGifHeader(refreshingBlock: {
//            weakSelf?.firstRefresh()
//        })
//        var gifImages = [UIImage]()
//        for string in ConstValue.refreshImageNames {
//            gifImages.append(UIImage(named: string)!)
//        }
//        mjRefreshHeader?.setImages(gifImages, for: .refreshing)
//        mjRefreshHeader?.setImages(gifImages, for: .idle)
//        mjRefreshHeader?.stateLabel.font = ConstValue.kRefreshLableFont
//        mjRefreshHeader?.lastUpdatedTimeLabel.font = ConstValue.kRefreshLableFont
//        return mjRefreshHeader!
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//    }
//
//    private func loadNotice() {
//        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
//        NicooErrorView.removeErrorMeesageFrom(view)
//        _ = noticeMessageApi.loadData()
//    }
//
//    private func firstRefresh() {
//        _ = noticeMessageApi.loadData()
//    }
//
//    private func loadNextpage() {
//        _ = noticeMessageApi.loadNextPage()
//    }
//
//    private func endRefreshing() {
//        tableView.mj_header.endRefreshing()
//        tableView.mj_footer.endRefreshing()
//    }
//}
//
//extension AdjectiveController: UITableViewDataSource, UITableViewDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return models.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: MessageSystemNoticeCell.cellId, for: indexPath) as! MessageSystemNoticeCell
//        cell.setModel(model: models[indexPath.row])
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return MessageSystemNoticeCell.cellHeight
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        let model = models[indexPath.row]
////        if let type = model.type, let dynamic_type = model.dynamic_type   {
////            if type == .follow { ///关注
////                if dynamic_type == .imageText {  ///跳转到动态详情
////                    goToDynamicDetail(model: model)
////                } else if dynamic_type == .video { ///跳转到视频详情
////                    goToVideoPlay(model: model)
////                }
////            } else if type == .topic {          ///话题
////                if dynamic_type == .imageText {
////                    goToDynamicDetail(model: model)
////                } else if dynamic_type == .video {
////                    goToVideoPlay(model: model)
////                }
////            }
////        }
////        tableView.deselectRow(at: indexPath, animated: false)
//    }
//}
//
//// MARK: -  NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
//extension AdjectiveController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
//
//    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
//        var params = [String : Any]()
//        return params
//
//    }
//
//    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
//        XSProgressHUD.hide(for: view, animated: false)
////        if manager is NoticeMessageListApi {
////            if let model = manager.fetchJSONData(MessageReformer()) as? NoticeMessageListModel {
////                if let data = model.data, let currentPage = model.current_page {
////                    if currentPage == 1 {
////                        models = data
////                        if data.count == 0 {
////                            NicooErrorView.showErrorMessage(.noData, on: view, topMargin: safeAreaTopHeight + 100, clickHandler: nil)
////                        }
////                    } else {
////                        models.append(contentsOf: data)
////                    }
////                    self.getMessageMaxId()
////                    self.loadMoreView.isHidden = data.count < NoticeMessageListApi.kDefaultCount
////                    endRefreshing()
////                    tableView.reloadData()
////                }
////            }
////        }
//
//    }
//
//    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
//        XSProgressHUD.hide(for: view, animated: false)
//    }
//}
//
//// MARK: - Layout
//extension AdjectiveController {
//
//    private func layoutPageSubViews() {
//        layoutNavBar()
//        layoutTableView()
//    }
//
//    private func layoutNavBar() {
//        navBar.snp.makeConstraints { (make) in
//            make.leading.trailing.top.equalToSuperview()
//            make.height.equalTo(safeAreaTopHeight)
//        }
//    }
//
//    private func layoutTableView() {
//        tableView.snp.makeConstraints { (make) in
//            make.leading.trailing.equalToSuperview()
//            make.top.equalTo(navBar.snp.bottom)
//            if #available(iOS 11.0, *) {
//                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
//            } else {
//                make.bottom.equalToSuperview()
//            }
//        }
//    }
//}
//
//// MARK: - QHNavigationBarDelegate
//extension AdjectiveController: QHNavigationBarDelegate  {
//    func backAction() {
//        navigationController?.popViewController(animated: true)
//    }
//}
