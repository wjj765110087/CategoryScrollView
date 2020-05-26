//
//  MainLineController.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/4/22.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import NicooNetwork

struct LineModel {
    var videoChannel: VideoChannelModel?
    var isSelected: Bool = false
}

class MainLineController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: view.bounds, style: .plain)
        table.backgroundColor = UIColor.white
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView.init(frame: CGRect.zero)
        table.register(MainLineChoseCell.classForCoder(), forCellReuseIdentifier: MainLineChoseCell.cellId)
        table.layer.cornerRadius = 6
        table.layer.masksToBounds = true
        return table
    }()
    private let arrowImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "mainLineArrow_S")
        image.isHidden = true
        return image
    }()
    
    private lazy var channelSaveApi: VideoChannelSaveApi = {
        let api = VideoChannelSaveApi()
        api.delegate = self
        api.paramSource = self
        return api
    }()
    
    var dissMisssCallBack:(() -> Void)?
    var successCallBack:(() -> Void)?
    var lines = [LineModel]()
    var currentIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(arrowImage)
        view.addSubview(tableView)
        layoutPageSubviews()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dissMisssCallBack?()
        dismiss(animated: false, completion: nil)
    }

}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension MainLineController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainLineChoseCell.cellId, for: indexPath) as! MainLineChoseCell
        let model = lines[indexPath.row]
        cell.nameLable.text = model.videoChannel?.title ?? ""
        cell.selectedBtn.isSelected = model.isSelected
        cell.selectionStyle = .default
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if currentIndex != indexPath.row {
            lines[currentIndex].isSelected = false
            lines[indexPath.row].isSelected = true
            currentIndex = indexPath.row
            _ = channelSaveApi.loadData()
        }
    }
    
}

// MARK: - NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate
extension MainLineController: NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        XSProgressHUD.showCustomAnimation(msg: nil, onView: view, imageNames: nil, bgColor: nil, animated: false)
        return [VideoChannelSaveApi.kKey: lines[currentIndex].videoChannel?.key ?? ""]
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is VideoChannelSaveApi {
            UserModel.share().userInfo?.channel = lines[currentIndex].videoChannel
            tableView.reloadData()
            successCallBack?()
            dismiss(animated: false, completion: nil)
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        XSProgressHUD.hide(for: view, animated: false)
        if manager is VideoChannelSaveApi {
            XSAlert.show(type: .error, text: "线路切换失败，请稍后再试！")
            dissMisssCallBack?()
            dismiss(animated: false, completion: nil)
        }
    }
    
}


// MARK: - layout
private extension MainLineController {
    
    func layoutPageSubviews() {
        layoutArrowView()
        layoutTableView()
    }
    
    func layoutArrowView() {
        arrowImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(12)
            make.width.equalTo(16)
            make.top.equalTo(ConstValue.kStatusBarHeight + 38)
        }
    }
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(lines.count * 50)
            make.width.equalTo(screenWidth - 60)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
}
