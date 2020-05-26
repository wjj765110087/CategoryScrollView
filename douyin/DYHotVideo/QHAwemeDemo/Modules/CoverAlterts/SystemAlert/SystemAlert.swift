//
//  SystemAlert.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/3/25.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class SystemAlert: UIView {

    @IBOutlet weak var contenView: UIView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var titleContenView: UIView!
    @IBOutlet weak var englishTitle: UILabel!
    @IBOutlet weak var msgLable: UILabel!
    @IBOutlet weak var webLable: UILabel!
    @IBOutlet weak var commitBtn: UIButton!
    @IBOutlet weak var yqLable: YQLabel!
    
    @IBOutlet weak var HeightContrast: NSLayoutConstraint!
    private let customLayout: CustomFlowPhotoLayout = {
        let layout = CustomFlowPhotoLayout()
        layout.itemSize = CGSize(width: 260, height: 200)
        // layout.
        return layout
    }()
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 120), collectionViewLayout: customLayout)
        collection.allowsSelection = false
        collection.backgroundColor = UIColor.clear
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(ScrollSystemAlertCell.classForCoder(), forCellWithReuseIdentifier: ScrollSystemAlertCell.cellId)
        return collection
    }()
    
    var isLinkType : Bool = false {
        didSet {
            msgLable.isHidden = isLinkType
            webLable.isHidden = isLinkType
            collectionView.isHidden = isLinkType
            yqLable.isHidden = !isLinkType
            HeightContrast.constant = 290
        }
    }
    var isScrollContent: Bool = false {
        didSet {
            msgLable.isHidden = isScrollContent
            webLable.isHidden = isScrollContent
            yqLable.isHidden = isScrollContent
            collectionView.isHidden = !isScrollContent
            HeightContrast.constant = 350
        }
    }
    
    var messages = [SystemMsgModel]()
    var currentIndex: Int = 0
    
    var commitActionHandler:(() -> Void)?
    var closeActionHandler:(() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contenView.layer.cornerRadius = 23
        contenView.layer.masksToBounds = true //224 196 170
        contenView.addSubview(collectionView)
        layoutCollection()
    }
    
    func setLinkText() {
        //亲爱的抖友们
//        牢记抖阴官网，开车永不迷路
//        遇到问题，加入官方群@群管理
//        强烈建议绑定手机，账号永不丢失
//        官网地址：http://appdyporn.me
        yqLable.add(text: "请牢记抖阴官网，开车永不迷路\n遇到问题，加入", color: UIColor.darkText)
       
        yqLable.add(text: "官方群@群管理\n", color: UIColor.blue,  clickHandler: { [weak self] (text, tag) in
            self?.goGroup()
        })
        yqLable.add(text: "强烈建议绑定手机，账号永不丢失\n官网地址：", color: UIColor.darkText)
        yqLable.add(text: "http://app.dyporn.me", color: UIColor.blue,  clickHandler: { [weak self] (text, tag) in
            self?.goWeb()
        })
    }
    
    func setMessages(_ messages: [SystemMsgModel]) {
        self.messages = messages
        collectionView.reloadData()
    }
    
    @IBAction func commitBtnClick(_ sender: UIButton) {
        commitActionHandler?()
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        closeActionHandler?()
    }
    
    private func goWeb() {
        if let url = URL(string: ConstValue.kAppDownLoadLoadUrl) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    private func goGroup() {
        if let url = URL(string: AppInfo.share().potato_invite_link ?? "") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: { (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SystemAlert: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScrollSystemAlertCell.cellId, for: indexPath) as! ScrollSystemAlertCell
        cell.textView.text = messages[indexPath.row].message
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
}

// MARK: - UIScrollViewDelegate
extension SystemAlert: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        DispatchQueue.main.async {
            let translatedPoint = scrollView.panGestureRecognizer.translation(in: scrollView)
            scrollView.panGestureRecognizer.isEnabled = false
            
            if translatedPoint.x < -50 && self.currentIndex < 1 {
                self.currentIndex += 1
            }
            if translatedPoint.x > 50 && self.currentIndex > 0 {
                self.currentIndex -= 1
            }
            let indexPath = IndexPath(item: self.currentIndex, section: 0)
            UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
                self.collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
                if self.messages.count > 1 {
                    self.titleLable.text = "系统公告(\(self.currentIndex + 1)/\(self.messages.count))"
                }
            }, completion: { finished in
                scrollView.panGestureRecognizer.isEnabled = true
            })
        }
    }
}

// MARK: - Layout
private extension SystemAlert {
    
    private func layoutCollection() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(yqLable)
        }
    }
}
