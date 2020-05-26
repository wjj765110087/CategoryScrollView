//
//  FilterChoseController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/4/20.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

class FilterChoseController: UIViewController {

    private let customLayout: CustomFlowPhotoLayout = {
        let layout = CustomFlowPhotoLayout()
        layout.itemSize = CGSize(width: 85, height: 120)
        // layout.
        return layout
    }()
    private let coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.9)
        return view
    }()
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: ConstValue.kScreenWdith, height: 120), collectionViewLayout: customLayout)
        collection.backgroundColor = UIColor.clear
        collection.showsHorizontalScrollIndicator = false
        collection.delegate = self
        collection.dataSource = self
        collection.register(FilterItemCell.classForCoder(), forCellWithReuseIdentifier: FilterItemCell.cellId)
        return collection
    }()
    var filterManager = FilterManager()
    var pictures = [UIImage]()
    /// 当前选中的滤镜index
    var currentSelectedIndex: Int = 0
    
    var filterChoseHandler:((_ filter: FilterModel) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(coverView)
        view.addSubview(collectionView)
        layoutPageSubviews()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension FilterChoseController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterManager.filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterItemCell.cellId, for: indexPath) as! FilterItemCell
        let filterModel = filterManager.filters[indexPath.row]
        cell.filterNameLable.text = filterModel.name
        cell.filterButton.isSelected = filterModel.isSelected
        cell.filterClickHandler = { [weak self] in
            guard let strongSelf = self else { return }
            if indexPath.row != strongSelf.currentSelectedIndex {  // 非选择当前
                strongSelf.filterManager.filters[indexPath.row].isSelected = true
                strongSelf.filterManager.filters[strongSelf.currentSelectedIndex].isSelected = false
                strongSelf.currentSelectedIndex = indexPath.row
                strongSelf.filterChoseHandler?(filterModel)
                strongSelf.collectionView.reloadData()
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
}

// MARK: - Layout
private extension FilterChoseController {
    
    func layoutPageSubviews() {
        layoutCoverView()
        layoutCollection()
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
            make.height.equalTo(135)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            } else {
                make.bottom.equalToSuperview().offset(-10)
            }
        }
    }
}
