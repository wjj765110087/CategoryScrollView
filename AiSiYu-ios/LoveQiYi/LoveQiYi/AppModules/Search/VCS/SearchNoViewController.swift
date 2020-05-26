//
//  SearchNoViewController.swift
//  DouCartoonDemo
//
//  Created by mac on 2019/6/6.
//  Copyright © 2019年 mac. All rights reserved.
//

import UIKit

class SearchNoViewController: UIViewController {

    private var searchView: SearchHeader = {
        guard let view = Bundle.main.loadNibNamed("SearchHeader", owner: nil, options: nil)?[0] as? SearchHeader else { return SearchHeader() }
        view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: statusBarHeight + 44)
        return view
    }()
    private lazy var recomentVc: RecomentController = {
        let recomvc = RecomentController()
        recomvc.sectionTitle = "为您推荐更多内容"
        return recomvc
    }()
    
    private var nodateView: NotDataTipsView = {
        let lable = NotDataTipsView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100))
        return lable
    }()
   
    var g_Type: String?
    var comicName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(searchView)
        view.addSubview(nodateView)
        addChild(recomentVc)
        view.addSubview(recomentVc.view)
        layoutpageSubviews()
        searchView.searchTf.text = comicName
        searchView.searchTf.delegate = self
        searchView.cancleAction = { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
}

extension SearchNoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let controllers = navigationController?.viewControllers, controllers.count > 0 {
            for controller in controllers {
                if controller is SearchMainController {
                     self.navigationController?.popToViewController(controller, animated: false)
                }
            }
        }
       
    }
}

private extension SearchNoViewController {
    
    func layoutpageSubviews() {
        layoutNavBar()
        layoutFinishView()
        layoutChildView()

    }
    
    func layoutNavBar() {
        searchView.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(statusBarHeight + 44)
        }
    }
    
    func layoutFinishView() {
        nodateView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(searchView.snp.bottom)
            make.height.equalTo(100)
        }
    }
    
    func layoutChildView() {
        recomentVc.view.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(nodateView.snp.bottom)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
    
}
