//
//  QHHomeCollectionViewCell.swift
//  QHAwemeDemo
//
//  Created by Anakin chen on 2017/10/22.
//  Copyright © 2017年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import DouYPlayer

public protocol QHHomeCollectionViewCellDelegate: NSObjectProtocol {
    
    func showDetails(_ view: QHHomeCollectionViewCell)
    
    func sliderTouch(_ isTouch: Bool)
}

public class QHHomeCollectionViewCell: UICollectionViewCell {
    
    static let cellId = "QHHomeCellIdentifier"
    
    @IBOutlet weak var bgImage: UIImageView!
    let imagePlace: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor(r: 30, g: 17, b: 23)
        imageView.image = UIImage(named: "playCellBg")
        return imageView
    }()
    /// 广告点击后响应跳转
    lazy var adCoverTap: UIButton = {
        let tap = UIButton(type: .custom)
        tap.addTarget(self, action: #selector(tapBtnClick), for: .touchUpInside)
        tap.isHidden = true
        return tap
    }()
    // 加载
    var playerStatusBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.isHidden = true
        return view
    }()
   
    lazy var favorItem: DYControltem = {
        let item = DYControltem(frame: CGRect.zero)
        return item
    }()
    lazy var commentItem: DYControltem = {
        let item = DYControltem(frame: CGRect.zero)
        return item
    }()
    lazy var shareItem: DYControltem = {
        let item = DYControltem(frame: CGRect.zero)
        return item
    }()
    lazy var seriesButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("", for: .normal)
        button.setTitleColor(ConstValue.kTitleYelloColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.contentMode = .scaleAspectFill
        button.layer.cornerRadius = 22.5
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.init(white: 0.8, alpha: 0.8).cgColor
        button.layer.borderWidth = 3.0
        button.addTarget(self, action: #selector(showDetailsAction(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var seriesAddButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(named: "VideoSeriesAdd"), for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(addFollow(_:)), for: .touchUpInside)
        return button
    }()
    lazy var adClickButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor(red: 0/255.0, green: 123/255.0, blue:  266/255.0, alpha: 0.95)
        button.titleLabel?.font = UIFont.italicSystemFont(ofSize: 16)
        button.setTitle("立即查看 >>", for: .normal)
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(showDetailsAction(_:)), for: .touchUpInside)
        return button
    }()
    /// Left Side Menus
    lazy var nameLable: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .left
        lable.text = "名字"
        lable.textColor = UIColor.white
        lable.font = UIFont.boldSystemFont(ofSize: 16)
        return lable
    }()
    var coinLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 10)
        lable.textColor = UIColor.white
        lable.textAlignment = .center
        lable.backgroundColor = UIColor(r: 255, g: 42, b: 49)
        lable.layer.cornerRadius = 3
        lable.layer.masksToBounds = true
        lable.isHidden = true
        return lable
    }()
    lazy var introLable: UILabel = {
        let lable = UILabel()
        lable.textAlignment = .left
        lable.numberOfLines = 4
        lable.textColor = .white
        lable.font = UIFont.systemFont(ofSize: 13)
        lable.text = ""
        return lable
    }()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 7
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.isScrollEnabled = true
        collection.allowsSelection = true
        collection.isUserInteractionEnabled = true
        collection.backgroundColor = UIColor.clear
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.register(TypeKeysCell.classForCoder(), forCellWithReuseIdentifier: TypeKeysCell.cellId)
        return collection
    }()
    
    var clickTypeKeyCellHandler: ((VideoKey)->())?
    var talksKeyClickHandler:(()->Void)?
    
    weak var delegate: QHHomeCollectionViewCellDelegate?
    
    var selectedTypeKeyCellTag = 0
    
    var videoModel: VideoModel = VideoModel()
    
    var keys: [VideoKey]?
    var talksModel: TalksModel?
    
    var commentItemClick:(() -> Void)?
    var shareItemClick:(() -> Void)?
    var videoFavorItemClick:((_ isFavor: Bool) -> Int)?
    var adTapActionHandler:(() ->())?
    var addFollowHandler:((VideoModel)->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.darkText
        self.selectedBackgroundView = UIView()
        setUpUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
    }
    
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        DLog("hitTestView ==== \(view)")
        delegate?.sliderTouch(view is UISlider)
        return view
    }
    
    //MARK: Private
    func setUpUI() {
        contentView.backgroundColor = UIColor.clear
        contentView.insertSubview(imagePlace, at: 0)
        contentView.addSubview(adCoverTap)
        contentView.addSubview(playerStatusBar)
        
        contentView.addSubview(shareItem)
        contentView.addSubview(commentItem)
        contentView.addSubview(favorItem)
        contentView.addSubview(seriesButton)
        contentView.addSubview(seriesAddButton)
        contentView.addSubview(adClickButton)
        contentView.addSubview(introLable)
        contentView.addSubview(nameLable)
        contentView.addSubview(coinLable)
        contentView.addSubview(collectionView)
        layoutPageSubviews()
        configItems()
    }
    
    func configItems() {
        shareItem.iconImage = "icon_home_share"
        shareItem.title =  "分享"
        commentItem.iconImage = "icon_home_comment"
        commentItem.title = "0"
        favorItem.iconImage = "icon_home_favor"
        favorItem.title = "0"
        shareItem.itemClickHandle = { [weak self] _ in
            self?.shareItemClick?()
        }
        commentItem.itemClickHandle = { [weak self] _ in
            self?.commentItemClick?()
        }
        favorItem.itemClickHandle = { [weak self] sender in
            self?.favorCurrentVideo(sender)
        }
    }
    
    /// 每次点赞状态赋值
    func setFavorStatu(_ favor: Bool) {
        favorItem.iconButton.isSelected = favor
        favorItem.iconImage = favor ? "icon_home_favor_s" : "icon_home_favor"
    }
    
    //MARK: Action
    @objc func showDetailsAction(_ sender: Any) {
        if let del = delegate {
            del.showDetails(self)
        }
    }
    ///添加关注
    @objc func addFollow(_ sender: UIButton) {
        addFollowHandler?(videoModel)
    }
    
    func setKeys(_ keys: [VideoKey]?, _ talksModel: TalksModel?) {
        self.keys = keys
        self.talksModel = talksModel
        collectionView.reloadData()
    }
    
    @objc func favorCurrentVideo(_ sender: UIButton) {
        if sender.isSelected {
            DLog("不喜欢这个Video")
            let appriseCount = videoFavorItemClick?(true)
            favorItem.title = "\(appriseCount ?? 0)"
            setFavorStatu(false)
        } else {
            DLog("喜欢这个Video")
            let appriseCount = videoFavorItemClick?(false)
            favorItem.title = "\(appriseCount ?? 0)"
            setFavorStatu(true)
        }
        
    }
    
    func startLoadingPlayItemAnim(_ isStart: Bool = true) {
        if isStart {
            playerStatusBar.backgroundColor = UIColor.white
            playerStatusBar.isHidden = false
            playerStatusBar.layer.removeAllAnimations()
            
            let animationGroup = CAAnimationGroup()
            animationGroup.duration = 0.6
            animationGroup.beginTime = CACurrentMediaTime()
            animationGroup.repeatCount = .infinity
            animationGroup.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            
            let scaleAnimX = CABasicAnimation()
            scaleAnimX.keyPath = "transform.scale.x"
            scaleAnimX.fromValue = 1.0
            scaleAnimX.toValue = 10.0 * UIScreen.main.bounds.width
            
            let scaleAnimY = CABasicAnimation()
            scaleAnimY.keyPath = "transform.scale.y"
            scaleAnimY.fromValue = 1.0
            scaleAnimY.toValue = 0.3
            
            let alphaAnim = CABasicAnimation()
            alphaAnim.keyPath = "opacity"
            alphaAnim.fromValue = 1.0
            alphaAnim.toValue = 0.35
            
            animationGroup.animations = [scaleAnimX, scaleAnimY, alphaAnim]
            playerStatusBar.layer.add(animationGroup, forKey: nil)
        } else {
            playerStatusBar.layer.removeAllAnimations()
            playerStatusBar.isHidden = true
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        let y = UIDevice.current.isiPhoneXSeriesDevices() ? self.bounds.maxY - 86 : self.bounds.maxY - 52
        playerStatusBar.frame = CGRect(x: self.bounds.midX - 0.5, y: y, width: 0.1, height: 2.5)
    }
    
    @objc func tapBtnClick() {
        adTapActionHandler?()
    }
    
    /// 拖动进度时的ui显示隐藏
    func setUIHidenOrNot(_ isDrag: Bool) {
        seriesButton.isHidden = isDrag
        seriesAddButton.isHidden = isDrag
        favorItem.isHidden = isDrag
        commentItem.isHidden = isDrag
        shareItem.isHidden = isDrag
        collectionView.isHidden = isDrag
        nameLable.isHidden = isDrag
        introLable.isHidden = isDrag
        if isDrag {
            coinLable.isHidden = true
        } else {
            if videoModel.is_coins == 0 || videoModel.coins == 0 {
                coinLable.isHidden  = true
            } else {
                coinLable.isHidden  = false
            }
        }
    }
    
    private func getwith(font: UIFont, height: CGFloat, string: String) -> CGSize {
        let size = CGSize.init(width: CGFloat(MAXFLOAT), height: height)
        let dic = [NSAttributedString.Key.font: font] // swift 4.2
        let strSize = string.boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: dic, context:nil).size
        return strSize
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension QHHomeCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if keys != nil, talksModel != nil {
            return keys!.count + 1
        } else if keys != nil, talksModel == nil {
            return keys!.count
        } else if keys == nil, talksModel != nil {
            return 1
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TypeKeysCell.cellId, for: indexPath) as! TypeKeysCell
        if talksModel != nil  {
            if indexPath.item == 0 {
                cell.titleLab.text = "#\(talksModel!.title ?? "")"
            } else {
                if let keys = self.keys, keys.count > indexPath.item - 1 {
                    cell.titleLab.text = "\(keys[indexPath.item - 1].title ?? "")"
                }
            }
        } else {
            if let keys = self.keys, keys.count > indexPath.item {
                cell.titleLab.text = "\(keys[indexPath.item].title ?? "")"
            }
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if talksModel != nil {
            if indexPath.item == 0 {
                self.talksKeyClickHandler?()
            } else {
                if let videoKey = keys?[indexPath.item - 1]{
                    self.clickTypeKeyCellHandler?(videoKey)
                }
            }
        } else {
            if let videoKey = keys?[indexPath.item]{
                self.clickTypeKeyCellHandler?(videoKey)
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size: CGSize = CGSize.zero
        if talksModel != nil  {
            if indexPath.item == 0 {
                size = getwith(font: UIFont.systemFont(ofSize: 12), height: 25, string: "#\(talksModel!.title ?? "")")
            } else {
                if let keys = self.keys, keys.count > indexPath.item - 1 {
                    size = getwith(font: UIFont.systemFont(ofSize: 12), height: 25, string: "\(keys[indexPath.item - 1].title ?? "")")
                }
            }
        } else {
            if let keys = self.keys, keys.count > indexPath.item {
                size = getwith(font: UIFont.systemFont(ofSize: 12), height: 25, string: "\(keys[indexPath.item].title ?? "")")
            }
        }
        return CGSize(width: size.width + 12, height: 30)
    }
    
    
}

// MARK: - layout
private extension QHHomeCollectionViewCell {
    
    func layoutPageSubviews() {
        layoutImagePlace()
        layoutShareItem()
        layoutCommentItem()
        layoutFavorItem()
        layoutSeriesButton()
        layoutAdclickButton()
        layoutIntrolLable()
        layoutNameLable()
        layoutTapBtn()
        layoutCollectionView()
    }
    func layoutImagePlace() {
        imagePlace.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    func layoutSeriesButton() {
        seriesButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(favorItem)
            make.bottom.equalTo(favorItem.snp.top).offset(-35)
            make.width.height.equalTo(45)
        }
        seriesAddButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(seriesButton)
            make.centerY.equalTo(seriesButton.snp.bottom)
            make.width.height.equalTo(20)
        }
    }
    func layoutCommentItem() {
        commentItem.snp.makeConstraints { (make) in
            make.trailing.equalTo(-6)
            make.bottom.equalTo(shareItem.snp.top).offset(-14)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }
    func layoutShareItem() {
        shareItem.snp.makeConstraints { (make) in
            make.trailing.equalTo(-6)
            make.bottom.equalTo(-(49 + 35 + safeAreaBottomHeight))
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }
    
    func layoutFavorItem() {
        favorItem.snp.makeConstraints { (make) in
            make.trailing.equalTo(-6)
            make.bottom.equalTo(commentItem.snp.top).offset(-14)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }
    func layoutAdclickButton() {
        adClickButton.snp.makeConstraints { (make) in
            make.leading.equalTo(12)
            make.bottom.equalTo(-(49 + 25 + safeAreaBottomHeight))
            make.trailing.equalTo(shareItem.snp.leading).offset(-60)
            make.height.equalTo(35)
        }
    }
    func layoutIntrolLable() {
        introLable.snp.makeConstraints { (make) in
            make.leading.equalTo(12)
//            make.bottom.equalTo(-(49 + 25 + safeAreaBottomHeight))
            make.bottom.equalTo(shareItem.snp.bottom)
            make.trailing.equalTo(shareItem.snp.leading).offset(-40)
        }
    }
    func layoutNameLable() {
        nameLable.snp.makeConstraints { (make) in
            make.leading.equalTo(introLable)
            make.bottom.equalTo(introLable.snp.top).offset(-5)
            make.height.equalTo(25)
        }
        coinLable.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLable.snp.trailing).offset(5)
            make.centerY.equalTo(nameLable)
            make.height.equalTo(18)
            make.width.equalTo(40)
        }
    }
    func layoutTapBtn() {
        adCoverTap.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    func layoutCollectionView() {
        collectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(introLable)
            make.trailing.equalTo(shareItem.snp.leading).offset(-10)
            make.bottom.equalTo(nameLable.snp.top).offset(-5)
            make.height.equalTo(30)
        }
    }
}
