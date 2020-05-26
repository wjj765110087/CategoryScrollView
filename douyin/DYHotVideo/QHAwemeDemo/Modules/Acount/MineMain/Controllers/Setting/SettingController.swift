//
//  SettingController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import DouYinScan

/// 设置页面
class SettingController: UIViewController, JHImagePickerDelegate {
    
    static let icons = ["verbPhoneIcon", "IDCardIcon", "pswLockIcon","inviteCodesave", "acountFindBack", "ChatCustom", "appUpdateIcon", "recordVideoRules"]
    static let titles = ["绑定手机", "身份卡", "密码锁", "绑定邀请码", "找回账号", "意见反馈", "检查更新", "视频上传规则"]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    var imgPicker: UIImagePickerController?
    
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "设置"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.clear
        bar.lineView.isHidden = true
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
        table.register(UINib(nibName: "SettingCell", bundle: Bundle.main), forCellReuseIdentifier: SettingCell.cellId)
        return table
    }()
    lazy var changeAcountBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = ConstValue.kTitleYelloColor
        button.layer.cornerRadius = 22.5
        button.layer.masksToBounds = true
        button.setTitle("切换账号", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(changeAcountClick), for: .touchUpInside)
        return button
    }()
    private let registerViewModel = RegisterLoginViewModel()
    private let userViewModel = UserInfoViewModel()
    
    var needRefresh = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(navBar)
        view.addSubview(tableView)
        view.addSubview(changeAcountBtn)
        layoutPageSubviews()
        loadAppInfoDataCallBackHandler()
        addUserModelcallback()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if needRefresh {
            tableView.reloadData()
        }
    }
    
    /// 打开手势密码 ，每次打开都是重新设置
    private func openGestureLock() {
        //设置手势密码
        let gesture = GestureViewController()
        gesture.type = GestureViewControllerType.setting
        gesture.cancleLockSetFailed = {
            self.tableView.reloadData()
        }
        navigationController?.pushViewController(gesture, animated: true)
    }
    
    /// 关闭手势密码， 每次关闭都是删除手势密码
    private func closeGestureLock() {
        let gestureVerifyVc  = GestureVerifyViewController()
        gestureVerifyVc.verifySuccess = {
            if GYCircleConst.getGestureWithKey(gestureFinalSaveKey) != nil {
                // 移除手势密码
                UserDefaults.standard.removeObject(forKey: gestureFinalSaveKey)
                // 移除手势密码开启标记
                UserDefaults.standard.removeObject(forKey: UserDefaults.kGestureLock)
            }
            // 刷新表状态
            self.tableView.reloadData()
            XSAlert.show(type: .success, text: "手势密码已关闭。")
        }
        
        gestureVerifyVc.verifyCancleOrFailed = {
            // 刷新表状态
            self.tableView.reloadData()
        }
        navigationController?.pushViewController(gestureVerifyVc, animated: true)
    }
    
    /// 检查更新
    private func loadUpdateInfo() {
        registerViewModel.checkUpdateInfo()
    }
    
    /// 版本信息请求回调
    private func loadAppInfoDataCallBackHandler() {
        registerViewModel.loadCheckVersionInfoApiSuccess = { [weak self] in
            ///判断是否当前为最新版本
            guard let strongSelf = self else { return }
            if strongSelf.registerViewModel.versionInfo != nil {
                strongSelf.checkAppVersionInfo()
            }
        }
    }
    
    /// 用户信息毁掉
    private func addUserModelcallback() {
        userViewModel.loadUserFindBackSuccessHandler = { [weak self] in
           // Timer.e
            self?.showAlert(true, errorMsg: nil)
    
        }
        userViewModel.loadUserFindBackFailHandler = {  [weak self] (msg) in
            self?.showAlert(false, errorMsg: msg)
        }
    }
    
    private func showAlert(_ success: Bool, errorMsg: String?) {
        let succeedModel = ConvertCardAlertModel.init(title: "账号切换成功", msgInfo: "您的账号信息已恢复", success: true)
        let failedModel = ConvertCardAlertModel.init(title: "账号切换失败", msgInfo: errorMsg ?? "无效二维码,请稍后再试", success: false)
        let controller = AlertManagerController(alertInfoModel: success ? succeedModel : failedModel)
        controller.modalPresentationStyle = .overCurrentContext
        controller.view.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        self.modalPresentationStyle = .currentContext
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc private func changeAcountClick() {
        showActionSheet()
    }

}

// MARK: - QHNavigationBarDelegate
extension SettingController:  QHNavigationBarDelegate  {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Show AppUpdateInfo
private extension SettingController {
    /// 切换账号弹框
    func showActionSheet() {
        let alert = UIAlertController.init(title: "通过以下方式切换账号", message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.darkText
        let action1 = UIAlertAction.init(title: "手机号切换账号", style: .default) { (alert) in
            let phoneFindVC = PhoneFindAcountController()
            self.needRefresh = true
            self.navigationController?.pushViewController(phoneFindVC, animated: true)
        }
        let action2 = UIAlertAction.init(title: "身份卡切换", style: .default) { (alert) in
            self.scanQRCode("扫描身份卡切换账号")
        }
        let action3 = UIAlertAction.init(title: "取消", style: .cancel) { (alert) in
        }
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.modalPresentationStyle = .fullScreen
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func checkAppVersionInfo() {
        let appInfo = AppInfo.share()
        guard let versionNew = appInfo.version_code else { return }
        guard let numVersionNew = versionNew.removeAllPoints() else { return }
        guard let numVersionCurrent = getCurrentAppVersion().removeAllPoints() else { return }
        if Int(numVersionNew) != nil && Int(numVersionCurrent) != nil && Int(numVersionNew)! > Int(numVersionCurrent)! {
            let controller = AlertManagerController()
            controller.alertType = .updateInfo
            controller.modalPresentationStyle = .overCurrentContext
            controller.commitActionHandler = { [weak self] in
                self?.goAndUpdate(String(format: "%@", appInfo.package_path ?? ConstValue.kAppDownLoadLoadUrl))
            }
            controller.cancleActionHandler = { [weak self] in
                self?.goAndUpdate(String(format: "%@", appInfo.official_url ?? ConstValue.kAppDownLoadLoadUrl))
            }
            self.modalPresentationStyle = .currentContext
            self.present(controller, animated: true, completion: nil)
        } else {
            XSAlert.show(type: .success, text: "您当前已是最新版本\(getCurrentAppVersion())")
        }
    }
    
    func getCurrentAppVersion() -> String {
        let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: filePath!)
        return dictionary!["CFBundleShortVersionString"] as! String
    }
    
    func goAndUpdate(_ downLoadUrl: String?) {
        if let urlstring = downLoadUrl {
            let downUrl = String(format: "%@", urlstring)
            if let url = URL(string: downUrl) {
                DLog(downUrl)
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:],
                                              completionHandler: {
                                                (success) in
                    })
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    /// 联系客服找回
    func findAcountWithCallUs() {
        if let url = URL(string: AppInfo.share().potato_invite_link ?? "") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    // MARK: - 扫描身份二维码
    func scanQRCode(_ navtitle: String) {
        //设置扫码区域参数
        var style = ScanViewStyle()
        style.centerUpOffset = 44
        style.photoframeAngleStyle = ScanViewPhotoframeAngleStyle.Inner
        style.photoframeLineW = 2
        style.photoframeAngleW = 18
        style.photoframeAngleH = 18
        style.isNeedShowRetangle = false
        style.anmiationStyle = ScanViewAnimationStyle.LineMove
        style.colorAngle = ConstValue.kTitleYelloColor
        
        style.animationImage = UIImage(named: "qrcode_Scan_weixin_Line")
        
        let vc = ScanIDQRCodeController()
        vc.navTitle = navtitle
        vc.scanStyle = style
        vc.scanResultDelegate = self
        vc.libraryClickHandler = {
            self.openLocalPhotoAlbum()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - 相册选择身份二维码识别
    func openLocalPhotoAlbum() {
        _ = self.jh_presentPhotoVC(1, completeHandler: { [weak self] items in
            if let first = items.first {
                first.originalImage({ (image) in
                        let arrayResult = ScanWrapper.recognizeQRImage(image: image)
                        if arrayResult.count > 0 {
                            let result = arrayResult[0]
                            DLog("result = \(result)")
                            if let resultString = result.strScanned, !resultString.isEmpty {
                                self?.findAccount(resultString)
                            }
                        } else {
                            XSAlert.show(type: .error, text: "没有可识别的二维码。")
                    }
                })
            }
        })
    }
    
    func findAccount(_ resultStr: String) {
        let params = [RecallByCardApi.kToken: resultStr, RecallByCardApi.kDevice_code: UIDevice.current.getIdfv()]
        userViewModel.findAcountWithSort(params)
    }
    
    /// 录制须知
    func getRecordLicenseVc() {
        let uploadLicense = UploadLicenseController()
        uploadLicense.webType = .typeUpload
        navigationController?.pushViewController(uploadLicense, animated: true)
    }
    
}


// MARK: - LBXScanViewControllerDelegate
extension SettingController: ScanViewControllerDelegate {
    
    func scanFinished(scanResult: ScanResult, error: String?) {
        DLog("scanResult:\(scanResult)")
        if let resultString = scanResult.strScanned, !resultString.isEmpty {
           findAccount(resultString)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SettingController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingController.icons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.cellId, for: indexPath) as! SettingCell
        cell.iconImage.image = UIImage(named: SettingController.icons[indexPath.row])
        cell.titleLab.text = SettingController.titles[indexPath.row]
        if indexPath.row == 2 { // 手势密码锁
            cell.accessoryType = .none
            cell.swichBtn.isHidden = false
            cell.swichBtn.isOn = UserDefaults.standard.bool(forKey: UserDefaults.kGestureLock)
            if cell.swichBtn.isOn {
                cell.swichBtn.thumbTintColor = ConstValue.kAppDefaultTitleColor
            } else {
                cell.swichBtn.thumbTintColor = UIColor.white
            }
            cell.switchValueChangeHandler = { [weak self] in
                if cell.swichBtn.isOn {
                    cell.swichBtn.thumbTintColor = ConstValue.kAppDefaultTitleColor
                    self?.openGestureLock()
                    DLog("打开手势密码")
                } else {
                    DLog("关闭手势密码")
                    cell.swichBtn.thumbTintColor = UIColor.white
                    self?.closeGestureLock()
                }
            }
        } else {
            cell.accessoryType = .disclosureIndicator
            cell.swichBtn.isHidden = true
            cell.msglab.text = ""
            cell.msglab.isHidden = true
            if indexPath.row == 0 {
                cell.msglab.isHidden = false
                let type = UserModel.share().userInfo?.type
                if type != nil && type == 0 {
                    cell.msglab.text = "\( UserModel.share().userInfo?.mobile ?? "已绑定")"
                } else {
                    cell.msglab.text = "未绑定"
                }
            } else if indexPath.row == 3 {
                cell.msglab.isHidden = false
                let inviteCode = UserModel.share().userInfo?.invite_me_code
                if inviteCode != nil && !inviteCode!.isEmpty {
                    cell.msglab.text = "已绑定"
                } else {
                    cell.msglab.text = "未绑定"
                }
            } else if indexPath.row == 6 {
                cell.msglab.isHidden = false
                cell.msglab.text = "V\(XSVideoService.appVersion)"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.row == 0 {
            let type = UserModel.share().userInfo?.type
            if type != nil && type == 0 {
                XSAlert.show(type: .error, text: "您已绑定手机。")
                return
            }
            let verbPhone = VerbPhoneController()
            needRefresh = true
            navigationController?.pushViewController(verbPhone, animated: true)
        } else if indexPath.row == 1 {
            // 身份卡
            let idCardVc = IDCardInfoController()
            navigationController?.pushViewController(idCardVc, animated: true)
        } else if indexPath.row == 5 {
            let feedBack = HelpController()
            navigationController?.pushViewController(feedBack, animated: true)
        } else if indexPath.row == 6 {
            loadUpdateInfo()
        } else if indexPath.row == 7 {
            getRecordLicenseVc()
        } else if indexPath.row == 3 {
            let inviteCode = SetInviteCodeController()
            needRefresh = true
            navigationController?.pushViewController(inviteCode, animated: true)
        } else if indexPath.row == 4 {
            let typeVC = FindTypeChoseController()
            typeVC.modalPresentationStyle = .overCurrentContext
            typeVC.definesPresentationContext = true
            typeVC.view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
            typeVC.itemClickHandler = { [weak self] (index) in
                if index == 1 {
                   self?.scanQRCode("用身份卡找回")
                } else if index == 2 {
                    let infoFindVC = InfoFindAcountController()
                    self?.navigationController?.pushViewController(infoFindVC, animated: true)
                } else if index == 3 {
                    self?.findAcountWithCallUs()
                }
                typeVC.dismiss(animated: false, completion: nil)
            }
            self.present(typeVC, animated: false, completion: nil)
        }
    }
    
}

// MARK: - Layout
private extension SettingController {
    
    func layoutPageSubviews() {
        layoutNavBar()
        layoutChangeAcountBtn()
        layoutTableView()
    }
    
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.bottom.equalTo(changeAcountBtn.snp.top)
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
    
    func layoutChangeAcountBtn() {
        changeAcountBtn.snp.makeConstraints { (make) in
            make.leading.equalTo(25)
            make.trailing.equalTo(-25)
            make.height.equalTo(45)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-25)
            } else {
                make.bottom.equalToSuperview().offset(-25)
            }
        }
    }
    
}
