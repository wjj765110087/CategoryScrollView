//
//  SeriesDetailViewControlller.swift
//  LoveQiYi
//
//  Created by mac on 2019/7/18.
//  Copyright © 2019 bingdaohuoshan. All rights reserved.
//

import UIKit

fileprivate let topInset: CGFloat = (screenHeight >= 812.0 && UIDevice.current.model == "iPhone" ? 44 : 20)
fileprivate let bottomInset: CGFloat = (screenHeight >= 812.0 && UIDevice.current.model == "iPhone" ? 34 : 50)

fileprivate let imageHeight: CGFloat = 168

class SeriesDetailViewControlller: BaseViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private lazy var cycleView: CyclePageView = {
        let view = CyclePageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: imageHeight + topInset), config: config)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var shadowImageView: UIImageView = {
       let imageView = UIImageView()
       imageView.frame = CGRect.init(x: 0, y: imageHeight + topInset, width: screenWidth, height: 40)
       imageView.image = UIImage(named: "shadow")
       return imageView
    }()
    
    private lazy var backButton: UIButton = {
       let button = UIButton(type: .custom)
       button.setImage(UIImage(named: ""), for:  .normal)
       button.addTarget(self, action: #selector(didClickBackButton), for:.touchUpInside)
       return button
        
    }()
    
    private var  config: CyclePageConfig = {
       let config = CyclePageConfig()
       config.animationType = .curlUp
       return config
    }()
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = SeriesDetailItemCell.itemSize
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets.init(top: 8, left: 10, bottom: 8, right: 10)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let rect: CGRect = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        let collection = UICollectionView(frame: rect, collectionViewLayout: flowLayout)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.white
        collection.allowsSelection = true
        collection.showsVerticalScrollIndicator = false
        collection.register(SeriesDetailItemCell.classForCoder(), forCellWithReuseIdentifier: SeriesDetailItemCell.cellId)
        
        let nib = UINib(nibName: CollectionSectionHeaderView.resuseId, bundle: Bundle.main)
        collection.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionSectionHeaderView.resuseId)
       // collection.mj_header = refreshView
        collection.mj_footer = loadMoreView
        return collection
        
    }()
    
    ///接收从精选系列传过来的model
    var model: SpecialSerialModel = SpecialSerialModel()
    
    /// viewModel
    private let viewModel: SpecialSeriesViewModel = SpecialSeriesViewModel()
    
    ///数据源
    var dataSource: [VideoModel] = [VideoModel]()
    
    var currentPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: true)

        layoutPageView()
        if let imageName = model.cover_oss_filename {
            cycleView.setImages([imageName])
        }
        navConfig()
        
        collectionView.contentInset = UIEdgeInsets(top: imageHeight + topInset , left: 0, bottom: bottomInset, right: 0)
       
        loadSerialData()
    }
    
    func navConfig() {
        navBar.backgroundColor = UIColor.clear
        navBar.lineView.backgroundColor = UIColor.clear
        navBar.backButton.backgroundColor = UIColor(white: 0, alpha: 0.5)
        navBar.backButton.layer.cornerRadius = 17
        navBar.backButton.layer.masksToBounds = true
        view.bringSubviewToFront(navBar)
    }
    
    func loadSerialData() {
        loadVideoListDataCallBack()
        NicooErrorView.removeErrorMeesageFrom(view)
        XSProgressHUD.showCustomAnimation(msg: "获取中...", onView: view, imageNames: nil, bgColor: nil, animated: false)
        viewModel.loadSeriesVideoListData([VideoListApi.kSpecial_id: model.id ?? 0])
    }
    
    override func loadFirstPage() {
        viewModel.loadSeriesVideoListData([VideoListApi.kSpecial_id: model.id ?? 0])
    }
    
    override func loadNextPage() {
        viewModel.loadSeriesVideoListNextPage()
    }
    
    func endRefreshing() {
        refreshView.endRefreshing()
        loadMoreView.endRefreshing()
    }
    
    private func loadVideoListDataCallBack() {
        viewModel.seriesDetailListSuccessHandler = { [weak self] (videoList, pageNumber) in
            guard  let strongSelf = self else { return }
            if let dataList = videoList.data {
                if pageNumber == 1 {
                    strongSelf.dataSource = dataList
                    if dataList.count == 0 {
                        //加载无数据占位
                        NicooErrorView.showErrorMessage(.noData, on: strongSelf.view, topMargin: safeAreaTopHeight + imageHeight + 90, clickHandler: nil)
                    }
                } else {
                    strongSelf.dataSource.append(contentsOf: dataList)
                }
                strongSelf.currentPage = pageNumber
                strongSelf.loadMoreView.isHidden = (dataList.count < VideoListApi.kDefaultCount)
                strongSelf.collectionView.reloadData()
                strongSelf.endRefreshing()
                XSProgressHUD.hide(for: strongSelf.view, animated: false)
            }
        }
        viewModel.seriesDetailListFailureHandler = { [weak self] (errorMsg) in
            guard  let strongSelf = self else { return }
            XSProgressHUD.hide(for: strongSelf.view, animated: false)
            if strongSelf.currentPage == 0 {
                NicooErrorView.showErrorMessage(.noNetwork, on: strongSelf.view , topMargin: safeAreaTopHeight + imageHeight + 90, clickHandler: {
                    strongSelf.loadSerialData()
                })
            }
        }
    }
    
    @objc func didClickBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SeriesDetailViewControlller: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeriesDetailItemCell.cellId, for: indexPath) as! SeriesDetailItemCell
        cell.setModel(self.dataSource[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let videoPlayVC = VideoDetailViewController()
        videoPlayVC.model = self.dataSource[indexPath.item]
        self.navigationController?.pushViewController(videoPlayVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SeriesDetailViewControlller: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: screenWidth, height: 70)
        
    }
    
    /// 组头组尾
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reuseableView: UICollectionReusableView?
        if kind == UICollectionView.elementKindSectionHeader {
            let seriesHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CollectionSectionHeaderView.resuseId, for: indexPath) as! CollectionSectionHeaderView
            reuseableView = seriesHeaderView
            seriesHeaderView.setModel(model: self.model)
        }
        return reuseableView!
    }
}

// MARK: - UIScrollViewDelegate
extension SeriesDetailViewControlller: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        var frame = self.cycleView.frame
       
        //print("offsetY = \(offsetY)")
        // imageHeight + topInset == 164 或者 140
        if offsetY <= -(imageHeight + topInset) {
            frame.origin.y = 0 // 这句代码一定要加  不然会出点问题
            frame.size.height =  -offsetY
            navBar.isHidden = false
            navBar.backgroundColor = UIColor.clear
            navBar.titleLabel.text = ""
        } else {
            frame.origin.y = -(imageHeight + topInset + offsetY)
            frame.size.height = (screenHeight >= 812.0) ? imageHeight + topInset : imageHeight
            if offsetY >= -safeAreaTopHeight {
                let alpha = (offsetY + safeAreaTopHeight) / CGFloat(safeAreaTopHeight)
                navBar.isHidden = false
                navBar.backgroundColor = UIColor(red: 47/255.0, green: 47/255.0, blue: 49/255.0, alpha: alpha > 0.99 ? 0.99 : alpha)
                navBar.titleLabel.text = "系列详情"
            }
        }
        self.cycleView.frame = frame
        shadowImageView.frame = CGRect(x: 0, y: frame.maxY - 40, width: screenWidth, height: 40)
    }
}

// MARK: - Layout
extension SeriesDetailViewControlller {
    private func layoutPageView() {
        view.addSubview(collectionView)
        view.addSubview(cycleView)
        view.addSubview(shadowImageView)
        cycleView.addSubview(backButton)
        
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(37)
            make.top.equalTo(26)
            make.size.equalTo(CGSize(width: 28.5, height: 28.5))
        }
    }
}
