//
//  MsgCenterController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/14.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

///消息中心
class MsgCenterController: UIViewController {
    
    let icons = ["msgCenterIcon1", "msgCenterIcon2"]
    let titles = ["我的消息", "官方公告"]
    let texts = ["关于个人的消息都在这里哟", "我们会在这里说一些很重要的事情哦"]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "消息中心"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.clear
        bar.delegate = self
        return bar
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor.clear
        table.showsVerticalScrollIndicator = false
        table.allowsSelection = true
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(MsgCenterMainCell.classForCoder(), forCellReuseIdentifier: MsgCenterMainCell.cellId)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(navBar)
        view.addSubview(tableView)
        layoutPageSubviews()
    }
    
    
    
}

// MARK: - QHNavigationBarDelegate
extension MsgCenterController:  QHNavigationBarDelegate  {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MsgCenterController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MsgCenterMainCell.cellId, for: indexPath) as! MsgCenterMainCell
        cell.iconImage.image = UIImage(named: icons[indexPath.row])
        cell.titleLab.text = titles[indexPath.row]
        cell.textsLab.text = texts[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let listCenter = MsgListController()
        navigationController?.pushViewController(listCenter, animated: true)
    }
    
}

// MARK: - Layout
private extension MsgCenterController {
    
    func layoutPageSubviews() {
        layoutNavBar()
        layoutTableView()
    }
    
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
        }
    }
    
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
    }
    
    
}
