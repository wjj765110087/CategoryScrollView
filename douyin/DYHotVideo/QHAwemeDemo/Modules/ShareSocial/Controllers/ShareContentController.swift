//
//  ShareContentController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/10/1.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit

/// 分享弹出页面
class ShareContentController: UIViewController {

    private let shareView: ShareContenView = {
        let view = ShareContenView.init(frame: CGRect.zero)
        return view
    }()
    private lazy var clearTapView: UIButton = {
        let view = UIButton(type: .custom)
        view.backgroundColor = UIColor.clear
        view.addTarget(self, action: #selector(shareComtentViewDissMiss), for: .touchUpInside)
        return view
    }()
    private lazy var  imageVc: ShareImageController = {
        let bigVc = ShareImageController()
       return bigVc
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .overCurrentContext
        self.definesPresentationContext = true
        self.view.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        NotificationCenter.default.addObserver(self, selector: #selector(shareactivityDown), name: Notification.Name.kShareActivityDownNotification, object: nil)
        view.addSubview(shareView)
        view.addSubview(clearTapView)
        layoutoPageSubviews()
       
        shareView.setShareModels(getShareTypeModels())
        shareView.closebtnClickHadnler = { [weak self] in
            UserModel.share().shareText  = nil
            UserModel.share().shareImageLink = nil
            self?.dismiss(animated: false, completion: nil)
        }
        shareView.itemClickHandler = { [weak self] (index) in
            guard let strongSelf = self else { return }
            if index == 0 {
                self?.shareText(ShareContentItemCell.getDefaultContentString())
            } else if index == 1 {
                strongSelf.imageVc.model = self?.getShareTypeModels()[index]
                strongSelf.imageVc.modalPresentationStyle = .fullScreen
                strongSelf.present(strongSelf.imageVc, animated: true, completion: nil)
            } else {
                self?.share()
            }
        }
    }
    
    @objc private func shareactivityDown() {
        UserModel.share().shareText  = nil
        UserModel.share().shareImageLink = nil
        self.dismiss(animated: false, completion: nil)
    }
    @objc private func shareComtentViewDissMiss() {
        UserModel.share().shareText  = nil
        UserModel.share().shareImageLink = nil
        self.dismiss(animated: false, completion: nil)
    }

}

// MARK: - funcs
private extension ShareContentController {
    func getShareTypeModels() -> [ShareTypeItemModel] {
        let shareImageLink = UserModel.share().shareImageLink
        let shareText = UserModel.share().shareText
        let textModel = ShareTypeItemModel.init(title: "分享链接", content:  shareText, imageUrl: nil, type: .text)
        let imageModel = ShareTypeItemModel.init(title: "分享图片", content: shareText, imageUrl: shareImageLink, type: .picture)
      //  let linkModel = ShareTypeItemModel.init(title: "分享链接", content: shareText, imageUrl: nil, type: .textLink)
        return [textModel, imageModel]
    }
}

// MARK: - Layout
private extension ShareContentController {
    func layoutoPageSubviews() {
        layoutShareView()
        layoutClearView()
    }
    func layoutShareView() {
        let height: CGFloat = UIDevice.current.isiPhoneXSeriesDevices() ? 200 : 170
        shareView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(height + screenWidth*4.15/5 )
        }
    }
    func layoutClearView() {
        clearTapView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(shareView.snp.top)
        }
    }
}
