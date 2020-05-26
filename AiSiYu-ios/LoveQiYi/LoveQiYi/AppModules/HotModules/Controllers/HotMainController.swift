//
//  HotMainController.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/26.
//  Copyright © 2019年 bingdaohuoshan. All rights reserved.
//

import UIKit

class HotMainController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private lazy var pageView: PageItemView = {
        let view = PageItemView(frame: CGRect(x: 25, y: 0, width: screenWidth - 50, height: 44))
        view.isAverageScreen = true
        view.titles = ["最新", "最热"]
        return view
    }()
    private lazy var layoutFlow: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        return layout
    }()
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: self.view.bounds, collectionViewLayout: layoutFlow)
        collection.delegate = self
        collection.dataSource = self
        collection.allowsSelection = false
        collection.isPagingEnabled = true
        collection.backgroundColor = UIColor.clear
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        
        return collection
    }()
    
    private lazy var controllers: [UIViewController] = {
        let new = HotViewController()
        new.sort = HotListApi.kSort_new
        let hot = HotViewController()
        hot.sort = HotListApi.kSort_hot
        return [new, hot]
    }()
    
    var currentIndex: Int = 0
    
    var scrollToIndex:((_ index: Int) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        view.backgroundColor = kBarColor
        navigationController?.navigationBar.addSubview(pageView)
        //navigationController?.navigationBar.addSubview(muneBtn)
        layoutPageView()
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        view.backgroundColor = UIColor.white
        view.addSubview(collectionView)
        layoutPageSubviews()
        
        pageView.itemClickHandler = { [weak self] (index) in
            guard let strongSelf = self else { return }
            strongSelf.clickItemToScroll(index)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func clickItemToScroll(_ index: Int) {
        currentIndex = index
        collectionView.scrollToItem(at: IndexPath(row: currentIndex, section: 0), at: .left, animated: true)
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension HotMainController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cellForRow(with: indexPath)
        return cell
    }
    
    /// 配置cell
    func cellForRow(with indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = "\(VCCollectionCell.cellId)\(indexPath.item)"
        collectionView.register(VCCollectionCell.classForCoder(), forCellWithReuseIdentifier: cellId)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! VCCollectionCell
        cell.setVCView(controllers[indexPath.item].view)
        return cell
    }
}

// MARK: - UIScrollViewDelegate
extension HotMainController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        DispatchQueue.main.async {
            let translatedPoint = scrollView.panGestureRecognizer.translation(in: scrollView)
            scrollView.panGestureRecognizer.isEnabled = false
            
            if translatedPoint.x < -60 && self.currentIndex < (self.controllers.count - 1) {
                self.currentIndex += 1
            }
            if translatedPoint.x > 60 && self.currentIndex > 0 {
                self.currentIndex -= 1
            }
            let indexPath = IndexPath(row: self.currentIndex, section: 0)
            UIView.animate(withDuration: 0.13, delay: 0.0, options: .curveEaseOut, animations: {
                self.collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
                self.pageView.scrollTopIndex(indexPath.item)
            }, completion: { finished in
                scrollView.panGestureRecognizer.isEnabled = true
            })
        }
    }
}


// MARK: - Layout
private extension HotMainController {
    
    func layoutPageSubviews() {
        layoutCollectionScroll()
    }
    
    func layoutCollectionScroll() {
        collectionView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
            } else {
                make.edges.equalToSuperview()
            }
        }
    }
    func layoutPageView() {
        pageView.snp.makeConstraints { (make) in
            make.leading.equalTo(25)
            make.trailing.equalTo(-25)
            make.top.equalTo(0)
            make.height.equalTo(44)
        }
        // layoutMuneButton()
    }
}
