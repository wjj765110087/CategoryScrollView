//
//  TalksMainController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/9/30.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

/// 话题详情页
class TalksMainController: QHBaseViewController {
    
    private let imagebgView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.isUserInteractionEnabled = true
        return image
    }()
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "#\(talksModel.title ?? "")"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.clear
        bar.backButton.isHidden = false
        bar.lineView.isHidden = true
        bar.delegate = self
        return bar
    }()
    private lazy var rightAddBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage.imageFromColor(UIColor(r: 215, g: 58, b: 54), frame: CGRect(x: 0, y: 0, width: 60, height: 27)), for: .normal)
        button.setBackgroundImage(UIImage.imageFromColor(UIColor(r: 30, g: 31, b: 49), frame: CGRect(x: 0, y: 0, width: 60, height: 27)), for: .selected)
        button.setTitle("+加入", for: .normal)
        button.setTitle("已加入", for: .selected)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.layer.cornerRadius = 13.5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(rightAddButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var seriverButton: ServerButton = {
        let frame = CGRect.init(x: ConstValue.kScreenWdith - 80, y: 345 + ConstValue.kStatusBarHeight + 60, width: 60, height: 60)
        let button = ServerButton(frame: frame)
        button.backgroundColor = UIColor(r: 215, g: 58, b: 45)
        button.radiuOfButton = 30
        button.paddingOfbutton = 15
        button.delegate = self
        button.setImage(UIImage(named: "enterTalksbtn"), for: .normal)
        return button
    }()
    private let headerView: TalksMainHeader = {
        let header = TalksMainHeader(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 90))
        return header
    }()
    private let segView: TalksSectionSegView = {
        let view = TalksSectionSegView(frame: CGRect(x: 0, y: 50, width: ConstValue.kScreenWdith, height: 40))
        view.backgroundColor = ConstValue.kVcViewColor
        return view
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
        let oneVc = TalksAllListController()
        oneVc.topicId = talksModel.id ?? 0
        let twoVc = TalksAllListController()
        twoVc.isRecommend = true
        twoVc.topicId = talksModel.id ?? 0
        let threeVc = TalksVideoController()
        threeVc.topicId = talksModel.id ?? 0
        return [oneVc, twoVc, threeVc]
    }()
    private lazy var pageView: PageItemView = {
        let view = PageItemView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50),config: config)
        view.titles = ["全部","精选","视频"]
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
    
    /// + 关注 或取消关注后回调
    var addFollowOrDelCallBack:(() -> Void)?
    
    var talksModel = TalksModel()
    
    private let viewModel = CommunityViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imagebgView)
        view.addSubview(navBar)
        view.addSubview(tableView)
        tableView.tableHeaderView = headerView
        navBar.addSubview(rightAddBtn)
        layoutPageSubviews()
        configNavBar()
        view.addSubview(seriverButton)
        addViewModelCallback()
        headerView.moreIntroClickHandler = { [weak self] in
            let vbc = TalksIntroController()
            vbc.talksModel = self?.talksModel
            self?.navigationController?.pushViewController(vbc, animated: true)
        }
        pageVc.scrollToIndex = { [weak self] (index) in
            guard let strongSelf = self else { return }
            strongSelf.pageView.scrollTopIndex(index)
        }
        pageView.itemClickHandler = { [weak self] (index) in
            guard let strongSelf = self else { return }
            strongSelf.pageVc.clickItemToScroll(index)
        }
        segView.segOrderHandler = { [weak self] (index) in
            self?.orderChange(index)
        }
        (vcs[0]as!TalksAllListController).scrollDownToTopHandler = { [weak self] (canScroll) in
            guard let strongSelf = self else { return }
            strongSelf.tableView.isScrollEnabled = canScroll
        }
        (vcs[1]as!TalksAllListController).scrollDownToTopHandler = { [weak self] (canScroll) in
            guard let strongSelf = self else { return }
            strongSelf.tableView.isScrollEnabled = canScroll
        }
        (vcs[2]as!TalksVideoController).scrollDownToTopHandler = { [weak self] (canScroll) in
            guard let strongSelf = self else { return }
            strongSelf.tableView.isScrollEnabled = canScroll
        }
    }
    private func configNavBar() {
        navBar.titleLabel.textAlignment = .left
        imagebgView.kfSetHorizontalImageWithUrl(talksModel.cover_url)
        if let intro = talksModel.intro, !intro.isEmpty {
             headerView.introlLab.attributedText = TextSpaceManager.getAttributeStringWithString(intro, lineSpace: 5)
        }
        navBar.titleLabel.text = "#\(talksModel.title ?? "")"
        segView.enterTimesLabel.text = "\(talksModel.view_count ?? 0)次浏览"
        rightAddBtn.isSelected = (talksModel.has_count ?? .noFollow) == .follow
        navBar.backButton.snp.updateConstraints { (make) in
            make.leading.equalTo(5)
        }
    }
    
    @objc private func rightAddButtonClick(_ sender: UIButton) {
        if rightAddBtn.isSelected {
            deleteFollow(talksModel.id ?? 0)
        } else {
            addFollow(talksModel.id ?? 0)
        }
    }
    private func orderChange(_ index: Int) {
        if let vc = vcs[0] as? TalksAllListController {
            vc.descOrder = index == 1 ? UserTopicListApi.kCreated_at : UserTopicListApi.kLike
            vc.loadTopicListData()
        }
        if let vc = vcs[1] as? TalksVideoController {
            vc.descOrder = index == 1 ? UserTopicListApi.kCreated_at : UserTopicListApi.kLike
            vc.loadData()
        }
    }
    
    /// 加关注
    private func addFollow(_ topicId: Int) {
        let params: [String: Any] = [TalksAddFollowApi.kTalkId: topicId]
        viewModel.loadTalksAddFollow(params)
    }
    /// 取消关注
    private func deleteFollow(_ topicId: Int) {
        let params: [String: Any] = [TalksAddFollowApi.kTalkId: topicId]
        viewModel.loadTalksDelFollow(params)
    }
    
    private func addViewModelCallback() {
        viewModel.talksAddOrDelFollowSuccess = { [weak self] isAdd in
            guard let strongSelf = self else { return }
            strongSelf.talksModel.has_count = isAdd ? .follow : .noFollow
            strongSelf.rightAddBtn.isSelected = isAdd
            strongSelf.addFollowOrDelCallBack?()
        }
        viewModel.talksAddOrDelFollowFail = { (msg, isAdd) in
            XSAlert.show(type: .error, text: msg)
        }
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension TalksMainController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight - 90 - safeAreaBottomHeight
        
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
        pageVc.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - 90 - safeAreaBottomHeight)
        layoutPagerVcviews()
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 90))
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(pageView)
        view.addSubview(segView)
        return view
    }
}

// MARK: - layout
private extension TalksMainController {
    func layoutPageSubviews() {
        layoutImageBgView()
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
        pageVc.view.snp.makeConstraints { (make) in
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
    func layoutImageBgView() {
        imagebgView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(safeAreaTopHeight + 90)
        }
    }
    
}

// MARK: - QHNavigationBarDelegate
extension TalksMainController: QHNavigationBarDelegate  {
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - FloatDelegate
extension TalksMainController: FloatDelegate {
    func singleClick() {
        print("go - 参与话题")
        let vc = PushWorksMainController()
        vc.talksModel = self.talksModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func repeatClick() {
        
    }
}
