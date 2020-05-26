//
//  CommunityMainController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/9/30.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

/// 社区主页
class CommunityMainController: QHBaseViewController {
    
    private let searchView: CommunitySearch = {
        let header = CommunitySearch(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: safeAreaTopHeight))
        header.backgroundColor =  ConstValue.kViewLightColor
        return header
    }()
    private let headerView: CommunityHeader = {
        let header = CommunityHeader(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 160))
        header.backgroundColor =  ConstValue.kViewLightColor
        return header
    }()
    lazy var tableView: CustomTableView = {
        let tableView = CustomTableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.bounces = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "fakeCell")
        return tableView
    }()

    private lazy var vcs: [UIViewController] = {
        let oneVc = CommunityListController()
        let twoVc = CommunityListController()
        let threeVc = CommunityListController()
        twoVc.isRecommend = true
        threeVc.isAttention = true
        return [oneVc, twoVc, threeVc]
    }()
    
    private lazy var pageView: PageItemView = {
        let view = PageItemView.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50),config: config)
        view.backgroundColor = UIColor.clear
        view.titles = ["全部","精选","关注"]
        return view
    }()
    
    /// 自定义pageView 设置   /*  --- 更多配置 请查看 PageItemConfig 属性 ---- */
    private lazy var config: PageItemConfig = {
        let pageConfig = PageItemConfig()
        pageConfig.pageViewBgColor = ConstValue.kVcViewColor
        pageConfig.leftRightMargin = 5.0
        pageConfig.titleColorNormal = UIColor(r: 153, g: 153, b: 153)
        pageConfig.titleColorSelected = UIColor.white
        pageConfig.titleFontNormal = UIFont.systemFont(ofSize: 17)
        pageConfig.titleFontSelected = UIFont.boldSystemFont(ofSize: 21)
        pageConfig.lineColor = UIColor.clear
        pageConfig.lineImage = UIImage(named: "pageLineBg")
        pageConfig.lineSize = CGSize(width: 40, height: 6)
        pageConfig.lineViewLocation = .center
        return pageConfig
    }()
    
    private lazy var pageVc: VCPageController = {
        let pageVC = VCPageController()
        pageVC.controllers = vcs
        return pageVC
    }()
    
    private let viewModel = CommunityViewModel()
    var messageViewModel: MessageViewModel = MessageViewModel()
    
    private var dataSource = [TalksModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.tableHeaderView = headerView
        view.addSubview(searchView)
        layoutPageSubviews()
        addSearchViewCallBack()
        addViewActionCallBack()
        pageVc.scrollToIndex = { [weak self] (index) in
            guard let strongSelf = self else { return }
            strongSelf.pageView.scrollTopIndex(index)
        }
        pageView.itemClickHandler = { [weak self] (index) in
            guard let strongSelf = self else { return }
            strongSelf.pageVc.clickItemToScroll(index)
        }
        (vcs[0]as!CommunityListController).scrollDownToTopHandler = { [weak self] (canScroll) in
            guard let strongSelf = self else { return }
            strongSelf.tableView.isScrollEnabled = canScroll
        }
        (vcs[1]as!CommunityListController).scrollDownToTopHandler = { [weak self] (canScroll) in
            guard let strongSelf = self else { return }
            strongSelf.tableView.isScrollEnabled = canScroll
        }
        (vcs[2]as!CommunityListController).scrollDownToTopHandler = { [weak self] (canScroll) in
            guard let strongSelf = self else { return }
            strongSelf.tableView.isScrollEnabled = canScroll
        }
        viewModel.loadTalksList(nil)
        
        addViewModelCallBack()
        loadMessageNewNumData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(messageDotView), name: Notification.Name.kMessageDotNotification, object: nil)
        
    }
    
    @objc func messageDotView() {
        searchView.dotView.isHidden = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.kMessageDotNotification, object: nil)
    }
}


// MARK: - Privite funcs
extension CommunityMainController {
    
    private func loadMessageNewNumData() {
        messageViewModel.loadMessageNewNumData(params: nil)
    }
    private func addSearchViewCallBack() {
        searchView.msgButtonHandler = { [weak self] in
            guard let strongSelf = self else { return }
            let messageMainVC = MessageMainController()
            strongSelf.navigationController?.pushViewController(messageMainVC, animated: true)
        }
        searchView.serachItemHandler = { [weak self] in
            guard let strongSelf = self else { return }
            let searchVC = SearchMainController()
            let nav = QHNavigationController(rootViewController: searchVC)
            nav.modalPresentationStyle = .fullScreen
            strongSelf.present(nav, animated: true, completion: nil)
            
        }
    }
    private func addViewActionCallBack() {
        headerView.itemClickHandler = { [weak self] (index) in
            guard let strongSelf = self else { return }
            let talkVc = TalksMainController()
            talkVc.talksModel = strongSelf.dataSource[index]
            strongSelf.navigationController?.pushViewController(talkVc, animated: true)
        }
        headerView.moreButtonHandler  = { [weak self] in
            guard let strongSelf = self else { return }
            let communityTopicVC = CommunityTopicController()
            strongSelf.navigationController?.pushViewController(communityTopicVC, animated: true)
            
        }
        viewModel.talksListApiSuccess = { [weak self] (listModels, pageNumber) in
            guard let strongSelf = self else { return }
            if let list = listModels, list.count > 0 {
                strongSelf.dataSource = list
                strongSelf.headerView.setModels(strongSelf.dataSource)
            }
        }
    }
    private func addViewModelCallBack() {
        messageViewModel.messageNewNumSuccessHandler = { [weak self]  messageNewNumList in
            guard let strongSelf = self else {return}
            var messageNumModels = [MessageModel]()
            if let noticeModel = messageNewNumList.Notice {
                
                messageNumModels.append(noticeModel)
            }
            if let praiseModel = messageNewNumList.Praise {
                messageNumModels.append(praiseModel)
            }
            if let commentModel = messageNewNumList.Comment {
                messageNumModels.append(commentModel)
            }
            if let followerModel = messageNewNumList.Follower {
                messageNumModels.append(followerModel)
            }
            if let systemModel = messageNewNumList.System {
                //strongSelf.systemMessage = systemModel
                messageNumModels.append(systemModel)
            }
            strongSelf.searchView.dotView.isHidden = !(messageNumModels.count > 0)
        }
        messageViewModel.messageNewNumFailureHandler = { msg in
            
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CommunityMainController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight - 50 - safeAreaBottomHeight
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "fakeCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        self.addChild(pageVc)
        cell.contentView.addSubview(pageVc.view)
        pageVc.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - 50 - safeAreaBottomHeight)
        layoutPagerVcviews()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50))
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(pageView)
        return view
    }
}

// MARK: - layout
private extension CommunityMainController {
    func layoutPageSubviews() {
        layoutSearchView()
        layoutTableView()
    }
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
    func layoutPagerVcviews() {
        pageVc.view.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    
    func layoutSearchView() {
        searchView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(safeAreaTopHeight)
        }
    }
   
}

