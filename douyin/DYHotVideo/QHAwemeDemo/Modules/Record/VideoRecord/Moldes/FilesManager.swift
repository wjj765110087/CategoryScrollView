//
//  FileManager.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/4/24.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import Foundation

class FilesManager: NSObject {
    
    class var recordSavePath: String {
        get {
            let tempath = NSTemporaryDirectory() + "videoFolder"
            return tempath
        }
    }
    
    /// 录制文件夹大小
    class func filesSizeOfRecorded() -> CGFloat {
        return folderSize(filePath: recordSavePath)
    }
    
    /// 删除录制临时文件
    class func deleteAllRecordFile() {
        let fm = FileManager.default
        let exist = fm.fileExists(atPath: recordSavePath)
        if exist {
            do {
                try fm.removeItem(at: URL(fileURLWithPath: recordSavePath))
            } catch let error as NSError {
                DLog(error.localizedDescription)
            }
        }
    }
    
    //遍历文件夹，返回多少M
    class func folderSize(filePath: String) -> CGFloat {
        let folderPath = filePath as NSString
        let manager = FileManager.default
        if manager.fileExists(atPath: filePath) {
            let childFilesEnumerator = manager.enumerator(atPath: filePath)
            var fileName = ""
            var folderSize: UInt64 = 0
            while childFilesEnumerator?.nextObject() != nil {
                if let file = childFilesEnumerator?.nextObject() as? String, !file.isEmpty {
                    fileName = file
                    let fileAbsolutePath = folderPath.strings(byAppendingPaths: [fileName])
                    folderSize += fileSize(filePath: fileAbsolutePath[0])
                }
            }
            return CGFloat(folderSize) / (1024.0 * 1024.0)
        }
        return 0
    }
    
    //计算单个文件的大小
    class func fileSize(filePath: String) -> UInt64 {
        let manager = FileManager.default
        if manager.fileExists(atPath: filePath) {
            do {
                let attr = try manager.attributesOfItem(atPath: filePath)
                let size = attr[FileAttributeKey.size] as! UInt64
                return size
            } catch  {
                DLog("error :\(error)")
                return 0
            }
        }
        return 0
    }
    
    // 清除缓存
    class func clearCache() {
        let cachPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
        guard let files = FileManager.default.subpaths(atPath: cachPath as String) else { return }
        DLog("filesPathOfCache = \(files)")
        for p in files {
//            let path = cachPath.appendingPathComponent(p)
//            if FileManager.default.fileExists(atPath: path) {
//                do {
//                    try FileManager.default.removeItem(atPath: path)
//                } catch {
//                    DLog("error:\(error)")
//                }
//            }
        }
    }
    
}
