//
//  DiscoverRankCell.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/5.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class DiscoverRankCell: UICollectionViewCell {
    
    static let cellId = "DiscoverRankCell"
    static let itemSize: CGSize = CGSize(width: screenWidth, height: 107)
    
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        layout.itemSize = RankItemCell.itemSize
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.clear
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(RankItemCell.classForCoder(), forCellWithReuseIdentifier: RankItemCell.cellId)
        return collection
    }()
    
    var didClickRankHandler: ((_ index: Int)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(collectionView)
        layoutPageViews()
    }
    
    var models: [FindRankModel] = [FindRankModel]()
    var images: [String] = ["weekRank","monthRank","lastMonth"]
    
    func setModel(rankList: [FindRankModel]) {
        models = rankList
        collectionView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: -Layout
private extension DiscoverRankCell {
    
    func layoutPageViews() {
        layoutCollectionView()
    }
    
    func layoutCollectionView() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

//MARK: - UICollectionViewDataSource && UICollectionViewDelegate
extension DiscoverRankCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RankItemCell.cellId, for: indexPath) as! RankItemCell
        let model = models[indexPath.row]
        cell.bgImageView.image = UIImage(named: images[indexPath.row])
        cell.setModel(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        didClickRankHandler?(indexPath.row)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DiscoverRankCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}

//MARK: -UICollectionViewCell 子cell
class RankItemCell: UICollectionViewCell {
    
    static let cellId = "RankItemCell"
    static let itemSize: CGSize = CGSize(width: 152, height: 97)
    
    private lazy var bgView: UIView = {
       let view = UIView()
       view.layer.cornerRadius = 4
       view.layer.masksToBounds = true
       return view
    }()
    
    lazy var bgImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var weekRankLabel: UILabel = {
       let label = UILabel()
       label.text = "本周精品榜单"
       label.textColor = .white
       label.font = UIFont.boldSystemFont(ofSize: 15)
       return label
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "rankArrow")
        return imageView
    }()
    
    private lazy var rankerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ConstValue.kDefaultHeader
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 23.5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var rankLabel: UILabel = {
        let label = UILabel()
        label.text = "TOP.1"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "奔驰路边停车..."
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(bgView)
        contentView.addSubview(bgImageView)
        contentView.addSubview(weekRankLabel)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(rankerImageView)
        contentView.addSubview(rankLabel)
        contentView.addSubview(nameLabel)
        layoutPageSubViews()
    }
    
    func setModel(model: FindRankModel) {
        let userDefaultHeader = UserModel.share().getUserHeader(model.video_model?.user?.id)
        if model.type == RankType.week {
            weekRankLabel.text = "本周最热视频"
        } else if model.type == RankType.month {
            weekRankLabel.text = "本月最热视频"
        } else if model.type == RankType.lastMonth {
            weekRankLabel.text = "上月最热视频"
        }
        rankerImageView.kfSetHeaderImageWithUrl(model.video_model?.user?.cover_path, placeHolder: userDefaultHeader)
        nameLabel.text = model.video_model?.user?.nikename
        
        if let top = model.top {
            if model.type == RankType.week {
                rankLabel.text = "TOP." + String(format: "%d", top)
            } else if model.type == RankType.month {
                rankLabel.text = "TOP." + String(format: "%d", top)
            } else if model.type == RankType.lastMonth {
                rankLabel.text = "TOP." + String(format: "%d", top)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: -Layout
private extension RankItemCell {
    
    func layoutPageSubViews() {
        layoutBgView()
        layoutBgImageView()
        layoutWeekRankLabel()
        layoutArrowImageView()
        layoutRankerImageView()
        layoutRankLabel()
        layoutNameLabel()
    }
    
    func layoutBgView() {
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func layoutBgImageView() {
        bgImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func layoutWeekRankLabel() {
        weekRankLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(10.5)
            make.top.equalTo(10.5)
        }
    }
    
    func layoutArrowImageView() {
        arrowImageView.snp.makeConstraints { (make) in
            make.trailing.equalTo(-10)
            make.centerY.equalTo(weekRankLabel.snp.centerY)
        }
    }
    
    func layoutRankerImageView() {
        rankerImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.top.equalTo(weekRankLabel.snp.bottom).offset(14)
            make.size.equalTo(CGSize(width: 47, height: 47))
        }
    }
    
    func layoutRankLabel() {
        rankLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(rankerImageView.snp.trailing).offset(8)
            make.top.equalTo(rankerImageView.snp.top).offset(6.5)
        }
    }
    
    func layoutNameLabel() {
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(rankerImageView.snp.trailing).offset(8)
            make.top.equalTo(rankLabel.snp.bottom).offset(11)
        }
    }
}
