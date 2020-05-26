//
//  RecomentController.swift
//  DouCartoonDemo
//
//  Created by mac on 2019/6/4.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit
import NicooNetwork

/// 所有的推荐都用这个
class RecomentController: UIViewController {

    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = VideoDoubleCollectionCell.itemSize
        layout.minimumLineSpacing = 10
        return layout
    }()
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.white
        collection.showsVerticalScrollIndicator = false
         collection.register(UINib.init(nibName: "VideoDoubleCollectionCell", bundle: Bundle.main), forCellWithReuseIdentifier: VideoDoubleCollectionCell.cellId)
        collection.register(SearchSecHeadView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchSecHeadView.identifier)
        return collection
    }()
    private lazy var guessLikeApi: VideoListApi = {
        let api = VideoListApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()

    var videoLsModel = VideoListModel()
    var videoModels = [VideoModel]()
    
    var sectionTitle = "他人搜过"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(collectionView)
        layoutCollectionView()
        loadData()
    }
    
    // 数据请求
    func loadData() {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: self.view, imageNames: nil, bgColor: UIColor.clear, animated: false)
        NicooErrorView.removeErrorMeesageFrom(view)
        let _ = guessLikeApi.loadData()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension RecomentController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoDoubleCollectionCell.cellId, for: indexPath) as! VideoDoubleCollectionCell
        let model = videoModels[indexPath.item]
        cell.setModel(model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let model = videoModels[indexPath.item]
        let videoDetail = VideoDetailViewController()
        videoDetail.model = model
        navigationController?.pushViewController(videoDetail, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableView:UICollectionReusableView?
        //是每组的头
        if kind == UICollectionView.elementKindSectionHeader {
            let searchReusable = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchSecHeadView.identifier, for: indexPath) as! SearchSecHeadView
          
            searchReusable.rightButton.isHidden = true
            searchReusable.titleLable.font = UIFont.systemFont(ofSize: 16)
            searchReusable.titleLable.text = sectionTitle
            reusableView = searchReusable
        }
        return reusableView!
    }
}

// MARK: - NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate
extension RecomentController: NicooAPIManagerCallbackDelegate, NicooAPIManagerParamSourceDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        var params = [String : Any]()
        params[VideoListApi.kSort] = VideoListApi.kSort_hot
        return params
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is VideoListApi {
            if let modules = manager.fetchJSONData(HotReformer()) as? VideoListModel {
                videoLsModel = modules
                if let videos = modules.data {
                    videoModels = videos
                }
                collectionView.reloadData()
            }
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
    }
}

// MARK: - Layout
private extension RecomentController {
    
    func layoutCollectionView() {
        collectionView.snp.makeConstraints { (make) in
           make.edges.equalToSuperview()
        }
    }
}
