//
//  CateAllTagsController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/5/2.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork

class CateAllTagsController: UIViewController {
    
    /// 单区可选限制
    static let sectionSelecteLimit = 1
    
    static let videoItemWidth: CGFloat = (ConstValue.kScreenWdith - 80)/4
    static let videoItemHieght: CGFloat = 35
    static let videoItemSize: CGSize = CGSize(width: videoItemWidth, height: videoItemHieght)
    static let collectionFootId = "TagChoseFooter"

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private lazy var navBar: QHNavigationBar = {
        let bar = QHNavigationBar()
        bar.titleLabel.text = "选择分类"
        bar.titleLabel.textColor = UIColor.white
        bar.backgroundColor = UIColor.clear
        bar.delegate = self
        return bar
    }()
    private lazy var doneBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("保存", for: .normal)
        button.setTitleColor(ConstValue.kTitleYelloColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.addTarget(self, action: #selector(doneAction(_:)), for: .touchUpInside)
        return button
    }()
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10 ,left: 10, bottom: 10, right: 10)
        return layout
    }()
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.clear
        collection.register(TagCell.classForCoder(), forCellWithReuseIdentifier: TagCell.cellId)
        collection.register(CateTagsSectionHeader.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CateTagsSectionHeader.identifier)
        collection.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CateAllTagsController.collectionFootId)
        return collection
    }()
    private lazy var cateTypeListApi: VideoUploadTipsApi = {
        let api = VideoUploadTipsApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    private var sourceData = [[CateTagModel]]()
    private var selectedTags = [[CateTagModel]]()
    var cateListMdoel: CateListModel?
    
    
    var saveButtonClickHandler:((_ allTags: [CateTagModel]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ConstValue.kVcViewColor
        view.addSubview(navBar)
        navBar.navBarView.addSubview(doneBtn)
        layoutBaseView()
        loadData()
    }
    
    private func loadData() {
        NicooErrorView.removeErrorMeesageFrom(view)
        _ = cateTypeListApi.loadData()
    }
    
    private func setUpUI() {
        view.addSubview(collectionView)
        layoutCollection()
    }
    
    private func fixSelectedData() {
        var allSections = [[CateTagModel]]()
        for _ in sourceData {
            let models = [CateTagModel]()
            allSections.append(models)
        }
        selectedTags = allSections
    }
    
    private func loadDataSuccess(_ model: CateListModel) {
        cateListMdoel = model
        var allSections = [[CateTagModel]]()
        if let sectionModels = model.data, sectionModels.count > 0 {
            for k in 0 ..< sectionModels.count {
                var models = [CateTagModel]()
                let sectionModel = sectionModels[k]
                if let cateModels = sectionModel.type_list, cateModels.count > 0 {
                    for i in 0 ..< cateModels.count {
                        let model = cateModels[i]
                        models.append(model)
                    }
                }
                allSections.append(models)
            }
        }
        sourceData = allSections
        fixSelectedData()
        setUpUI()
    }
    

}

// MARK: - User Actions
private extension CateAllTagsController {
    
    @objc func doneAction(_ sender: UIButton) {
        var finalSelecteds = [CateTagModel]()
        for models in selectedTags {
            for model in models {
                finalSelecteds.append(model)
            }
        }
        if finalSelecteds.count == 0 {
            XSAlert.show(type: .warning, text: "您还没有选择分类！")
            return
        }
        saveButtonClickHandler?(finalSelecteds)
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension CateAllTagsController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sourceData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sourceData[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cellForRow(with: indexPath)
        return cell
    }
    
    /// 配置cell
    func cellForRow(with indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.cellId, for: indexPath) as! TagCell
        let model = sourceData[indexPath.section][indexPath.row]
        cell.tagLabel.text = model.title ?? ""
        if model.isSelected ?? false {
            cell.tagLabel.backgroundColor = ConstValue.kTitleYelloColor
            cell.tagLabel.textColor = UIColor.white
        } else {
            cell.tagLabel.textColor = UIColor.white
            cell.tagLabel.backgroundColor = UIColor(r: 30, g:31, b: 49)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let model = sourceData[indexPath.section][indexPath.row]
        if !(model.isSelected ?? false)  {
            if selectedTags[indexPath.section].count < CateAllTagsController.sectionSelecteLimit { // 限制每个区 最多选几个
                sourceData[indexPath.section][indexPath.row].isSelected = true
                selectedTags[indexPath.section].append(sourceData[indexPath.section][indexPath.row])
            }
        } else {
            sourceData[indexPath.section][indexPath.row].isSelected = false
            var changeModels = selectedTags[indexPath.section]
            for i in 0 ..< selectedTags[indexPath.section].count {
                let modelSlected = selectedTags[indexPath.section][i]
                if (modelSlected.id ?? 0) == (model.id ?? 0) {
                    changeModels.remove(at: i)
                }
            }
            selectedTags.insert(changeModels, at: indexPath.section)
            selectedTags.remove(at: indexPath.section + 1)
        }
        collectionView.reloadItems(at: [indexPath])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return PushVideoController.videoItemSize
    }
    
    /// sectionHeader高度
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: ConstValue.kScreenWdith, height: 50)
    }
    
    /// 区头 && 区脚 - View
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader { // header
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CateTagsSectionHeader.identifier, for: indexPath) as! CateTagsSectionHeader
            if let sectionModels = cateListMdoel?.data, sectionModels.count > indexPath.section {
                let sectionModel = sectionModels[indexPath.section]
                view.titleLable.text = sectionModel.title ?? "分类\(indexPath.section)"
            }
            return view
        } else { // footer
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CateAllTagsController.collectionFootId, for: indexPath)
            return footer
        }
    }
    
}

// MARK: - NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate
extension CateAllTagsController: NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        return nil
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is VideoUploadTipsApi {
            if let cateListModel = manager.fetchJSONData(VideoReformer()) as? CateListModel {
                loadDataSuccess(cateListModel)
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is VideoUploadTipsApi {
            NicooErrorView.showErrorMessage(.noNetwork, on: view) {
                self.loadData()
            }
        }
    }
}


// MARK: - QHNavigationBarDelegate
extension CateAllTagsController:  QHNavigationBarDelegate  {
    
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Layout
private extension CateAllTagsController {
    
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
    
    func layoutCollection() {
        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
}
