//
//  VipCardController.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/17.
//  Copyright © 2019年 bingdaohuoshan. All rights reserved.
//

import UIKit
import NicooNetwork

class VipCardController: BaseViewController {

    private let headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 90))
        view.clipsToBounds = true
        return view
    }()
    private var header: UserInfoView = {
        guard let view = Bundle.main.loadNibNamed("UserInfoView", owner: nil, options: nil)?[0] as? UserInfoView else { return UserInfoView() }
        return view
    }()
    private var bottomView: PayBottomView = {
        guard let view = Bundle.main.loadNibNamed("PayBottomView", owner: nil, options: nil)?[0] as? PayBottomView else { return PayBottomView() }
        return view
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NounMuneListCell.classForCoder(), forCellReuseIdentifier: NounMuneListCell.cellId)
        tableView.register(PayTypeItemCell.classForCoder(), forCellReuseIdentifier: PayTypeItemCell.cellId)
        tableView.register(VipWelfaresCell.classForCoder(), forCellReuseIdentifier: VipWelfaresCell.cellId)
        return tableView
    }()
    private lazy var chargelsApi: RechargeMenuApi = {
        let api = RechargeMenuApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    private lazy var payTypelsApi: PayTypeLsApi = {
        let api = PayTypeLsApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    private lazy var orderAddApi: UserOrderAddApi = {
        let api = UserOrderAddApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    var chargeHandler:((_ paySuccess: Bool) -> Void)?
    
    var chargeCurrentIndex = 0
    var payTypeCurrentIndex = 0
    
    var charges: [ChargeModel]?
    var vipWelfareS: [VIPWelfareMune]?
    var paytypes = [PayTypeModel]()
    
    var currentCharge = ChargeModel()
    var currentPayType: PayTypeModel?
    
    var welfareHeight: CGFloat = 30.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(bottomView)
        bottomView.addShadow(radius: 1.5, opacity: 0.3)
        headerView.addSubview(header)
        view.addSubview(tableView)
        layoutHeaderView()
        layoutPageSubviews()
        tableView.tableHeaderView = headerView
        navConfig()
        
        loadMunes()
        
        setUpUserInfo()

    }
    
    override func rightButtonClick(_ sender: UIButton) {
        let buyRecord = PayRecordController()
        navigationController?.pushViewController(buyRecord, animated: true)
    }
  
    private func navConfig() {
        view.bringSubviewToFront(navBar)
        navBar.titleLabel.text = "会员中心"
        rightBtn.isHidden = false
        rightBtn.setTitle("购买记录", for: .normal)
    }
    
    private func setUpUserInfo() {
        header.headerImg.image = UserModel.share().getUserHeader()
        header.nameLabel.text = UserModel.share().userInfo?.nick_name ?? "老湿"
        header.openStatu.isSelected = UserModel.share().userInfo?.is_vip?.boolValue ?? false
        if UserModel.share().userInfo?.is_vip?.boolValue ?? false {
            header.tipsLabel.text = "到期时间:\(UserModel.share().userInfo?.vip_expire ?? "")"
             header.openStatu.backgroundColor = UIColor(r: 255, g: 42, b: 49)
        } else {
            header.tipsLabel.text = "开通会员享立VIP特权"
            header.openStatu.backgroundColor = UIColor(r: 88, g: 88, b: 88)
        }
        bottomView.payAction = { [weak self] in
            self?.payAction()
        }
    }
    
    private func payAction() {
        if currentPayType == nil {
            XSAlert.show(type: .error, text: "请选择支付方式")
            return
        }
        XSProgressHUD.showCustomAnimation(msg: "提交订单...", onView: view, imageNames: nil, bgColor: nil, animated: false)
//        DispatchQueue.global(qos: .default).asyncAfter(deadline: DispatchTime.now() + TimeInterval((arc4random_uniform(3)))) {
//
//        }
        let _ = orderAddApi.loadData()
    }
    
    /// 支付
    private func goAlipay(_ playUrl: String) {
        let alipayVc = PayWebController()
        alipayVc.urlString = playUrl
        alipayVc.title = "支付"
        navigationController?.pushViewController(alipayVc, animated: true)
    }
    
    /// 充值系统繁忙提示
    private func showServerWarningAlert() {
        let alert = UIAlertController(title: "温馨提示", message: "\r 每一分钟能请求一次支付，请勿频繁请求。", preferredStyle: .alert)
       // alert.view.tintColor = UIColor.darkText
        let cancle = UIAlertAction(title: "知道了", style: .cancel, handler: nil)
        let commit = UIAlertAction.init(title: "立即咨询", style: .destructive) { (alert) in
            self.goToServerVerb()
        }
        alert.addAction(cancle)
        alert.addAction(commit)
        self.present(alert, animated: true, completion: nil)
    }
    
    /// 联系管理员充值
    private func goToServerVerb() {
        if let url = URL(string: AppInfo.share().appInfo?.potato_invite_link ?? "") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

}

// MARK: - DataAccess
private extension VipCardController {
    
    func loadMunes() {
        NicooErrorView.removeErrorMeesageFrom(view)
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        _ = chargelsApi.loadData()
    }
    
    func loadPayTypeList() {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        _ = payTypelsApi.loadData()
    }
    
    func rechargeMenuSuccess(_ chargeModel: RechargeModel) {
        if let chargeModels = chargeModel.recharge, let welfares = chargeModel.icon, chargeModels.count > 0 {
            self.charges = chargeModels
            self.vipWelfareS = welfares
            currentCharge = chargeModels[0]
            /// 计算会员特权模块高度
            getWelfareHeight()
            tableView.reloadSections([0,2], with: .none)
            loadPayTypeList()
            bottomView.setMuneModel(currentCharge)
        }
    }
    func getWelfareHeight() {
        if let vipWels = vipWelfareS {
            var numLine: Int = vipWels.count/4
            let numLs: Int = vipWels.count%4
            if numLs > 0 {
                numLine = numLine + 1
            }
            welfareHeight = (VipWelfareItemCell.itemSize.height + 8) * CGFloat(numLine) + 30
        }
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate
extension VipCardController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 || section == 2 {
            return 10
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 || section == 2 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 20))
            view.backgroundColor = UIColor.groupTableViewBackground
            return view
        }
        return nil
    }
    func numberOfSections(in tableView: UITableView) -> Int {
         return 3
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return NounMenuItemCell.itemSize.height + 40
        } else if indexPath.section == 1 {
            return 60
        } else if indexPath.section == 2 {
            return welfareHeight
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return paytypes.count
        } else if section == 2 {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: NounMuneListCell.cellId, for: indexPath) as! NounMuneListCell
            if let models = charges, models.count > 0 {
                cell.setModels(models)
            }
            cell.itemClickHandler = { [weak self] (model) in
                self?.currentCharge = model
                self?.loadPayTypeList()
                self?.bottomView.setMuneModel(model)
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PayTypeItemCell.cellId, for: indexPath) as! PayTypeItemCell
            if paytypes.count > indexPath.row {
                cell.setModel(paytypes[indexPath.row])
            }
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: VipWelfaresCell.cellId, for: indexPath) as! VipWelfaresCell
            if let models = vipWelfareS, models.count > 0 {
                cell.setModels(models)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == 1 && paytypes.count > indexPath.row {
            if paytypes[indexPath.row].status?.allowPay ?? false {  /// 通道可用，才可选
                paytypes[payTypeCurrentIndex].selected = false
                paytypes[indexPath.row].selected = true
                payTypeCurrentIndex = indexPath.row
                currentPayType = paytypes[payTypeCurrentIndex]
                tableView.reloadSections([1], with: .none)
            }
        }
    }

}


// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension VipCardController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        if manager is UserOrderAddApi {
            var params = [String: Any]()
            params[UserOrderAddApi.kPay_type] = currentPayType?.key
            params[UserOrderAddApi.kCharge_id] = currentCharge.id
            params[UserOrderAddApi.kDevice_type] = "ios"
            params[UserOrderAddApi.kDevice_code] = UIDevice.current.getIdfv()
            return params
        }
        
        if manager is PayTypeLsApi {
            return [PayTypeLsApi.kAmount: currentCharge.price ?? "0.00"]
        }
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is RechargeMenuApi {
            if let chargeModel = manager.fetchJSONData(UserReformer()) as? RechargeModel {
                rechargeMenuSuccess(chargeModel)
            }
        }
        if manager is PayTypeLsApi {
            if let paytype = manager.fetchJSONData(UserReformer()) as? [PayTypeModel] {
                self.paytypes = paytype
                tableView.reloadSections([1], with: .none)
            }
        }
        if manager is UserOrderAddApi {
            if let orderModel = manager.fetchJSONData(UserReformer()) as? OrderAddModel {
                if (orderModel.target?.allowPay ?? false) {
                    if orderModel.payUrl != nil {
                        goAlipay(orderModel.payUrl!)
                    }
                } else {
                    XSAlert.show(type: .success, text: "支付成功。")
                }
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is RechargeMenuApi {
            NicooErrorView.showErrorMessage(.noNetwork, on: view, topMargin: safeAreaTopHeight + 90) { [weak self] in
                self?.loadMunes()
            }
        }
        if manager is UserOrderAddApi {
            showServerWarningAlert()
        }
    }
}


// MARK: - Layout
extension VipCardController {
    
    func layoutPageSubviews() {
        layoutBottomView()
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
            make.bottom.equalTo(bottomView.snp.top).offset(-4)
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
   
}
