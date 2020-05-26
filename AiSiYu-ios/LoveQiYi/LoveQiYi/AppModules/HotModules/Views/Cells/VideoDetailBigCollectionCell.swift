//
//  VideoDetailBigCollectionCell.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/22.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit

class VideoDetailBigCollectionCell: UICollectionViewCell {
    
    static let cellId = "VideoDetailBigCollectionCell"
    static let itemSize = CGSize(width: screenWidth-20, height: 70 + 0.364*(screenWidth-20))
    
    private lazy var titleLab: UILabel = {
        let label = UILabel()
        label.text = "最好看的小姐姐视频，没有之一"
        label.textColor = UIColor.init(r: 34, g: 34, b: 34)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        return label
    }()

    private lazy var vipLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(r: 255, g: 42, b: 49)
        label.textColor = .white
        label.text = "VIP"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    private let playCountLabel: UILabel = {
       let playCountLabel = UILabel()
       playCountLabel.text = "播放量:0"
       playCountLabel.textColor = UIColor.init(r: 162, g: 162, b: 162)
       playCountLabel.font = UIFont.systemFont(ofSize: 13)
       playCountLabel.textAlignment = .center
       return playCountLabel
    }()
    private let channelContainer: UIView = {
        let view = UIView()
        view.backgroundColor = kAppDefaultColor
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }()
    private let channelLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "VIP专线"
        return label
    }()
    private let arrowImg: UIImageView = {
        let imagev = UIImageView()
        imagev.contentMode = .scaleAspectFit
        imagev.image = UIImage(named: "down")
        return imagev
    }()
    private lazy var adButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(didClickAd), for: .touchUpInside)
        return button
    }()
    private lazy var vipLineButton: UIButton = {
       let button = UIButton(type: .custom)
       button.addTarget(self, action: #selector(didClick), for: .touchUpInside)
       return button
    }()
    
    private var config: CyclePageConfig = {
        let config = CyclePageConfig()
        config.isLocalImage = false
        config.animationType = .crossDissolve
        config.transitionDuration = 4
        config.animationDuration = 1.5
        config.activeTintColor = kAppDefaultColor
        return config
    }()
    private lazy var imgView: CyclePageView = {
        let view = CyclePageView.init(frame: CGRect(x: 0, y: 0, width: screenWidth , height: screenWidth/2.16), config: config)
        return view
    }()
    var scrollItemClickHandler:((_ index: Int) -> Void)?
    
    var vipIsHidden: Bool = false {
        didSet {
            vipLabel.snp.updateConstraints { (make) in
                make.size.equalTo(CGSize(width: vipIsHidden ? 0 : 36, height: 17))
            }
            playCountLabel.snp.updateConstraints { (make) in
                make.leading.equalTo(vipLabel.snp.trailing).offset(vipIsHidden ? 0 : 6)
            }
        }
    }
    var admodel: VideoDetailAdModel?
    
    ///点击切换线路的闭包
    var changeRouterHandler:(()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        channelContainer.addSubview(arrowImg)
        channelContainer.addSubview(channelLabel)
        contentView.addSubview(channelContainer)
        contentView.addSubview(vipLineButton)
        contentView.addSubview(titleLab)
        contentView.addSubview(vipLabel)
        contentView.addSubview(playCountLabel)
        contentView.addSubview(imgView)
        contentView.addSubview(adButton)
        layoutCellSubViews()
        self.setImages(images: ["PH"])
        imgView.pageClickAction = { [weak self] (index) in
            guard let strongSelf = self else {return}
            strongSelf.scrollItemClickHandler?(index)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    ///设置线路的模型
    func setModel(_ model: RouterModel) {
        self.channelLabel.text = model.title ?? ""
    }
    
    ///设置广告模型
    func setAdModel(_ model: VideoDetailAdModel) {
        admodel = model
        self.imgView.kfSetHorizontalImageWithUrl(model.cover_oss_path)
    }

    ///设置详情模型
    func setVideoIndoModel(_ model: VideoModel) {
        self.vipLabel.isHidden = !(model.is_vip?.boolValue ?? false)
        vipIsHidden = self.vipLabel.isHidden
        self.titleLab.text = model.title ?? "老司机必备"
        if let playCount = model.play_count {
            self.playCountLabel.text = playCount >= 10000 ? String(format: "播放量:%.2f万", Float(playCount)/Float(10000.0)) : "播放量:\(playCount)"
        }
    }
    func setImages(images: [String]) {
        imgView.setImages(images)
    }
    
    ///线路点击
    @objc func didClick() {
       changeRouterHandler?()
    }
    
    @objc func didClickAd() {
        if admodel != nil {
            if let redirect_url = admodel!.redirect_url {
                let url = URL.init(string: redirect_url)
                if let openUrl = url {
                    UIApplication.shared.openURL(openUrl)
                }
            }
        }
    }
}

//MARK: -Layout
extension VideoDetailBigCollectionCell {
    
    private func layoutCellSubViews() {
        layoutChannelView()
        layoutDescriptionViewSubViews()
        layoutImageView()
    }
    
    private func layoutDescriptionViewSubViews() {
        vipLineButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(-11)
            make.top.equalTo(2)
            make.size.equalTo(CGSize(width: 100, height: 32))
        }
        titleLab.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.top.equalTo(2)
            make.trailing.equalTo(vipLineButton.snp.leading).offset(-5)
        }

        vipLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.size.equalTo(CGSize(width: 36, height: 17))
            make.top.equalTo(titleLab.snp.bottom).offset(4)
        }

        playCountLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(vipLabel.snp.trailing).offset(12)
            make.top.equalTo(titleLab.snp.bottom).offset(6)
        }
    }
    
    private func layoutChannelView() {
        channelContainer.snp.makeConstraints { (make) in
            make.trailing.equalTo(-5)
            make.top.equalTo(2)
            make.size.equalTo(CGSize(width: 100, height: 32))
        }
        arrowImg.snp.makeConstraints { (make) in
            make.trailing.equalTo(-8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(7)
        }
        channelLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(5)
            make.trailing.equalTo(-15)
            make.centerY.equalToSuperview()
        }
    }
    
    private func layoutImageView() {
        imgView.snp.makeConstraints { (make) in
            make.top.equalTo(playCountLabel.snp.bottom).offset(10)
            make.bottom.equalTo(-10)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
        }
        adButton.snp.makeConstraints { (make) in
            make.edges.equalTo(imgView)
        }
    }
    
}
