//
//  GameStakeView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019-12-20.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import AVFoundation

struct StakeModel: Codable {
    var propId: Int = 0
    var sCount: Int = 0
    var icon: String
    var music: String
}

class GameStakeView: UIView {
    
    private let customLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 2
        return layout
    }()
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: customLayout)
        collection.backgroundColor = UIColor.clear
        collection.showsHorizontalScrollIndicator = false
        collection.allowsSelection = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(GameStakeItemView.classForCoder(), forCellWithReuseIdentifier: GameStakeItemView.cellId)
        return collection
    }()
    
    var itemClickHandler:(()->Void)?
    var gameModel: GameMainModel?
    var stakeModels = [StakeModel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ConstValue.kViewLightColor
        addSubview(collectionView)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setModels(_ list: [StakeModel]) {
        stakeModels = list
        collectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension GameStakeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stakeModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameStakeItemView.cellId, for: indexPath) as! GameStakeItemView
        let stakeModel = stakeModels[indexPath.item]
        cell.setPropModel(stakeModel)
        cell.stakeClickHandler = { [weak self] in
            guard let strongSelf = self else { return }
            GameStakeItemView.playSound(stakeModel.music)
            let beiCount = UserModel.share().gameBeiCount
            let userCoins = UserModel.share().wallet?.coins ?? 0
            if userCoins < beiCount {
                XSAlert.show(type: .error, text: "金币不足")
                return
            }
            let propModel = strongSelf.stakeModels[indexPath.item]
            if propModel.sCount >= 999 { return }
            
            strongSelf.stakeModels[indexPath.item].sCount = strongSelf.stakeModels[indexPath.item].sCount + 1
            UserModel.share().wallet?.coins = userCoins - beiCount
            cell.setPropModel(strongSelf.stakeModels[indexPath.item])
            strongSelf.itemClickHandler?()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (screenWidth-24)/CGFloat(stakeModels.count)
        return CGSize(width: width, height: width/2*3 + 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}

// MARK: - Layout
private extension GameStakeView {
    func layoutPageSubviews() {
        layoutCollection()
    }
    func layoutCollection() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

class GameStakeItemView: UICollectionViewCell {
    
    static let cellId = "GameStakeItemViewv"
    
    let colorRed: UIColor = UIColor(r: 129, g: 0, b: 11)
    let numberBgImg: UIImageView = {
        let img = UIImageView(image: UIImage(named: "stakeNumberBg"))
        img.contentMode = .scaleAspectFill
        img.isUserInteractionEnabled = true
        return img
    }()
    let numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "DBLCDTempBlack", size: 17)
        label.textColor = UIColor(r: 129, g: 0, b: 11)
        label.textAlignment = .center
        label.text = "000"
        return label
    }()
    lazy var stakeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "game_stakeBtnNor"), for: .normal)
        button.setBackgroundImage(UIImage(named: "game_stakeBtnHL"), for: .highlighted)
        button.addTarget(self, action: #selector(stakeButtonClick), for: .touchUpInside)
        return button
    }()
    let propImg: UIImageView = {
        let img = UIImageView(image: UIImage(named: "babyGame"))
        img.contentMode = .scaleAspectFit
        img.isUserInteractionEnabled = false
        return img
    }()
    var stakeClickHandler:(()->Void)?
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadUI()
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func loadUI() {
        backgroundColor = UIColor.clear
        contentView.addSubview(numberBgImg)
        contentView.addSubview(numberLabel)
        contentView.addSubview(stakeButton)
        contentView.addSubview(propImg)
        layoutPageSubviews()
    }
    
    func setPropModel(_ propModel: StakeModel) {
       propImg.kfSetHeaderImageWithUrl(propModel.icon, placeHolder: UIImage(named: "babyGame"))
        if propModel.sCount > 0 {
            numberLabel.text = "\(propModel.sCount)"
            numberLabel.textColor = UIColor.white
        } else {
            numberLabel.text = "000"
            numberLabel.textColor = UIColor(r: 129, g: 0, b: 11)
        }
    }
    
    @objc func stakeButtonClick() {
        //GameStakeItemView.playSound("laohu2"v)
        stakeClickHandler?()
    }
    
    /// - 按键音
    class func playSound(_ name: String) -> Void {
        var soundID: SystemSoundID = 0
        let soundFile = Bundle.main.path(forResource: name, ofType: "mp3")
        AudioServicesCreateSystemSoundID(URL(fileURLWithPath: soundFile!) as  CFURL, &soundID)
        //播放系统提示音
        AudioServicesPlaySystemSound(soundID)
    }
    
}

private extension GameStakeItemView {
    func layoutPageSubviews() {
        layoutNumberPart()
        layoutStakeButton()
    }
    func layoutNumberPart() {
        numberBgImg.snp.makeConstraints { (make) in
            make.leading.equalTo(2)
            make.trailing.equalTo(-2)
            make.top.equalToSuperview()
            make.height.equalTo(25)
        }
        numberLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(5)
            make.trailing.equalTo(-5)
            make.centerY.equalTo(numberBgImg).offset(2)
        }
    }
    func layoutStakeButton() {
        stakeButton.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(numberBgImg.snp.bottom).offset(5)
        }
        propImg.snp.makeConstraints { (make) in
            make.bottom.equalTo(stakeButton.snp.bottom).offset(-10)
            make.leading.top.trailing.equalTo(stakeButton)
        }
    }
    
}
