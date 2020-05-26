//
//  ExchangeController.swift
//  DouCartoonDemo
//
//  Created by mac on 2019/6/24.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit

class ExchangeController: QHBaseViewController {

    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "兑换中心"
        bar.backgroundColor =  ConstValue.kViewLightColor
        bar.lineView.backgroundColor = UIColor.clear
        bar.titleLabel.textColor = UIColor.white
        bar.delegate = self
        return bar
    }()
    
    private lazy var exChangeView: ExchangeView = {
        guard let login = Bundle.main.loadNibNamed("ExchangeView", owner: nil, options: nil)?[0] as? ExchangeView else { return ExchangeView() }
        login.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 240)
        return login
    }()
    
    let viewModel = UserInfoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(navBar)
        view.addSubview(exChangeView)
        layoutPageSubviews()
        addViewModelCallback()
        exChangeView.commitActionHandler = { [weak self] (actionid) in
            if actionid == 0 {
                self?.loadVipConvertInfo()
            } else if actionid == 1 {
                self?.exchange()
            }
        }
        exChangeView.exCodeTf.setPlaceholderTextColor(placeholderText: "请输入兑换码", color: UIColor(white: 0.7, alpha: 0.6))
    }
    
    private func loadVipConvertInfo() {
        XSProgressHUD.showCustomAnimation(msg: "验证中...", onView: self.view, imageNames: nil, bgColor: UIColor.clear, animated: false)
        _ = viewModel.exchangeInfo([VipConvertInfoApi.kCode: exChangeView.exCodeTf.text ?? ""])
    }
    
    private func exchange() {
        XSProgressHUD.showCustomAnimation(msg: "兑换中...", onView: self.view, imageNames: nil, bgColor: UIColor.clear, animated: false)
        _ = viewModel.exchangeVip([VipConvertInfoApi.kCode: exChangeView.exCodeTf.text ?? ""])
    }
    
    private func addViewModelCallback() {
        viewModel.exchangeInfoApiSuccessHandler = { [weak self] (model) in
            self?.stopLoading()
            self?.resetUI(model)
        }
        viewModel.exchangeIndoApiFailHandler = { [weak self] (msg) in
            XSAlert.show(type: .error, text: msg)
            self?.stopLoading()
        }
        
        viewModel.convertVipSuccessHandler = { [weak self] (model) in
            XSAlert.show(type: .success, text: "兑换成功")
            self?.stopLoading()
            self?.exChangeView.exCodeTf.text = nil
            self?.resetUI(model)
        }
        viewModel.convertVipFailHandler = { [weak self] (msg) in
            XSAlert.show(type: .error, text: msg)
            self?.stopLoading()
        }
    }
    
    private func resetUI(_ model: ExCoinsInfo) {
        exChangeView.statuContainer.isHidden = false
        exChangeView.containerHeight.constant = 240
        exChangeView.codeLable.text = model.code
        exChangeView.coinsLab.text = "\(model.title ?? "")"
        exChangeView.exStatuLab.text = (model.is_exchange ?? 0) == 0 ? "未兑换" : "已兑换"
        exChangeView.commitBtn.isEnabled = (model.is_exchange ?? 0) == 0
        exChangeView.commitBtn.setTitle("确认兑换", for: .normal)
        exChangeView.actionId = 1
    }
    
    private func stopLoading() {
        XSProgressHUD.hide(for: view, animated: false)
    }

}

// MARK: - CNavigationBarDelegate
extension ExchangeController: QHNavigationBarDelegate {
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Layout
private extension ExchangeController {
    func layoutPageSubviews() {
        layoutNavBar()
        layoutExView()
    }
    
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(statusBarHeight + 44)
        }
    }
    
    func layoutExView() {
        exChangeView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
}

