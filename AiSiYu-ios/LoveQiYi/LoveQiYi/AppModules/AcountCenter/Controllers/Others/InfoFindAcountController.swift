//
//  InfoFindAcountController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/4/3.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

/// 通过信息找回原来账号
class InfoFindAcountController: UIViewController {
    
    static let fakeCell = "fakeCellId"
    
    private lazy var navBar: CNavigationBar = {
        let bar = CNavigationBar()
        bar.titleLabel.text = "填写资料找回"
        bar.backgroundColor = UIColor.clear
        bar.delegate = self
        return bar
    }()
    private lazy var bgScroll: UIView = {
        let scroll = UIView.init(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 710))
        scroll.backgroundColor = UIColor.clear
        return scroll
    }()
    let titLable: UILabel = {
        let lable = UILabel()
        lable.textColor = ConstValue.kAppDefaultColor
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.text = "*以下资料可以帮助您找回账号,请尽量填写准确"
        return lable
    }()
    /// 邀请码
    let orderTitleLable: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.darkText
        lable.font = UIFont.systemFont(ofSize: 13)
        lable.text = "开通会员时的支付宝订单编号(选填)"
        return lable
    }()
    private lazy var orderNumTf: UITextField = {
        let textFiled = UITextField()
        textFiled.tintColor = .clear
        textFiled.backgroundColor = UIColor(r: 244, g: 244, b: 244)
        textFiled.textColor = UIColor.darkText
        textFiled.borderStyle = .none
        textFiled.font = UIFont.systemFont(ofSize: 15)
        textFiled.layer.cornerRadius = 8
        textFiled.layer.masksToBounds = true
        textFiled.placeholder = "  请填写订单编号"
        textFiled.setValue(UIColor(white: 0.7, alpha: 0.6), forKeyPath: "_placeholderLabel.textColor")
        return textFiled
    }()
    /// username
    let usernameLable: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.darkText
        lable.font = UIFont.systemFont(ofSize: 13)
        lable.text = "丢失账号用户名 (选填)"
        return lable
    }()
    private lazy var usernameTf: UITextField = {
        let textFiled = UITextField()
        textFiled.tintColor = .clear
        textFiled.backgroundColor = UIColor(r: 244, g: 244, b: 244)
        textFiled.textColor = UIColor.darkText
        textFiled.borderStyle = .none
        textFiled.font = UIFont.systemFont(ofSize: 15)
        textFiled.layer.cornerRadius = 8
        textFiled.layer.masksToBounds = true
        textFiled.placeholder = "  如:郑成仁"
        textFiled.setValue(UIColor(white: 0.7, alpha: 0.6), forKeyPath: "_placeholderLabel.textColor")
        return textFiled
    }()
    /// 注册时间
    let registTimeLable: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.darkText
        lable.font = UIFont.systemFont(ofSize: 13)
        lable.text = "丢失账号邀请码 (选填)"
        return lable
    }()
    private lazy var registerTimeTf: UITextField = {
        let textFiled = UITextField()
        textFiled.tintColor = .clear
        textFiled.backgroundColor = UIColor(r: 244, g: 244, b: 244)
        textFiled.textColor = UIColor.darkText
        textFiled.borderStyle = .none
        textFiled.font = UIFont.systemFont(ofSize: 15)
        textFiled.layer.cornerRadius = 8
        textFiled.layer.masksToBounds = true
        textFiled.placeholder = "  如：GZDKZ"
        textFiled.setValue(UIColor(white: 0.7, alpha: 0.6), forKeyPath: "_placeholderLabel.textColor")
        return textFiled
    }()
    ///  说明备注
    let remarkLable: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.darkText
        lable.font = UIFont.systemFont(ofSize: 13)
        lable.text = "说明备注"
        return lable
    }()
    lazy var remarkTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.darkText
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.layer.cornerRadius = 10
        textView.backgroundColor = UIColor(r: 244, g: 244, b: 244)
        textView.clipsToBounds = false
        textView.delegate = self
        return textView
    }()
    let placeHodlerLable: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor(white: 0.7, alpha: 0.6)
        lable.numberOfLines = 3
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.text = " 请尽可能详情的描述需要找回的账号信息,可缩短找回账号所需要期限"
        return lable
    }()
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.clear
        table.showsVerticalScrollIndicator = false
        table.delegate = self
        table.dataSource = self
        table.allowsSelection = false
        table.separatorStyle = .none
        table.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: InfoFindAcountController.fakeCell)
        return table
    }()
    
    lazy var commitBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = ConstValue.kAppDefaultColor
        button.layer.cornerRadius = 23
        button.layer.masksToBounds = true
        button.setTitle("提交资料", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(commitClick), for: .touchUpInside)
        return button
    }()
    let viewMode = AcountViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(navBar)
        view.addSubview(tableView)
        layoutViewSubviews()
        bgScroll.addSubview(titLable)
        bgScroll.addSubview(orderTitleLable)
        bgScroll.addSubview(orderNumTf)
        bgScroll.addSubview(usernameLable)
        bgScroll.addSubview(usernameTf)
        bgScroll.addSubview(registTimeLable)
        bgScroll.addSubview(registerTimeTf)
        bgScroll.addSubview(remarkLable)
        bgScroll.addSubview(remarkTextView)
        bgScroll.addSubview(placeHodlerLable)
        bgScroll.addSubview(commitBtn)
        tableView.tableHeaderView = bgScroll
        layoutPageSubviews()
        addViewModelCallBack()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func addViewModelCallBack() {
        viewMode.infoFindApiSuccessHandler = { [weak self] in
            guard let strongSelf  = self else { return }
            XSProgressHUD.hide(for: strongSelf.view, animated: false)
            strongSelf.showAlert(true)
        }
        viewMode.infoFindApiFailHandler = { [weak self] in
            guard let strongSelf  = self else { return }
            XSProgressHUD.hide(for: strongSelf.view, animated: false)
            XSAlert.show(type: .error, text: "提交失败，请稍后再试")
        }
    }
    
    private func showAlert(_ success: Bool) {
        let succeedModel = ConvertCardAlertModel.init(title: "资料提交成功", msgInfo: "请等待管理员审核结果，如有疑问请到客服群联系管理员。", success: true)
        let controller = AlertManagerController(alertInfoModel: succeedModel)
        controller.modalPresentationStyle = .overCurrentContext
        controller.view.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        controller.commitActionHandler = { [weak self] in
            if success {
                self?.navigationController?.popViewController(animated: true)
            }
        }
        self.modalPresentationStyle = .currentContext
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc private func commitClick() {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: self.view, imageNames: nil, bgColor: UIColor.clear, animated: false)
        let params: [String: Any] = [InfoFindAcountApi.kUsername: usernameTf.text ?? "", InfoFindAcountApi.kOrder_no: orderNumTf.text ?? "", InfoFindAcountApi.kRegister_at: registerTimeTf.text ?? "", InfoFindAcountApi.kRemark: remarkTextView.text ?? ""]
        viewMode.findAcountWithInfo(params)
    }
   
}

// MARK: - CNavigationBarDelegate
extension InfoFindAcountController:  CNavigationBarDelegate  {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextViewDelegate
extension InfoFindAcountController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeHodlerLable.text = ""
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.isEmpty {
            placeHodlerLable.text = " 请尽可能详情的描述需要找回的账号信息,可缩短找回账号所需要期限"
        }
        return true
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension InfoFindAcountController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

// MARK: - UIScrollViewDelegate
extension InfoFindAcountController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

// MARK: - Layout
private extension InfoFindAcountController {
    
    func layoutPageSubviews() {
        layoutTipsLable()
        layoutOrderPart()
        layoutUserPart()
        layoutRegisterPart()
        layoutRemarkPart()
        layoutCommitBtn()
    }
    
    func layoutViewSubviews() {
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
    
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
    }
    
    func layoutScrollView() {
        bgScroll.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(710)
            make.width.equalTo(ConstValue.kScreenWdith)
        }
    }
    
    func layoutTipsLable() {
        titLable.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(15)
            make.height.equalTo(30)
        }
    }
    
    func layoutOrderPart() {
        orderTitleLable.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(titLable.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
        orderNumTf.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(orderTitleLable.snp.bottom).offset(10)
            make.height.equalTo(44)
        }
    }
    
    func layoutUserPart() {
        usernameLable.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(orderNumTf.snp.bottom).offset(20)
            make.height.equalTo(20)
        }
        usernameTf.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(usernameLable.snp.bottom).offset(10)
            make.height.equalTo(44)
        }
    }
    
    func layoutRegisterPart() {
        registTimeLable.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(usernameTf.snp.bottom).offset(20)
            make.height.equalTo(20)
        }
        registerTimeTf.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(registTimeLable.snp.bottom).offset(10)
            make.height.equalTo(44)
        }
    }
    
    func layoutRemarkPart() {
        remarkLable.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(registerTimeTf.snp.bottom).offset(20)
            make.height.equalTo(20)
        }
        remarkTextView.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(remarkLable.snp.bottom).offset(10)
            make.height.equalTo(150)
        }
        placeHodlerLable.snp.makeConstraints { (make) in
            make.leading.equalTo(25)
            make.trailing.equalTo(-25)
            make.top.equalTo(remarkLable.snp.bottom).offset(15)
            make.height.equalTo(40)
        }
    }
    
    func layoutCommitBtn() {
        commitBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.height.equalTo(46)
            make.top.equalTo(remarkTextView.snp.bottom).offset(25)
        }
    }
}

