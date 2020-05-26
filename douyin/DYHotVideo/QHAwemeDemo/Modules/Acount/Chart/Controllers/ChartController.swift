//
//  ChartController.swift
//  DouCartoonDemo
//
//  Created by mac on 2019/6/7.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit
import NicooNetwork

class ChartController: BaseController {
    
    private var bottomView: ChartBottomView = {
        guard let view = Bundle.main.loadNibNamed("ChartBottomView", owner: nil, options: nil)?[0] as? ChartBottomView else { return ChartBottomView() }
        view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 59)
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.clear
        table.showsVerticalScrollIndicator = false
        table.allowsSelection = false
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(UINib.init(nibName: "FeedChatInfoCell", bundle: Bundle.main), forCellReuseIdentifier: FeedChatInfoCell.cellId)
        table.register(UINib.init(nibName: "ChartYouCell", bundle: Bundle.main), forCellReuseIdentifier: ChartYouCell.cellId)
        table.register(UINib.init(nibName: "ChartMeCell", bundle: Bundle.main), forCellReuseIdentifier: ChartMeCell.cellId)
        table.register(UINib.init(nibName: "ImgChartCell", bundle: Bundle.main), forCellReuseIdentifier: ImgChartCell.cellId)
        table.register(UINib.init(nibName: "ImgChartBackCell", bundle: Bundle.main), forCellReuseIdentifier: ImgChartBackCell.cellId)
        return table
    }()
    private lazy var imageUpLoad: UploadImageTool = {
        let upload = UploadImageTool()
        upload.delegate = self
        return upload
    }()
    
    private lazy var msgApi: UserMsgLsApi = {
        let api = UserMsgLsApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    var feedModel = FeedModel()
    
    var msgList = [MsgModel]()
    
    let viewModel = UserInfoViewModel()
    
    var imageSend: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        navBar.titleLabel.text = "客服回复"
        navBar.backButton.setImage(UIImage(named: "feedbackBack"), for: .normal)
        navBar.titleLabel.textColor = .white
        navBar.backgroundColor = ConstValue.kViewLightColor
        navBar.lineView.isHidden = true
        view.addSubview(bottomView)
        bottomView.contentTf.delegate = self
        view.addSubview(tableView)
        layoutPageSubviews()
        viewModelCallback()
        bottomViewCallback()
        loadData()
    }

    override func loadData() {
        NicooErrorView.removeErrorMeesageFrom(view)
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        let _  = msgApi.loadData()
    }
    
    override func loadNextPage() {
        
    }
    
    private func viewModelCallback() {
        viewModel.replyApiSuccessHandler = { [weak self] (msgModel) in
            guard let strongSelf = self else { return }
            strongSelf.msgList.insert(msgModel, at: 0)
            strongSelf.tableView.reloadData()
            strongSelf.tableView.scrollToRow(at: IndexPath.init(row: strongSelf.msgList.count - 1, section: 1), at: .middle, animated: true)
            XSProgressHUD.hide(for: strongSelf.view, animated: false)
        }
        viewModel.replyApiFailHandler = { [weak self] (msg) in
            guard let strongSelf = self else { return }
            XSAlert.show(type: .error, text: msg)
            XSProgressHUD.hide(for: strongSelf.view, animated: false)
        }
    }
    
    private func bottomViewCallback() {
        bottomView.actionHandler = { [weak self] (actionId) in
            if actionId == 1 { // 选择图片上查
                self?.openLocalPhotoAlbum()
            } else {  /// 发送消息
                self?.sendMsg(self?.bottomView.contentTf.text, type: "1")
            }
        }
    }
    
    private func sendMsg(_ content: String?, type: String) {
        XSProgressHUD.showCustomAnimation(msg: "发送中...", onView: view, imageNames: nil, bgColor: nil, animated: false)
        var params = [String: Any]()
        params[FeedReplyApi.kContent] = content
        params[FeedReplyApi.kType] = type
        params[FeedReplyApi.kFeed_id] = "\(feedModel.id ?? 0)"
        viewModel.replyFeedMsg(params)
        bottomView.contentTf.text = nil
        bottomView.contentTf.resignFirstResponder()
    }
    
    // MARK: - 相册选图
    private func openLocalPhotoAlbum() {
        _ = self.jh_presentPhotoVC(1, completeHandler: {  [weak self]  items in
            guard let strongSelf = self else { return }
            for item in items {
                let _ = item.originalImage({ (originImage) in
                     strongSelf.imageUpLoad.upload(originImage)
                })
            }
        })
    }
    
    private func showPhotoBrowser(_ pictures:[String], _ index: Int) {
        // 网图加载器
        let loader = JXKingfisherLoader()
        // 数据源
        let source = JXNetworkingDataSource(photoLoader: loader, numberOfItems: { () -> Int in
            return pictures.count
        }, placeholder: { index -> UIImage? in
            return UIImage(named: "playCellBg")
        }) { index -> String? in
            return pictures[index]
        }
        // 视图代理，实现了光点型页码指示器
        let delegate = JXDefaultPageControlDelegate() // 视图代理，实现了光点型页码指示器
        // 转场动画
        let trans = JXPhotoBrowserZoomTransitioning { (browser, index, view) -> UIView? in
            return nil
        }
        // 打开浏览器
        JXPhotoBrowser(dataSource: source, delegate: delegate, transDelegate: trans)
            .show(pageIndex: index)
    }
    
    private func loadDataSuccess(_ model: MsgLsModel) {
        if let list = model.data , list.count > 0 {
            msgList = list
            tableView.reloadData()
            tableView.scrollToRow(at: IndexPath(row: msgList.count - 1, section: 1), at: .middle, animated: false)
        }
    }
}

extension ChartController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMsg(textField.text, type: "1")
        return true
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension ChartController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100.0
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return msgList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FeedChatInfoCell.cellId, for: indexPath) as! FeedChatInfoCell
            cell.setModel(feedModel)
            if let imags = feedModel.cover_url {
                cell.setImage(imags)
                cell.imageClickhandler = { [weak self] (index) in
                    self?.showPhotoBrowser(imags, index)
                }
            }
            return cell
        } else {
            let model = msgList.reversed()[indexPath.row]
            if model.user_id ?? 0 == 0 {  /// 表示是管理员
                if (model.type ?? .text) == .text {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ChartYouCell.cellId, for: indexPath) as! ChartYouCell
                    cell.setModel(model)
                    return cell
                } else if (model.type ?? .text) == .image {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ImgChartBackCell.cellId, for: indexPath) as! ImgChartBackCell
                    cell.setModel(model)
                    cell.pictureClick = { [weak self] in
                       self?.showPhotoBrowser([model.content ?? ""], 0)
                    }
                    return cell
                }
            } else {
                if (model.type ?? .text) == .text {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ChartMeCell.cellId, for: indexPath) as! ChartMeCell
                    cell.setModel(model)
                    return cell
                } else if (model.type ?? .text) == .image {
                    let cell = tableView.dequeueReusableCell(withIdentifier: ImgChartCell.cellId, for: indexPath) as! ImgChartCell
                    cell.setModel(model)
                    cell.pictureClick = { [weak self] in
                        self?.showPhotoBrowser([model.content ?? ""], 0)
                    }
                    return cell
                }
            }
            return UITableViewCell()
        }
    }
    
}

// MARK: - UploadImageDelegate
extension ChartController: UploadImageDelegate {
    
    func paramsForAPI(_ uploadImageTool: UploadImageTool) -> [String : String]? {
        XSProgressHUD.showProgress(msg: nil, onView: view, animated: false)
        return nil
    }
    
    func uploadImageMethod(_ uploadImageTool: UploadImageTool) -> String {
        return "/\(ConstValue.kApiVersion)/feedback/upload"
    }
    
    func uploadImageSuccess(_ uploadImageTool: UploadImageTool, resultDic: [String : Any]?) {
        XSProgressHUD.hide(for: view, animated: false)
        if let imageName = resultDic?["result"] as? String {
            sendMsg(imageName, type: "2")
        }
    }
    
    func uploadImageFailed(_ uploadImageTool: UploadImageTool, errorMessage: String?) {
        XSProgressHUD.hide(for: view, animated: false)
        XSAlert.show(type: .error, text: "图片上传失败")
    }
    
    func uploadFailedByTokenError() {
        XSProgressHUD.hide(for: view, animated: false)
    }
    
}

// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension ChartController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        var params = [String: Any]()
        if manager is UserMsgLsApi {
            params[UserMsgLsApi.kFeed_id] = "\(feedModel.id ?? 0)"
            return params
        }
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is UserMsgLsApi {
            if let lsModel = manager.fetchJSONData(UserReformer()) as? MsgLsModel {
                loadDataSuccess(lsModel)
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is UserMsgLsApi {
            navBar.titleLabel.text = "客服回复（未连接）"
        }
    }
}


// MARK: - Description
private extension ChartController {
    func layoutPageSubviews() {
        layoutBottomView()
        layoutTableView()
    }
    
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
             make.bottom.equalTo(bottomView.snp.top)
        }
    }
    
    func layoutBottomView() {
        bottomView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(safeAreaBottomHeight + 55)
        }
    }
    
    
}
