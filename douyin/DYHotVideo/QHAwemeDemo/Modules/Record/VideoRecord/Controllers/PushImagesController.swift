//
//  PushImagesController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/3.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork


struct UploadImgModel {
    var imgData: Data?
    var image: UIImage?
    var isGif: Bool
}

class PushImagesController: QHBaseViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "发布动态"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.clear
        bar.lineView.backgroundColor = UIColor.clear
        bar.delegate = self
        return bar
    }()
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.init(white: 0.9, alpha: 1.0)
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.backgroundColor = UIColor.clear
        textView.delegate = self
        return textView
    }()
    let placeHodlerLable: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor(r: 59, g: 57, b: 73)
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.numberOfLines = 2
        lable.text = "@抖阴 随时随地，分享你的性福生活"
        return lable
    }()
    lazy var commitBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("发 布", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(r: 0, g: 123, b: 255)
        button.layer.cornerRadius = 22.5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(uploadImages), for: .touchUpInside)
        return button
    }()
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: self.view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.clear
        collection.register(PushItemChoseCell.classForCoder(), forCellWithReuseIdentifier: PushItemChoseCell.cellId)
        collection.register(PhotoItemCell.classForCoder(), forCellWithReuseIdentifier: PhotoItemCell.cellId)
        collection.register(PushTipsCell.classForCoder(), forCellWithReuseIdentifier: PushTipsCell.cellId)
        return collection
    }()
    private lazy var imageUpLoad: UploadImageTool = {
        let upload = UploadImageTool()
        upload.delegate = self
        return upload
    }()
    /// 提交动态Api
    private lazy var pushTopicUpApi: PushTopicApi = {
        let pushApi = PushTopicApi()
        pushApi.paramSource = self
        pushApi.delegate = self
        return pushApi
    }()
    var talkModel: TalksModel?
    var imageSource = [UploadImgModel]()
    var commitParams = [String: Any]()
    var commitImageNames = [String]()
    var maxCount: Int = 9
    /// 上级页面传过来的内容
    var content: String?
    
    /// 上传第几张图片
    var uploadImageIndex = 0
    
    
    /// 进入时先设置UI, 用于区分： 直接进选择页面 & 手动点击选择图片
    var firstSetUI: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !firstSetUI {
            addPicture()
        }
        setUpUI()
    }
    
    private func setUpUI() {
        view.addSubview(navBar)
        view.addSubview(textView)
        view.addSubview(placeHodlerLable)
        view.addSubview(collectionView)
        view.addSubview(commitBtn)
        layoutPageSubviews()
        if content != nil && !content!.isEmpty {
            textView.text = content
            placeHodlerLable.text = ""
        }
    }
}

// MARK: - Private Funcs
private extension PushImagesController {
    
    func choseTalksModel() {
        let talksvc = AddTalksController()
        talksvc.talksChooseBackHandler = { (talksModel) in
            self.talkModel = talksModel
            self.collectionView.reloadSections([1])
        }
        navigationController?.pushViewController(talksvc, animated: true)
    }
    /// 打开相册选择图片
    func addPicture() {
        _ = self.jh_presentPhotoVC(maxCount - imageSource.count, completeHandler: {  [weak self]  items in
            guard let strongSelf = self else { return }
            var pictures = strongSelf.imageSource
            for item in items {
                let _ = item.originalImage({ (originImage) in
                    var model = UploadImgModel(imgData: nil, image: originImage, isGif: false)
                    if item.isGIF { // gif
                        let _ = item.originalData({ (data) in
                            model.imgData = data
                            model.isGif = true
                        })
                    }
                    pictures.append(model)
                })
               
                
            }
            strongSelf.imageSource = pictures
            strongSelf.collectionView.reloadSections([0])
        })
    }
    @objc func uploadImages() {
        var params = [String: Any]()
        if textView.text.isEmpty {
            XSAlert.show(type: .warning, text: "请填写动态内容")
            return
        }
        if talkModel == nil {
            XSAlert.show(type: .warning, text: "请添加话题")
            return
        }
        if let content = textView.text {
            if content.isEmpty {
                XSAlert.show(type: .warning, text: "请填写动态内容")
                return
            }
            params[PushTopicApi.kTitle] = content
        }
        if let topicId = talkModel?.id {
            params[PushTopicApi.kTalks_id] = topicId
        }
        // 保存参数
        commitParams = params
        if imageSource.count > 0 {
            // 先上传照片，在zuo 提交
            XSProgressHUD.showProgress(msg: "图片上传中...", onView: view, animated: false)
            upload(uploadImageIndex)
        } else {
            // 没有上传照片，直接提交
            commitTopicPush(params)
        }
    }
    /// 开始上床
    func upload(_ currentIndex: Int) {
        if imageSource.count > currentIndex {
            let model = imageSource[currentIndex]
            if model.isGif {
                imageUpLoad.uploadGif(model.imgData)
            } else {
                imageUpLoad.upload(model.image)
            }
        } else {
            if commitImageNames.count == imageSource.count { // 上传完成
                XSProgressHUD.hide(for: view, animated: false)
                uploadImageIndex = 0
                if let data = try? JSONSerialization.data(withJSONObject: commitImageNames, options: []) {
                    if let json = NSString.init(data: data, encoding: String.Encoding.utf8.rawValue) {
                        commitParams[PushTopicApi.kResource] = json as String
                        commitTopicPush(commitParams)
                    }
                }
            }
        }
    }
    
    /// 提交动态
    func commitTopicPush(_ params: [String : Any]) {
        XSProgressHUD.showProgress(msg: "发布中...", onView: view, animated: false)
        let _ = pushTopicUpApi.loadData()
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension PushImagesController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return imageSource.count == maxCount ? imageSource.count : imageSource.count + 1
        } else if section == 1 || section == 2 {
            return 1
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cellForRow(with: indexPath)
        return cell
    }
    /// 配置cell
    func cellForRow(with indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoItemCell.cellId, for: indexPath) as! PhotoItemCell
            if indexPath.item < imageSource.count {
                let picture = imageSource[indexPath.item]
                cell.photoImage.image = picture.image
                cell.deleteBtn.isHidden = false
                cell.gigTipsLabel.isHidden = !picture.isGif
            } else {
                cell.photoImage.image = UIImage(named: "pushPictureAdd")
                cell.deleteBtn.isHidden = true
                cell.gigTipsLabel.isHidden = true
            }
            cell.deleteImageAction = { [weak self] in
                self?.imageSource.remove(at: indexPath.item)
                self?.collectionView.reloadData()
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PushItemChoseCell.cellId, for: indexPath) as! PushItemChoseCell
            if let titles = talkModel?.title, titles.count > 0 {
                cell.itemView.tipsLable.text = "\(titles)"
                cell.itemView.tipsLable.textColor = UIColor.white
            } else {
                cell.itemView.tipsLable.text = "参与话题,让更多人看到"
                cell.itemView.tipsLable.textColor = UIColor(r: 59, g: 57, b: 73)
            }
            cell.itemClickHandler = { [weak self] in
                self?.choseTalksModel()
            }
            return cell
        } else if indexPath.section == 2 {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PushTipsCell.cellId, for: indexPath) as! PushTipsCell
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == imageSource.count  {
                // 点击了添加
                if imageSource.count < maxCount {
                    addPicture()
                } else {
                    XSAlert.show(type: .error, text: "最多添加\(maxCount)个图片")
                }
            } else {
                let dataSource = JXLocalDataSource(numberOfItems: {
                    // 共有多少项
                    return self.imageSource.count
                }, localImage: { index -> UIImage? in
                    // 每一项的图片对象
                    return self.imageSource[index].image
                })
                JXPhotoBrowser(dataSource: dataSource).show(pageIndex: indexPath.item)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return section == 0 ? UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10) : UIEdgeInsets.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return section == 0 ? 5 : 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return section == 0 ? 5 : 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let width: CGFloat = (screenWidth - 40)/3
            return CGSize(width: width, height: width)
        } else if indexPath.section == 1 {
            return CGSize(width: screenWidth, height: 50)
        } else if indexPath.section == 2 {
            return CGSize(width: screenWidth, height: 70)
        }
        return CGSize.zero
    }
}

// MARK: - UploadImageDelegate
extension PushImagesController: UploadImageDelegate {
    func paramsForAPI(_ uploadImageTool: UploadImageTool) -> [String : String]? {
        XSProgressHUD.showProgress(msg: "图片上传中...", onView: view, animated: false)
        return nil
    }
    func uploadImageMethod(_ uploadImageTool: UploadImageTool) -> String {
        return "/\(ConstValue.kApiVersion)/topic/content-upload"
    }
    func uploadImageSuccess(_ uploadImageTool: UploadImageTool, resultDic: [String : Any]?) {
        
        if let imageName = resultDic?["result"] as? String {
            commitImageNames.append(imageName)
            uploadImageIndex  = uploadImageIndex + 1
            upload(uploadImageIndex)
        } else {
            XSAlert.show(type: .error, text: "图片上传失败")
        }
    }
    func uploadImageFailed(_ uploadImageTool: UploadImageTool, errorMessage: String?) {
        XSProgressHUD.hide(for: view, animated: false)
        XSAlert.show(type: .error, text: "图片上传失败")
    }
    
    func uploadFailedByTokenError() {
        XSProgressHUD.hide(for: view, animated: false)
    }
    
}


// MARK: - UITextViewDelegate
extension PushImagesController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeHodlerLable.text = ""
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text.count >= 300 {
            return false
        }
        return true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.isEmpty {
            placeHodlerLable.text = "@抖阴 随时随地，分享你的性福生活"
        }
        return true
    }
}

// MARK: - NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate
extension PushImagesController: NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        return commitParams
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is PushTopicApi {
            XSAlert.show(type: .success, text: "发布成功")
            closeAction()
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is PushTopicApi {
            XSAlert.show(type: .error, text: manager.errorMessage)
        }
    }
}


// MARK: - Layout
private extension PushImagesController {
    
    func layoutPageSubviews() {
        layoutNavBar()
        layoutVideoPart()
        layoutBottomPart()
        layoutCollectionView()
    }
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
    }
    func layoutVideoPart() {
        textView.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.top.equalTo(navBar.snp.bottom).offset(5)
            make.trailing.equalTo(-15)
            make.height.equalTo(120)
        }
        placeHodlerLable.snp.makeConstraints { (make) in
            make.top.equalTo(navBar.snp.bottom).offset(5)
            make.leading.equalTo(textView).offset(5)
            make.trailing.equalTo(textView).offset(-10)
            make.height.equalTo(40)
        }
    }
    func layoutBottomPart() {
        commitBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-25)
            make.leading.equalTo(25)
            make.height.equalTo(45)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            } else {
                make.bottom.equalTo(-20)
            }
        }
    }
    func layoutCollectionView() {
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(textView.snp.bottom).offset(15)
            make.bottom.equalTo(commitBtn.snp.top).offset(-10)
        }
    }
}

// MARK: - QHNavigationBarDelegate
extension PushImagesController: QHNavigationBarDelegate  {
    func backAction() {
        closeAction()
    }
    private func closeAction() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
