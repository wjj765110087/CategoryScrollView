//
//  InvestControllerViewController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/11/18.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//  充值中心

import UIKit
import NicooNetwork

class InvestController: QHBaseViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private var bottomView: PayBottomView = {
        guard let view = Bundle.main.loadNibNamed("PayBottomView", owner: nil, options: nil)?[0] as? PayBottomView else { return PayBottomView() }
        return view
    }()

    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "充值中心"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.init(r: 30, g: 31, b: 50)
        bar.delegate = self
        return bar
    }()
    private lazy var recordBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("充值记录", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(ConstValue.kTitleYelloColor, for: .normal)
        button.addTarget(self, action: #selector(recordBtnBtnClick(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var pageTitleView: PageItemView = {
       let view = PageItemView(frame: .zero, config: config)
        view.backgroundColor = UIColor.init(r: 30, g: 31, b: 50)
        view.titles = titles
        return view
    }()
    
    private lazy var pageVC: VCPageController = {
        let vc = VCPageController()
        vc.controllers = vcs
        return vc
    }()
    
    private lazy var buyVipVC = VipCardsController()
    private lazy var coinVC = CoinController()
    private lazy var doorVC = UpDoorPayController()
    
    private lazy var vcs: [UIViewController] = {
        return [buyVipVC, doorVC, coinVC]
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
    
    private lazy var titles: [String] = {
       return ["购买会员","购买服务","充值金币"]
    }()
    
    var currentIndex: Int = 1
    
    var walletModel = WalletInfo()
    
    private lazy var walletApi: UserWalletApi = {
        let api = UserWalletApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.navBarView.addSubview(recordBtn)
        view.addSubview(navBar)
        view.addSubview(bottomView)
        view.addSubview(pageTitleView)
        addChild(pageVC)
        view.addSubview(pageVC.view)
    
        layoutPageViews()
        
        pageVC.scrollToIndex = { [weak self] (index) in
            guard let strongSelf = self else { return }
            strongSelf.currentIndex = index
            strongSelf.pageTitleView.scrollTopIndex(index)
        }
        
        pageTitleView.itemClickHandler = { [weak self] index in
            guard let strongSelf = self else {return}
            strongSelf.currentIndex = index
            strongSelf.pageVC.clickItemToScroll(index)
        }
    
        bottomView.payAction = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.payAction()
        }
        addVCsCallBack()
        
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pageVC.clickItemToScroll(currentIndex)
    }
    
    @objc func recordBtnBtnClick(_ sender: UIButton) {
        let payRecordVC = PayRecordController()
        navigationController?.pushViewController(payRecordVC, animated: true)
    }
    
    func addVCsCallBack() {
        buyVipVC.bottomViewVIPHandler = { [weak self] type, cardModel in
            guard let strongSelf = self else {return}
            strongSelf.bottomView.setMuneModel(cardModel)
        }
        coinVC.bottomViewCoinHandler = { [weak self] type, coinModel in
            guard let strongSelf = self else {return}
            strongSelf.bottomView.setBottomWithCoinModel(coinModel)
        }
        doorVC.bottomViewServerHandler = { [weak self] type, serverModel in
            guard let strongSelf = self else {return}
            strongSelf.bottomView.setBottomWithServerModel(serverModel)
        }
    }
    
    func payAction() {
        ///根据curretIndex来判断是购买会员，还是购买金币
        if currentIndex == 0 {
            buyVipVC.payAction()
        } else if currentIndex == 1 {
            doorVC.payAction()
        } else {
            coinVC.payAction()
        }
        loadData()
    }
    
    private func loadData() {
        let _ = walletApi.loadData()
    }
}

// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension InvestController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if  manager is UserWalletApi {
            if let wallet = manager.fetchJSONData(UserReformer()) as? WalletInfo {
                walletModel = wallet
                if let money =  walletModel.money, !money.isEmpty {
                    UserDefaults.standard.set(money, forKey: "UserBalance")
                    UserDefaults.standard.synchronize()
                }
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is UserWalletApi {
            XSAlert.show(type: .error, text: manager.errorMessage)
        }
    }
}

// MARK: - QHNavigationBarDelegate
extension InvestController:  QHNavigationBarDelegate  {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

private extension InvestController {
    func layoutPageViews() {
        layoutNavBar()
        layoutRecordBtn()
        layoutPageTitleView()
        layoutBottomView()
        layoutPageVcView()
    }
    
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
    }
    
    func layoutRecordBtn() {
        recordBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-12)
            make.centerY.equalToSuperview()
            make.width.equalTo(65)
            make.height.equalTo(35)
        }
    }
    
    func layoutPageTitleView() {
        pageTitleView.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.top.equalTo(navBar.snp.bottom)
            make.height.equalTo(44)
        }
    }
    
    func layoutBottomView() {
        bottomView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(0)
            }
        }
    }
    
    func layoutPageVcView() {
        pageVC.view.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top).offset(-4)
            make.top.equalTo(pageTitleView.snp.bottom)
        }
    }
}
