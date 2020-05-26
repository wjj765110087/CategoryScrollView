//
//  UserPopController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/12.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

enum UserAlertType: String {
    case userSexAlert           //用户性别
    case userBirthdayAlert      //生日
    case userCameraPhotoAlert   //相册|拍照
    case addGroupAlert          //加群交流
}

import UIKit

class UserPopController: UIViewController {
    
    var alertType: UserAlertType = .userSexAlert {
        didSet {
            if alertType == .userSexAlert {
                getUserSexAlert()
            } else if alertType == .userBirthdayAlert {
                getUserBirthdayAlert()
            } else if alertType == .userCameraPhotoAlert {
                getUserCameraOrPhotoAlert()
            } else if alertType == .addGroupAlert {
                getAddGroupAlert()
                if let models = SystemMsg.share().addGroupLinkModels {
                    if models.count > 0 {
                        return
                    }
                }
                addViewModelCallBack()
                loadInviteLinkData()
            }
        }
    }
        
    /// 弹框点击确认按钮操作
    var commitActionHandler:((String) -> Void)?
    
    var closeActionHandler: (() -> Void)?
    
    var cancleActionHandler:(() -> Void)?
    
    var buttonClickHandler: ((Int)->())?
    
    var viewModel: UserInfoViewModel = UserInfoViewModel()
    
    var models: [AddGroupLinkModel] = [AddGroupLinkModel]()
    
    var addGroupAlert: AddGroupAlert?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    ///加群交流
    func loadInviteLinkData() {
        viewModel.inviteLinkInfo(nil)
    }
    
    func addViewModelCallBack() {
        viewModel.addGroupLinkSuccessHandler = { [weak self] models in
            guard let strongSelf = self else {return}
             SystemMsg.share().addGroupLinkModels = models
//            strongSelf.addGroupAlert?.models = models
            strongSelf.addGroupAlert?.setModels(models: models)
            strongSelf.addGroupAlert?.tableView.reloadData()
        }
        
        viewModel.addGroupLinkFailureHandelr = { [weak self] msg in
            guard let strongSelf = self else {return}
           
        }
    }
    
    /// 弹框消失
    func dissMiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - 弹窗
extension UserPopController {
    
    func getUserSexAlert() {
        guard let sexAlert = Bundle.main.loadNibNamed("UserSexAlert", owner: nil, options: nil)?[0] as? UserSexAlert else {return}
        view.addSubview(sexAlert)
        layoutAlertView(sexAlert)
        
        sexAlert.commitActionHandler = { [weak self] sex in
            guard let strongSelf = self else {return}
            strongSelf.commitActionHandler?(sex)
            strongSelf.dissMiss()
        }
        
        sexAlert.cancleActionHandler = { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.closeActionHandler?()
            strongSelf.dissMiss()
        }
    }
    
    func getUserBirthdayAlert() {
        guard let birthdayAlert = Bundle.main.loadNibNamed("UserBirthdayAlert", owner: nil, options: nil)?[0] as? UserBirthdayAlert else {return}
        view.addSubview(birthdayAlert)
        layoutAlertView(birthdayAlert)
        
        birthdayAlert.commitActionHandler = { [weak self] birthday in
            guard let strongSelf = self else {return}
            strongSelf.commitActionHandler?(birthday)
            strongSelf.dissMiss()
        }
        
        birthdayAlert.cancleActionHandler = { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.closeActionHandler?()
            strongSelf.dissMiss()
        }
    }
    
    func getUserCameraOrPhotoAlert() {
        guard let cameraOrPhotoAlert = Bundle.main.loadNibNamed("UserCameraPhotoAlert", owner: nil, options: nil)?[0] as? UserCameraPhotoAlert else {return}
        view.addSubview(cameraOrPhotoAlert)
        layoutAlertView(cameraOrPhotoAlert)
        
        cameraOrPhotoAlert.buttonDidClickHandler = { [weak self] tag in
            guard let strongSelf = self else {return}
            strongSelf.buttonClickHandler?(tag)
        }
    }
    
    func getAddGroupAlert() {
        
        guard let addGroupAlert = Bundle.main.loadNibNamed("AddGroupAlert", owner: nil, options: nil)?[0] as? AddGroupAlert else {
            return
        }
        self.addGroupAlert = addGroupAlert
        view.addSubview(addGroupAlert)
        layoutAlertView(addGroupAlert)
        
        addGroupAlert.didClickRowHandler = { [weak self] model in
            guard let strongSelf = self else {return}
            strongSelf.gotoWeb(model: model)
        }
    }
    
    func gotoWeb(model: AddGroupLinkModel) {
        if let url = URL(string: model.url ?? "") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

// MARK: - Layout
private extension UserPopController {
    
    func layoutAlertView(_ view: UIView) {
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
