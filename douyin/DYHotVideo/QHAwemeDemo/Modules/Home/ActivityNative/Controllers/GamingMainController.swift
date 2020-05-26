//
//  GamingMainController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019-12-19.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

/// 游戏界面
class GamingMainController: QHBaseViewController {
    
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "双蛋狂欢"
        bar.titleLabel.textColor = UIColor.white
        bar.backButton.isHidden = false
        bar.lineView.isHidden = true
        bar.delegate = self
        return bar
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.clear
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.bounces = false
        return tableView
    }()
    private lazy var tableHeaderView: UIView = {
        let runViewheight: CGFloat = (screenWidth-70)/6 * 6 + 25
        let width: CGFloat = (screenWidth-24)/8
        let stakeHight: CGFloat = width/2*3 + 30
        let allHight: CGFloat = runViewheight + stakeHight + 300
        let header = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: allHight))
        header.backgroundColor = UIColor.clear
        return header
    }()
    private lazy var rulesBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("游戏规则", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(rulesButtonClick(_:)), for: .touchUpInside)
        return button
    }()
    private let barbgImg: UIImageView = {
        let img = UIImageView(image: UIImage(named: "game_barBg"))
        img.isUserInteractionEnabled = true
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    private let runViewbgImg: UIImageView = {
        let img = UIImageView(image: UIImage(named: "game_RunViewBg"))
        img.isUserInteractionEnabled = true
        img.contentMode = .scaleAspectFill
        return img
    }()
    private let bottomImg: UIImageView = {
        let img = UIImageView(image: UIImage(named: "game_BottomImg"))
        img.isUserInteractionEnabled = true
        img.contentMode = .scaleAspectFill
        return img
    }()
    lazy var topItemView: GameTopItemView = {
        let view = GameTopItemView(frame: CGRect.zero)
        return view
    }()
    lazy var gameView: GameRunningView = {
        if let view = Bundle.main.loadNibNamed("GameRunningView", owner: nil, options: nil)?[0] as? GameRunningView {
            return view
        }
        return GameRunningView()
    }()
    lazy var controllView: GameControllView = {
        if let view = Bundle.main.loadNibNamed("GameControllView", owner: nil, options: nil)?[0] as? GameControllView {
            return view
        }
        return GameControllView()
    }()
    lazy var stakeView: GameStakeView = {
        let view = GameStakeView(frame: CGRect.zero)
        return view
    }()
   
    var activityId: Int = 8
    var gameModel: GameMainModel?
    var resultModel: GameResultModel?
    
    let viewModel = GameViewModel()
    
    deinit {
        DLog("定时器释放")
        viewModel.noticetTimer?.invalidate()
        viewModel.noticetTimer = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        topItemView.clickHandler = { [weak self]  actionId in
            if actionId == 3 { // 兑奖专区
                let convertVC = ConvertGiftsController()
                convertVC.activityId = self?.activityId ?? 0
                self?.navigationController?.pushViewController(convertVC, animated: true)
            } else if actionId == 1 { // 每日任务
                let taskVC = DailyTaskController()
                self?.navigationController?.pushViewController(taskVC, animated: true)
            } else if actionId == 2 {  // 我的奖品
                let giftVC = MyGiftsController()
                self?.navigationController?.pushViewController(giftVC, animated: true)
            }
        }
        controllView.buttonClickHandler = { [weak self]  actionId in
            if actionId == 3 {        // 开始
                self?.startPlay()
            } else if actionId == 1 { // 清零
                self?.cleanStakes()
            } else if actionId == 2 {  // 全押
                self?.allInTenCoins()
            }
        }
        /// 押注建表
        stakeView.itemClickHandler = { [weak self]  in
            self?.controllView.userCoinsLabel.text = "\(UserModel.share().wallet?.coins ?? 0)"
        }
        /// 单局结束, 开始按钮
        gameView.endingBlock = { [weak self] in
            self?.controllView.isUserInteractionEnabled = true
            self?.stakeView.isUserInteractionEnabled = true
            self?.gameView.isStaked  = false
            self?.cleanStakeReccord()
            self?.controllView.userCoinsLabel.text = "\(UserModel.share().wallet?.coins ?? 0)"
        }
        viewModel.loadGameMainData([GameActivityMainApi.kActivity_id: activityId], succeedHandler: { [weak self] (model) in
            self?.gameModel = model
            self?.loadGameMainApiSuccess()
        }) { (msg) in
            /// 无网络提示
            
        }
        getNitoceData()
    }
    
    private func setUpUI() {
        self.automaticallyAdjustsScrollViewInsets = false
        view.addSubview(barbgImg)
        view.addSubview(navBar)
        navBar.addSubview(rulesBtn)
        view.addSubview(tableView)
        tableHeaderView.addSubview(runViewbgImg)
        tableHeaderView.addSubview(topItemView)
        tableHeaderView.addSubview(gameView)
        tableHeaderView.addSubview(controllView)
        tableHeaderView.addSubview(stakeView)
        tableHeaderView.addSubview(bottomImg)
        layoutPageSubviews()
        tableView.tableHeaderView = tableHeaderView
    }
    
    /// 开始
    private func startPlay() {
        let stakedModels = stakeView.stakeModels.filter { (model) -> Bool in
            return model.sCount > 0
        }
        print("stakedModels.count === \(stakedModels.count)")
        /// 是否押注
        gameView.isStaked = stakedModels.count > 0
        if stakedModels.count == 0 {  /// 未押注， 空转， 不调用接口
            gameView.star()
            controllView.isUserInteractionEnabled = false
            stakeView.isUserInteractionEnabled = false
            return
        }
        getPlayResult()
    }
    
    /// 调用结果 接口
    private func getPlayResult() {
        var params = [String: Any]()
        var allKeyValues = [[String: Any]]()
        for i in 0 ..< stakeView.stakeModels.count {
            let stake = stakeView.stakeModels[i]
            if stake.sCount > 0 {
                allKeyValues.append(["props_id": stake.propId, "props_number": stake.sCount])
            }
        }
        if let data = try? JSONSerialization.data(withJSONObject: allKeyValues, options: []) {
            if let json = NSString.init(data: data, encoding: String.Encoding.utf8.rawValue) {
                params[GamePlayApi.kJson_data] = json as String
            }
        }
        params[GamePlayApi.kActivity_id] = activityId
        viewModel.loadGameResultData(params, succeedHandler: { [weak self] (model) in
            print("拿到结果了")
            self?.resultModel = model
            self?.loadPayResultSuccess()
        }) { (errorMsg) in
            /// 无网络提示
            XSAlert.show(type: .error, text: "网络开小差，请重试")
        }
    }
    
    /// 清零
    private func cleanStakes() {
        let beiCount = UserModel.share().gameBeiCount
        var userCoins = UserModel.share().wallet?.coins ?? 0
        for i in 0 ..< stakeView.stakeModels.count {
            if stakeView.stakeModels[i].sCount > 0 {
                let coinsStaked = stakeView.stakeModels[i].sCount * beiCount
                userCoins = userCoins + coinsStaked
                stakeView.stakeModels[i].sCount = 0
            }
        }
        UserModel.share().wallet?.coins = userCoins
        controllView.userCoinsLabel.text = "\(userCoins)"
        stakeView.collectionView.reloadData()
    }
    
    /// 全押。全 + 10
    private func allInTenCoins() {
        let beiCount = UserModel.share().gameBeiCount
        var userCoins = UserModel.share().wallet?.coins ?? 0
        if userCoins < beiCount {
            XSAlert.show(type: .error, text: "金币不足")
            return
        }
        GameStakeItemView.playSound("laohu2")
        for i in 0 ..< stakeView.stakeModels.count {
            if stakeView.stakeModels[i].sCount < 999 {
                stakeView.stakeModels[i].sCount += 1
                if userCoins >= beiCount {
                    userCoins = userCoins - beiCount
                }
            }
        }
        UserModel.share().wallet?.coins = userCoins
        controllView.userCoinsLabel.text = "\(userCoins)"
        stakeView.collectionView.reloadData()
    }
    
    /// 清除 当次 押注记录
    private func cleanStakeReccord() {
        for i in 0 ..< stakeView.stakeModels.count {
            if stakeView.stakeModels[i].sCount > 0 {
                stakeView.stakeModels[i].sCount = 0
            }
        }
        stakeView.collectionView.reloadData()
    }
    
    private func getNitoceData() {
        self.loadNoticeData()
    }
    
    private func loadNoticeData() {
        let params: [String: Any] = [GameNoticesApi.kActivity_id: activityId, GameNoticesApi.kLimit: 50]
        viewModel.loadGameNoticeData(params, succeedHandler: { [weak self] (notices) in
            self?.topItemView.setNotices(notices)
        }) { (errorMsg) in
            
        }
    }

    @objc private func rulesButtonClick(_ sender: UIButton) {
        let uploadLicense = UploadLicenseController()
        uploadLicense.webType = .typeWebUrl
        uploadLicense.webUrlString = gameModel?.activity_info?.rules_url
        uploadLicense.navTitle = "\(gameModel?.activity_info?.title ?? "活动")"
        navigationController?.pushViewController(uploadLicense, animated: true)
    }
    
}

// MARK: - DataAccess
private extension GamingMainController {
    func loadGameMainApiSuccess() {
        if gameModel != nil {
            gameView.setGameModel(gameModel!)
            stakeView.gameModel = gameModel
        }
        if let gameCoins = Int(gameModel?.activity_info?.game_coins ?? "1") {
            UserModel.share().gameBeiCount = gameCoins
        }
        if let walletInfo = gameModel?.user_wallet_info {
            controllView.userCoinsLabel.text = "\(walletInfo.coins ?? 0)"
            UserModel.share().wallet = walletInfo
        }
        if let propModels = gameModel?.game_props_data {
            var stakes = [StakeModel]()
            for i in 0 ..< propModels.count {
                let model = propModels[i]
                let stake =  StakeModel(propId: model.props_id ?? 0, sCount: 0, icon: model.props_img ?? "", music: "f\(i+1)")
                stakes.append(stake)
            }
            stakeView.setModels(stakes)
        }
    }
    
    func loadPayResultSuccess() {
        if let resultSite = resultModel?._site, resultSite > 0 {  /// 中奖脚码
            gameView.result = resultSite
        }
        if let isWin = resultModel?.is_win {  /// 是否中奖
            gameView.isWin = isWin == 1
        }
        if let propModel = resultModel?.rand_props_info {
            gameView.winProp = propModel
            let stakes = stakeView.stakeModels.filter { (model) -> Bool in
                return model.propId == propModel.props_id
            }
            if stakes.count <= 0 {
                XSAlert.show(type: .error, text: "中奖道具不在押注范围内！")
                return
            }
            let stake = stakes[0]
            gameView.propNumBall = stake.sCount
        }
        if let wallet = resultModel?.user_info {
            UserModel.share().wallet?.coins = wallet.coins
        }
        gameView.star()
        controllView.isUserInteractionEnabled = false
        stakeView.isUserInteractionEnabled = false
    }
}

// MARK: - layout
private extension GamingMainController {
    func layoutPageSubviews() {
        layoutBarbgImgviews()
        layoutNavBar()
        layoutTableView()
        layoutGameTopItemView()
        layoutGameView()
        layoutRunBgImage()
        layoutControllView()
        layoutStakeView()
        layoutBottomImg()
    }
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(navBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    func layoutBarbgImgviews() {
        barbgImg.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
    }
    func layoutRunBgImage() {
        runViewbgImg.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(0)
            make.bottom.equalTo(gameView.snp.bottom)
        }
    }
    func layoutGameTopItemView() {
        topItemView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(tableHeaderView.snp.top)
            make.height.equalTo(85)
        }
    }
    func layoutGameView() {
        let height: CGFloat = (screenWidth-70)/6 * 6 + 25
        gameView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(topItemView.snp.bottom)
            make.height.equalTo(height)
        }
    }
    func layoutControllView() {
        controllView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(gameView.snp.bottom)
            make.height.equalTo(150)
        }
    }
    func layoutStakeView() {
        let width: CGFloat = (screenWidth-24)/8
        stakeView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(controllView.snp.bottom).offset(-15)
            make.height.equalTo(width/2*3 + 35)
        }
    }
    func layoutBottomImg() {
        bottomImg.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(stakeView.snp.bottom)
            make.height.equalTo(70)
        }
    }
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
        rulesBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-15)
            make.centerY.equalTo(navBar.titleLabel)
            make.width.equalTo(70)
            make.height.equalTo(27)
        }
    }
}

// MARK: - QHNavigationBarDelegate
extension GamingMainController: QHNavigationBarDelegate  {
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}
