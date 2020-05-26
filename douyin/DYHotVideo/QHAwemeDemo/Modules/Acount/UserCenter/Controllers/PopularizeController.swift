//
//  PopularizeController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//  推广权益

import UIKit
import NicooNetwork

class PopularizeController: QHBaseViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "推广权益"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.clear
        bar.delegate = self
        return bar
    }()
    
    private lazy var titleImageV: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "titleImage")
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var rewardWallImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "scroll")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView.init(frame: .zero, style: .plain)
       tableView.delegate = self
       tableView.dataSource = self
       tableView.separatorStyle = .none
       tableView.backgroundColor = .clear
       tableView.register(InviteCell.classForCoder(), forCellReuseIdentifier: InviteCell.cellId)
       tableView.register(InviteSectionHeader.classForCoder(), forHeaderFooterViewReuseIdentifier: InviteSectionHeader.reuseId)
       return tableView
    }()
    
    private lazy var footerView: InviteSectionFooter = {
        let footerView = InviteSectionFooter(frame: CGRect(x: 0, y: 0, width: screenWidth - 42, height: 784))
        return footerView
    }()
    
    private lazy var invitRuleApi: InvitationRulesApi = {
        let api = InvitationRulesApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    var inviteRules: [InviteRuleModel] = [InviteRuleModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(r: 68, g: 76, b: 247)
        view.addSubview(navBar)
        view.addSubview(titleImageV)
        view.addSubview(rewardWallImage)
        view.addSubview(tableView)
        tableView.tableFooterView = footerView
        layoutPageViews()
        loadData()
        addFooterViewCallBack()
    }
    
    private func loadData() {
        let _ = invitRuleApi.loadData()
    }

    private func addFooterViewCallBack() {
        footerView.buttonClickHandler = { [weak self] tag in
            guard let strongSelf = self else {return}
            if tag == 100 {
                strongSelf.copyLinkURL()
            } else if tag == 101 || tag == 102 {
                let vc = PopularizeShareController()
                vc.modalPresentationStyle = .fullScreen
                strongSelf.present(vc, animated: true, completion: nil)
//                strongSelf.screenSnapshot(save: true)
            }
        }
    }
    
    func screenSnapshot(save: Bool)  {
        guard let window = UIApplication.shared.keyWindow else {return}
        // 用下面这行而不是UIGraphicsBeginImageContext()，因为前者支持Retina
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, 0.0)
        window.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if save {
            UIImageWriteToSavedPhotosAlbum(image ?? UIImage(), self, nil, nil)
        }
        XSProgressHUD.showSuccess(msg: "保存图片成功", onView: view, animated: true)
    }
    
    func copyLinkURL() {
        var downString = ConstValue.kAppDownLoadLoadUrl
        if let downloadString = AppInfo.share().share_url {
            if downloadString.hasSuffix("/") {
                downString = downloadString
            } else {
                downString = String(format: "%@%@", downloadString, "/")
            }
        }
        
        if let userInviteCode = UserModel.share().userInfo?.code {
            downString = String(format: "%@%@",downString, userInviteCode)
        } else {
            if let codeSave = UserDefaults.standard.object(forKey: UserDefaults.kUserInviteCode) as? String {
                downString = String(format: "%@%@", downString, codeSave)
            } else {
                downString = String(format: "%@", downString)
            }
        }
        var textShare = "抖阴小视频"
        if let textToShare = AppInfo.share().share_text {
            if textToShare.contains("{{share_url}}") {
                textShare = textToShare.replacingOccurrences(of: "{{share_url}}", with: downString)
            }
        }
        UIPasteboard.general.string = String(format: "%@", textShare)
        XSAlert.show(type: .success, text: "推广链接复制成功！")
    }
}

//MARK: -UITableViewDataSource && UITableViewDelegate
extension PopularizeController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inviteRules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InviteCell.cellId, for: indexPath) as! InviteCell
        cell.setModel(model: inviteRules[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return InviteCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return InviteSectionHeader.headerHeight
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: InviteSectionHeader.reuseId) as! InviteSectionHeader
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension PopularizeController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is InvitationRulesApi {
            if let ruleList = manager.fetchJSONData(UserReformer()) as? [InviteRuleModel] {
                inviteRules = ruleList
                tableView.reloadData()
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
    }
}

//MARK: -Layout
extension PopularizeController {
    
    func layoutPageViews() {
         layoutNavBar()
         layoutTitleImageView()
         layoutRewardImageView()
         layoutTableView()
    }
    
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(safeAreaTopHeight)
        }
    }
    
    func layoutTitleImageView() {
        titleImageV.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
            make.height.equalTo(147.0)
        }
    }
    
    func layoutRewardImageView() {
        rewardWallImage.snp.makeConstraints { (make) in
            make.leading.equalTo(9.5)
            make.trailing.equalTo(-9.5)
            make.top.equalTo(navBar.snp.bottom).offset(152)
            make.height.equalTo(27)
        }
    }
    
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20.5)
            make.top.equalTo(navBar.snp.bottom).offset(165)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
}

//MARK: -QHNavigationBarDelegate
extension PopularizeController: QHNavigationBarDelegate {
    func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
