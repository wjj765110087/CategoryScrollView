//
//  HistoryWatchListController.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/8.
//  Copyright © 2018年 pro5. All rights reserved.
//

import UIKit
import SnapKit

struct CellModel: Codable {
    var model: VideoModel?
    var isSelected: Bool? = false  // 此属性是本地为了区分数据Model的选中状态而加的，初始值应该为nil
}

class HisEditeController: UIViewController {
    
    /// 每页应有的数据条数
    static let kPageDataCount = 15
    
    fileprivate var isEdit = false {
        didSet {
            if !isEdit {
                updateButtonView(0, 0)     // 取消编辑时，重置底部按钮
                backAction()
            }
            editeBtn.isSelected = isEdit
            baseListVC.tableEditing = isEdit
            updateButtonViewlayout()
        }
    }
    private lazy var navBar: CNavigationBar = {
        let bar = CNavigationBar()
        bar.titleLabel.text = "已选0部"
        bar.backgroundColor = kBarColor
        bar.backButton.isHidden = true
        bar.delegate = self
        return bar
    }()
    private lazy var editeBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("编辑", for: .normal)
        button.setTitle("完成", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(kAppDefaultColor, for: .normal)
        button.addTarget(self, action: #selector(rightBarButtonClick), for: .touchUpInside)
        return button
    }()
    
    var dataSource = [CellModel]()
    let viewModel = AcountViewModel()
    var isHistory: Bool = false
    var backActionHandler:(() -> Void)?
    private lazy var baseListVC: NicooTableListViewController = {
        let vc = NicooTableListViewController()
        vc.delegate = self
        return vc
    }()
   
    private lazy var buttonsView: MutableButtonsView = {
        let view = MutableButtonsView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        view.titlesForNormalStatus = ["全选","删除"]
        view.titlesForSelectedStatus = ["取消全选", "删除"]
        view.imagesForNormalStatus = ["sel_N",""]
        view.imagesForSelectedStatus = ["sel_S",""]
        view.colorsForNormalStatus = [UIColor.darkGray, UIColor(r: 255, g: 42, b: 49)]
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navBar.navBarView.addSubview(editeBtn)
        view.addSubview(navBar)
        view.addSubview(buttonsView)
        addChild(baseListVC)
        view.addSubview(baseListVC.view)
        layoutPageSubviews()
        rightBarButtonClick()
        viewModelCallback()
    }
    
    private func viewModelCallback() {
        viewModel.cancleApiFailHandler = { [weak self] (msg) in
            guard let strongSelf = self else { return }
            XSProgressHUD.hide(for: strongSelf.view, animated: false)
            XSAlert.show(type: .error, text: msg)
        }
        viewModel.cancleApiSuccessHandler = { [weak self] in
            guard let strongSelf = self else { return }
            XSProgressHUD.hide(for: strongSelf.view, animated: false)
            self?.updateDataSourcesAfterDeletedModels()
        }
    }
    
    // MARK: - User actions
    @objc func rightBarButtonClick() {
        if dataSource.count > 0 {
            isEdit = !isEdit
        } else {
            isEdit = false
            editeBtn.isEnabled = false
        }
    }
    
}

extension HisEditeController: CNavigationBarDelegate {
    func backAction() {
        backActionHandler?()
        dismiss(animated: false, completion: nil)
    }
}

// MARK: - MutableButtonsViewDelegate    全选删除操作
extension HisEditeController: MutableButtonsViewDelegate {
    
    func didClickButton(button: UIButton, at index: Int) {
        if index == 0 {                                    /// 全选 + 反选
            print( button.isSelected)
            selectedAllRows(button.isSelected)
        } else if index == 1 {                             /// 删除
            deleteSelectedRowsAndDataDources()
        }
    }
}


// MARK: - EditingConfig  编辑时的操作
extension HisEditeController {
    
    /// 全选或者全反选
    func selectedAllRows(_ isAllSelected: Bool) {
        for index in 0 ..< dataSource.count {
            if !isAllSelected {          ///
                dataSource[index].isSelected = false
                baseListVC.deselectedRowAtIndexPath(IndexPath(row: index, section: 0))  ///
            } else {
                dataSource[index].isSelected = true
                baseListVC.selectedRowAtIndexPath(IndexPath(row: index, section: 0))
            }
        }
        updateSelectedRows()
    }
    
    /// 删除选中的rows 以及数据源
    func deleteSelectedRowsAndDataDources() {
        guard let selectedRows = baseListVC.getAllSelectedRows(), selectedRows.count > 0 else { return }         // 选中rows数组不为空
        /// 调用删除接口，成功后更新UI ,在接口成功的方法中 调用下面方法：
        //updateDataSourcesAfterDeletedModels()
        let deleteGroups = dataSource.filter { (model) -> Bool in
            return model.isSelected == true
        }
        var comicIds = [Int]()
        for cellModel in deleteGroups {
            comicIds.append(cellModel.model?.id ?? 0)
        }
        
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        var params = [String: Any]()
        if let data = try? JSONSerialization.data(withJSONObject: comicIds, options: []) {
            if let json = NSString.init(data: data, encoding: String.Encoding.utf8.rawValue) {
                params[UserHisCancleApi.kVideo_id] = json as String
            }
        }
        viewModel.paramsCancle = params
        if isHistory {
            viewModel.cancelHisList()
        } else {
            viewModel.cancelFavorList()
        }
       
    }
    
    /// 更新数据源 以及 table的选中非选中cell
    func updateSelectedRows() {
        if let selectedIndexPaths = baseListVC.getAllSelectedRows(), selectedIndexPaths.count > 0 {   /// 有选中
            updateButtonView(selectedIndexPaths.count, dataSource.count)
        } else {
            updateButtonView(0, dataSource.count)
        }
    }
    
    /// 删除之后更新数据源
    private func updateDataSourcesAfterDeletedModels() {
        let videoAfterDeleteGroups = dataSource.filter { (model) -> Bool in
            model.isSelected == nil || model.isSelected == false
        }
        dataSource = videoAfterDeleteGroups
        baseListVC.reloadData()
        // 删除操作完成之后，判断是否还有数据，有则不管，无则取消编辑状态
        updateButtonView(0, dataSource.count)
        baseListVC.resetStatisticsData()
        if dataSource.count == 0 {
            isEdit = false
        }
    }
    
    /// 跟新底部按钮的删除个数
    private func updateButtonView(_ selectedCount: Int, _ allCount: Int) {
        if selectedCount == 0 {
            buttonsView.buttons?[0].isSelected = false
            buttonsView.updateButtonTitle(title: "删除", at: 1, for: .normal)
            buttonsView.updateButtonTitle(title: "删除", at: 1, for: .selected)
            navBar.titleLabel.text = "已选0部"
        } else {
            buttonsView.buttons?[0].isSelected = selectedCount == allCount
            buttonsView.updateButtonTitle(title: "删除(\(selectedCount))", at: 1, for: .normal)
            buttonsView.updateButtonTitle(title: "删除(\(selectedCount))", at: 1, for: .selected)
            navBar.titleLabel.attributedText = TextSpaceManager.configColorString(allString: "已选(\(selectedCount))部", attribStr: "\(selectedCount)")
        }
    }
}


// MARK: - NicooTableViewDelegate   需要编辑才实现编辑的代理，需要头部底部舒心才实现刷新代理
extension HisEditeController: NicooTableViewDelegate {
    
    /// 是否带头部刷新
    func haveHeaderRefreshView() -> Bool {
        return false
    }
    /// 是否带底部加载更多
    func haveFooterRefreshView() -> Bool {
        return false
    }
    
    /// 是否显示底部的数据统计
    func shouldShowStatics(_ listBaseViewController: NicooTableListViewController) -> Bool {
        return false
    }
    
    func cellHeight(for listBaseViewController: NicooTableListViewController) -> CGFloat? {
        return 130
    }
    
    func cellClass(for listBaseViewController: NicooTableListViewController) -> AnyClass? {
        return CollectedVideoCell.classForCoder()
    }
    
    
    func listTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
        
    }
    
    func listTableView(_ listBaseViewController: NicooTableListViewController, tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CollectedVideoCell")
        if cell == nil {
            cell = Bundle.main.loadNibNamed("CollectedVideoCell", owner: nil, options: nil)![0] as! CollectedVideoCell
        }
        return cell
    }
    
    /// 处理Model的方法，与cellForRow方法分开
    func configCell(_ tableView: UITableView, for cell: UITableViewCell, cellForRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        if let videoModel = model.model {
            (cell as! CollectedVideoCell).setModdel(videoModel)
        }
    }
    
    /// 非编辑状态下选中
    func listTableView(_ tableView: UITableView, didSelectedAtIndexPath indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("非编辑状态下选中,跳转到xxx")
    }
    
    /// 编辑状态下的选中
    func editingListTableView(_ tableView: UITableView, didSelectedAtIndexPath indexPath: IndexPath, didSelected indexPaths: [IndexPath]?) {
        DLog("选择的行数 --- \(String(describing: indexPaths))  --- \(indexPaths?.count)")
        dataSource[indexPath.row].isSelected = true   // 选中
        updateSelectedRows()
    }
    
    /// 编辑状态下的反选
    func editingListTableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath, didSelected indexPaths: [IndexPath]?) {
        DLog("反选之后 --- \(String(describing: indexPaths))--- \(indexPaths?.count)")
        dataSource[indexPath.row].isSelected = false  // 反选
        updateSelectedRows()
    }
    
    func editingSelectedViewColor() -> UIColor {
        return UIColor.red
    }
}

// MARK: - layout subViews

private extension HisEditeController {
    
    func layoutPageSubviews() {
        layoutNavBar()
        layoutEdBtnBtn()
        layoutButtonsView()
        layoutBaseListTableView()
    }
    
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(statusBarHeight + 44)
        }
    }
    func layoutEdBtnBtn() {
        editeBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-12)
            make.centerY.equalToSuperview()
            make.width.equalTo(55)
            make.height.equalTo(35)
        }
    }
    
    private func layoutButtonsView() {
        buttonsView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(0)
            if #available(iOS 11.0, *) {  // 适配X
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
            make.height.equalTo(0)
        }
    }
    
    func layoutBaseListTableView() {
        baseListVC.view.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
            make.bottom.equalTo(buttonsView.snp.top)
        }
    }
    
    private func updateButtonViewlayout() {
        buttonsView.snp.updateConstraints { (make) in
            if isEdit {
                make.height.equalTo(50)
            } else {
                make.height.equalTo(0)
            }
        }
        buttonsView.redrawButtonLines()   // 重新绘制线条
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
}
