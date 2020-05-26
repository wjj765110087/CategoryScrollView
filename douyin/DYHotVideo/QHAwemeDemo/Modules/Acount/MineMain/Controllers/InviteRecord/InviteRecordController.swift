
//

import UIKit
import MJRefresh
import NicooNetwork

/// 邀请记录
class InviteRecordController: UIViewController {

    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "邀请记录"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.clear
        bar.delegate = self
        return bar
    }()
    private let topCountView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 35/255.0, green: 38/255.0, blue: 53/255.0, alpha: 1)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    private let countLable: UILabel = {
        let lable = UILabel()
        lable.textColor = ConstValue.kTitleYelloColor
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 24)
        lable.text = "0 人"
        return lable
    }()
    private let alreadyLable: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.white
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 16)
        lable.text = "已邀请好友"
        return lable
    }()
    /// tableview 数据为0时，显示
    private let notYetLable: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.lightGray
        lable.textAlignment = .center
        lable.numberOfLines = 0
        lable.font = UIFont.systemFont(ofSize: 16)
        lable.text = "您还没有邀请好友哦\n赶快邀请好友获得折扣卡吧"
        lable.isHidden = true
        return lable
    }()
    private lazy var inviteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("立即邀请", for: .normal)
        button.backgroundColor = ConstValue.kTitleYelloColor
        button.addTarget(self, action: #selector(inviteBtnClick), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
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
        table.register(InviteRecordCell.classForCoder(), forCellReuseIdentifier: InviteRecordCell.cellId)
        table.mj_header = refreshView
        table.mj_footer = loadMoreView
        return table
    }()
    lazy private var loadMoreView: MJRefreshAutoNormalFooter = {
        weak var weakSelf = self
        let loadMore =  MJRefreshAutoNormalFooter(refreshingBlock: {
            weakSelf?.loadNextPage()
        })
        loadMore?.stateLabel.font = ConstValue.kRefreshLableFont
        loadMore?.isHidden = true
        return loadMore!
    }()
    lazy private var refreshView: MJRefreshGifHeader = {
        weak var weakSelf = self
        let mjRefreshHeader = MJRefreshGifHeader(refreshingBlock: {
            weakSelf?.loadFirstPage()
        })
        var gifImages = [UIImage]()
        for string in ConstValue.refreshImageNames {
            gifImages.append(UIImage(named: string)!)
        }
        mjRefreshHeader?.setImages(gifImages, for: .refreshing)
        mjRefreshHeader?.setImages(gifImages, for: .idle)
        mjRefreshHeader?.stateLabel.font = ConstValue.kRefreshLableFont
        mjRefreshHeader?.lastUpdatedTimeLabel.font = ConstValue.kRefreshLableFont
        return mjRefreshHeader!
    }()
    
    /// 是否是下拉刷新操作
    private var isRefreshOperation = false
    
    private lazy var inviteRecord: UserInvitedListApi = {
        let api = UserInvitedListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    var inviteList = [inviteUserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubviews()
    }
    
    private func setUpSubviews() {
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(navBar)
        topCountView.addSubview(countLable)
        topCountView.addSubview(alreadyLable)
        view.addSubview(topCountView)
        view.addSubview(inviteButton)
        view.addSubview(tableView)
        view.addSubview(notYetLable)
        layoutPageSubviews()
        loadData()
        setTopViewData()
        loadMoreView.isHidden = true
    }
    
    private func loadData() {
        NicooErrorView.removeErrorMeesageFrom(self.view)
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        let _ = inviteRecord.loadData()
    }
    private func loadFirstPage() {
        let _ = inviteRecord.loadData()
    }
    private func loadNextPage() {
        let _ = inviteRecord.loadNextPage()
    }
    
    private func setTopViewData() {
        countLable.text = "\(UserModel.share().userInfo?.invite_count ?? 0) 人"
    }
    
    private func inviteListSuccess(_ listModel: InviteListModel) {
        if let models = listModel.data, let currentPage = listModel.current_page {
            if currentPage ==  1 {
                inviteList = models
                if inviteList.count == 0 {
                    NicooErrorView.showErrorMessage("您还没有邀请好友哦\n赶快邀请好友获得折扣卡吧～", on: view, customerTopMargin: ConstValue.kScreenHeight/2 + ConstValue.kStatusBarHeight, clickHandler: nil)
                    inviteButton.setTitle("立即邀请", for: .normal)
                } else {
                    inviteButton.setTitle("继续邀请", for: .normal)
                }
            } else {
                inviteList.append(contentsOf: models)
            }
            loadMoreView.isHidden = models.count < UserInvitedListApi.kDefaultCount
        }
        endRefreshing()
        tableView.reloadData()
    }
    private func orderListFailed() {
        NicooErrorView.showErrorMessage(.noNetwork, on: view) {
            self.loadData()
        }
    }
    
    private func  endRefreshing() {
        tableView.mj_header.endRefreshing()
        tableView.mj_footer.endRefreshing()
    }
    
    @objc func inviteBtnClick() {
        let vc = PopularizeController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

// MARK: - QHNavigationBarDelegate
extension InviteRecordController:  QHNavigationBarDelegate  {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension InviteRecordController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 50))
            view.backgroundColor = UIColor(red: 16/255.0, green: 18/255.0, blue: 29/255.0, alpha: 1)
            let userIdtitle = UILabel(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith/3, height: 50))
            userIdtitle.textColor = UIColor.white
            userIdtitle.text = "用户编码"
            userIdtitle.textAlignment = .center
            userIdtitle.font = UIFont.systemFont(ofSize: 13)
            view.addSubview(userIdtitle)
            let userName = UILabel(frame: CGRect(x: ConstValue.kScreenWdith/3, y: 0, width: ConstValue.kScreenWdith/3, height: 50))
            userName.textColor = UIColor.white
            userName.textAlignment = .center
            userName.font = UIFont.systemFont(ofSize: 13)
            userName.text = "用户名"
            view.addSubview(userName)
            let inviterTimetitle = UILabel(frame: CGRect(x: ConstValue.kScreenWdith*2/3, y: 0, width: ConstValue.kScreenWdith/3, height: 50))
            inviterTimetitle.textColor = UIColor.white
            inviterTimetitle.textAlignment = .center
            inviterTimetitle.font = UIFont.systemFont(ofSize: 13)
            inviterTimetitle.text = "邀请时间"
            view.addSubview(inviterTimetitle)
            return view
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inviteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InviteRecordCell.cellId, for: indexPath) as! InviteRecordCell
        let model = inviteList[indexPath.row]
        cell.userIdLab.text = "\(model.name ?? "老湿")"
        cell.inviteTimeLab.text = "\(model.created_at ?? "")"
        cell.userNameLab.text = "\(model.nikename ?? "老湿")"
        return cell
    }
    
}

// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension InviteRecordController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
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
        if manager is UserInvitedListApi  && !isRefreshOperation{
            NicooErrorView.showErrorMessage(.noNetwork, on: view) {
                self.loadData()
            }
        }
        
    }
}

// MARK: - Layout
private extension InviteRecordController {
    
    func layoutPageSubviews() {
        layoutNavBar()
        layoutTopContainer()
        layoutCountlable()
        layoutAlreadyLable()
        layoutInviteBtn()
        layoutTableView()
        layoutNotYetLable()
    }
    
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.bottom.equalTo(inviteButton.snp.top)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(topCountView.snp.bottom).offset(20)
        }
    }
    
    func layoutNotYetLable() {
        notYetLable.snp.makeConstraints { (make) in
            make.center.equalTo(tableView)
        }
    }
    
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
    }
    
    func layoutCountlable() {
        countLable.snp.makeConstraints { (make) in
            make.bottom.equalTo(topCountView.snp.centerY).offset(-5)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
    }
    
    func layoutAlreadyLable() {
        alreadyLable.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(countLable.snp.bottom).offset(10)
            make.height.equalTo(35)
        }
    }
    
    func layoutTopContainer() {
        topCountView.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.top.equalTo(navBar.snp.bottom).offset(10)
            make.height.equalTo(100)
        }
    }
    
    func layoutInviteBtn(){
        inviteButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
            make.height.equalTo(50)
        }
    }
    
    
}
