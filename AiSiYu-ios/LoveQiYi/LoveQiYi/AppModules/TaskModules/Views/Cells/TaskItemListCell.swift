//
//  TaskItemListCell.swift
//  YellowBook
//
//  Created by mac on 2019/7/1.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit

class TaskItemListCell: UITableViewCell {
    
    static let cellId = "TaskItemListCell"
    
    private let customLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let itemWidth: CGFloat = (UIScreen.main.bounds.size.width - 24)/3
        let itemHieght: CGFloat = 68
        layout.itemSize = CGSize(width: itemWidth, height: itemHieght)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }()
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: self.bounds, collectionViewLayout: customLayout)
        collection.backgroundColor = UIColor.clear
        collection.showsHorizontalScrollIndicator = false
        collection.isScrollEnabled = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(TaskItemCell.classForCoder(), forCellWithReuseIdentifier: TaskItemCell.cellId)
        return collection
    }()
    var itemClickHandler:((_ index: Int) ->Void)?
    var taskModels: [TaskModel]?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.clear
        contentView.addSubview(collectionView)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTaskModels(_ tasks: [TaskModel]?) {
        taskModels = tasks
        collectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension TaskItemListCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskModels?.count ?? 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskItemCell.cellId, for: indexPath) as! TaskItemCell
        cell.itemBgView.backgroundColor = [UIColor(r: 255, g: 191, b: 26), UIColor(r: 255, g: 120, b: 94), UIColor(r:40, g: 136, b: 255),UIColor(r: 255, g: 191, b: 26), UIColor(r: 255, g: 120, b: 94), UIColor(r:40, g: 136, b: 255)][indexPath.item]
        if let model = taskModels?[indexPath.item] {
            cell.setTaskModel(model)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let model = taskModels?[indexPath.item] {
            if (model.sign ?? .normal) == .normal {
                itemClickHandler?(indexPath.row)
            } else {
                XSAlert.show(type: .warning, text: "任务已完成。")
            }
        }
    }
    
}

// MARK: - Layout
private extension TaskItemListCell {
    
    func layoutPageSubviews() {
        layoutCollection()
    }
    func layoutCollection() {
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(6)
            make.bottom.equalTo(-6)
        }
    }
}


class TaskItemCell: UICollectionViewCell {
    
    static let cellId = "TaskItemCell"
    
    lazy var taskStatuBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(nil, for: .normal)
        button.setImage(UIImage(named: "taskBeenDone"), for: .selected)
        return button
    }()
    let itemBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 255, g: 181, b: 26)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    let taskLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "新手注册"
        return label
    }()
    let taskCoins: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "无限天数 +3"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(itemBgView)
        itemBgView.addSubview(taskLabel)
        itemBgView.addSubview(taskCoins)
        itemBgView.addSubview(taskStatuBtn)
        layoutPageSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTaskModel(_ model: TaskModel) {
        taskLabel.text = "\(model.title ?? "")"
        taskCoins.text = "无限天数+\(model.day ?? 0)"
        taskStatuBtn.isSelected = (model.sign ?? .normal) == .selected
    }
    
}

private extension TaskItemCell {
    
    func layoutPageSubviews() {
        layoutBgView()
        layoutTaskLable()
        layoutTaskCoins()
        layoutTaskStatuBtn()
    }
    func layoutBgView() {
        itemBgView.snp.makeConstraints { (make) in
            make.leading.equalTo(5)
            make.trailing.equalTo(-5)
            make.top.bottom.equalTo(0)
        }
    }
    func layoutTaskStatuBtn() {
        taskStatuBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(0)
            make.trailing.equalTo(0)
            make.width.equalTo(32)
            make.height.equalTo(24)
        }
    }
    func layoutTaskLable() {
        taskLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(8)
            make.top.equalTo(10)
            make.trailing.equalTo(-5)
        }
    }
    func layoutTaskCoins() {
        taskCoins.snp.makeConstraints { (make) in
            make.leading.equalTo(8)
            make.top.equalTo(taskLabel.snp.bottom).offset(5)
            make.trailing.equalTo(-5)
        }
    }
}
