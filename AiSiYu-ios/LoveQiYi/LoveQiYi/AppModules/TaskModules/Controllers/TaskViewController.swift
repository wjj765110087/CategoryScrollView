//
//  TaskViewController.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/17.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit
import MJRefresh

class TaskViewController: BaseViewController {
  
    private var header: TaskHeader = {
        guard let view = Bundle.main.loadNibNamed("TaskHeader", owner: nil, options: nil)?.last as? TaskHeader else {return TaskHeader()}
        view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 64)
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: view.bounds, style: .grouped)
        table.backgroundColor = UIColor.clear
        table.showsVerticalScrollIndicator = false
        table.allowsSelection = false
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(TaskItemListCell.classForCoder(), forCellReuseIdentifier: TaskItemListCell.cellId)
        table.register(InviteBotCell.classForCoder(), forCellReuseIdentifier: InviteBotCell.cellId)
        table.register(InviteRuleTitleCell.classForCoder(), forCellReuseIdentifier: InviteRuleTitleCell.cellId)
        table.register(UINib(nibName: "InvitedRuleListCell", bundle: Bundle.main), forCellReuseIdentifier: InvitedRuleListCell.cellId)
        table.mj_header = refreshView
        return table
    }()
    
    private let viewModel = TasksViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(header)
        view.addSubview(tableView)
        layoutPageSubviews()
        tableView.tableFooterView = UIView()
        navConfig()
        addViewModelCallBack()
        loadTask()
        addRefreshTaskListObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerInfoSet()
    }
    
    override func loadFirstPage() {
        refreshData()
    }
    
    private func navConfig() {
        navBar.backButton.isHidden = true
        rightBtn.isHidden = true
        navBar.backgroundColor = UIColor.white
        navBar.lineView.backgroundColor = UIColor.clear
        navBar.snp.updateConstraints { (make) in
            make.height.equalTo(statusBarHeight + 8)
        }
    }
    
    // MARK: - 添加任务完成监听
    private func addRefreshTaskListObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name.kLoadTaskListNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didUserBeenKickedOut), name: Notification.Name.kUserBeenKickedOutNotification, object: nil)
    }
    
    private func headerInfoSet() {
        header.headerImg.image = UserModel.share().getUserHeader()
        header.nameLab.text = UserModel.share().userInfo?.nick_name ?? "爱私欲"
        if let inviteCount = UserModel.share().userInfo?.invite, !inviteCount.isEmpty {
            if let count = Int(inviteCount) {
                header.inviteCountLab.attributedText = TextSpaceManager.configColorString(allString: "累计邀请人数: \(count)", attribStr: "\(count)", kAppDefaultTitleColor, UIFont.systemFont(ofSize: 18))
            }
        }
    }
    
    private func showGiftMsg() {
        if let cc = viewModel.taskList?.coupon {
            XSAlert.show(type: .success, text: "恭喜获得\(cc)阅读卷。")
        }
    }
    
    private func endRefresh() {
        refreshView.endRefreshing()
        XSProgressHUD.hide(for: view, animated: false)
    }
    
    private func showUserInvitedCard() {
        let controller = IDCardInfoController()
        controller.isCardId = false
        controller.view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        controller.modalPresentationStyle = .overCurrentContext
        self.modalPresentationStyle = .currentContext
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.tabBarController?.present(controller, animated: false, completion: nil)
    }
}

// MARK: - dataAccess funcs
extension TaskViewController {
    
    /// 头部刷新
    @objc private func refreshData() {
        viewModel.loadTasksList()
    }
    
    /// 请求列表
    private func loadTask() {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        viewModel.loadTasksList()
    }
    
    /// 签到操作
    private func sign() {
        viewModel.loadSignApi()
    }
    
    /// 接口请求回调
    private func addViewModelCallBack() {
        viewModel.loadTaskListSuccessHandler = { [weak self] in
            guard let strongSelf = self else { return }
            if (strongSelf.viewModel.taskList?.coupon ?? 0) > 0 && Int(strongSelf.viewModel.taskList?.sign ?? "0") ?? 0 == 3 {
                strongSelf.showGiftMsg()
            }
            strongSelf.headerInfoSet()
            strongSelf.tableView.reloadData()
            strongSelf.endRefresh()
        }
        viewModel.loadTaskListFailHandler = { [weak self] in
            self?.endRefresh()
        }
        
        viewModel.dailySignInFailHandler = { (msg) in
            XSAlert.show(type: .error, text: msg ?? "签到失败")
        }
    }
    private func taskClick(_ index: Int) {
        if let tasks = viewModel.taskList?.task, tasks.count > index {
            let task = tasks[index]
            if (task.key ?? .newUser) == .bindMobile {
                let verbPhone = VerbPhoneController()
                navigationController?.pushViewController(verbPhone, animated: true)
            } else if (task.key ?? .newUser) == .saveCard {
                let idcard = IDCardInfoController()
                navigationController?.pushViewController(idcard, animated: true)
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension TaskViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 2 {
            return 0
        }
        return 8
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 8))
            view.backgroundColor = UIColor(r: 244, g: 244, b: 244)
            return view
        }
        return nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 90
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return 75
            } else {
                return 68
            }
        } else if indexPath.section == 2 {
           return 190
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return (viewModel.taskList?.rule?.count ?? 0) + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: TaskItemListCell.cellId, for: indexPath) as! TaskItemListCell
            cell.setTaskModels(viewModel.taskList?.task)
            cell.itemClickHandler = { [weak self] (index) in
                self?.taskClick(index)
            }
            return cell
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: InviteRuleTitleCell.cellId, for: indexPath) as! InviteRuleTitleCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: InvitedRuleListCell.cellId, for: indexPath) as! InvitedRuleListCell
                if let rules = viewModel.taskList?.rule, rules.count > 0 {
                    if indexPath.row == rules.count - 1 {
                        cell.lineView.isHidden = true
                    }
                    cell.setModel(rules[indexPath.row - 1], index: indexPath.row)
                }
                cell.doneTaskClick = { [weak self] in
                    self?.showUserInvitedCard()
                }
                return cell
            }
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: InviteBotCell.cellId, for: indexPath) as! InviteBotCell
            cell.cardActionHandler = { [weak self] in
                self?.showUserInvitedCard()
            }
            return cell
        }
        
        return UITableViewCell()
    }
}


// MARK: - Layout
private extension TaskViewController {
    func layoutPageSubviews() {
        layoutHeaderView()
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
            make.top.equalTo(header.snp.bottom)
        }
    }
    
    func layoutHeaderView() {
        header.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
            make.height.equalTo(70)
        }
    }
}


// MARK: - 被挤掉提示
extension TaskViewController {
    
    @objc private func didUserBeenKickedOut() {
        DLog("didUserBeenKickedOut  ===== AdController")
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.window?.rootViewController?.showDialog(title: "被挤掉提示", message: XSAlertMessages.kNotAvailTokenAlertMsg, okTitle: "确认", cancelTitle: "取消", okHandler: {
                DLog("跳转到官网")
            }, cancelHandler: nil)
        }
    }
}
