//
//  DrawCashController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/6/1.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork

class DrawCashController: UIViewController {

    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "提现"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.clear
        bar.backButton.setImage(UIImage(named: "navbackWhite"), for: .normal)
        bar.lineView.backgroundColor = UIColor.clear
        bar.delegate = self
        return bar
    }()
    private let headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 145))
        view.backgroundColor = UIColor.clear
        return view
    }()
    private var header: DrawCashHead = {
        guard let view = Bundle.main.loadNibNamed("DrawCashHead", owner: nil, options: nil)?[0] as? DrawCashHead else { return DrawCashHead() }
        view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 145)
        return view
    }()
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    private lazy var drawBackBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("确认提现", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = UIColor(r: 0, g: 123, b: 255)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(drawBtnClick(_:)), for: .touchUpInside)
        button.layer.cornerRadius = 22.5
        button.layer.masksToBounds = true
        return button
    }()
    private lazy var recordBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "recordMoney"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(UIColor.darkText, for: .normal)
        button.addTarget(self, action: #selector(recordBtnClick(_:)), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.clear
        table.showsVerticalScrollIndicator = false
        table.allowsSelection = false
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(OrderExplainCell.classForCoder(), forCellReuseIdentifier: OrderExplainCell.cellId)
        table.register(UINib(nibName: "DrawCashCell", bundle: Bundle.main), forCellReuseIdentifier: DrawCashCell.cellId)
        table.register(UINib(nibName: "DrawCashAlCell", bundle: Bundle.main), forCellReuseIdentifier: DrawCashAlCell.cellId)
        return table
    }()
    private lazy var getCashApi: UserGetCashApi = {
        let api = UserGetCashApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    private var params = [String: Any]()
    var allMoney = "0.00"
    
    var minMoney: Float = 0.00
    
    var drawTypyAlipay = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubviews()
    }
    
    private func setUpSubviews() {
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(navBar)
        navBar.navBarView.addSubview(recordBtn)
        headerView.addSubview(header)
        view.addSubview(headerView)
        view.addSubview(bottomView)
        view.addSubview(drawBackBtn)
        view.addSubview(tableView)
        addHeaderActionCallBack()
        
        tableView.tableHeaderView = headerView
        layoutPageSubviews()
        
        if let money = AppInfo.share().app_rule?.money, !money.isEmpty {
            minMoney = Float(money) ?? 0.00
        }

        if let all = Float(allMoney) {
            if all < minMoney {
                header.sxfLab.attributedText = TextSpaceManager.configColorString(allString: "余额\(allMoney)(满\(minMoney)可提现)", attribStr: "\(allMoney)")
                header.allMoney = Float(allMoney) ?? 0.00
            } else {
                header.sxfLab.attributedText = TextSpaceManager.configColorString(allString: "可提现\(allMoney)(最少\(minMoney)元)", attribStr: "\(allMoney)")
                header.allMoney = Float(allMoney) ?? 0.00
            }
        }
    }
    
    private func addHeaderActionCallBack() {
        header.actionHandler = { [weak self] in
            self?.header.moneyValue.text = self?.allMoney
            if let num = self?.header.moneyValue.text, !num.isEmpty {
                if let moneyFuWu = Float(num) {
                    if moneyFuWu < self?.minMoney ?? 0.00 {
                        XSAlert.show(type: .error, text: "最小提现金额为\(self?.minMoney ?? 0.00)元")
                        return
                    }
                    let fee: Float = Float(AppInfo.share().app_rule?.fee ?? "0") ?? 0
                    let ps = fee/100.0
                    self?.header.sxfLab.attributedText = TextSpaceManager.configColorString(allString: "服务费: ￥\(String(format: "%.2f", Float(moneyFuWu*ps)))", attribStr: "￥\(String(format: "%.2f", Float(moneyFuWu*ps)))")
                }
            }
        }
    }
    
    @objc private func drawBtnClick(_ sender: UIButton) {
        if let num = header.moneyValue.text, !num.isEmpty {
            if let moneyFuWu = Float(num) {
                if moneyFuWu < minMoney {
                    XSAlert.show(type: .error, text: "最小提现金额为\(minMoney)元")
                    return
                }
                let fee: Float = Float(AppInfo.share().app_rule?.fee ?? "0") ?? 0
                let ps = fee/100.0
                header.sxfLab.attributedText = TextSpaceManager.configColorString(allString: "服务费: ￥\(String(format: "%.2f", Float(moneyFuWu*ps)))", attribStr: "￥\(String(format: "%.2f", Float(moneyFuWu*ps)))")
            }
        } else {
            XSAlert.show(type: .error, text: "请输入提现金额")
            return
        }
        var paramsforApi = [String: Any]()
        if drawTypyAlipay {
            if let cell = tableView.cellForRow(at: IndexPath.init(item: 0, section: 0)) as? DrawCashAlCell {
                if cell.nameTf.text == nil || cell.nameTf.text!.isEmpty {
                    XSAlert.show(type: .error, text: "请输入名称")
                    return
                }
                paramsforApi[UserGetCashApi.kWithdraw_name] = cell.nameTf.text
                if cell.alipayTf.text == nil || cell.alipayTf.text!.isEmpty {
                    XSAlert.show(type: .error, text: "请输入支付宝账号")
                    return
                }
                paramsforApi[UserGetCashApi.kWithdraw_alipayno] = cell.alipayTf.text
                paramsforApi[UserGetCashApi.kWithdraw_type] = 1
                paramsforApi[UserGetCashApi.kmoney] = Float(header.moneyValue.text ?? "0.00")
                paramsforApi[UserGetCashApi.kDevice_Code] = UIDevice.current.getIdfv()
                paramsforApi[UserGetCashApi.kDevice_type] = "ios"
            }
        } else {
            if let cell = tableView.cellForRow(at: IndexPath.init(item: 0, section: 0)) as? DrawCashCell {
                if cell.inputTextfile.text == nil || cell.inputTextfile.text!.isEmpty {
                    XSAlert.show(type: .error, text: "请输入名称")
                    return
                }
                paramsforApi[UserGetCashApi.kWithdraw_name] = cell.inputTextfile.text
                if cell.bankName.text == nil || cell.bankName.text!.isEmpty {
                    XSAlert.show(type: .error, text: "请输入银行名称")
                    return
                }
                paramsforApi[UserGetCashApi.kWithdraw_banknam] = cell.bankName.text
                if cell.bankCard.text == nil || cell.bankCard.text!.isEmpty {
                    XSAlert.show(type: .error, text: "请输入银行卡号")
                    return
                }
                paramsforApi[UserGetCashApi.kWithdraw_cardno] = cell.bankCard.text
                if cell.bankKh.text == nil || cell.bankKh.text!.isEmpty {
                    XSAlert.show(type: .error, text: "请输入开户行")
                    return
                }
                paramsforApi[UserGetCashApi.kWithdraw_bankopen] = cell.bankKh.text
                paramsforApi[UserGetCashApi.kWithdraw_type] = 2
                paramsforApi[UserGetCashApi.kmoney] = Float(header.moneyValue.text ?? "0.00")
                paramsforApi[UserGetCashApi.kDevice_Code] = UIDevice.current.getIdfv()
                paramsforApi[UserGetCashApi.kDevice_type] = "ios"
            }
        }
        params = paramsforApi
        /// 调用接口
        let _ = getCashApi.loadData()
        
    }
    
    @objc private func recordBtnClick(_ sender: UIButton) {
        let vc = DrawCashRecordController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - QHNavigationBarDelegate
extension DrawCashController:  QHNavigationBarDelegate  {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension DrawCashController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return drawTypyAlipay ? 120 : 245
        }
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100.0
        return tableView.rowHeight
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = DrawTypeView.init(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 55))
            view.buttonClick(drawTypyAlipay ? view.alipayBtn : view.bankCardBtn)
            view.actionHandler = { [weak self] (tag) in
                self?.drawTypyAlipay = tag == 1
                self?.tableView.reloadData()
            }
            return view
        }
        return nil
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: OrderExplainCell.cellId, for: indexPath) as! OrderExplainCell
            cell.msgLable.font = UIFont.systemFont(ofSize: 14)
            cell.msgLable.text = "温馨提示：\r\r1、请填写正确的\(drawTypyAlipay ? "支付宝账号" : "银行卡信息")及姓名，如信息填写错误可能导致提现失败\r\r2、提现到账时间为1-2个工作日，请随时留意银行账单状态注意查收\r\r3、您的个人信息将严格保密，不会用于任何第三方"
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            return cell
        } else if indexPath.section == 0 {
            if drawTypyAlipay {
                let cell = tableView.dequeueReusableCell(withIdentifier: DrawCashAlCell.cellId, for: indexPath) as! DrawCashAlCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: DrawCashCell.cellId, for: indexPath) as! DrawCashCell
                return cell
            }
        }
        return UITableViewCell()
    }
    
}

// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension DrawCashController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        if manager is UserGetCashApi {
            return params
        }
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)

        if manager is UserGetCashApi {
            let vc = DrawSuccController()
            vc.money = header.moneyValue.text ?? "0.00"
            addChild(vc)
            view.addSubview(vc.view)
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is UserPayTypeListApi {
            XSAlert.show(type: .error, text: "申请提交失败，请稍后再试")
        }
    }
}


// MARK: - Description
private extension DrawCashController {
    
    func layoutPageSubviews() {
        layoutNavBar()
        layoutRecordBtn()
        layoutTableHeaderView()
        layoutBottomView()
        layoutTableView()
    }
    
    func layoutTableHeaderView() {
        header.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.bottom.equalTo(bottomView.snp.top)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom).offset(0)
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
            make.height.equalTo(65)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
            make.leading.trailing.equalToSuperview()
        }
        drawBackBtn.snp.makeConstraints { (make) in
            make.top.equalTo(bottomView).offset(10)
            make.height.equalTo(45)
            make.leading.equalTo(25)
            make.trailing.equalTo(-25)
        }
    }
    
    func layoutRecordBtn() {
        recordBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-12)
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(35)
        }
    }
    
    
    
}
