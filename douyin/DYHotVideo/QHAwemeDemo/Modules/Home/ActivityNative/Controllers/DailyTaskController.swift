//
//  DailyTaskController.swift
//  QHAwemeDemo
//
//  Created by mac on 20/12/2019.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//  每日任务控制器

import UIKit
import MJRefresh
import NicooNetwork

class DailyTaskController: QHBaseViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "每日任务"
        bar.titleLabel.textColor = UIColor.init(r: 34, g: 34, b: 34)
        bar.backButton.isHidden = false
        bar.lineView.isHidden = true
        bar.backgroundColor = UIColor.white
        bar.backButton.setImage(UIImage(named: "navBackBlack"), for: .normal)
        bar.delegate = self
        return bar
    }()
    
    private lazy var tableView: CommunityTableView = {
        let tableView = CommunityTableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UINib.init(nibName: "DailyTaskCell", bundle: Bundle.main), forCellReuseIdentifier: DailyTaskCell.cellId)
        tableView.register(DaliyTaskFristCell.classForCoder(), forCellReuseIdentifier: DaliyTaskFristCell.reuseId)
        tableView.register(ConvertSectionFooter.classForCoder(), forHeaderFooterViewReuseIdentifier: ConvertSectionFooter.reuseId)
        return tableView
    }()
    
    private lazy var gameTaskApi: GameTaskListApi = {
        let api = GameTaskListApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    
    var coinsTasks: [GameTaskModel] = [GameTaskModel]()
    var propsTasks: [GameTaskModel] = [GameTaskModel]()
    
    var viewModel: GameViewModel = GameViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(r: 244, g: 244, b: 244)
        view.addSubview(navBar)
        view.addSubview(tableView)
        layoutPageViews()
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(hasInvestSuccess), name: Notification.Name.kHasInvestSuccessNotification, object: nil)
    }
    
    func repairData(models: [GameTaskModel]) {
        for model in models {
            if let group = model.group {
                if group == .coins {
                     coinsTasks.append(model)
                } else {
                    propsTasks.append(model)
                }
            }
        }
    }
    
    func loadData() {
        let _ = gameTaskApi.loadData()
    }
    
    @objc func hasInvestSuccess() {
        loadData()
    }
    
    func viewModelCallBack(model: GameTaskModel) {
        viewModel.getTaskRewardData([GetTaskRewardApi.kTaskId: model.id ?? 0], successHandler: { [weak self] (getTaskModel) in
            guard let strongSelf = self else {return}
            XSAlert.show(type: .text, text: "领取成功")
            ///先清空之前的数组
            strongSelf.coinsTasks.removeAll()
            strongSelf.propsTasks.removeAll()
            strongSelf.loadData()
        }) {  errorMsg in
            XSAlert.show(type: .error, text: errorMsg)
        }
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension DailyTaskController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return coinsTasks.count + 1
        }
        return  propsTasks.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell =  tableView.dequeueReusableCell(withIdentifier: DaliyTaskFristCell.reuseId, for: indexPath) as! DaliyTaskFristCell
                cell.titleLabel.text = "金币任务"
                cell.desLabel.text = "领取第一个奖励后才能领下一个"
                cell.shadowLabel.text  = "MONEY"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: DailyTaskCell.cellId, for: indexPath) as! DailyTaskCell
                cell.setModel(model: coinsTasks[indexPath.row - 1])
                let model = coinsTasks[indexPath.row - 1]
                cell.buttonClickHandler = { [weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.repailCoinsEvent(model: model)
                }
                return cell
            }
        } else {
            if indexPath.row == 0 {
                let cell =  tableView.dequeueReusableCell(withIdentifier: DaliyTaskFristCell.reuseId, for: indexPath) as! DaliyTaskFristCell
                cell.titleLabel.text = "道具任务"
                cell.desLabel.text = "奖励领取后才会重新开始统计"
                cell.shadowLabel.text = "PROPS"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: DailyTaskCell.cellId, for: indexPath) as! DailyTaskCell
                cell.setModel(model: propsTasks[indexPath.row - 1])
                let model = propsTasks[indexPath.row - 1]
                
                cell.buttonClickHandler = { [weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.repailEvent(model: model)
                }
                return cell
            }
        }
    }
    
    func repailCoinsEvent(model: GameTaskModel) {
        if let sign = model.sign {
            if sign == .doTask {
                
            } else if sign == .waitGet {
                viewModelCallBack(model: model)
            } else if sign == .hasFinish {
                
            }
        }
    }
    
    func repailEvent(model: GameTaskModel) {
        if let key = model.key, let sign = model.sign {
            if key == "LOGIN" {
                if sign == .waitGet { //待领取
                    viewModelCallBack(model: model)
                } else if sign == .hasFinish {
                    XSAlert.show(type: .text, text: "明日再来")
                } else if sign == .doTask {
                    DLog("iuiuiiuiu")
                }
            } else if key == "INVITE" || key == "INVITE_RECHARGE" {
                if sign == .waitGet { //待领取
                    viewModelCallBack(model: model)
                } else if sign == .hasFinish {
                    XSAlert.show(type: .text, text: "明日再来")
                } else if sign == .doTask {
                    let popularVC = PopularizeController()
                    navigationController?.pushViewController(popularVC, animated: true)
                }
            } else if key == "RECHARGE" {
                if sign == .waitGet { //待领取
                    viewModelCallBack(model: model)
                } else if sign == .hasFinish {
                    XSAlert.show(type: .text, text: "明日再来")
                } else if sign == .doTask {
                    let investVC = InvestController()
                    investVC.currentIndex = 0
                    navigationController?.pushViewController(investVC, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                if coinsTasks.count > 0 {
                    return DaliyTaskFristCell.headerHeight
                }
                return 0.0001
            }
            return DailyTaskCell.cellHeight
        } else {
            if indexPath.row == 0 {
                if propsTasks.count > 0 {
                    return DaliyTaskFristCell.headerHeight
                }
                return 0.0001
            }
            return DailyTaskCell.cellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            if coinsTasks.count > 0 {
                return 10.0
            }
        }
        return 0.0001
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: ConvertSectionFooter.reuseId)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            if coinsTasks.count > 0 {
                return 20.0
            }
            return 0.0001
        } else {
            if propsTasks.count > 0 {
                return 20.0
            }
            return 0.0001
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        if indexPath.section == 0 { //金币任务
//            if indexPath.row == 0 {
//
//            } else {
////                if coinsTasks.count > indexPath.row - 1 {
////                    let model = coinsTasks[indexPath.row - 1]
////                    repailCoinsEvent(model: model)
////                }
//            }
//        } else { //道具任务
//            if indexPath.row == 0 {
//
//            } else {
////                if propsTasks.count > indexPath.row - 1 {
////                    let model = propsTasks[indexPath.row - 1]
////                    repailEvent(model: model)
////                }
//            }
//        }
//    }
}

// MARK: - NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate
extension DailyTaskController: NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate {
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
            return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        if let models = manager.fetchJSONData(ActivityReformer()) as? [GameTaskModel] {
           repairData(models: models)
           tableView.reloadData()
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        
    }
}

// MARK: - QHNavigationBarDelegate
extension DailyTaskController: QHNavigationBarDelegate  {
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: -Layout
private extension DailyTaskController {
    
    func layoutPageViews() {
        layoutNavBar()
        layoutTableView()
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
}
