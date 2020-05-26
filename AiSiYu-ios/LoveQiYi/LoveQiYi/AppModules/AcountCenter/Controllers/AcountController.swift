//
//  AcountController.swift
//  LoveAVDemo
//
//  Created by mac on 2019/7/15.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit

class AcountController: BaseViewController {
    
    private let imageIcons = ["VipIcon","ExchangeIcon","myFavorIcon","HistoryIcon","","DownloadIcon","FeedBackIcon","LuyouIcon"]
    private let titleS = ["会员中心","兑换中心","我的收藏","历史记录","","我的下载","意见反馈","撸友交流"]
    private let bgFakeVirw: UIView = {
        let view = UIView()
        view.backgroundColor = kBarColor
        return view
    }()
    private let headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 162))
        view.clipsToBounds = true
        return view
    }()
    private var header: UserHeaderView = {
        guard let view = Bundle.main.loadNibNamed("UserHeaderView", owner: nil, options: nil)?[0] as? UserHeaderView else { return UserHeaderView() }
        return view
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AcountListCell.classForCoder(), forCellReuseIdentifier: AcountListCell.cellId)
        tableView.register(HistoryCell.classForCoder(), forCellReuseIdentifier: HistoryCell.cellId)
        return tableView
    }()
    
    private let userViewModel = AcountViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didUserBeenKickedOut), name: Notification.Name.kUserBeenKickedOutNotification, object: nil)
        view.backgroundColor = UIColor.white
       
        view.addSubview(bgFakeVirw)
        headerView.addSubview(header)
        layoutHeaderView()
        view.addSubview(tableView)
        layoutPageSubviews()
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        
        navConfig()
        
        /// 每次初始化，先弹用户idcard
        showUserInvitedCard()
        
        addHeaderActions()
        addUserModelcallback()
        setUpUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.layoutIfNeeded()
        userViewModel.loadUserInfo()
    }
    
    override func rightButtonClick(_ sender: UIButton) {
        let setting = SettingController()
        navigationController?.pushViewController(setting, animated: true)
    }
    
    private func setUpUserInfo() {
        header.headerImg.image = UserModel.share().getUserHeader()
        header.userName.text = UserModel.share().userInfo?.nick_name ?? "老湿"
        header.inviteCountBtn.setTitle("已邀请: \(UserModel.share().userInfo?.invite ?? "0")", for: .normal)
        header.vipButton.isSelected = UserModel.share().userInfo?.is_vip?.boolValue ?? false
        if UserModel.share().userInfo?.is_vip?.boolValue ?? false {
            header.mesgLabel.text = "到期时间:\(UserModel.share().userInfo?.vip_expire ?? "")"
            header.vipButton.backgroundColor = UIColor(r: 255, g: 42, b: 49)
        } else {
            header.mesgLabel.text = "开通会员享VIP特权"
            header.vipButton.backgroundColor = UIColor(r: 88, g: 88, b: 88)
        }
        header.inviteCount.text = UserModel.share().userInfo?.view_info ?? "0"
        header.readJuan.text = "\(UserModel.share().userInfo?.remain_day ?? 0)"
        header.readedCount.text = UserModel.share().userInfo?.download_info ?? "0"
    }
    
    private func addHeaderActions() {
        header.buttonClickHandler = { [weak self] (actionId) in
            if actionId == 1 {
                /// 邀请记录
                let inviteRecordVC = InviteRecordViewController()
                self?.navigationController?.pushViewController(inviteRecordVC, animated: true)
            } else {
                if actionId == 2 {
                    self?.showTipAlert("\r 1、今日次数是您今日可观看影片次数 \r\r  2、邀请好友/开通会员可以享受每日无限次观看", "今日次数说明")
                } else if actionId == 3 {
                    self?.showTipAlert("\r 1、邀请好友可以获得每日不限次看片奖励 \r\r  2、仅限普通影片哦，开通会员可以看更多精彩影片", "无限天数说明")
                } else if actionId == 4 {
                    self?.showTipAlert("\r 1、开通会员可以获得每日下载3部影片特权 \r\r  2、精彩内容要下载保存后慢慢看才爽", "下载次数说明")
                }
            }
        }
    }
    
    private func navConfig() {
        navBar.backgroundColor = UIColor.clear
        navBar.backButton.setImage(nil, for: .normal)
        navBar.titleLabel.textAlignment = .left
        rightBtn.isHidden = false
        rightBtn.setTitle("", for: .normal)
        rightBtn.setImage(UIImage(named: "SettingBtn"), for: .normal)
        navBar.lineView.backgroundColor = UIColor.clear
        navBar.snp.updateConstraints { (make) in
            make.height.equalTo(statusBarHeight + 36)
        }
        navBar.backButton.snp.updateConstraints { (make) in
            make.bottom.equalTo(-2)
            make.width.equalTo(29)
        }
        view.bringSubviewToFront(navBar)
    }
    
    /// 用户信息毁掉
    private func addUserModelcallback() {
        userViewModel.loadUserInfoSuccessHandler = { [weak self]  in
            self?.setUpUserInfo()
            self?.userViewModel.loadHisListVideo()
        }
        userViewModel.loadHistoryListSuccessHandler = { [weak self] in
            self?.tableView.reloadRows(at: [IndexPath.init(row: 4, section: 0)], with: .none)
        }
        userViewModel.loadHistoryListFailHandler = { [weak self] in
            self?.tableView.reloadRows(at: [IndexPath.init(row: 4, section: 0)], with: .none)
        }
    }
    
    /// 跳到土豆群
    func findAcountWithCallUs() {
        if let url = URL(string: AppInfo.share().appInfo?.potato_invite_link ?? "") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    /// 提示
    private func showTipAlert(_ msg: String, _ title: String) {
        let alert = UIAlertController.init(title: title, message: msg, preferredStyle: .alert)
        let actionCancle = UIAlertAction.init(title: "朕知道了", style: .default, handler: nil)
        alert.addAction(actionCancle)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func goDetail(_ model: VideoModel) {
        let detailVC = VideoDetailViewController()
        detailVC.model = model
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    /// 显示用户idCard
    private func showUserInvitedCard() {
        let controller = IDCardInfoController()
        controller.isCardId = true
        controller.view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        controller.modalPresentationStyle = .overCurrentContext
        self.modalPresentationStyle = .currentContext
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.tabBarController?.present(controller, animated: false, completion: nil)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension AcountController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 {
            if userViewModel.videoList.count == 0 {
                return 0
            } else {
                return  VideoDoubleCollectionCell.itemSize.height
            }
        }
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleS.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.cellId, for: indexPath) as! HistoryCell
            cell.setModels(userViewModel.videoList)
            cell.itemClickHandler = { [weak self] (index) in
                guard let strongSelf = self else { return }
                strongSelf.goDetail(strongSelf.userViewModel.videoList[index])
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: AcountListCell.cellId, for: indexPath) as! AcountListCell
            cell.imageIcon.image = UIImage(named: imageIcons[indexPath.row])
            cell.titleLab.text = titleS[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let vip = VipCardController()
            navigationController?.pushViewController(vip, animated: true)
        } else if indexPath.row == 2 {
            let collvc = CollectedLsController()
            collvc.isHistory = false
            navigationController?.pushViewController(collvc, animated: true)
        } else if indexPath.row == 3 {
            let hisvc = CollectedLsController()
            hisvc.isHistory = true
            navigationController?.pushViewController(hisvc, animated: true)
        } else if indexPath.row == 1 {
            let exVc = ExchangeController()
            navigationController?.pushViewController(exVc, animated: true)
        } else if indexPath.row == 6 {
            let feedBack = HelpController()
            navigationController?.pushViewController(feedBack, animated: true)
        } else if indexPath.row == 7 {
            findAcountWithCallUs()
        } else if indexPath.row == 5 {
            let downloadVC = DownloadTasksController()
            navigationController?.pushViewController(downloadVC, animated: true)
        }
    }
}

// MARK: - UIScrollViewDelegate
extension AcountController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY >= 44 {
            navBar.titleLabel.text = "\(UserModel.share().userInfo?.nick_name ?? "老湿")"
            navBar.backButton.setImage(UserModel.share().getUserHeader(), for: .normal)
        } else {
            navBar.titleLabel.text = ""
            navBar.backButton.setImage(nil, for: .normal)
        }
    }
}

// MARK: - Layout
extension AcountController {
    
    func layoutPageSubviews() {
        layoutBgFakeView()
        layoutTableView()
    }
    func layoutHeaderView() {
        header.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(0)
            }
        }
    }
    func layoutBgFakeView() {
        bgFakeVirw.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(420)
        }
    }
}


// MARK: - 掉线提醒
extension AcountController {
    
    @objc private func didUserBeenKickedOut() {
        DLog("didUserBeenKickedOut  ===== AdController")
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.window?.rootViewController?.showDialog(title: "被挤掉提示", message: XSAlertMessages.kNotAvailTokenAlertMsg, okTitle: "确认", cancelTitle: "取消", okHandler: {
                DLog("跳转到官网")
            }, cancelHandler: nil)
        }
    }
}
