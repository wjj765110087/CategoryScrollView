//
//  SeriesViewController.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/18.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit

class SeriesViewController: BaseViewController {
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = SeriesCollectionCell.itemSize
        layout.sectionInset = UIEdgeInsets.init(top: 8, left: 0, bottom: 15, right: 0)
        return layout
    }()
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.white
        collection.allowsSelection = true
        collection.showsVerticalScrollIndicator = false
        collection.register(SeriesCollectionCell.classForCoder(), forCellWithReuseIdentifier: SeriesCollectionCell.cellId)
        
        collection.mj_header = refreshView
        collection.mj_footer = loadMoreView
        
        return collection
        
    }()
    
    private lazy var searchButton: UIButton = {
       let button = UIButton(type: .custom)
       button.setImage(UIImage(named: "2"), for: .normal)
       button.addTarget(self, action: #selector(didClickSearchButton), for: .touchUpInside)
       return button
    }()
    
    var viewModel: SpecialSeriesViewModel = SpecialSeriesViewModel()
    
    var dataSource: [SpecialSerialModel] = [SpecialSerialModel]()
    
    var currentPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutPageSubViews()
        navConfig()
        refreshSeriesData()
    }
    
    func navConfig() {
        navBar.isHidden = false
        navBar.backButton.isHidden = true
        navBar.titleLabel.text = "精选系列"
        view.bringSubviewToFront(navBar)
        navBar.addSubview(searchButton)
        searchButton.snp.makeConstraints { (make) in
            make.right.equalTo(-17)
            make.bottom.equalTo(-13.5)
            make.size.equalTo(CGSize(width: 17.5, height: 17))
        }
    }
    
    @objc func didClickSearchButton() {
        let search = SearchMainController()
        navigationController?.pushViewController(search, animated: true)
    }
    
    
    private func refreshSeriesData() {
        loadSerialData()
        NicooErrorView.removeErrorMeesageFrom(view)
        XSProgressHUD.showCustomAnimation(msg: "获取中...", onView: view, imageNames: nil, bgColor: nil, animated: false)
        viewModel.loadSerialVideoListData()
    }
    
    override func loadFirstPage() {
        viewModel.loadSerialVideoListData()
    }
    
    override func loadNextPage() {
        viewModel.loadNextPage()
    }
    
    private func endRefreshing() {
        loadMoreView.endRefreshing()
        refreshView.endRefreshing()
    }
    
    private func loadSerialData() {
        viewModel.successHandler = { [weak self] (specialSerialListModel, pageNumber) in
            guard let strongSelf = self else { return }
            if let dataSource = specialSerialListModel.data {
                if pageNumber == 1 {
                    strongSelf.dataSource = dataSource
                    if dataSource.count == 0 {
                        NicooErrorView.showErrorMessage(.noData, on: strongSelf.view, topMargin: safeAreaTopHeight + 10, clickHandler: nil)
                    }
                } else {
                    strongSelf.dataSource.append(contentsOf: dataSource)
                }
                strongSelf.currentPage = pageNumber
                strongSelf.collectionView.reloadData()
                strongSelf.endRefreshing()
                strongSelf.loadMoreView.isHidden = dataSource.count < SpecialSerialApi.kDefaultCount
                XSProgressHUD.hide(for: strongSelf.view, animated: true)
            }
        }
        
        viewModel.failureHandler = { [weak self] errorMsg in
            guard let strongSelf = self else { return }
            if strongSelf.currentPage == 0 {
                NicooErrorView.showErrorMessage(.noData, on: strongSelf.view, clickHandler: {
                    strongSelf.refreshSeriesData()
                })
            }
            XSProgressHUD.hide(for: strongSelf.view, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension SeriesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeriesCollectionCell.cellId, for: indexPath) as! SeriesCollectionCell
        let model: SpecialSerialModel = self.dataSource[indexPath.item]
        cell.setModel(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let seriesDetailVC = SeriesDetailViewControlller()
        seriesDetailVC.model = self.dataSource[indexPath.item]
        self.navigationController?.pushViewController(seriesDetailVC, animated: true)
    }
}

extension SeriesViewController {
    private func layoutPageSubViews() {
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
        }
    }
}
