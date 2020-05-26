//
//  ActivityMainController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/11/6.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork
import MJRefresh

class ActivityMainController: QHBaseViewController {

    static let cellIdPager = "cellIdPager"
    
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "\(activityModel.title ?? "活动")"
        bar.titleLabel.textColor = UIColor.white
        bar.backButton.isHidden = false
        bar.lineView.isHidden = true
        bar.delegate = self
        return bar
    }()
    private lazy var rightAddBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("发布", for: .normal)
        button.setTitleColor(ConstValue.kTitleYelloColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(rightAddButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    private let sectionHeader: UIView = {
        let view = UIView()
        view.backgroundColor = ConstValue.kVcViewColor
        view.clipsToBounds = true
        return view
    }()
    private let headerView: ActivityTableHeaderView = {
        let header = ActivityTableHeaderView(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: ActivityTableHeaderView.height))
        return header
    }()
    private let segView: ActivityItemsHeaderView = {
        let view = ActivityItemsHeaderView(frame: CGRect(x: 0, y: 5, width: ConstValue.kScreenWdith, height: 38))
        view.backgroundColor = UIColor.clear
        return view
    }()
    private lazy var feedButton: ServerButton = {
           let frame = CGRect.init(x: ConstValue.kScreenWdith - 75, y: 360 + ConstValue.kStatusBarHeight + 60, width: 55, height: 55)
           let button = ServerButton(frame: frame)
           button.backgroundColor = UIColor(white: 0.0, alpha: 0.9)
           button.radiuOfButton = 30
           button.paddingOfbutton = 15
           button.delegate = self
           button.setImage(UIImage(named: "onlineFeedBack"), for: .normal)
           return button
       }()
    lazy var tableView: CustomTableView = {
        let tableView = CustomTableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.bounces = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: ActivityMainController.cellIdPager)
        tableView.register(UINib(nibName: "RankCell", bundle: Bundle.main), forCellReuseIdentifier: RankCell.cellId)
        tableView.register(UploadRankCell.classForCoder(), forCellReuseIdentifier: UploadRankCell.cellId)
        tableView.mj_footer = loadMoreView
        return tableView
    }()
    lazy private var loadMoreView: MJRefreshAutoNormalFooter = {
        weak var weakSelf = self
        let loadMore = MJRefreshAutoNormalFooter(refreshingBlock: {
            weakSelf?.loadNextPage()
        })
        loadMore?.isHidden = true
        loadMore?.stateLabel.font = ConstValue.kRefreshLableFont
        return loadMore!
    }()
    private lazy var vcs: [UIViewController] = {
        var controllers = [ActivityPraiseController]()
        var currentItem = activityItems[currentItemIndex]
        if let topics = activityModel.topics {
            for model in topics {
                let activityTopicVc = ActivityPraiseController()
                activityTopicVc.topicId = model.id ?? 0
                activityTopicVc.key = currentItem.key?.rawValue ?? ActivityItemKey.Dynamic_Praise.rawValue
                controllers.append(activityTopicVc)
            }
        }
        return controllers
    }()

    private lazy var pageView: PageItemView = {
        let view = PageItemView(frame: CGRect(x: 0, y: 50, width: screenWidth, height: 44),config: config)
        var titles = [String]()
        for model in activityTalks {
            titles.append("#\(model.title ?? "")")
        }
        view.titles = titles
        return view
    }()
    /// 自定义pageView 设置   /*  --- 更多配置 请查看 PageItemConfig 属性 ---- */
    private lazy var config: PageItemConfig = {
        let pageConfig = PageItemConfig()
        pageConfig.pageViewBgColor = UIColor(r: 15, g: 15, b: 29)
        pageConfig.leftRightMargin = 5.0
        pageConfig.titleColorNormal = UIColor(r: 153, g: 153, b: 153)
        pageConfig.titleColorSelected = UIColor.white
        pageConfig.titleFontNormal = UIFont.systemFont(ofSize: 14)
        pageConfig.titleFontSelected = UIFont.boldSystemFont(ofSize: 15)
        pageConfig.lineImage = UIImage(named: "pageLineBg")
        pageConfig.lineSize = CGSize(width: 30, height: 6)
        pageConfig.lineViewLocation = .center
        return pageConfig
    }()
    private lazy var pageVc: VCPageController = {
        let pageVC = VCPageController()
        pageVC.controllers = vcs
        return pageVC
    }()
    private lazy var rankListApi: ActivityRankListApi = {
        let api = ActivityRankListApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    private lazy var uploadRankApi: ActivityRankUploadApi = {
        let api = ActivityRankUploadApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    
    var desHeight: CGFloat = 40.0
    
    var activityModel = ActivityModel()
    var activityTalks = [TalksModel]()
    var activityItems = [ActivityChild]()
    
    var currentItemIndex: Int = 0

    var videoList = [FindRankModel]()
    var userList = [UserInfoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if activityItems.count > 0 {
            for i in 0 ..< activityItems.count {
                activityItems[i].selected = i == 0
            }
        }
        view.addSubview(navBar)
        view.addSubview(tableView)
        view.addSubview(feedButton)
        navBar.addSubview(rightAddBtn)
        layoutPageSubviews()
       
        pageVc.scrollToIndex = { [weak self] (index) in
            guard let strongSelf = self else { return }
            strongSelf.pageView.scrollTopIndex(index)
        }
        pageView.itemClickHandler = { [weak self] (index) in
            guard let strongSelf = self else { return }
            strongSelf.pageVc.clickItemToScroll(index)
        }
        segView.itemClickHandler = { [weak self] (index) in
            guard let strongSelf = self else { return }
            strongSelf.currentItemIndex = index
            strongSelf.reSetNextVcKeys()
            strongSelf.tableView.reloadData()
            strongSelf.loadDataOrNextVcLoadData()
        }
        headerView.moreClick = { [weak self] in
            self?.goDesAllVc()
        }
        for controller in vcs {
            (controller as! ActivityPraiseController).scrollDownToTopHandler = { [weak self] (canScroll) in
                guard let strongSelf = self else { return }
                strongSelf.tableView.isScrollEnabled = canScroll
            }
        }
        segView.setModels(activityItems)
        headerView.setModel(activityModel)
        if let descStr = activityModel.rules_desc {
             desHeight = descStr.getLableHeight(font: UIFont.systemFont(ofSize: 13), width: screenWidth-24)
             headerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: desHeight + 105 + (screenWidth - 20)*0.4)
             DLog("height== \(desHeight)")
        }
        tableView.tableHeaderView = headerView
        loadDataOrNextVcLoadData()
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        headerView.countdownTimer.suspend()
    }
    
    private func reSetNextVcKeys() {
        let currentItem = activityItems[currentItemIndex]
        if let keyType = currentItem.key {
            for vc in vcs {
                (vc as! ActivityPraiseController).key = keyType.rawValue
            }
        }
    }
    
    private func loadRankList() {
         NicooErrorView.removeErrorMeesageFrom(view)
         XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
         _ = rankListApi.loadData()
    }
    private func loadNextPage() {
        if activityItems.count > currentItemIndex {
            let itemModel = activityItems[currentItemIndex]
            if itemModel.key == .Video_Praise {
                 _ = rankListApi.loadNextPage()
            } else if itemModel.key == .Upload_Video {
                 _ = uploadRankApi.loadNextPage()
            }
        }
    }
    
    private func loadUploadList() {
        NicooErrorView.removeErrorMeesageFrom(view)
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        _ = uploadRankApi.loadData()
    }
    
    private func loadDataOrNextVcLoadData() {
        
        if activityItems.count > currentItemIndex {
            let itemModel = activityItems[currentItemIndex]
            if itemModel.key == .Dynamic_Praise || itemModel.key == .Coins_Video { // 让当前的
                loadMoreView.isHidden = true
            } else if itemModel.key == .Video_Praise {
                loadMoreView.isHidden = false
                loadRankList()
            } else if itemModel.key == .Upload_Video {
                loadMoreView.isHidden = false
                loadUploadList()
            }
        }
    }
    
    @objc private func rightAddButtonClick(_ sender: UIButton) {
        let pushVc = PushWorksMainController()
        navigationController?.pushViewController(pushVc, animated: true)
    }
    
    private func loadRankListSuccess(_ rankList: FindRankDetailListModel) {
        if let data = rankList.data {
            if rankListApi.pageNumber == 1 {
                videoList = data
            } else {
                videoList.append(contentsOf: data)
            }
            if videoList.count == 0 {
                NicooErrorView.showErrorMessage(.noData
                , "还没有人上榜，快去发布作品吧！", on: view, topMargin: self.desHeight + 155 + (screenWidth - 20)*0.4) {
                    self.loadDataOrNextVcLoadData()
                }
            }
            loadMoreView.isHidden = data.count < ActivityRankListApi.kDefaultCount
        }
        endRefreshing()
        tableView.reloadData()
    }
    private func loadUploadUserListSuccess(_ list: UserListModel) {
        if let data = list.data {
            if uploadRankApi.pageNumber == 1 {
                userList = data
            } else {
                userList.append(contentsOf: data)
            }
            loadMoreView.isHidden = data.count < ActivityRankUploadApi.kDefaultCount
            if userList.count == 0 {
                NicooErrorView.showErrorMessage(.noData
                , "还没有人上榜，快去发布作品吧！", on: view, topMargin: self.desHeight + 155 + (screenWidth - 20)*0.4) {
                    self.loadDataOrNextVcLoadData()
                }
            }
        }
        endRefreshing()
        tableView.reloadData()
    }
    
    private func endRefreshing() {
        loadMoreView.endRefreshing()
        XSProgressHUD.hide(for: view, animated: false)
    }
    
    private func goDesAllVc() {
        let uploadLicense = UploadLicenseController()
        uploadLicense.webType = .typeWebUrl
        uploadLicense.webUrlString = activityModel.rules_url
        uploadLicense.navTitle = "\(activityModel.title ?? "活动")"
        navigationController?.pushViewController(uploadLicense, animated: true)
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ActivityMainController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if activityItems.count > currentItemIndex {
            let itemModel = activityItems[currentItemIndex]
            if itemModel.key == .Dynamic_Praise || itemModel.key == .Coins_Video {
                return screenHeight - 95 - safeAreaTopHeight
            } else if itemModel.key == .Video_Praise{
                return RankCell.cellHeight
            } else if itemModel.key == .Upload_Video {
                return UploadRankCell.rowHeight
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if activityItems.count > currentItemIndex {
            let itemModel = activityItems[currentItemIndex]
            if itemModel.key == .Dynamic_Praise || itemModel.key == .Coins_Video {
                return 1
            } else if itemModel.key == .Video_Praise {
                return videoList.count
            } else if itemModel.key == .Upload_Video {
                return userList.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if activityItems.count <= currentItemIndex { return UITableViewCell() }
        let itemModel = activityItems[currentItemIndex]
        if itemModel.key == .Dynamic_Praise || itemModel.key == .Coins_Video {
            let cell = tableView.dequeueReusableCell(withIdentifier: ActivityMainController.cellIdPager, for: indexPath)
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = UIColor.clear
            self.addChild(pageVc)
            cell.contentView.addSubview(pageVc.view)
            pageVc.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - 95 - safeAreaTopHeight)
            layoutPagerVcviews()
            return cell
        } else if itemModel.key == .Video_Praise {
            let cell = tableView.dequeueReusableCell(withIdentifier: RankCell.cellId, for: indexPath) as! RankCell
            cell.setActivityModel(model: videoList[indexPath.row])
            cell.rankLabel.font = UIFont.systemFont(ofSize: 18)
            cell.playButton.isHidden = false
            cell.rankLabel.textColor = (videoList[indexPath.row].top ?? 0) < 4 ? ConstValue.kTitleYelloColor : UIColor.white
            return cell
        } else if itemModel.key == .Upload_Video {
            let cell = tableView.dequeueReusableCell(withIdentifier: UploadRankCell.cellId, for: indexPath) as! UploadRankCell
            cell.setModel(userList[indexPath.row])
            cell.rankLabel.textColor = (userList[indexPath.row].top ?? 0) < 4 ? ConstValue.kTitleYelloColor : UIColor.white
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if activityItems.count > currentItemIndex {
            let itemModel = activityItems[currentItemIndex]
            if itemModel.key == .Dynamic_Praise || itemModel.key == .Coins_Video {
            } else if itemModel.key == .Video_Praise {
                let playVideoVC = SeriesPlayController()
                var videos = [VideoModel]()
                for model in videoList {
                    if let video = model.video_model {
                        videos.append(video)
                    } else {
                        videos.append(VideoModel())
                    }
                }
                playVideoVC.videos = videos
                playVideoVC.currentIndex = indexPath.row
                playVideoVC.currentPlayIndex = indexPath.row
                playVideoVC.goVerbOrRefreshActionHandler = { [weak self] (isVerb) in
                    if isVerb {
                        let vipvc = InvestController()
                        vipvc.currentIndex = 0
                        self?.navigationController?.pushViewController(vipvc, animated: false)
                    } else {
                        self?.loadRankList()
                    }
                }
                let nav = UINavigationController(rootViewController: playVideoVC)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
                
            } else if itemModel.key == .Upload_Video {
                let userCenter = UserMCenterController()
                userCenter.user = userList[indexPath.row]
                self.navigationController?.pushViewController(userCenter, animated: true)
            }
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if activityItems.count > currentItemIndex {
            let itemModel = activityItems[currentItemIndex]
            if itemModel.key == .Dynamic_Praise || itemModel.key == .Coins_Video {
                return 95
            }  else if itemModel.key == .Video_Praise {
                return 50
            } else if itemModel.key == .Upload_Video {
                return 50
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if activityItems.count > currentItemIndex {
            let itemModel = activityItems[currentItemIndex]
            sectionHeader.frame = CGRect(x: 0, y: 0, width: screenWidth, height: (itemModel.key == .Dynamic_Praise || itemModel.key == .Coins_Video) ? 95 : 50)
            sectionHeader.addSubview(segView)
            if itemModel.key == .Dynamic_Praise || itemModel.key == .Coins_Video {
                sectionHeader.addSubview(pageView)
                pageView.isHidden = false
            } else {
                pageView.isHidden = true
            }
            return sectionHeader
        }
        return nil
    }
}

// MARK: - FloatDelegate
extension ActivityMainController: FloatDelegate {
    func singleClick() {
        let feedBack = HelpController()
        navigationController?.pushViewController(feedBack, animated: true)
    }
    func repeatClick() {
        
    }
}

// MARK: - NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate
extension ActivityMainController: NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate {
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        if activityItems.count > currentItemIndex {
            let itemModel = activityItems[currentItemIndex]
            if itemModel.key == .Video_Praise { // 视频点赞
                return [ActivityRankListApi.kKey : ActivityItemKey.Video_Praise.rawValue]
            } else if itemModel.key == .Upload_Video { // 视频上传排行
                return [ActivityRankUploadApi.kKey : ActivityItemKey.Upload_Video.rawValue]
            }
        }
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        if activityItems.count > currentItemIndex {
            let itemModel = activityItems[currentItemIndex]
            if itemModel.key == .Video_Praise { // 视频点赞
                if let model = manager.fetchJSONData(DiscoverReformer()) as? FindRankDetailListModel {
                   loadRankListSuccess(model)
                }
            } else if itemModel.key == .Upload_Video { // 视频上传排行
                if let model = manager.fetchJSONData(UserReformer()) as? UserListModel {
                    loadUploadUserListSuccess(model)
                }
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        
    }
    
}

// MARK: - layout
private extension ActivityMainController {
    func layoutPageSubviews() {
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
    func layoutPagerVcviews() {
        pageVc.view.snp.remakeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
        rightAddBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-15)
            make.centerY.equalTo(navBar.titleLabel)
            make.width.equalTo(60)
            make.height.equalTo(27)
        }
    }
}

// MARK: - QHNavigationBarDelegate
extension ActivityMainController: QHNavigationBarDelegate  {
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

/// 活动弹出框
class ActivityAlertController: UIViewController {
    
    private lazy var iconButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(iconClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "alertCloseBtn"), for: .normal)
        button.addTarget(self, action: #selector(closeBtnClick), for: .touchUpInside)
        return button
    }()
    var actionClcick:((_ actionId: Int) ->Void)?
    
    private var activityAlert: String = ""
    
    convenience init(activityIcon: String) {
        self.init()
        self.activityAlert = activityIcon
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        iconButton.kfSetHeaderImageWithUrl(activityAlert, placeHolder: UIImage(named: "activityAlertShow"))
        view.addSubview(iconButton)
        view.addSubview(closeButton)
        layoutPageSubviews()
    }
    
    @objc private func iconClick() {
        actionClcick?(1)
    }
    @objc private func closeBtnClick() {
        actionClcick?(0)
    }
    private func layoutPageSubviews() {
        iconButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
        closeButton.snp.makeConstraints { (make) in
            make.top.equalTo(iconButton.snp.bottom).offset(16)
            make.centerX.equalTo(iconButton)
            make.height.width.equalTo(35)
        }
    }
}
