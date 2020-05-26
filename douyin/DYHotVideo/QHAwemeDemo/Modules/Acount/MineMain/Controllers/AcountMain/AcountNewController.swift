//
//  AcountNewController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/4.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import DouYinScan

class AcountNewController: QHBaseViewController {

    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = ""
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.clear
        bar.lineView.isHidden = true
        return bar
    }()
    private lazy var settingBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "settingBtn"), for: .normal)
        button.addTarget(self, action: #selector(settingBtnClick(_:)), for: .touchUpInside)
        // button.isHidden = true
        return button
    }()
    private lazy var feedButton: ServerButton = {
        let frame = CGRect.init(x: ConstValue.kScreenWdith - 75, y: 360 + ConstValue.kStatusBarHeight + 60, width: 55, height: 55)
        let button = ServerButton(frame: frame)
        button.backgroundColor = UIColor(white: 0.0, alpha: 0.9)
        button.radiuOfButton = 30
        button.paddingOfbutton = 15
        button.delegate = self
        button.setImage(UIImage(named: "onlineFeedBack"), for: .normal)
        return button
    }()
    private lazy var userInfoHeader: AcountNewHeaderView = {
        if let header = Bundle.main.loadNibNamed("AcountNewHeaderView", owner: nil, options: nil)?[0] as? AcountNewHeaderView {
            header.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 250)
            return header
        }
        return AcountNewHeaderView()
    }()
    private let userItemView: AcountNewItemView = {
        let itemView = AcountNewItemView(frame: CGRect.zero)
        return itemView
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
        let workVc = WorkVideosController()
        let communityVc = UserTopicsController()
        let favorvc = FavorVideosController()
        let buyVC = BuyVideosController()

        favorvc.userId = UserModel.share().userInfo?.id
        favorvc.isUserCenter = true
        workVc.userId = UserModel.share().userInfo?.id
        workVc.isUserCenter = true
        communityVc.isAcount = true
        communityVc.userId = UserModel.share().userInfo?.id
        buyVC.userId = UserModel.share().userInfo?.id
        favorvc.favorVideoTotalHandler = { [weak self] (total) in
            guard let strongSelf = self else { return }
            strongSelf.favorCount = total
            strongSelf.pageView.titles = ["作品\(strongSelf.getStringWithNumber(strongSelf.worksCount))","动态\(strongSelf.getStringWithNumber(strongSelf.talksCount))","喜欢\(strongSelf.getStringWithNumber(strongSelf.favorCount))","购买\(strongSelf.getStringWithNumber(strongSelf.buysCount))"]
            strongSelf.pageView.reloadData()
        }
        buyVC.buyVideoTotalHandler = { [weak self] (total) in
            guard let strongSelf = self else { return }
            strongSelf.buysCount = total
            strongSelf.pageView.titles = ["作品\(strongSelf.getStringWithNumber(strongSelf.worksCount))","动态\(strongSelf.getStringWithNumber(strongSelf.talksCount))","喜欢\(strongSelf.getStringWithNumber(strongSelf.favorCount))","购买\(strongSelf.getStringWithNumber(strongSelf.buysCount))"]
            strongSelf.pageView.reloadData()
        }
        workVc.workVideoTotalHandler = { [weak self] (total) in
            guard let strongSelf = self else { return }
            strongSelf.worksCount = total
            strongSelf.pageView.titles = ["作品\(strongSelf.getStringWithNumber(strongSelf.worksCount))","动态\(strongSelf.getStringWithNumber(strongSelf.talksCount))","喜欢\(strongSelf.getStringWithNumber(strongSelf.favorCount))","购买\(strongSelf.getStringWithNumber(strongSelf.buysCount))"]
            strongSelf.pageView.reloadData()
        }
        communityVc.topicTotalHandler = { [weak self] (total) in
            guard let strongSelf = self else { return }
            strongSelf.talksCount = total
            strongSelf.pageView.titles = ["作品\(strongSelf.getStringWithNumber(strongSelf.worksCount))","动态\(strongSelf.getStringWithNumber(strongSelf.talksCount))","喜欢\(strongSelf.getStringWithNumber(strongSelf.favorCount))","购买\(strongSelf.getStringWithNumber(strongSelf.buysCount))"]
            strongSelf.pageView.reloadData()
        }
        return [workVc, communityVc,favorvc, buyVC]
    }()
    private lazy var titles: [String] = {
        return ["作品","动态","喜欢","购买"]
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
        pageConfig.isAverageWith = true
        pageConfig.titleColorNormal = UIColor.darkGray
        pageConfig.titleColorSelected = UIColor.white
        pageConfig.titleFontNormal = UIFont.systemFont(ofSize: 15)
        pageConfig.titleFontSelected = UIFont.boldSystemFont(ofSize: 16)
        pageConfig.lineColor = UIColor.clear
        pageConfig.lineImage = UIImage(named: "pageLineBg")
        pageConfig.lineSize = CGSize(width: 33, height: 6)
        pageConfig.lineViewLocation = .center
        return pageConfig
    }()
    private lazy var pageVc: VCPageController = {
        let pageVC = VCPageController()
        pageVC.controllers = vcs
        return pageVC
    }()
    
    private var worksCount: Int = 0
    private var talksCount: Int = 0
    private var favorCount: Int = 0
    private var buysCount: Int = 0

    
    private let userViewModel = UserInfoViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        userInfoViewModelCallBack()
        addHeaderActionCallBack()
        showUserInfoCard()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userViewModel.loadUserInfo()
    }
    
    private func setupUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.automaticallyAdjustsScrollViewInsets = false
        view.addSubview(navBar)
        navBar.navBarView.addSubview(settingBtn)
        view.addSubview(tableView)
        view.addSubview(feedButton)
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 345))
        headerView.addSubview(userInfoHeader)
        headerView.addSubview(userItemView)
        layoutHeaderSubviews()
        layoutPageSubviews()
        tableView.tableHeaderView = headerView
        navConfig()
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
        (vcs[2]as!FavorVideosController).scrollDownToTopHandler = { [weak self] (canScroll) in
            guard let strongSelf = self else { return }
            strongSelf.tableView.isScrollEnabled = canScroll
        }
        (vcs[3]as!BuyVideosController).scrollDownToTopHandler = { [weak self] (canScroll) in
            guard let strongSelf = self else { return }
            strongSelf.tableView.isScrollEnabled = canScroll
        }
        ///数据填充
        setUpUserInfo()
    }
    private func navConfig() {
        navBar.backButton.setImage(nil, for: .normal)
        navBar.titleLabel.textAlignment = .left
        navBar.backButton.layer.cornerRadius = 14.0
        navBar.backButton.layer.masksToBounds = true
        navBar.backButton.snp.updateConstraints { (make) in
            make.bottom.equalTo(-3)
            make.width.equalTo(28)
            make.leading.equalTo(15)
        }
    }
    @objc func settingBtnClick(_ sender: UIButton) {
        let settingVC = SettingController()
        navigationController?.pushViewController(settingVC, animated: true)
    }
}
// MARK: - privite data
private extension AcountNewController {
    
    func userInfoViewModelCallBack() {
        userViewModel.loadUserInfoSuccessHandler = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.setUpUserInfo()
        }
    }
    func setUpUserInfo() {
        let userInfo = UserModel.share().userInfo
        if let info = userInfo {
            userInfoHeader.setUser(info)
        }
    }

    private func showUserInfoCard() {
        let controller = IDCardInfoController()
        controller.isPresent = true//
        controller.view.backgroundColor = UIColor(white: 0.0, alpha: 0.8)
        controller.modalPresentationStyle = .overCurrentContext
        self.modalPresentationStyle = .currentContext
        self.present(controller, animated: true, completion: nil)
    }
    func addHeaderActionCallBack() {
        userInfoHeader.actionHandler = { [weak self] actionId in
            if actionId == 1 { // 登录，即绑定手机
                let verbPhone = VerbPhoneController()
                verbPhone.isLogin = true
                self?.navigationController?.pushViewController(verbPhone, animated: true)
            } else if actionId == 2 { // 今日次数
                let investVC = InvestController()
                investVC.currentIndex = 0
                self?.navigationController?.pushViewController(investVC, animated: true)
            } else if actionId == 3 {
                let editVC = UserInfoEditController()
                self?.navigationController?.pushViewController(editVC, animated: true)
            } else if actionId == 4 || actionId == 5 {
                let vc = AttentionFansController()
                vc.userId = UserModel.share().userInfo?.id ?? 0
                vc.user = UserModel.share().userInfo
                vc.fansCount = UserModel.share().userInfo?.fans ?? 0
                vc.attentionCount = UserModel.share().userInfo?.flow ?? 0
                vc.pageIndex = actionId == 4 ? 0 : 1
                self?.navigationController?.pushViewController(vc, animated: true)
            } else if actionId == 6 {
                let recordVC = InviteRecordController()
                self?.navigationController?.pushViewController(recordVC, animated: true)
            }
        }
        userItemView.itemClickHandler = { [weak self] index in
            if index == 0 { // 充值中心
                let investVC = InvestController()
                investVC.currentIndex = 0
                self?.navigationController?.pushViewController(investVC, animated: true)
            } else if index == 1 {
                let walletvc =  WalletMainNewController()
                self?.navigationController?.pushViewController(walletvc, animated: true)
            } else if index == 2 {
                let vc = PopularizeController()
                self?.navigationController?.pushViewController(vc, animated: true)
            } else if index == 3 {
                let controller = UserPopController()
                controller.view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
                controller.alertType = .addGroupAlert
                controller.modalPresentationStyle = .overCurrentContext
                self?.modalPresentationStyle = .currentContext
                self?.present(controller, animated: true, completion: nil)
            }
        }
    }

}

//MARK: -UIScrollViewDelegate
extension AcountNewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY >= 44 {
            navBar.titleLabel.text = "  \(UserModel.share().userInfo?.nikename ?? "老湿")"
            navBar.backButton.kfSetHeaderImageWithUrl(UserModel.share().userInfo?.cover_path, placeHolder: ConstValue.kDefaultHeader)
        } else {
            navBar.titleLabel.text = ""
            navBar.backButton.setImage(nil, for: .normal)
        }
    }
}

// MARK：数据源 & 代理
extension AcountNewController: UITableViewDataSource, UITableViewDelegate {
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
// MARK: - FloatDelegate
extension AcountNewController: FloatDelegate {
    func singleClick() {
        let feedBack = HelpController()
        navigationController?.pushViewController(feedBack, animated: true)
    }
    func repeatClick() {
        
    }
}

//MARK: Layout
extension AcountNewController {
    func layoutHeaderSubviews() {
        userInfoHeader.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(245)
        }
        userItemView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(userInfoHeader.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    func layoutPageSubviews() {
        layoutNavBar()
        layoutTableView()
        layoutSettingBtn()
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
            make.height.equalTo(ConstValue.kStatusBarHeight + 36)
        }
    }
    func layoutSettingBtn() {
        settingBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-12)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(30)
        }
    }
}
