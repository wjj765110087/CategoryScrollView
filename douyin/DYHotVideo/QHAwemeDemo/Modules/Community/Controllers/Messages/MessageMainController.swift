//
//  MessageMainController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/2.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//  消息

import UIKit
import MJRefresh


class MessageMainController: QHBaseViewController {

    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "消息"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = ConstValue.kViewLightColor
        bar.backButton.isHidden = false
        bar.titleLabel.isHidden = false
        bar.lineView.isHidden = true
        bar.delegate = self
        return bar
    }()
    private lazy var headerView: MessageHeaderView = {
        let view = MessageHeaderView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 130))
        return view
    }()
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = UIColor.clear
        table.showsVerticalScrollIndicator = false
        table.allowsSelection = true
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(MessageMainCell.classForCoder(), forCellReuseIdentifier: MessageMainCell.cellId)
        return table
    }()
    
    var viewModel: MessageViewModel = MessageViewModel()
    var messageNum: MessageNumModel = MessageNumModel()
    var systemMessage: MessageModel = MessageModel()
    var maxId: Int?
    
    var systemMessageModels = [SystemMessageModel]()
    var feedbackMessageModels = [FeedModel]()
    
    var icons: [String] = ["messageFeedBack","app"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(navBar)
        view.addSubview(headerView)
        view.addSubview(tableView)
        layoutPageSubViews()
        addHeaderViewCallBack()
        addViewModelCallBack()
        loadMessageNumData()
        loadSystemMessageData()
        loadFeedbackMessageData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.kLookMessageNotification, object: nil)
    }
}

//MARK: - CallBack
extension MessageMainController {
    
    private func addHeaderViewCallBack() {
        headerView.didClickCellHandler = { [weak self] index in
            guard let strongSelf = self else {return}
            switch index {
            case 0:
                let noticeVC = MessageNoticeController()
            
                if let model = strongSelf.messageNum.Notice {
                    if let maxId = model.max_id {
                        noticeVC.maxId = maxId
                    }
                }
                
                strongSelf.navigationController?.pushViewController(noticeVC, animated: true)
            case 1:
                let zanVC = MessageZansController()
                if let model = strongSelf.messageNum.Comment {
                    if let maxId = model.max_id {
                        zanVC.maxId = maxId
                    }
                
                }
                strongSelf.navigationController?.pushViewController(zanVC, animated: true)
            case 2:
                let pinglunVC = MessagePinglunController()
                if let model = strongSelf.messageNum.Follower {
                    if let maxId = model.max_id {
                        pinglunVC.maxId = maxId
                    }
                }
                strongSelf.navigationController?.pushViewController(pinglunVC, animated: true)
            case 3:
                let fansVC = MessageFansController()
                if let model = strongSelf.messageNum.Praise {
                    if let maxId = model.max_id {
                        fansVC.maxId = maxId
                    }
                }
                strongSelf.navigationController?.pushViewController(fansVC, animated: true)
            default:
                break
            }
        }
    }
    
    private func addViewModelCallBack() {
        
        viewModel.messageNewNumSuccessHandler = { [weak self]  messageNewNumList in
            guard let strongSelf = self else {return}
            strongSelf.messageNum = messageNewNumList
            var messageNumModels = [MessageModel]()
            if let noticeModel = messageNewNumList.Notice {
                
                messageNumModels.append(noticeModel)
            }
            if let praiseModel = messageNewNumList.Praise {
                messageNumModels.append(praiseModel)
            }
            if let commentModel = messageNewNumList.Comment {
                messageNumModels.append(commentModel)
            }
            if let followerModel = messageNewNumList.Follower {
                messageNumModels.append(followerModel)
            }
            if let systemModel = messageNewNumList.System {
                strongSelf.systemMessage = systemModel
            }
            strongSelf.headerView.setModels(models: messageNumModels)
            
            
        }
        
        viewModel.systemMessageSuccessHandler = { [weak self] model in
            guard let strongSelf = self else {return}
            var models = [SystemMessageModel]()
            if let data = model.data, let current_page = model.current_page {
                if current_page == 1 {
                    if data.count == 0 {
                  
                    }
                    models = data
                } else {
                    models.append(contentsOf: data)
                }
            }
           strongSelf.systemMessageModels = models
           strongSelf.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .none)
        }
        
        viewModel.feedbackMessageSuccessHandler = { [weak self] model in
            guard let strongSelf = self else {return}
            strongSelf.feedbackMessageModels = model
            strongSelf.tableView.reloadRows(at: [IndexPath.init(row: 0, section: 0)], with: .none)
        }
    }
}

//MARK: -LoadData
extension MessageMainController {
    
    private func loadMessageNumData() {
        viewModel.loadMessageNewNumData(params: nil)
    }
    
    private func loadSystemMessageData() {
        let params = [SystemMessageListApi.kAlias: "SYSTEM-MSG"] as [String : Any]
        viewModel.loadMessageNewNumData(params: params)
    }
    
    private func loadFeedbackMessageData() {
        viewModel.loadFeedBackMessageData(params: nil)
    }
}


// MARK: - UITableViewDataSource && UITableViewDelegate
extension MessageMainController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageMainCell.cellId, for: indexPath) as! MessageMainCell
        if indexPath.row == 0 {
            cell.icomImageView.image = UIImage(named: "app")
            cell.titleLab.text = "系统消息"
            if systemMessageModels.count > 0 {
                let model = systemMessageModels[0]
                cell.subLab.text = model.alter?.title ?? ""
                cell.timeLab.text = model.created_at ?? ""
            }
        } else if indexPath.row == 1 {
            cell.icomImageView.image = UIImage(named: "messageFeedBack")
            cell.titleLab.text = "意见反馈"
            if feedbackMessageModels.count > 0 {
                let model = feedbackMessageModels[0]
                cell.subLab.text = model.title ?? ""
                cell.timeLab.text = model.created_at ?? ""
            }
//            cell.subLab.text = ""
//            cell.timeLab.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MessageMainCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row == 0 {
            let messageSystemNoticeVC = MessageSystemNoticeController()
//            messageSystemNoticeVC.systemNoticeHandler = { [weak self] systemNotice in
//                guard let strongSelf = self else {return}
//                let cell = strongSelf.tableView.cellForRow(at: indexPath) as! MessageMainCell
//                cell.setModel(model: systemNotice)
//                strongSelf.tableView.reloadRows(at: [indexPath], with: .none)
//            }
//            if let systemModel = self.messageNum.System {
//                messageSystemNoticeVC.maxId = systemModel.max_id
//            }
            self.navigationController?.pushViewController(messageSystemNoticeVC, animated: true)
        } else {
            let helpVC = HelpController()
            self.navigationController?.pushViewController(helpVC, animated: true)
        }
    }
}

// MARK: - Layout
extension MessageMainController {
    
    private func layoutPageSubViews() {
        layoutNavBar()
        layoutHeaderView()
        layoutTableView()
    }
    
    private func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(safeAreaTopHeight)
        }
    }
    
    private func layoutHeaderView() {
        headerView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
            make.height.equalTo(130)
        }
    }
    
    private func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
}

// MARK: - QHNavigationBarDelegate
extension MessageMainController: QHNavigationBarDelegate  {
    func backAction() {
        NotificationCenter.default.post(name: Notification.Name.kMessageDotNotification, object: nil, userInfo: nil)
        navigationController?.popViewController(animated: true)
    }
}
