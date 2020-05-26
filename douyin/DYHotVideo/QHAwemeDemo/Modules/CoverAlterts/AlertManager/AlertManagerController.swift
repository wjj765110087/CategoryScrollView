//
//  AlertManagerController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/15.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit


/// 弹框类型
///
/// - updateInfo: 版本更新
/// - newUserReward: 新用户奖励
/// - addPhoneWarning: 绑定手机号提醒
/// - systemAlert: 系统弹框
/// - convertCardAlert: 福利卡兑换结果弹框
/// - findAcountAlert: 用户找回原账号弹框
public enum DouYinAlertType: Int {
    case updateInfo = 1
    case newUserReward
    case addPhoneWarning
    case systemAlert
    case systemMessage
    case convertCardAlert
    case findAcountAlert
    /// vipCard
    case VipCardAlert_TiYan     // 体验
    case VipCardAlert_YouXiang  // 优享
    case VipCardAlert_GuiBing   // 贵宾
    case VipCardAlert_ZhiZun    // 至尊
    


}

/// 弹框 管理控制器，所有弹框 都被他持有，选择调用
class AlertManagerController: UIViewController {
    
    static let kWelfCardString = "WelfCardInfo"
    static let kWelfCardTiem = "WelfCardTime"
    
    static let kConvertTitle = "ConvertTitle"
    static let kConvertMsg = "ConvertMsg"
    
    var alertType: DouYinAlertType = .updateInfo
    
    private(set) var newUserCardInfo: [String : String]?
    private(set) var addPhoneDays: Int = 3
    private(set) var vipCardModel: VipCardModel?
    private(set) var systemModel: SystemAlertModel?
    private(set) var convertCardInfo: ConvertCardAlertModel?
    private(set) var systemMessages: [SystemMsgModel]?

    /// 弹框点击确认按钮操作
    var commitActionHandler:(() -> Void)?
    
    var closeActionHandler: (() -> Void)?
    
    /// 弹框绘制完成回调
    var alertLoadFinishHandler:(() -> Void)?
    
    var cancleActionHandler:(() -> Void)?
    
    /// 福利卡兑换后状态 弹框
    ///
    /// - Parameter altertType: 弹框类型
    convenience init(cardModel: ConvertCardAlertModel) {
        self.init()
        self.alertType = .convertCardAlert
        convertCardInfo = cardModel
    }
    
    /// 找回原账号提示
    ///
    /// - Parameter cardModel: 弹框需要的信息
    convenience init(alertInfoModel: ConvertCardAlertModel) {
        self.init()
        self.alertType = .findAcountAlert
        convertCardInfo = alertInfoModel
    }
    
    /// 系统提示弹框
    ///
    /// - Parameter model: 系统model
    convenience init(systemAlert model: SystemAlertModel) {
        self.init()
        alertType = .systemAlert
        systemModel = model
    }
    
    /// 系统公告
    ///
    /// - Parameter messages:  消息公告
    convenience init(system messages: [SystemMsgModel]) {
        self.init()
        alertType = .systemMessage
        systemMessages = messages
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if alertType == .updateInfo {
            getUpdateAlter()
        } else if alertType == .systemAlert {
            getSystemAlter(systemModel!)
        } else if alertType == .systemMessage {
            getSystemMessagesAlter(systemMessages!)
        } else if alertType == .convertCardAlert {
            getLuckCardConvertAlter(model: convertCardInfo!)
        } else if alertType == .findAcountAlert {
            getAcountBackConvertAlter(model: convertCardInfo!)
        }
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
    }
    
    /// 版本更新弹框
    func getUpdateAlter() {
        guard let updateView = Bundle.main.loadNibNamed("UpdateAlert", owner: nil, options: nil)?[0] as? UpdateAlert else { return }
        view.addSubview(updateView)
        layoutAlertView(updateView)
        updateView.updateTitle.text = AppInfo.share().title ?? ""
        updateView.updateInfo.text = AppInfo.share().remark ?? ""
        updateView.closeBtn.isHidden = AppInfo.share().force?.isForce ?? false
        
        updateView.closeActionHandler = {
            self.closeActionHandler?()
            self.dissMiss()
        }
        updateView.updateActionHandler = {
            self.commitActionHandler?()
            if !(AppInfo.share().force?.isForce ?? false) {
                self.dissMiss()
            }
        }
        updateView.webUpdateActonhandler = {
            self.cancleActionHandler?()
            if !(AppInfo.share().force?.isForce ?? false) {
                self.dissMiss()
            }
        }
    }
    
    /// 兑换福利卷提示
    func getLuckCardConvertAlter(model: ConvertCardAlertModel) {
        guard let CardConvertAlter = Bundle.main.loadNibNamed("LuckCardSucceedAlert", owner: nil, options: nil)?[0] as? LuckCardSucceedAlert else { return }
        view.addSubview(CardConvertAlter)
        layoutAlertView(CardConvertAlter)
        CardConvertAlter.titLabel.text = model.title ?? ""
        CardConvertAlter.mesgLabel.text = model.msgInfo ?? ""
        CardConvertAlter.contenView.backgroundColor =  model.success ? UIColor(red: 90/255.0, green: 210/255.0, blue: 144/255.0, alpha: 0.99) : UIColor(red: 255/255.0, green: 37/255.0, blue: 91/255.0, alpha: 0.99)
        CardConvertAlter.statuImage.image = model.success ? UIImage(named: "cardConvertSucceed") : UIImage(named: "cardConvertFailed")
        CardConvertAlter.commitActionhandler = {
            self.commitActionHandler?()
            self.dissMiss()
        }
    }
    
    
    /// 提交找回原账号提示
    func getAcountBackConvertAlter(model: ConvertCardAlertModel) {
        guard let CardConvertAlter = Bundle.main.loadNibNamed("LuckCardSucceedAlert", owner: nil, options: nil)?[0] as? LuckCardSucceedAlert else { return }
        view.addSubview(CardConvertAlter)
        layoutAlertView(CardConvertAlter)
        CardConvertAlter.contenView.backgroundColor = UIColor.white
        CardConvertAlter.titLabel.textColor = UIColor.darkText
        CardConvertAlter.mesgLabel.textColor = UIColor.gray
        CardConvertAlter.commitBtn.layer.borderColor = UIColor.clear.cgColor
        CardConvertAlter.commitBtn.layer.borderWidth = 0.0
        CardConvertAlter.commitBtn.setTitleColor(UIColor.white, for: .normal)
        CardConvertAlter.titLabel.text = model.title ?? ""
        CardConvertAlter.mesgLabel.text = model.msgInfo ?? ""
        CardConvertAlter.statuImage.image = model.success ? UIImage(named: "acountFindSucceed") : UIImage(named: "acountFIndFailedAlert")
        CardConvertAlter.commitBtn.backgroundColor = ConstValue.kTitleYelloColor
        CardConvertAlter.commitBtn.setTitle(model.success ? "朕知道了" : "重新找回", for: .normal)
        CardConvertAlter.commitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        CardConvertAlter.commitActionhandler = {
            self.commitActionHandler?()
            self.dissMiss()
        }
    }
    
    /// 系统提示框
    func getSystemAlter(_ systemModel: SystemAlertModel) {
        guard let systemAlert = Bundle.main.loadNibNamed("SystemAlert", owner: nil, options: nil)?[0] as? SystemAlert else { return }
        view.addSubview(systemAlert)
        layoutAlertView(systemAlert)
        systemAlert.titleLable.text = systemModel.title
        systemAlert.msgLable.attributedText = TextSpaceManager.getAttributeStringWithString(systemModel.msgInfo ?? "", lineSpace: 5)
        systemAlert.webLable.text = systemModel.tipsMsg
        systemAlert.commitBtn.setTitle(systemModel.commitTitle ?? "朕知道了", for: .normal)
        systemAlert.isLinkType = (systemModel.isLinkType ?? false)
        if systemModel.isLinkType ?? false {
            systemAlert.setLinkText()
        }
        systemAlert.closeActionHandler = {
            self.dissMiss()
        }
        systemAlert.commitActionHandler = {
            self.commitActionHandler?()
            self.dissMiss()
        }
    }
    
    /// 系统公告
    func getSystemMessagesAlter(_ message: [SystemMsgModel]) {
        guard let systemAlert = Bundle.main.loadNibNamed("SystemAlert", owner: nil, options: nil)?[0] as? SystemAlert else { return }
        view.addSubview(systemAlert)
        layoutAlertView(systemAlert)
        systemAlert.commitBtn.setTitle("朕知道了", for: .normal)
        systemAlert.isScrollContent = true
        systemAlert.setMessages(message)
      
        systemAlert.closeActionHandler = {
            self.closeActionHandler?()
            self.dissMiss()
        }
        systemAlert.commitActionHandler = {
            self.commitActionHandler?()
            self.dissMiss()
        }
    }
    
    /// 弹框消失
    func dissMiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func exitApp() {
        exit(0)
    }

}


// MARK: - Layout
private extension AlertManagerController {
    
    func layoutAlertView(_ view: UIView) {
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
