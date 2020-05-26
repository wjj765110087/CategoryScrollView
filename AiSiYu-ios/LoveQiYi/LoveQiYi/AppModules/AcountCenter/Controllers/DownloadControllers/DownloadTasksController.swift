//
//  DownloadTasksController.swift
//  XSVideo
//
//  Created by pro5 on 2019/2/18.
//  Copyright © 2019年 pro5. All rights reserved.
//

import UIKit

/// 下载任务列表
class DownloadTasksController: BaseViewController {
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: view.bounds, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView()
        table.separatorStyle = .none
        table.register(DownloadTaskListCell.classForCoder(), forCellReuseIdentifier: DownloadTaskListCell.cellId)
        table.register(UINib(nibName: "CollectedVideoCell", bundle: Bundle.main), forCellReuseIdentifier: CollectedVideoCell.cellId)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        layoutPageSubviews()
        navConfig()
        DownLoadMannager.share().delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DownLoadMannager.share().saveDownloadTaskToLocal()
        
    }
    
    private func navConfig() {
        navBar.titleLabel.text = DownLoadMannager.share().yagors.count == 0 ? "我的下载" : String(format: "%@ (%d)", "我的下载", DownLoadMannager.share().yagors.count)
        view.bringSubviewToFront(navBar)
    }
    
    /// 1.删除本地文件。 2.删除数据源。 3.删除本地数据库表。 （删除本地文件时，需要根据数据源来删除，所以 1、2 顺序不能互换）
    private func deleteFileAndTask(indexPath: IndexPath) {
        let yagor = DownLoadMannager.share().yagors[indexPath.row]
        yagor.cancelDownloadSegment() //取消下载
        // 1. 删除任务本地文件
        yagor.deleteDownloadedContents(with: DownLoadMannager.share().yagors[indexPath.row].directoryName)
        
        // 3. 下载表存在,删除对应ID的本地数据库数据
        let store = XSKeyValueStore(dbWithName: ConstValue.kXSVideoLocalDBName)
        if store.isTableExists(ConstValue.kVideoDownLoadListTable) {
            store.deleteObject(byId: DownLoadMannager.share().videoDownloadModels[indexPath.row].videoDownLoadUrl!.md5(), fromTable: ConstValue.kVideoDownLoadListTable)
        }
        // 2. 从任务管理器中移除任务
        DownLoadMannager.share().yagors.remove(at: indexPath.row)
        DownLoadMannager.share().videoDownloadModels.remove(at: indexPath.row)
        let downLoadings =  DownLoadMannager.share().yagorsDownloading.filter { (item) -> Bool in
            return item.directoryName != yagor.directoryName
        }
        DownLoadMannager.share().yagorsDownloading = downLoadings
        navBar.titleLabel.text = DownLoadMannager.share().yagors.count == 0 ? "我的下载" : String(format: "%@ (%d)", "我的下载", DownLoadMannager.share().yagors.count)
        tableView.reloadData()
        // 删除本地数据库 id
        if var itemIds = UserDefaults.standard.object(forKey: UserDefaults.kDownloadIds) as? [String], itemIds.count > indexPath.row {
            itemIds.remove(at: indexPath.row)
            UserDefaults.standard.set(itemIds, forKey: UserDefaults.kDownloadIds)
        }
    }
    
}

// MARK: - YagorDelegate
extension DownloadTasksController: DownloadManagerDelegate {
    
    func videoDownloadSucceeded(by yagor: NicooYagor) {
        let filePath = NicooDownLoadHelper.getDocumentsDirectory().appendingPathComponent(NicooDownLoadHelper.downloadFile)
        print("downLoadFilePath = \(filePath). videoFileName = \(yagor.directoryName)")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func videoDownloadFailed(by yagor: NicooYagor) {
        print("Video download failed. \(yagor.directoryName)")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func videoDownloadUpdate(progress: Float, yagor: NicooYagor) {
        DispatchQueue.main.async {
            let index = DownLoadMannager.share().yagors.firstIndex(where: { (item) -> Bool in
                return item.directoryName == yagor.directoryName
            })
            if index != nil {
                if let cell = self.tableView.cellForRow(at: IndexPath(item: index!, section: 0)) as? DownloadTaskListCell {
                    cell.progressView.progress = yagor.progress
                    cell.percentageLable.text = String(format: "%.2f %@", yagor.progress * 100, "%")
                    cell.statuButton.setTitle("暂停", for: .normal)
                }
            }
        }
    }
    
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension DownloadTasksController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170 * 9/16 + 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DownLoadMannager.share().yagors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let yagor = DownLoadMannager.share().yagors[indexPath.row]
        let videoModel = DownLoadMannager.share().videoDownloadModels[indexPath.row]
        
        if yagor.downloader.downloadStatus == .finished || yagor.progress == 1.0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CollectedVideoCell.cellId, for: indexPath) as! CollectedVideoCell
            cell.setLocalVideoModel(videoModel)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DownloadTaskListCell.cellId, for: indexPath) as! DownloadTaskListCell
            cell.setLocalVideoModel(videoModel)
            if yagor.progress > 0 {
                cell.percentageLable.text = String(format: "%.2f %@", yagor.progress * 100, "%")
                cell.progressView.progress = yagor.progress
                cell.statuButton.isEnabled = true
                if yagor.downloader.downloadStatus == .paused {
                    cell.statuButton.setTitle("开始", for: .normal)
                } else if yagor.downloader.downloadStatus == .started {
                    cell.statuButton.setTitle("暂停", for: .normal)
                } else if yagor.downloader.downloadStatus == .failed {
                    cell.percentageLable.text = "下载失败"
                    cell.statuButton.setTitle("重新下载", for: .normal)
                } else if yagor.downloader.downloadStatus == .canceled {
                    cell.statuButton.setTitle("继续下载", for: .normal)
                } else if yagor.downloader.downloadStatus == .finished {
                    
                }
//                if yagor.progress == 1.0 {
//                    cell.statuButton.setTitle("下载完成", for: .normal)
//                    cell.statuButton.isEnabled = false
//                }
            }
            cell.downLoadStatuButtonClick = { (sender) in
                if yagor.downloader.downloadStatus == .paused {
                    yagor.resumeDownloadSegment()
                    cell.statuButton.setTitle("暂停", for: .normal)
                } else if yagor.downloader.downloadStatus == .started {
                    yagor.pauseDownloadSegment()
                    cell.statuButton.setTitle("开始", for: .normal)
                } else if yagor.downloader.downloadStatus == .failed {
                    yagor.parse()
                    cell.statuButton.setTitle("暂停", for: .normal)
                    cell.percentageLable.text = String(format: "%.2f %@", yagor.progress * 100, "%")
                } else if yagor.downloader.downloadStatus == .canceled {
                    yagor.parse()
                    cell.statuButton.setTitle("暂停", for: .normal)
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.setEditing(true, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style:.default, title: "删除") { [weak self] (action, index) in
            print("deleted")
            guard let strongSelf = self else { return }
            strongSelf.deleteFileAndTask(indexPath: indexPath)
        }
        deleteAction.backgroundColor = UIColor.red
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let videoModel = DownLoadMannager.share().videoDownloadModels[indexPath.row]
        let localPlayVC = LocalVideoPlayerController()
        if let vModel = decoderVideoModel(videoModel.videoModelString) {
            localPlayVC.dire = vModel.title ?? ""
        }
        localPlayVC.videoName = videoModel.videoDirectory ?? ""
        navigationController?.pushViewController(localPlayVC, animated: true)
    }
    
    func decoderVideoModel(_ string: String?) -> VideoModel? {
        if string == nil || string!.isEmpty { return nil }
        if let data = string!.data(using: .utf8, allowLossyConversion: false) {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let videoModel = try? decoder.decode(VideoModel.self, from: data)
            return videoModel
        }
        return nil
    }
    
    
    //    // 每个cell中的状态更新，应该在willDisplay中执行
    //    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //        let yagor = yagorList[indexPath.row]
    //
    //        configTask(yagor: yagor, cell: cell as! DownloadTaskListCell, visible: true)
    //    }
    //
    //    // 由于cell是循环利用的，不在可视范围内的cell，不应该去更新cell的状态
    //    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //       let yagor = yagorList[indexPath.row]
    //
    //        configTask(yagor: yagor, cell: cell as! DownloadTaskListCell, visible: false)
    //    }
    //
    //    /// 单个任务下载完成或者其他
    //    func configTask(yagor: NicooYagor, cell: DownloadTaskListCell, visible: Bool) {
    //        cell.percentageLable.text = "\(yagor.progress * 100) %"
    //        cell.progressView.progress = yagor.progress
    //        if yagor.downloader.downloadStatus == .paused {
    //            yagor.resumeDownloadSegment()
    //            cell.statuButton.setTitle("暂停", for: .normal)
    //        } else if yagor.downloader.downloadStatus == .started {
    //            yagor.pauseDownloadSegment()
    //            cell.statuButton.setTitle("开始", for: .normal)
    //        } else if yagor.downloader.downloadStatus == .finished {
    //            cell.statuButton.setTitle("完成", for: .normal)
    //        }
    //    }
    
}


// MARK: - Layout
private extension DownloadTasksController {
    
    func layoutPageSubviews() {
        layoutTableView()
    }
    
    func layoutTableView() {
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(navBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }
    
}
