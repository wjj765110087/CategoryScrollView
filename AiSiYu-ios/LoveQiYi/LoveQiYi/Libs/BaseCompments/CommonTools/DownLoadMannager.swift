//
//  DownLoadMannager.swift
//  XSVideo
//
//  Created by pro5 on 2019/2/16.
//  Copyright © 2019年 pro5. All rights reserved.
//

import UIKit

/// 下载代理
protocol DownloadManagerDelegate: class {
    func videoDownloadSucceeded(by yagor: NicooYagor)
    
    func videoDownloadFailed(by yagor: NicooYagor)
    
    func videoDownloadUpdate(progress: Float, yagor: NicooYagor)
}

/// 分线程下载单例
class DownLoadMannager: NSObject {
    
    static private let shareManager: DownLoadMannager = DownLoadMannager()
    class func share() -> DownLoadMannager {
        return shareManager
    }
    /// 所有任务
    var yagors = [NicooYagor]()
    /// 正在下载的认为
    var yagorsDownloading = [NicooYagor]()
    var videoDownloadModels = [VideoDownLoad]()
    weak  var delegate: DownloadManagerDelegate?
    
    func downloadViedoWith(_ video: VideoDownLoad) {
        // 少于两个，直接解析下载
        let yagor = NicooYagor()
        yagor.directoryName = video.videoDirectory ?? ""
        yagor.m3u8URL = video.videoDownLoadUrl ?? ""
        yagor.delegate = self
        yagor.parse()
        yagors.insert(yagor, at: 0)
        yagorsDownloading.insert(yagor, at: 0)
        videoDownloadModels.insert(video, at: 0)
        saveDownloadTaskToLocal()
    }
    
    /// 读取数据库下载进度
    func checkDownLoadingTaskCount() {
        DispatchQueue.global().async {
            let store = XSKeyValueStore(dbWithName: ConstValue.kXSVideoLocalDBName)
            guard let itemIds = UserDefaults.standard.object(forKey: UserDefaults.kDownloadIds) as? [String] else {
                return
            }
            if itemIds.count == 0 {
                store.clearTable(ConstValue.kVideoDownLoadListTable)
                return
            }
//            if let allItems = store.getAllItems(fromTable: ConstValue.kVideoDownLoadListTable) as? [XSKeyValueItem] {
//                print("allitems.count = \(allItems.count)")
//                if allItems.count > 0 {
//                    let item = allItems[0]
//                    if let value = item.itemObject as? [String: Any] {
//                        print("item0.value == \(value)")
//                    }
//                }
//            }
            for i in 0 ..< store.getCountFromTable(ConstValue.kVideoDownLoadListTable) {
            
                if let item = store.getObjectById(itemIds[Int(i)], fromTable: ConstValue.kVideoDownLoadListTable) as? [String: Any] {
                    let yagor = NicooYagor()
                    yagor.directoryName = item["videoDirectory"] as! String
                    yagor.delegate = self
                    yagor.m3u8URL = item["downloadUrl"] as! String
                    let progress = item["progress"] as! NSNumber
                    let failed = item["isFailed"] as! NSNumber
                    let isfailed = failed.boolValue
                    yagor.progress = progress.floatValue
                    yagor.downloader.downloadStatus = .finished
                    self.yagors.append(yagor)
                    if progress.floatValue < 1.0 {
                        yagor.downloader.downloadStatus = isfailed ? .failed : .canceled
                        self.yagorsDownloading.append(yagor)
                    }
                    let model = VideoDownLoad.init(videoDirectory: (item["videoDirectory"] as! String), videoDownLoadUrl: (item["downloadUrl"] as! String), videoModelString: (item["videoModel"] as! String))
                    self.videoDownloadModels.append(model)
                }
            }
        }
    }
    
    /// 下载进度存入数据库
    func saveDownloadTaskToLocal() {
        DispatchQueue.global().async {
            var modelIds = [String]()
            for i in 0 ..< self.videoDownloadModels.count {
                let model = self.videoDownloadModels[i]
                let yagor = self.yagors[i]
                if model.videoDownLoadUrl == nil { return }
                let params: [String: Any] = ["videoDirectory": model.videoDirectory ?? "","videoModel": model.videoModelString ?? "" ,"downloadUrl": model.videoDownLoadUrl!, "progress": yagor.progress, "isFailed": yagor.downloader.downloadStatus == .failed ? 1 : 0]
                let store = XSKeyValueStore(dbWithName: ConstValue.kXSVideoLocalDBName)
                if store.isTableExists(ConstValue.kVideoDownLoadListTable) {  // 下载表存在, 直接插入当前下载的数据
                    store.put(params, withId: String(format: "%@", model.videoDownLoadUrl!.md5()), intoTable: ConstValue.kVideoDownLoadListTable)
                } else {  // 不存在，创建一个表， 再存
                    store.createTable(withName: ConstValue.kVideoDownLoadListTable)
                    store.put(params, withId: String(format: "%@", model.videoDownLoadUrl!.md5()), intoTable: ConstValue.kVideoDownLoadListTable)
                }
                modelIds.append(model.videoDownLoadUrl!.md5())
               
            }
             UserDefaults.standard.set(modelIds, forKey: UserDefaults.kDownloadIds)
        }
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

}

// MARK: - YagorDelegate
extension DownLoadMannager: YagorDelegate {
    
    func videoDownloadSucceeded(by yagor: NicooYagor) {
        let downloadTasks = yagorsDownloading.filter { (task) -> Bool in
            return task.directoryName != yagor.directoryName
        }
        yagorsDownloading = downloadTasks
        delegate?.videoDownloadSucceeded(by: yagor)
        saveDownloadTaskToLocal()
    }
    
    func videoDownloadFailed(by yagor: NicooYagor) {
        delegate?.videoDownloadFailed(by: yagor)
        //saveDownloadTaskToLocal()
        let store = XSKeyValueStore(dbWithName: ConstValue.kXSVideoLocalDBName)
        if !store.isTableExists(ConstValue.kVideoDownLoadListTable) { return }
        if var item = store.getObjectById(yagor.m3u8URL.md5(), fromTable: ConstValue.kVideoDownLoadListTable) as? [String: Any]
        {
            item["isFailed"] = 0
            store.put(item, withId: String(format: "%@", yagor.m3u8URL.md5()), intoTable: ConstValue.kVideoDownLoadListTable)
        }
    }
    
    func update(progress: Float, yagor: NicooYagor) {
        print("downloadPress == \(progress)")
        delegate?.videoDownloadUpdate(progress: progress, yagor: yagor)
    }
    
    
}
