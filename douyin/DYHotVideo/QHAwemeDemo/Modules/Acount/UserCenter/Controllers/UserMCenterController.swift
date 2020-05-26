//
//  UserMCenterController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/9/29.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//  用户主页

import UIKit
import NicooNetwork

class UserMCenterController: QHBaseViewController {

    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = user?.nikename ?? "老湿"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.clear
        bar.backButton.isHidden = false
        bar.titleLabel.isHidden = true
        bar.lineView.isHidden = true
        bar.delegate = self
        return bar
    }()
    
    private lazy var userInfoHeader: UserCenterHeader = {
        if let header = Bundle.main.loadNibNamed("UserCenterHeader", owner: nil, options: nil)?[0] as? UserCenterHeader {
            header.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 260)
            return header
        }
        return UserCenterHeader()
    }()
    
    lazy var tableView: CustomTableView = {
        let tableView = CustomTableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.bounces = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "fakeCell")
        return tableView
    }()
    
    private lazy var vcs: [UIViewController] = {
        let oneVc = UserTopicsController()
        oneVc.isAcount = false
        oneVc.userId = user?.id
        oneVc.topicTotalHandler = { [weak self] (total) in
            guard let strongSelf = self else { return }
            strongSelf.talksCount = total
            strongSelf.pageView.titles = ["作品\(strongSelf.worksCount)","动态\(strongSelf.talksCount)"]
            strongSelf.pageView.reloadData()
        }
        let twoVc = WorkVideosController()
        twoVc.workListHandler = { [weak self] user in
            guard let strongSelf = self else {return}
            strongSelf.user = user
            //strongSelf.setUpUserInfo()
        }
        twoVc.userId = user?.id
        twoVc.workVideoTotalHandler = { [weak self] (total) in
            guard let strongSelf = self else { return }
            strongSelf.worksCount = total
            strongSelf.pageView.titles = ["作品\(strongSelf.worksCount)","动态\(strongSelf.talksCount)"]
            strongSelf.pageView.reloadData()
        }
        return [twoVc, oneVc]
    }()
    private lazy var titles: [String] = {
        return ["作品","动态"]
    }()
    private lazy var pageView: PageItemView = {
        let view = PageItemView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 40),config: config)
        view.backgroundColor = UIColor.clear
        view.titles = titles
        return view
    }()
    
    /// 自定义pageView 设置   /*  --- 更多配置 请查看 PageItemConfig 属性 ---- */
    private lazy var config: PageItemConfig = {
        let pageConfig = PageItemConfig()
        pageConfig.leftRightMargin = 8
        pageConfig.titleColorNormal = UIColor(r: 153, g: 153, b: 153)
        pageConfig.titleColorSelected = UIColor.white
        pageConfig.titleFontNormal = UIFont.systemFont(ofSize: 15)
        pageConfig.titleFontSelected = UIFont.boldSystemFont(ofSize: 16)
        pageConfig.lineColor = UIColor.clear
        pageConfig.lineImage = UIImage(named: "pageLineBg")
        pageConfig.lineSize = CGSize(width: 33, height: 6)
        pageConfig.lineViewLocation = .left
        return pageConfig
    }()
    
    private lazy var pageVc: VCPageController = {
        let pageVC = VCPageController()
        pageVC.controllers = vcs
        return pageVC
    }()
    
    var user: UserInfoModel?
    private let userViewModel = UserInfoViewModel()
    private var worksCount: Int = 0
    private var talksCount: Int = 0
//    private var favorCount: Int = 0
    private var followCount: Int = 0
    private var fansCount: Int = 0
    
    var followOrCancelBackHandler:((_ followStatu: FocusVideoUploader) -> Void)?
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshAttentionStatus), name: Notification.Name.kUserCenterRefreshAttentionStateNotification, object: nil)
        setupUI()
    }
}

//MARK: 设置UI
extension UserMCenterController {
    
    private func setupUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.automaticallyAdjustsScrollViewInsets = false
        
        view.addSubview(tableView)
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 260))
        headerView.addSubview(userInfoHeader)
        
        tableView.tableHeaderView = headerView
        view.addSubview(navBar)
        layoutPageSubviews()
        
        pageVc.scrollToIndex = { [weak self] (index) in
            guard let strongSelf = self else { return }
            strongSelf.pageView.scrollTopIndex(index)
        }
        pageView.itemClickHandler = { [weak self] (index) in
            guard let strongSelf = self else { return }
            strongSelf.pageVc.clickItemToScroll(index)
        }
        (vcs[0]as!WorkVideosController).scrollDownToTopHandler = { [weak self] (canScroll) in
            guard let strongSelf = self else { return }
            strongSelf.tableView.isScrollEnabled = canScroll
        }
        (vcs[1]as!UserTopicsController).scrollDownToTopHandler = { [weak self] (canScroll) in
            guard let strongSelf = self else { return }
            strongSelf.tableView.isScrollEnabled = canScroll
        }
        ///数据获取
        setUpUserInfo(true)
        loadData()
    }
    
    private func setUpUserInfo(_ statuSet: Bool) {
        if let userHeader = user?.cover_path {
             userInfoHeader.headerImg.kfSetHeaderImageWithUrl(userHeader, placeHolder: UserModel.share().getUserHeader(user?.id))
        } else {
             userInfoHeader.headerImg.kfSetHeaderImageWithUrl(user?.avatar, placeHolder: UserModel.share().getUserHeader(user?.id))
        }
        if let nickName = user?.nikename, !nickName.isEmpty {
            userInfoHeader.userNamelabel.text = nickName
        }
        if let intro = user?.intro, !intro.isEmpty {
             userInfoHeader.introLabel.attributedText = TextSpaceManager.getAttributeStringWithString(intro, lineSpace: 3)
        }
        if user?.id == UserModel.share().userInfo?.id {
            userInfoHeader.attentionBtn.setTitle("编辑资料", for: .normal)
            userInfoHeader.attentionBtn.backgroundColor = UIColor(r: 235, g: 94, b: 97)
        } else {
            if statuSet {
                if user?.followed != nil {
                               userInfoHeader.attentionBtn.setTitle((user?.followed ?? .focus) == .focus ? "取消关注" : "+关注", for: .normal)
                               userInfoHeader.attentionBtn.backgroundColor = (user?.followed ?? .focus) == .focus ? UIColor(r: 42, g: 42, b: 47) :  UIColor(r: 215, g: 58, b: 45)
                           } else {
                               userInfoHeader.attentionBtn.setTitle("+关注", for: .normal)
                           }
            }
        }
        if let users = user {
             userInfoHeader.setModel(user: users)
        }
    }
}

// MARK: 网络请求
extension UserMCenterController {
    
    private func loadData() {
        userInfoViewModelCallBack()
        addHeaderItemCLickHandler()
        loadFollowStatu()
        loadFansCount()
        loadFollowCount()
        userViewModel.loadUserOtherInfo([UserInfoOtherApi.kUserId: user?.id ?? 0])
    }
    
    private func loadFansCount() {
        userViewModel.loadFansCount([UserFansCountApi.kUserId: user?.id ?? 0])
    }
    private func loadFollowCount() {
        userViewModel.loadFollowCount([UserFansCountApi.kUserId: user?.id ?? 0])
    }
    private func loadFollowStatu() {
        userViewModel.loadFollowStatu([UserFollowStatuApi.kUserId: user?.id ?? 0, UserFollowStatuApi.kSelfId: UserModel.share().userInfo?.id ?? 0])
    }
}

// MARK: 数据回调
extension UserMCenterController {
    
    private func userInfoViewModelCallBack() {
        userViewModel.loadUserOtherInfoSuccessHandler = { [weak self] user in
            self?.user = user
            self?.setUpUserInfo(false)
        }
        userViewModel.fansOrFollowCountApiSuccessHandler = { [weak self] (count, isFollow) in
            guard let strongSelf = self else { return }
            strongSelf.setFansOrFollowCount(count: count, isFollow: isFollow)
        }
        userViewModel.followStatuCallBackhandler = { [weak self] (statu) in
            if (statu.status ?? 0) == 1 {
                self?.user?.followed = .focus
            } else {
                self?.user?.followed = .notFocus
            }
            self?.setUpUserInfo(true)
        }
        
        userViewModel.followAddOrCancelSuccessHandler = { [weak self] isAdd, _ in
            guard let strongSelf = self else { return }
            if isAdd {
                self?.userInfoHeader.attentionBtn.setTitle("取消关注", for: .normal)
                self?.userInfoHeader.attentionBtn.backgroundColor = UIColor(r: 42, g: 42, b: 47)
                DLog("--userId = \(String(describing: strongSelf.user?.id))")
                self?.user?.followed = .focus
                self?.followOrCancelBackHandler?(.focus)
                self?.loadFansCount()
            } else {
                self?.userInfoHeader.attentionBtn.setTitle("+关注", for: .normal)
                self?.userInfoHeader.attentionBtn.backgroundColor = UIColor(r: 215, g: 58, b: 45)
                DLog("userId = \(String(describing: strongSelf.user?.id))")
                self?.user?.followed = .notFocus
                self?.followOrCancelBackHandler?(.notFocus)
                self?.loadFansCount()
            }
        }
        
        userViewModel.followOrCancelFailureHandler = { (isAdd, msg) in
            XSAlert.show(type: .error, text: msg)
        }
    }
    
    private func addHeaderItemCLickHandler() {
        userInfoHeader.actionClickHandler = { [weak self] (tag) in
            if tag == 1 {
                self?.followBtnClickAction()
            } else if tag == 2 {
                self?.share()
            } else if tag == 101 || tag == 102 {
                let vc = AttentionFansController()
                vc.userId = self?.user?.id ?? 0
                vc.user = self?.user
                vc.fansCount = self?.fansCount ?? 0
                vc.attentionCount = self?.followCount ?? 0
                vc.pageIndex = tag == 101 ? 0 : 1
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    ///设置粉丝和关注的数量
    private func setFansOrFollowCount(count: Int, isFollow: Bool) {
        if isFollow {
            let title = count > 10000 ? String(format: "%.1fw", Float(count)/10000) : "\(count)"
            userInfoHeader.attentionCount.text = title
            followCount = count
        } else {
            let title = count > 10000 ? String(format: "%.1fw", Float(count)/10000) : "\(count)"
            userInfoHeader.fansCount.text = title
            fansCount  = count
        }
    }
}

//MARK: -点击事件
extension UserMCenterController {
    @objc func settingBtnClick(_ sender: UIButton) {
        let settingVC = SettingController()
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
    @objc func msgBtnClick(_ sender: UIButton) {
        let msgVC = MsgCenterController()
        navigationController?.pushViewController(msgVC, animated: true)
    }
    
    ///关注，取消关注的点击事件
    private func followBtnClickAction() {
        if user?.id ?? 0 == UserModel.share().userInfo?.id {       ///如果点击刚好点击的是自己的作品，进入编辑界面
            let vc = UserInfoEditController()
            navigationController?.pushViewController(vc, animated: true)
        } else {
            if let focusStatu = user?.followed {
                if focusStatu == .focus {  // 已关注，调用取消
                    userViewModel.loadCancleFollowApi([UserFollowStatuApi.kUserId: user?.id ?? 0, UserFollowStatuApi.kSelfId: UserModel.share().userInfo?.id ?? 0])
                } else  { // 未关注，调用关注
                    userViewModel.loadAddFollowApi([UserFollowStatuApi.kUserId: user?.id ?? 0, UserFollowStatuApi.kSelfId: UserModel.share().userInfo?.id ?? 0])
                }
            }
        }
    }
}

//MARK: -FloatDelegate
extension UserMCenterController: FloatDelegate {
    
    func singleClick() {
        if let url = URL(string: AppInfo.share().potato_invite_link ?? "") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    func repeatClick() {
        
    }
    ///通知方法
    @objc func refreshAttentionStatus() {
        ///刷新关注状态
        loadFollowStatu()
        loadFansCount()
    }
}

//MARK: -UIScrollViewDelegate
extension UserMCenterController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY > 50 {
            navBar.titleLabel.isHidden = false
            navBar.titleLabel.text = user?.nikename ?? ""
        } else {
            navBar.titleLabel.isHidden = true
        }
    }
}


// MARK：数据源 & 代理
extension UserMCenterController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight - 40 - safeAreaBottomHeight
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "fakeCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        self.addChild(pageVc)
        cell.contentView.addSubview(pageVc.view)
        pageVc.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - 40 - safeAreaBottomHeight)
        layoutSubviews()
        pageVc.view.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.top.equalTo(cell.contentView.safeAreaLayoutGuide.snp.top)
            } else {
                make.top.equalToSuperview()
            }
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(cell.contentView.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 40))
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(pageView)
        return view
    }
}


//MARK: Layout
extension UserMCenterController {
    
    func layoutPageSubviews() {
        layoutNavBar()
        layoutTableView()
    }
    
    func layoutTableView() {
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
    
    func layoutSubviews() {
        pageVc.view.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
    }
}

// MARK: - QHNavigationBarDelegate
extension UserMCenterController: QHNavigationBarDelegate  {
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}
