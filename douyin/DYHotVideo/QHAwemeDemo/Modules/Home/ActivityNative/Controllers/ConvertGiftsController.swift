//
//  ConvertGiftsController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019-12-21.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

/// 奖品兑换
class ConvertGiftsController: QHBaseViewController {
    
    static let bgColors: [UIColor] = [UIColor(r: 250, g: 170, b: 9),UIColor(r: 42, g: 138, b: 246),UIColor(r: 251, g: 73, b: 54),UIColor(r: 42, g: 121, b: 33)]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "兑奖专区"
        bar.titleLabel.textColor = UIColor.init(r: 34, g: 34, b: 34)
        bar.backButton.isHidden = false
        bar.lineView.isHidden = true
        bar.backgroundColor = UIColor.white
        bar.backButton.setImage(UIImage(named: "navBackBlack"), for: .normal)
        bar.delegate = self
        return bar
    }()
    private let tabeleHeader: UIView = {
        let collectHeight: CGFloat = 140
        let view = UIView(frame : CGRect(x: 0, y: 0, width: screenWidth, height: CGFloat(117.0 + collectHeight)))
        view.backgroundColor = UIColor.clear
        return view
    }()
    private lazy var headerView: ConvertGiftHeader = {
        let header = ConvertGiftHeader.init(frame: CGRect.zero)
        header.backgroundColor = UIColor.white
        header.layer.cornerRadius = 4.0
        header.layer.masksToBounds = true
        return header
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ConvertGiftTableCell.classForCoder(), forCellReuseIdentifier: ConvertGiftTableCell.cellId)
        tableView.register(ConvertSectionTitleCell.classForCoder(), forCellReuseIdentifier: ConvertSectionTitleCell.cellId)
        tableView.register(ConvertSectionFooter.classForCoder(), forHeaderFooterViewReuseIdentifier: ConvertSectionFooter.reuseId)
        return tableView
    }()
    var activityId: Int = 0
    var giftSectionModels = [GameGiftListModel]()
    
    let viewModel = GameViewModel()
    
    deinit {
        DLog("VC release")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(r: 244, g: 244, b: 244)
        view.addSubview(navBar)
        view.addSubview(tableView)
        tabeleHeader.addSubview(headerView)
        layoutPageViews()
        loadConvertList()
    }
    
    private func loadConvertList() {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, animated: false)
        viewModel.loadConvertListData([GameConvertListApi.kActivity_id: activityId], succeedHandler: { [weak self] (model) in
            self?.loadConvertListSuccess(model)
        }) { [weak self] (errormsg) in
            self?.loadListFailed(errormsg)
        }
    }
    
    private func loadConvertListSuccess(_ model: ConvertListModel) {
        XSProgressHUD.hide(for: view, animated: false)
        if let userPropData = model.user_props_data, userPropData.count > 0 {
            headerView.setModels(userPropData)
            tableView.tableHeaderView = tabeleHeader
        }
        if let giftModels = model.game_prize_data {
            giftSectionModels = giftModels
        }
        tableView.reloadData()
    }
    
    private func loadListFailed(_ errorMsg: String) {
        XSProgressHUD.hide(for: view, animated: false)
        XSAlert.show(type: .error, text: errorMsg)
    }
    
    private func convertGift(_ prizeSid: Int) {
        viewModel.convertGiftData([ConvertGiftApi.kActivity_id: activityId, ConvertGiftApi.kPrizero_sid: prizeSid], succeedHandler: { [weak self] (model) in
            self?.loadConvertListSuccess(model)
        }) { (errorMsg) in
            XSAlert.show(type: .error, text: errorMsg)
        }
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension ConvertGiftsController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return giftSectionModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let giftGroupModel = giftSectionModels[section]
        if let gifts = giftGroupModel.prize_list {
            return gifts.count + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let giftGroupModel = giftSectionModels[indexPath.section]
        if indexPath.row == 0 {
            let cell =  tableView.dequeueReusableCell(withIdentifier: ConvertSectionTitleCell.cellId, for: indexPath) as! ConvertSectionTitleCell
            cell.titleLabel.text = giftGroupModel.props_info?.props_title
            cell.shadowLabel.text = giftGroupModel.props_info?.props_name_en
            cell.desLabel.text = "已拥有\(giftGroupModel.props_info?.props_name ?? ""):\(giftGroupModel.props_info?._user_props_number ?? 0)个"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ConvertGiftTableCell.cellId, for: indexPath) as! ConvertGiftTableCell
            if let gifts = giftGroupModel.prize_list, gifts.count > indexPath.row - 1 {
                let giftModel = gifts[indexPath.row - 1]
                cell.giftIcon.kfSetVerticalImageWithUrl(giftModel.prize_img)
                cell.nameLabel.text = "\(giftModel.prize_name ?? "")"
                cell.desLabel.text = "\(giftModel.prize_props_number ?? 0)个可以兑换"
                if let canConvert = giftModel._is_convert, canConvert == 1 {
                    cell.convertButton.isEnabled = true
                } else {
                    cell.convertButton.isEnabled = false
                }
                cell.convertActionHandler = { [weak self] in
                    self?.convertGift(giftModel.prizero_sid ?? 0)
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 90.0
        }
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: ConvertSectionFooter.reuseId)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: - QHNavigationBarDelegate
extension ConvertGiftsController: QHNavigationBarDelegate  {
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: -Layout
private extension ConvertGiftsController {
    
    func layoutPageViews() {
        layoutNavBar()
        layoutTableView()
        layoutHederView()
    }
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(safeAreaTopHeight)
        }
    }
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(navBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                // Fallback on earlier versions
                make.bottom.equalToSuperview()
            }
        }
    }
    func layoutHederView() {
        headerView.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
        }
    }
}
