//
//  PushTypeChoseController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/11/19.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class PushTypeChoseController: QHBaseViewController {

    private let customLayout: CustomFlowPhotoLayout = {
        let layout = CustomFlowPhotoLayout()
        return layout
    }()
    private let coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        return view
    }()
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "pushTypeItemClose"), for: .normal)
        button.addTarget(self, action: #selector(closeWindow), for: .touchUpInside)
        return button
    }()
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect(x: 20, y: 15, width: ConstValue.kScreenWdith-40, height: 110), collectionViewLayout: customLayout)
        collection.backgroundColor = UIColor.clear
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(PushTypeItemCell.classForCoder(), forCellWithReuseIdentifier: PushTypeItemCell.cellId)
        return collection
    }()
    
    var itemCount: Int = 3
    
    /// typeId : 0 图文 1: 发布 2 ：拍摄
    var pushtypeChoseHandler:((_ typeId: Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        view.addSubview(coverView)
        view.addSubview(contentView)
        contentView.addSubview(collectionView)
        contentView.addSubview(closeButton)
        layoutPageSubviews()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func closeWindow() {
        dismiss(animated: false, completion: nil)
    }
    private func alertForUpdateVideos() {
        let msg = "您有一个待处理视频，请前往个人中心 -> 作品列表 查看视频上传状态。"
        let alertContro = UIAlertController.init(title: nil, message: msg, preferredStyle: .alert)
        let cancleAction = UIAlertAction(title: "知道了", style: .cancel) { (action) in
        }
        alertContro.addAction(cancleAction)
        alertContro.modalPresentationStyle = .fullScreen
        self.present(alertContro, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension PushTypeChoseController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PushTypeItemCell.cellId, for: indexPath) as! PushTypeItemCell
        cell.titleLab.text = ["发布图文","发布视频","拍摄视频"][indexPath.item]
        cell.itemImage.image = UIImage(named: ["imageTextPush","videoPush","recordVideoPush"][indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.item == 1 || indexPath.item == 2 {
            if let tasks = UploadTask.shareTask().tasks, tasks.count > 0 {
                alertForUpdateVideos()
                return
            }
        }
        self.dismiss(animated: false) {
            self.pushtypeChoseHandler?(indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (screenWidth-40)/CGFloat(itemCount), height: 100)
    }
    
}

// MARK: - Layout
private extension PushTypeChoseController {
    
    func layoutPageSubviews() {
        layoutCoverView()
        layoutContentView()
        layoutCollection()
        layoutCloseButton()
    }
    
    func layoutCoverView() {
        coverView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(180)
        }
    }
    func layoutContentView() {
        contentView.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.bottom.equalTo(25)
            make.height.equalTo(240)
        }
    }
    func layoutCollection() {
        collectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(110)
            make.top.equalTo(15)
        }
    }
    func layoutCloseButton() {
        closeButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom).offset(10)
            make.height.equalTo(35)
            make.width.equalTo(100)
        }
    }
}
