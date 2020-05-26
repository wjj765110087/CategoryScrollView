//
//  SettingController.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/18.
//  Copyright © 2019年 bingdaohuoshan. All rights reserved.
//

import UIKit
import DouYinScan

class SettingController: BaseViewController {

    private let icons = [["verbPhoneIcon", "IDCardIcon", "pswLockIcon"], ["inviteCodesave", "acountFindBack"], ["appUpdateIcon"]]
    private let titles = [["绑定手机", "身份卡", "密码锁",],["邀请码","找回账号"] , ["检查更新"]]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "SettingCell", bundle: Bundle.main), forCellReuseIdentifier: SettingCell.cellId)
        return tableView
    }()
    
    private let registerViewModel = CommonViewModel()
    private let userViewModel = AcountViewModel()
    
    var needRefresh: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        layoutPageSubviews()
        navConfig()
        addUserModelcallback()
    }
    private func navConfig() {
        navBar.backgroundColor = kBarColor
        navBar.lineView.backgroundColor = UIColor.clear
        navBar.titleLabel.text = "设置"
        view.bringSubviewToFront(navBar)
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
            //self?.setUpUserInfo()
            self?.showAlert(true, errorMsg: nil)
        }
        userViewModel.loadUserFindBackFailHandler = {  [weak self] (msg) in
            self?.showAlert(false, errorMsg: msg)
        }
        userViewModel.loadUserInfoSuccessHandler = { [weak self]  in
           // self?.setUpUserInfo()
            self?.tableView.reloadData()
        }
    }
    
    private func showAlert(_ success: Bool, errorMsg: String?) {
        let succeedModel = ConvertCardAlertModel.init(title: "恭喜找回成功", msgInfo: "您的账号信息已恢复", success: true)
        let failedModel = ConvertCardAlertModel.init(title: "找回失败", msgInfo: errorMsg ?? "无效二维码,请稍后再试", success: false)
        let controller = AlertManagerController(alertInfoModel: success ? succeedModel : failedModel)
        controller.modalPresentationStyle = .overCurrentContext
        controller.view.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        self.modalPresentationStyle = .currentContext
        self.tabBarController?.present(controller, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SettingController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 10
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 10))
            view.backgroundColor = UIColor.groupTableViewBackground
            return view
        }
        return nil
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.cellId, for: indexPath) as! SettingCell
        cell.titleLab.text = titles[indexPath.section][indexPath.row]
        cell.iconImage.image = UIImage(named: icons[indexPath.section][indexPath.row])
        cell.lineView.isHidden = false
        if indexPath.section == 0 && indexPath.row == 2 { // 手势密码锁
            cell.accessoryType = .none
            cell.swichBtn.isHidden = false
            cell.swichBtn.isOn = UserDefaults.standard.bool(forKey: UserDefaults.kGestureLock)
            if cell.swichBtn.isOn {
                cell.swichBtn.thumbTintColor = UIColor.white
            } else {
                cell.swichBtn.thumbTintColor = kAppDefaultTitleColor
            }
            cell.switchValueChangeHandler = { [weak self] in
                if cell.swichBtn.isOn {
                    cell.swichBtn.thumbTintColor = UIColor.white
                    self?.openGestureLock()
                    DLog("打开手势密码")
                } else {
                    DLog("关闭手势密码")
                    cell.swichBtn.thumbTintColor = kAppDefaultTitleColor
                    //cell.swichBtn.tintColor = UIColor.white
                    self?.closeGestureLock()
                }
            }
        } else {
            cell.accessoryType = .disclosureIndicator
            cell.swichBtn.isHidden = true
            cell.msglab.text = ""
            cell.msglab.isHidden = true
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    cell.msglab.isHidden = false
                    let type = UserModel.share().userInfo?.type
                    if type != nil {
                        if type == .phoneUser {
                            cell.msglab.text = "已绑定"
                        } else {
                            cell.msglab.text = "未绑定"
                        }
                    } else {
                        cell.msglab.text = "未绑定"
                    }
                } else if indexPath.row == 1 {
                    cell.msglab.isHidden = false
                    cell.msglab.text = "保存至本地,账号更安全"
                }
            } else if indexPath.section == 1 {
                if indexPath.row == 0 {
                    cell.msglab.isHidden = false
                    let inviteCode = UserModel.share().userInfo?.invite_me_code
                    if inviteCode != nil && !inviteCode!.isEmpty {
                        cell.msglab.text = "已绑定"
                    } else {
                        cell.msglab.text = "未绑定"
                    }
                }
            } else if indexPath.section == 2 {
                cell.lineView.isHidden = true
                cell.msglab.isHidden = false
                cell.msglab.text = "V\(XSVideoService.appVersion)"
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0  {
            if indexPath.row == 0 {
                let type = UserModel.share().userInfo?.type
                if type != nil && type! == .phoneUser {
                    XSAlert.show(type: .success, text: "已绑定:\(UserModel.share().userInfo?.mobile ?? "")")
                    return
                }
                let verbPhone = VerbPhoneController()
                navigationController?.pushViewController(verbPhone, animated: true)
            } else if indexPath.row == 1 {
                // 身份卡
                let idCardVc = IDCardInfoController()
                idCardVc.isCardId = true
                idCardVc.view.backgroundColor = UIColor.white
                navigationController?.pushViewController(idCardVc, animated: true)
            }
            
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                // 填写邀请码
                let inviteCode = SetInviteCodeController()
                needRefresh = true
                navigationController?.pushViewController(inviteCode, animated: true)
            } else if indexPath.row == 1 {
                // 找回账号
                showActionSheet()
            }
        } else if indexPath.section == 2 {
            // 检查更新
            loadAppInfoDataCallBackHandler()
            loadUpdateInfo()
        }
    }
}

// MARK: - 检查更新
private extension SettingController {
    
    @objc func checkAppVersionInfo() {
        let appInfo = AppInfo.share()
        guard let versionNew = appInfo.appInfo?.version_code else { return }
        guard let numVersionNew = versionNew.removeAllPoints() else { return }
        guard let numVersionCurrent = getCurrentAppVersion().removeAllPoints() else { return }
        if Int(numVersionNew) != nil && Int(numVersionCurrent) != nil && Int(numVersionNew)! > Int(numVersionCurrent)! {
            let controller = AlertManagerController()
            controller.alertType = .updateInfo
            controller.modalPresentationStyle = .overCurrentContext
            controller.commitActionHandler = { [weak self] in
                self?.goAndUpdate(String(format: "%@", appInfo.appInfo?.package_path ?? ConstValue.kAppDownLoadLoadUrl))
            }
            controller.cancleActionHandler = { [weak self] in
                self?.goAndUpdate(String(format: "%@", appInfo.appInfo?.official_url ?? ConstValue.kAppDownLoadLoadUrl))
            }
            self.modalPresentationStyle = .currentContext
            self.present(controller, animated: false, completion: nil)
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
    
}

// MARK: - 账号找回
private extension SettingController {
    
    /// 找回账号弹框
    func showActionSheet() {
        let alert = UIAlertController.init(title: "通过以下方式找回账号", message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = UIColor.darkText
        let action1 = UIAlertAction.init(title: "身份卡找回", style: .default) { (alert) in
            self.scanQRCode()
        }
        let action2 = UIAlertAction.init(title: "手机号码找回", style: .default) { (alert) in
            let phoneFindVC = PhoneFindAcountController()
            self.needRefresh = true
            self.navigationController?.pushViewController(phoneFindVC, animated: true)
        }
        let action3 = UIAlertAction.init(title: "填写信息找回", style: .default) { (alert) in
            let infoFindVC = InfoFindAcountController()
            self.navigationController?.pushViewController(infoFindVC, animated: true)
        }
        let action4 = UIAlertAction.init(title: "联系客服找回", style: .default) { (alert) in
            self.findAcountWithCallUs()
        }
        let action5 = UIAlertAction.init(title: "取消", style: .cancel) { (alert) in
            
        }
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(action4)
        alert.addAction(action5)
        self.present(alert, animated: true, completion: nil)
    }
    
    /// 跳到土豆群
    func findAcountWithCallUs() {
        if let url = URL(string: AppInfo.share().appInfo?.potato_invite_link ?? "") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    // MARK: - 扫描身份二维码
    func scanQRCode() {
        //设置扫码区域参数
        var style = ScanViewStyle()
        style.centerUpOffset = 44
        style.photoframeAngleStyle = ScanViewPhotoframeAngleStyle.Inner
        style.photoframeLineW = 2
        style.photoframeAngleW = 18
        style.photoframeAngleH = 18
        style.isNeedShowRetangle = false
        style.anmiationStyle = ScanViewAnimationStyle.LineMove
        style.colorAngle = UIColor.white
        
        style.animationImage = UIImage(named: "qrcode_Scan_weixin_Line")
        
        let vc = ScanIDQRCodeController()
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
                    print("获取原图：",image)
                    let arrayResult = ScanWrapper.recognizeQRImage(image: image)
                    if arrayResult.count > 0 {
                        let result = arrayResult[0]
                        print("result = \(result)")
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
        let resultString = resultStr.encodeWithXorByte(key: 101)
        print("resultString = \(resultString)  =-= \(resultStr)")
        if let trueStr = resultString.components(separatedBy: "asyqra/").last, !trueStr.isEmpty {
            let params = [RecallByCardApi.kToken: trueStr]
            print("resultString = \(resultString)  =-= \(params)")
            userViewModel.findAcountWithSort(params)
        }
    }
}

// MARK: - ScanViewControllerDelegate
extension SettingController: ScanViewControllerDelegate {
    
    func scanFinished(scanResult: ScanResult, error: String?) {
        if let resultString = scanResult.strScanned, !resultString.isEmpty {
            findAccount(resultString)
        }
    }
}
    
// MARK: - 手势密码操作
private extension SettingController {
    
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
}
    
    

// MARK: - Layout
extension SettingController {
    
    func layoutPageSubviews() {
        layoutTableView()
    }
  
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom).offset(5)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalTo(0)
            }
        }
    }
}
