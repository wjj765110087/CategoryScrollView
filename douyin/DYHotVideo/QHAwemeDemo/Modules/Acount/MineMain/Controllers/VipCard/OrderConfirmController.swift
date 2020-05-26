//
//  OrderConfirmController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/12.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork

/// 确认订单页面
class OrderConfirmController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "确认订单"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.clear
        bar.delegate = self
        return bar
    }()
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()
    private let payTitleLab: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.white
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.text = "应付:"
        return lable
    }()
    private let payPriceLab: UILabel = {
        let lable = UILabel()
        lable.textColor = ConstValue.kTitleYelloColor
        lable.font = UIFont.systemFont(ofSize: 22)
        lable.text = "¥0.00"
        return lable
    }()
    private lazy var payButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("立即付款", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(red: 254/255.0, green:  88/255.0, blue: 92/255.0, alpha: 1)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        button.addTarget(self, action: #selector(payAction), for: .touchUpInside)
        return button
    }()
    private lazy var vipCardView: VipCardsView = {
        let view = VipCardsView.init(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: (ConstValue.kScreenWdith - 30)/2.4))
        return view
    }()

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.clear
        table.showsVerticalScrollIndicator = false
        table.allowsSelection = true
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(OrderConfirmCell.classForCoder(), forCellReuseIdentifier: OrderConfirmCell.cellId)
        table.register(OrderExplainCell.classForCoder(), forCellReuseIdentifier: OrderExplainCell.cellId)
        table.register(PayTypeChoseCell.classForCoder(), forCellReuseIdentifier: PayTypeChoseCell.cellId)
        return table
    }()
    private lazy var orderAddApi: UserOrderAddApi = {
        let api = UserOrderAddApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private lazy var payTypeApi: UserPayTypeListApi = {
        let api = UserPayTypeListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    
    private let userViewModel = UserInfoViewModel()
    
    var cardModel: VipCardModel?
    var orderdetail: OrderDetailModel?
    var selectedIndex: Int = 0
    var finishPrice: Float = 0.00
    
    var payTypes = [PayTypeModel]()
    
    var currentPayType: PayTypeModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        if (orderdetail?.welfareCard?.count ?? 0) > selectedIndex {
            let card = orderdetail!.welfareCard![selectedIndex]
            let priceFinish = (Float((orderdetail!.price_current ?? "0.00")) ?? 0.00) * ((Float(card.discount ?? "1.00")) ?? 1.00)/10
            finishPrice = priceFinish
        }
        setUpSubviews()
        setUpCardInfo()
        loadPayType()
    }
    
    private func setUpSubviews() {
        view.backgroundColor = UIColor(red: 22/255.0, green: 24/255.0, blue: 36/255.0, alpha: 0.99)
        view.addSubview(navBar)
        view.addSubview(vipCardView)
        bottomView.addSubview(payTitleLab)
        bottomView.addSubview(payPriceLab)
        bottomView.addSubview(payButton)
        view.addSubview(bottomView)
        view.addSubview(tableView)
        layoutPageSubviews()
    }
    
    private func setUpCardInfo() {
        //cardModel?.key ??
        let cardLayer = VipCardManager.fixVipWithCardType(cardType: cardModel?.key ?? VipKey.card_TiYan)
        vipCardView.setCardLayer(cardLayer: cardLayer)
        vipCardView.cardMsgLable.text = cardModel?.remark ?? ""
        
    }
    
    /// 支付
    private func goAlipay(_ playUrl: String) {
        let alipayVc = AdvertWebController()
        alipayVc.urlString = playUrl
        alipayVc.title = "支付"
        navigationController?.pushViewController(alipayVc, animated: true)
    }
    
    /// 充值系统繁忙提示
    private func showServerWarningAlert() {
        let systemModel = SystemAlertModel.init(title: "温馨提示", englishTitle: "System Tips", msgInfo: "当前支付系统繁忙\n请前往咨询抖阴官方客服，为您获取有效充值方式，切勿通过其他途径转账，以免资金受到损失。", tipsMsg: nil, commitTitle: "立即咨询",isLinkType: false)
        let controller = AlertManagerController(systemAlert: systemModel)
        controller.modalPresentationStyle = .overCurrentContext
        controller.commitActionHandler = { [weak self] in
            self?.goToServerVerb()
        }
        self.modalPresentationStyle = .currentContext
        self.present(controller, animated: true, completion: nil)
    }
    
    /// 联系管理员充值
    private func goToServerVerb() {
        if let url = URL(string: AppInfo.share().potato_invite_link ?? "") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    ///请求支付列表接口
    private func loadPayType() {
        let _ = payTypeApi.loadData()
    }
    
    ///立即付款点击事件
    @objc func payAction() {
        if currentPayType != nil {
            let _ = orderAddApi.loadData()
        } else {
            self.currentPayType = payTypes[0]
            let _ = orderAddApi.loadData()
        }
    }
}

// MARK: - UIScrollViewDelegate
extension OrderConfirmController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let sectionHeaderHeight: CGFloat = 50
        if scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y > 0 {
            scrollView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
            
        } else if scrollView.contentOffset.y >= sectionHeaderHeight {
            scrollView.contentInset = UIEdgeInsets(top: -sectionHeaderHeight, left: 0, bottom: 0, right: 0)
        }
    }
    
}

// MARK: - QHNavigationBarDelegate
extension OrderConfirmController:  QHNavigationBarDelegate  {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension OrderConfirmController: UITableViewDataSource, UITableViewDelegate {
    
    ///UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        } else if indexPath.section == 1 {
           return 70
        } else {
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 100.0
            return tableView.rowHeight
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        if section == 1 || section == 2 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 50))
            view.backgroundColor = UIColor.clear
            let lable = UILabel(frame: CGRect(x: 25, y: 10, width: ConstValue.kScreenWdith - 50, height: 30))
            lable.font = UIFont.systemFont(ofSize: 19)
            lable.textColor = UIColor.white
            lable.text = ["支付方式","使用卡说明"][section - 1]
            view.addSubview(lable)
            let lineView = UIView(frame: CGRect(x: 25, y: 49.5, width: ConstValue.kScreenWdith - 50, height: 0.5))
            lineView.backgroundColor = UIColor(red: 14/255.0 , green: 15/255.0, blue: 24/255.0, alpha: 0.99)
            view.addSubview(lineView)
            return view
        }
        return nil
       
    }
    
    /// UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return (orderdetail?.welfareCard?.count ?? 0) > 0 ? 3 : 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderConfirmCell.cellId, for: indexPath) as! OrderConfirmCell
            if (orderdetail?.welfareCard?.count ?? 0) > selectedIndex {
                cell.titleLab.text = [orderdetail!.title ?? "", "福利券", "金额总计"][indexPath.row]
                cell.accessoryType = .none
                let card = orderdetail!.welfareCard![selectedIndex]
                if indexPath.row == 0 {
                    cell.priceLab.text = "¥ \(orderdetail!.price_current ?? "0.00")"
                    cell.priceLab.textColor = ConstValue.kTitleYelloColor
                    cell.selectionStyle = .none
                }
                if indexPath.row == 1 {
                    cell.priceLab.text =  "\(card.discount ?? "1.0") 折"
                    cell.priceLab.textColor = UIColor.red
                }
                if indexPath.row == 2 {
                    let priceFinish = (Float((orderdetail!.price_current ?? "0.00")) ?? 0.00) * ((Float(card.discount ?? "1.00")) ?? 1.00)/10
                    finishPrice = priceFinish
                    cell.priceLab.text = String(format: "¥ %.2f", priceFinish)
                    cell.priceLab.textColor = ConstValue.kTitleYelloColor
                    self.payPriceLab.text = cell.priceLab.text
                    cell.selectionStyle = .none
                }
                if orderdetail!.welfareCard!.count > 1, indexPath.row == 1 {
                    cell.cardTipsLab.isHidden = false
                    cell.cardTipsLab.text = "\(orderdetail!.welfareCard!.count)张可用"
                    cell.accessoryType = .disclosureIndicator
                } else {
                    cell.cardTipsLab.isHidden = true
                    cell.accessoryType = .none
                }
                
            } else {
                 cell.titleLab.text = [cardModel?.title ?? "", "金额总计"][indexPath.row]
                if indexPath.row == 0 {
                    cell.priceLab.text = "¥ \(orderdetail?.price_current ?? "0.00")"
                    cell.priceLab.textColor = ConstValue.kTitleYelloColor
                    cell.selectionStyle = .none
                }
                if indexPath.row == 1 {
                    cell.priceLab.text = "¥ \(orderdetail?.price_current ?? "0.00")"
                    cell.priceLab.textColor = ConstValue.kTitleYelloColor
                    self.payPriceLab.text = cell.priceLab.text
                    cell.selectionStyle = .none
                }
            }
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: PayTypeChoseCell.cellId, for: indexPath) as! PayTypeChoseCell
            cell.selectionStyle = .none
            if payTypes.count > 0 {
                cell.setModels(payTypes)
            }
            cell.itemClickHandler = { [weak self] (model) in
                self?.currentPayType = model
            }
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderExplainCell.cellId, for: indexPath) as! OrderExplainCell
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && (orderdetail?.welfareCard?.count ?? 0) > 1 && indexPath.row == 1 {
            // 去选折扣卡
            let luckCardVC = LuckCardUnusedController()
            luckCardVC.cards = orderdetail!.welfareCard!
            luckCardVC.needFetch = false
            luckCardVC.choseCardHandler = { [weak self] (index) in
                guard let strongSelf = self else { return }
                self?.selectedIndex = index
                let card = strongSelf.orderdetail!.welfareCard![strongSelf.selectedIndex]
                let priceFinish = (Float((strongSelf.orderdetail!.price_current ?? "0.00")) ?? 0.00) * ((Float(card.discount ?? "1.00")) ?? 1.00)/10
                strongSelf.finishPrice = priceFinish
                self?.tableView.reloadData()
                luckCardVC.navigationController?.popViewController(animated: true)
                self?.loadPayType()
            }
            navigationController?.pushViewController(luckCardVC, animated: true)
        }
    }
    
}

// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension OrderConfirmController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        if manager is UserOrderAddApi {
            var params = [String: Any]()
            params[UserOrderAddApi.kOrder_type] = 2
            params[UserOrderAddApi.kDevice_type] = "ios"
            params[UserOrderAddApi.kDevice_code] = UIDevice.current.getIdfv()
            if let welfCards = orderdetail?.welfareCard, welfCards.count > selectedIndex {
                params[UserOrderAddApi.kU_wc_id] = welfCards[selectedIndex].id ?? 0
            } else {
                params[UserOrderAddApi.kU_wc_id] = 0
            }
            if cardModel != nil {
                params[UserOrderAddApi.kVc_id] = cardModel!.id
            }
            if currentPayType != nil {
                params[UserOrderAddApi.kPay_type] = currentPayType!.key ?? ""
            }
            return params
        }
        if manager is UserPayTypeListApi {
            if finishPrice == 0.00 {
                return [UserPayTypeListApi.kAmount: Float(orderdetail!.price_current ?? "0.00") ?? 0.00]
            } else {
                return [UserPayTypeListApi.kAmount: finishPrice]
            }
        }
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
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
        
        if  manager is UserPayTypeListApi {
            if let pays = manager.fetchJSONData(UserReformer()) as? [PayTypeModel] {
                if pays.count > 0 {
                    payTypes = pays
                    tableView.reloadSections([1], with: .none)
                }
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is UserOrderAddApi {
            showServerWarningAlert()
        }
    }
}

// MARK: - Description
private extension OrderConfirmController {
    
    func layoutPageSubviews() {
        layoutNavBar()
        layoutVIPCard()
        layoutPayTitleView()
        layoutPriceLable()
        layoutPayButton()
        layoutBottomView()
        layoutTableView()
    }
    
    func layoutVIPCard() {
        vipCardView.snp.makeConstraints { (make) in
            make.top.equalTo(navBar.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(165)
        }
    }
//    func layoutTableHeaderView() {
//        tableHeaderView.snp.makeConstraints { (make) in
//            make.leading.trailing.top.equalToSuperview()
//            make.height.equalTo(180)
//        }
//    }
    
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.bottom.equalTo(bottomView.snp.top)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(vipCardView.snp.bottom).offset(10)
        }
    }
    
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
    }
    
    func layoutBottomView() {
        bottomView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
            make.height.equalTo(50)
        }
    }
    
    func layoutPayTitleView() {
        payTitleLab.snp.makeConstraints { (make) in
            make.leading.equalTo(27)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    func layoutPriceLable() {
        payPriceLab.snp.makeConstraints { (make) in
            make.leading.equalTo(payTitleLab.snp.trailing).offset(5)
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
        }
    }
    
    func layoutPayButton() {
        payButton.snp.makeConstraints { (make) in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalTo(140)
        }
    }
    
}
