//
//  InviteRecordViewController.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/25.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//  邀请记录控制器

import UIKit
import NicooNetwork

class InviteRecordViewController: BaseViewController {
    
    private let topCountView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    private let img: UIImageView = {
       let img = UIImageView(image: UIImage(named: "invitedAccount"))
       img.isUserInteractionEnabled = true
       img.contentMode = .scaleToFill
       img.clipsToBounds = true
       return img
    }()
    private let countLabel: UILabel = {
       let label = UILabel()
       label.textColor = .white
       label.font = UIFont.systemFont(ofSize: 35)
       label.textAlignment = .center
       label.text = "0"
       return label
    }()
    private let alreadyLabel: UILabel = {
        let lable = UILabel()
        lable.textColor = .white
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.text = "已邀请人数"
        return lable
    }()
    ///tableView数据为0时，显示
    private let notYetLabel: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.lightGray
        lable.textAlignment = .center
        lable.numberOfLines = 0
        lable.font = UIFont.systemFont(ofSize: 12)
        lable.text = "您还没有邀请好友哦"
        lable.isHidden = true
        return lable
    }()
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.clear
        table.showsVerticalScrollIndicator = false
        table.allowsSelection = false
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(InviteRecordCell.classForCoder(), forCellReuseIdentifier: InviteRecordCell.cellId)
        table.mj_header = refreshView
        return table
    }()
    private lazy var inviteRecodeApi: UserInvitedListApi = {
        let api = UserInvitedListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    private let leftLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    private let rightLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    private let topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    private let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    var currentPage = 0
    var inviteList = [inviteUserModel]()
    var inviteListModel: InviteListModel = InviteListModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavBar()
        layoutPageSubviews()
        loadData()
        setTopViewData()
    }
    
    private func configNavBar() {
        navBar.titleLabel.text = "邀请记录"
    }
    
    private func loadData() {
        NicooErrorView.removeErrorMeesageFrom(self.view)
        notYetLabel.isHidden = true
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        let _ = inviteRecodeApi.loadData()
    }
    
    override func loadFirstPage() {
      inviteListSuccess(self.inviteListModel)
      loadData()
    }
    
    override func loadNextPage() {
         let _ = inviteRecodeApi.loadNextPage()
    }
    
    func endRefreshing() {
        refreshView.endRefreshing()
        loadMoreView.endRefreshing()
    }
    
    private func  inviteListSuccess(_ listModel: InviteListModel) {
        self.inviteListModel = listModel
        if let models = listModel.data {
            if inviteRecodeApi.pageNumber == 1 {
                inviteList = models
                notYetLabel.isHidden = models.count != 0
            } else {
                inviteList.append(contentsOf: models)
            }
            currentPage = inviteRecodeApi.pageNumber
            loadMoreView.isHidden = models.count < UserInvitedListApi.kDefaultCount
        }
        endRefreshing()
        tableView.reloadData()
    }
    
    private func setTopViewData() {
        countLabel.text = "\(UserModel.share().userInfo?.invite ?? "0")"
    }
}

extension InviteRecordViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inviteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InviteRecordCell.cellId, for: indexPath) as! InviteRecordCell
        let model = inviteList[indexPath.row]
        cell.inviteTimeLab.text = "\(model.created_at ?? "")"
        cell.userNameLab.text = "\(model.nick_name ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50))
            view.backgroundColor = UIColor(r: 244, g: 244, b: 244)
            let userName = UILabel(frame: CGRect(x:0, y: 0, width: screenWidth/2, height: 50))
            userName.textColor = UIColor(r: 139, g: 139, b: 139)
            userName.textAlignment = .center
            userName.font = UIFont.systemFont(ofSize: 14)
            userName.text = "用户名"
            view.addSubview(userName)
            let inviterTimetitle = UILabel(frame: CGRect(x: screenWidth/2, y: 0, width: screenWidth/2, height: 50))
            inviterTimetitle.textColor = UIColor(r: 139, g: 139, b: 139)
            inviterTimetitle.textAlignment = .center
            inviterTimetitle.font = UIFont.systemFont(ofSize: 14)
            inviterTimetitle.text = "邀请时间"
            view.addSubview(inviterTimetitle)
            return view
        }
        return nil
    }
}

// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension InviteRecordViewController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is UserInvitedListApi {
            if let inviteList = manager.fetchJSONData(UserReformer()) as? InviteListModel {
                inviteListSuccess(inviteList)
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is UserInvitedListApi && currentPage == 0 {
            NicooErrorView.showErrorMessage(.noNetwork, on: view, topMargin: screenHeight/2 - 60) {
                self.loadData()
            }
        }
    }
}

// MARK: - Layout
private extension InviteRecordViewController {
    
    func layoutPageSubviews() {
        layoutTopContainer()
        layoutTopImg()
        layoutCountlable()
        layoutAlreadyLable()
        layoutTableView()
        layoutNotYetLable()
    }
    
    func layoutTopContainer() {
        view.addSubview(topCountView)
        topCountView.snp.makeConstraints { (make) in
            make.leading.equalTo(14)
            make.trailing.equalTo(-14)
            make.top.equalTo(navBar.snp.bottom).offset(10)
            make.height.equalTo(135)
        }
    }

    func layoutCountlable() {
        topCountView.addSubview(countLabel)
        countLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(topCountView.snp.centerY).offset(-5)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
    }
    
    func layoutAlreadyLable() {
        topCountView.addSubview(alreadyLabel)
        alreadyLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(countLabel.snp.bottom).offset(10)
            make.height.equalTo(35)
        }
    }
    
    func layoutTopImg() {
        topCountView.addSubview(img)
        img.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    func layoutTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(topCountView.snp.bottom).offset(12)
        }
    }

    func layoutNotYetLable() {
        view.addSubview(notYetLabel)
        notYetLabel.snp.makeConstraints { (make) in
            make.center.equalTo(tableView)
        }
    }
}
