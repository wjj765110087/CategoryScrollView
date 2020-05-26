//
//  MessageHeaderView.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/2.
//  Copyright © 2019 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class MessageHeaderView: UIView {

    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = MessageCollectionCell.itemSize
        layout.minimumLineSpacing = (screenWidth - 4 * 50 - 25 * 2) / 3
        layout.sectionInset = UIEdgeInsets(top: 30, left: 25, bottom: 26, right: 25)
        return layout
    }()
    
   private lazy var collectionView: UICollectionView = {
       let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
       collection.backgroundColor = .clear
       collection.isScrollEnabled = false
       collection.bounces = false
       collection.showsHorizontalScrollIndicator = false
       collection.delegate = self
       collection.dataSource = self
       collection.register(MessageCollectionCell.classForCoder(), forCellWithReuseIdentifier: MessageCollectionCell.cellId)
       return collection
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = ConstValue.kViewLightColor
        return view
    }()
    
    private let titles = ["通知","点赞","评论","粉丝"]
    private let icons = ["messageNotice","messageZan", "messagePinglun", "messageFans"]
    
    var messageNumModels: [MessageModel] = [MessageModel]()
    
    var didClickCellHandler:((_ index: Int)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lineView)
        addSubview(collectionView)
        layoutPageViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(hasLookTagMessage), name: Notification.Name.kLookMessageNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setModels(models: [MessageModel]) {
        self.messageNumModels = models
        collectionView.reloadData()
    }
    
    @objc func hasLookTagMessage(notifiy: Notification) {
        if let userinfo = notifiy.userInfo {
            if let tag = userinfo["message"] as? Int {
                switch tag {
                case 1: let cell = collectionView.cellForItem(at: IndexPath.init(item: 0, section: 0)) as! MessageCollectionCell
                        cell.countLab.isHidden = true
                case 2: let cell = collectionView.cellForItem(at: IndexPath.init(item: 1, section: 0)) as! MessageCollectionCell
                cell.countLab.isHidden = true
                case 3: let cell = collectionView.cellForItem(at: IndexPath.init(item: 2, section: 0)) as! MessageCollectionCell
                cell.countLab.isHidden = true
                case 4: let cell = collectionView.cellForItem(at: IndexPath.init(item: 3, section: 0)) as! MessageCollectionCell
                cell.countLab.isHidden = true
                default:
                    break
                }
            }
        }
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MessageHeaderView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCollectionCell.cellId, for: indexPath) as! MessageCollectionCell
        cell.setTitle(title: titles[indexPath.item])
        cell.setIconImage(image: icons[indexPath.item])
        if messageNumModels.count > 0 {
            cell.setModel(model: messageNumModels[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        didClickCellHandler?(indexPath.row)
    }
}

//MARK: - layout
extension MessageHeaderView {
    
    private func layoutPageViews() {
        layoutLineView()
        layoutCollectionView()
    }
    
    private func layoutLineView() {
        lineView.snp.makeConstraints { (make) in
            make.leading.equalTo(18)
            make.trailing.equalTo(-18)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    private func layoutCollectionView() {
        collectionView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(lineView.snp.top)
        }
    }
}
