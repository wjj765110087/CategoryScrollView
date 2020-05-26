//
//  UserInfoEditController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/8/27.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork

class UserInfoEditController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "编辑个人资料"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.clear
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
        table.register(UINib(nibName: "InfoEditCell", bundle: Bundle.main), forCellReuseIdentifier: InfoEditCell.cellId)
        return table
    }()
    private lazy var  header: InfoEditHeader = {
        let view = InfoEditHeader.init(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 200))
        if let cover_path = UserModel.share().userInfo?.cover_path {
            view.headerBtn.kfSetHeaderImageWithUrl(cover_path, placeHolder: ConstValue.kDefaultHeader)
        }
        return view
    }()
    
    private lazy var imageUpLoad: UploadImageTool = {
        let upload = UploadImageTool()
        upload.delegate = self
        return upload
    }()
    
    private lazy var updateUserInfoApi: UserUpdateInfoApi = {
        let api = UserUpdateInfoApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    
    let userViewModol = UserInfoViewModel()
    
    var uploadImage: UIImage?
    var currentImage: UIImage?
    
    var infoText: String = ""
    var params = [String : Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(navBar)
        view.addSubview(tableView)
        layoutPageSubviews()
        tableView.tableHeaderView = header

        header.choosePictureAction = { [weak self] in
            self?.cameraOrPhotoAlert()
//            self?.openLocalPhotoAlbum()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - 相册选图
    private func openLocalPhotoAlbum() {
        _ = self.jh_presentPhotoVC(1, completeHandler: {  [weak self]  items in
            guard let strongSelf = self else { return }
            for item in items {
                if let image = item.image {
                    strongSelf.imageUpLoad.paramsKey = "avatar"
                    strongSelf.imageUpLoad.upload(image)
                    strongSelf.uploadImage = image
                }
            }
        })
    }
    
    func changeUserinfo() {
        let _ = updateUserInfoApi.loadData()
    }
    
    func cameraOrPhotoAlert() {
        let controller = UserPopController()
        controller.alertType = .userCameraPhotoAlert
        controller.modalPresentationStyle = .overCurrentContext
        controller.view.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
        controller.buttonClickHandler = { [weak self] tag in
            guard let strongSelf = self else {return}
            let imagePickerVC = UIImagePickerController()
            imagePickerVC.delegate = self
            if tag == 100 {  ///相机
                strongSelf.dismiss(animated: true, completion: nil)
                
                imagePickerVC.sourceType = .camera
                
                strongSelf.present(imagePickerVC, animated: true, completion: nil)
            } else { ///相册
                strongSelf.dismiss(animated: true, completion: nil)
                strongSelf.openLocalPhotoAlbum()
                
//                imagePickerVC.sourceType = .photoLibrary
//                strongSelf.present(imagePickerVC, animated: true, completion: nil)
            }
        }
        self.modalPresentationStyle = .currentContext
        self.present(controller, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension UserInfoEditController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            header.headerBtn.setImage(imagePicked, for: .normal)
            self.imageUpLoad.paramsKey = "avatar"
            self.imageUpLoad.upload(imagePicked)
            self.uploadImage = imagePicked
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: - UploadImageDelegate
extension UserInfoEditController: UploadImageDelegate {
    
    func paramsForAPI(_ uploadImageTool: UploadImageTool) -> [String : String]? {
        XSProgressHUD.showProgress(msg: nil, onView: view, animated: false)
        return nil
    }
    
    func uploadImageMethod(_ uploadImageTool: UploadImageTool) -> String {
        return "/\(ConstValue.kApiVersion)/user/avatar/upload"
    }
    
    func uploadImageSuccess(_ uploadImageTool: UploadImageTool, resultDic: [String : Any]?) {
        XSProgressHUD.hide(for: view, animated: false)
        if let result = resultDic?["result"] as? String {
            UserModel.share().userInfo?.cover_path = result
        }
        self.currentImage = uploadImage
        self.header.headerBtn.setImage(currentImage, for: .normal)
        userViewModol.loadUserInfo()
    }
//    func baseURLForUploadTool() -> String {
//        return  ProdValue.prod().kProdUrlBase ?? ""
//    }
    
    func uploadImageFailed(_ uploadImageTool: UploadImageTool, errorMessage: String?) {
        XSProgressHUD.hide(for: view, animated: false)
        XSAlert.show(type: .error, text: "头像上传失败")
    }
    
    func uploadFailedByTokenError() {
        XSProgressHUD.hide(for: view, animated: false)
    }
    
}

// MARK: - QHNavigationBarDelegate
extension UserInfoEditController:  QHNavigationBarDelegate  {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension UserInfoEditController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InfoEditCell.cellId, for: indexPath) as! InfoEditCell
        if indexPath.row == 0 {
            cell.titleLab.text = "名字"
            cell.msglab.isHidden = false
            cell.msglab.text = UserModel.share().userInfo?.nikename
        } else if indexPath.row == 1 {
            cell.titleLab.text = "简介"
            cell.msglab.isHidden = false
            if let intro = UserModel.share().userInfo?.intro, !intro.isEmpty {
                cell.msglab.text = intro
            } else {
                cell.msglab.text = "填写个人简介更容易获得别人关注哦"
            }
        } else if indexPath.row == 2 {
            cell.titleLab.text = "性别"
            cell.msglab.isHidden = false
            if UserModel.share().userInfo?.sex == 1 {
                cell.msglab.text = "男"
            } else if UserModel.share().userInfo?.sex == 2 {
                cell.msglab.text = "女"
            } else {
                cell.msglab.text = "选择性别"
            }
        } else if indexPath.row == 3 {
            cell.titleLab.text = "生日"
            cell.msglab.isHidden = false
            cell.msglab.text = UserModel.share().userInfo?.birth ?? "选择生日"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let nickVc = NicknameController()
            navigationController?.pushViewController(nickVc, animated: true)
        } else if indexPath.row == 1 {
            let changeInfo = ChangeInfoController()
            changeInfo.textViewHandler = { [weak self] text in
                DLog("=======\(text)")
                guard let strongSelf = self else {return}
                strongSelf.infoText = text
                strongSelf.navigationController?.popViewController(animated: true)
                strongSelf.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
            }
            navigationController?.pushViewController(changeInfo, animated: true)
        } else if indexPath.row == 2 {
            let controller = UserPopController()
            controller.alertType = .userSexAlert
            controller.modalPresentationStyle = .overCurrentContext
            controller.view.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
            controller.commitActionHandler = { [weak self] sex in
                guard let strongSelf = self else {return}
                if sex == "男" {
                    UserModel.share().userInfo?.sex = 1
                    strongSelf.params = [UserUpdateInfoApi.kKey: "sex", UserUpdateInfoApi.kValue: "1"]
                } else if sex == "女" {
                    UserModel.share().userInfo?.sex = 2
                   strongSelf.params = [UserUpdateInfoApi.kKey: "sex", UserUpdateInfoApi.kValue: "2"]
                } else if sex == "不显示" {
                    UserModel.share().userInfo?.sex = 0
                    strongSelf.params = [UserUpdateInfoApi.kKey: "sex", UserUpdateInfoApi.kValue: "0"]
                }
                strongSelf.changeUserinfo()
            }
            controller.cancleActionHandler = { [weak self]  in
                
            }
            self.modalPresentationStyle = .currentContext
            self.present(controller, animated: true, completion: nil)
            
        } else if indexPath.row == 3 {
            let controller = UserPopController()
            controller.alertType = .userBirthdayAlert
            controller.modalPresentationStyle = .overCurrentContext
            controller.view.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
            controller.commitActionHandler = { [weak self] birthday in
                guard let strongSelf = self else {return}
                UserModel.share().userInfo?.birth = birthday
                strongSelf.params =  [UserUpdateInfoApi.kKey: "birth", UserUpdateInfoApi.kValue: birthday]
                strongSelf.changeUserinfo()
            }
            controller.cancleActionHandler = { [weak self] in
                
            }
            self.modalPresentationStyle = .currentContext
            self.present(controller, animated: true, completion: nil)
        }
    }
}


//MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate

extension UserInfoEditController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        return params
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        
        if manager is UserUpdateInfoApi {
            tableView.reloadData()
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        if manager is UserUpdateInfoApi {
            
        }
    }
}

// MARK: - Layout
private extension UserInfoEditController {
    
    func layoutPageSubviews() {
        layoutNavBar()
        layoutTableView()
    }
    
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
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
}
