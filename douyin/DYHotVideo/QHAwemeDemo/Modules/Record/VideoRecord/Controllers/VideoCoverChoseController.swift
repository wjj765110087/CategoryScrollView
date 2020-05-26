//
//  VideoCoverChoseController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/4/25.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import AVKit

/// 视频封面图片选择
class VideoCoverChoseController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "选择封面"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.clear
        bar.delegate = self
        return bar
    }()
    private lazy var photoBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("相册", for: .normal)
        button.setTitleColor(ConstValue.kTitleYelloColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(libraryChoseAction(_:)), for: .touchUpInside)
        return button
    }()
    private lazy var doneBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("完成", for: .normal)
        button.setTitleColor(ConstValue.kTitleYelloColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(doneAction(_:)), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    private let customLayout: CustomFlowPhotoLayout = {
        let layout = CustomFlowPhotoLayout()
        layout.itemSize = CGSize(width: 85, height: 120)
        // layout.
        return layout
    }()
    private let videoCover: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "playCellBg")
        image.contentMode = .scaleAspectFit
        return image
    }()
    private let coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.9)
        return view
    }()
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 120), collectionViewLayout: customLayout)
        collection.backgroundColor = UIColor.clear
        collection.showsHorizontalScrollIndicator = true
        collection.delegate = self
        collection.dataSource = self
        collection.register(VideoCoverChoseCell.classForCoder(), forCellWithReuseIdentifier: VideoCoverChoseCell.cellId)
        return collection
    }()
    var videoPathUrl: URL?
    var pictures = [UIImage]()
    var duration: Int = 0
    /// 当前选中的滤镜index
    var currentSelectedIndex: Int = 0
    
    var fakeButton: UIButton?
    
    var filterChoseHandler:((_ filter: FilterModel) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        setUpViews()
        getImageLastImage()
    }
    
    private func setUpViews() {
        view.addSubview(navBar)
        navBar.navBarView.addSubview(doneBtn)
        layoutBaseView()
        view.addSubview(videoCover)
        view.addSubview(coverView)
        view.addSubview(collectionView)
        layoutPageSubviews()
    }
    
    /// 截取视频 图片 每5秒抽一针
    private func getImageLastImage() {
        guard let url = self.videoPathUrl else {
            XSAlert.show(type: .error, text: "封面获取失败！")
            return
        }
        XSProgressHUD.showCycleProgress(msg: "图片获取中...", onView: view, animated: false)
        //1. 获取视频时长
        let urlAsset = AVURLAsset(url: url)
        let seconds = urlAsset.duration.seconds
        duration = Int(seconds)
        //2. 截图配置
        let generator = AVAssetImageGenerator(asset: urlAsset)
        generator.appliesPreferredTrackTransform = true
        generator.maximumSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        generator.requestedTimeToleranceBefore = .zero
        generator.requestedTimeToleranceAfter = .zero
        
        //3. 分段截图时间数组
        var times: [NSValue] = []
        for i in 1...Int(seconds) {
            let timeM = CMTimeMake(value: Int64(i), timescale: 1)
            if Int(timeM.seconds)%(seconds > 150 ? 10 : 5) == 1 { // 视频时长大余2分钟 每五秒取一帧。 小于2分钟 每3秒取一帧
                let timeV = NSValue(time: timeM)
                times.append(timeV)
            }
        }
        DLog("times: \(times), count: \(times.count)")
        //4. 开始截图
        generator.generateCGImagesAsynchronously(forTimes: times) { [weak self]
            (requestedTime, cgimage, actualTime, result, error) in
            guard let strongSelf = self else { return }
            switch result {
            case .cancelled, .failed: break
            case .succeeded:
                guard let image = cgimage else {
                    return
                }
                let displayImage = UIImage(cgImage: image)
                if let dataImage = displayImage.jpegData(compressionQuality: 0.4) { // 图片压缩一次，否则原图5 -600 kb
                    DLog("displayImage.size = \((displayImage.pngData() ?? Data()).count/1024)KB  dataImage.size = \(dataImage.count/1024)KB")
                    if let imageSmall = UIImage(data: dataImage) {
                        strongSelf.pictures.append(imageSmall)
                    }
                }
                DispatchQueue.main.async {
                    DLog("strongSelf.pictures.count = \(strongSelf.pictures.count) times.count = \(times.count)")
                    if strongSelf.pictures.count == times.count {
                        XSProgressHUD.hide(for: strongSelf.view, animated: false)
                        strongSelf.doneBtn.isEnabled = true
                        strongSelf.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
}

// MARK: - User - Actions
private extension VideoCoverChoseController {
    
    @objc func libraryChoseAction(_ sender: UIButton) {
        
    }
    
    @objc func doneAction(_ sender: UIButton) {
        // 点击完成，先删除录制的临时 视频文件
        //FilesManager.deleteAllRecordFile()
        // 拿到URL
        DLog("拿到视频 --> \(videoPathUrl!) \n 拿到视频封面 --> \(videoCover.image ?? UIImage())")
        fileSizeWithPath(FileManager.videoExportURL)
        let pushVc = PushVideoController()
        pushVc.videoImage = videoCover.image
        pushVc.videoDuration = duration
        navigationController?.pushViewController(pushVc, animated: true)
    }
    
    // 计算文件大小
    func fileSizeWithPath(_ url: URL) {
        DLog("outputPath = \(url.absoluteString)")
        if let dataFile = try? Data(contentsOf: url)  {
            let size = Float(dataFile.count/1024/1024)
            DLog("fileSize = \(size)M")
        }
    }
}

// MARK: - QHNavigationBarDelegate
extension VideoCoverChoseController:  QHNavigationBarDelegate  {
    
    func backAction() {
       navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension VideoCoverChoseController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCoverChoseCell.cellId, for: indexPath) as! VideoCoverChoseCell
        cell.imageCover.image = pictures[indexPath.row]
        videoCover.image = pictures[currentSelectedIndex]
        cell.fakeButton.isSelected = indexPath.row == currentSelectedIndex
        if indexPath.row == currentSelectedIndex {
            fakeButton = cell.fakeButton
        }
        cell.coverClickHandler = { [weak self] in
            guard let strongSelf = self else { return }
            if indexPath.row != strongSelf.currentSelectedIndex {
                strongSelf.fakeButton?.isSelected = false
                cell.fakeButton.isSelected = true
                strongSelf.currentSelectedIndex = indexPath.row
                collectionView.reloadData()
                strongSelf.videoCover.image = strongSelf.pictures[indexPath.row]
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}

// MARK: - Layout
private extension VideoCoverChoseController {
    
    func layoutPageSubviews() {
        layoutCoverView()
        layoutCollection()
        layoutVideoCover()
    }
    
    func layoutBaseView() {
         layoutNavBar()
    }
    
    func layoutNavBar() {
        navBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(ConstValue.kStatusBarHeight + 44)
        }
        layoutDoneBtn()
    }
    
    func layoutDoneBtn() {
        doneBtn.snp.makeConstraints { (make) in
            make.trailing.equalTo(-12)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(50)
        }
    }
    
    func layoutVideoCover() {
        videoCover.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.top.equalTo(navBar.snp.bottom).offset(5)
            make.bottom.equalTo(coverView.snp.top)
        }
    }
    
    func layoutCoverView() {
        coverView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(180)
        }
    }
    
    func layoutCollection() {
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(140)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-5)
            } else {
                make.bottom.equalToSuperview().offset(-5)
            }
        }
    }
}
