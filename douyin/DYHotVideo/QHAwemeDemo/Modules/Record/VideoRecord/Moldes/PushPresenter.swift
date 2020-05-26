//
//  PushPresenter.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/5/3.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import UIKit
import Alamofire
import NicooNetwork

/// 视频上传状态
///
/// - waitForUpload: 视频等待上传
/// - videoUploading: 视频上传中...
/// - videoUploadFailed: 视频上传失败
/// - imageUploading: 封面图上传中...
/// - imageUploadFailed: 封面图上传失败
/// - commitFailed: 提交失败
/// - videoChecking: 提交成功之后，视频进入审核状态 （下一次拉去列表这个状态应该有后台数据 控制）
enum VideoPushStatu: Int {
    case waitForUpload = 0
    case videoUploading = 1
    case videoUploadFailed = 2
    case imageUploading = 3
    case imageUploadFailed = 4
    case commitFailed = 5
    case videoChecking = 6
}

/// 上传类型
///
/// - pushTypeCheck: 资质审核
/// - pushTypeWorks: 上传作品
enum VideoPushType: Int {
    case pushTypeCheck = 0
    case pushTypeWorks
}

class PushPresenter: NSObject {

    /// 封面图上传Api
    private lazy var imageUpLoad: UploadImageTool = {
        let upload = UploadImageTool()
        upload.delegate = self
        return upload
    }()
    /// 视频上传Api
    private lazy var videoUpLoad: UploadVideoTool = {
        let upload = UploadVideoTool()
        upload.delegate = self
        return upload
    }()
    /// 上传提交Api
    private lazy var pushUpApi: PushVideoApi = {
        let pushApi = PushVideoApi()
        pushApi.paramSource = self
        pushApi.delegate = self
        return pushApi
    }()
    /// 上传资质审核
    private lazy var applyCheckApi: ApplyCheckApi = {
        let api = ApplyCheckApi()
        api.paramSource = self
        api.delegate = self
        return api
    }()
    var videoPushStatu: VideoPushStatu = .waitForUpload
    var videoPushType: VideoPushType = .pushTypeWorks
    
    /// 上传所需资源，参数
    var pushModel = PushVideoModel()
    var videoProgress: Double = 0.0
    
    /// 视频上传进度回调
    var videoUploadProgressHandler:((_ progress: Double) -> Void)?
    /// 视频上传成功
    var videoUploadSucceedHandler:(() -> Void)?
    /// 视频上传失败
    var videoUploadFailedHandler:((_ errorMsg: String) -> Void)?
    
    /// 图片上传成功
    var imageUploadSucceedHandler:(() -> Void)?
    /// 图片上传失败
    var imageUploadFailedHandler:((_ errorMsg: String) -> Void)?
    
    /// 提交成功
    var commitUploadSucceedHandler:(() -> Void)?
    /// 提交失败
    var commitUploadFailedHandler:((_ errorMsg: String) -> Void)?
 
}

// MARK: - Open func
extension PushPresenter {
    
    /// 上传视频封面
    func uploadVideoCover() {
        videoPushStatu = .imageUploading
        imageUpLoad.upload(pushModel.videoCover)
    }
    
    /// 上传视频
    func uploadVideo() {
        videoPushStatu = .videoUploading
        videoUpLoad.upload(pushModel.videoUrl)
    }
    
    /// 资源上传完，提交
    func commitForPush() {
        if videoPushType == .pushTypeCheck {
            let _ = applyCheckApi.loadData()
        } else {
            let _ = pushUpApi.loadData()
        }
    }
    
    /// 上传失败时，存本地
    func saveUploadTask() {
        guard let tasks = UploadTask.shareTask().tasks else { return }
        if tasks.count == 0 { return }
        let image = UIImage(cgImage: (pushModel.videoCover!.cgImage!), scale: pushModel.videoCover!.scale,
                            orientation: pushModel.videoCover!.imageOrientation)
        let taskImage = NSKeyedArchiver.archivedData(withRootObject: image)
        UserDefaults.standard.set(pushModel.commitParams, forKey: UserDefaults.kUploadTaskParams)
        UserDefaults.standard.setValue(taskImage, forKey: UserDefaults.kUploadTaskImage)
        let taskData = NSKeyedArchiver.archivedData(withRootObject: image)
        UserDefaults.standard.set(taskData, forKey: UserDefaults.kUploadTaskImage)
        UserDefaults.standard.set(videoPushStatu.rawValue, forKey: UserDefaults.kUploadTaskStatu)
    }
}

// MARK: - UploadImageDelegate
extension PushPresenter: UploadImageDelegate {
    
    func paramsForAPI(_ uploadImageTool: UploadImageTool) -> [String : String]? {
        return nil
    }
    
    func uploadImageMethod(_ uploadImageTool: UploadImageTool) -> String {
        return "/\(ConstValue.kApiVersion)/video/cover/upload"
    }
    
    func uploadImageSuccess(_ uploadImageTool: UploadImageTool, resultDic: [String : Any]?) {
        var paramsStep2 = [String: Any]()
        if let imageFileName = resultDic?["result"] as? String, var params = pushModel.commitParams {
            params[PushVideoApi.kCoverName] = imageFileName
            paramsStep2 = params
        }
        pushModel.commitParams = paramsStep2
        ///  图片上传成功回调
        imageUploadSucceedHandler?()
        /// 这里吊用提交接口
        commitForPush()
    }
    
    func uploadImageFailed(_ uploadImageTool: UploadImageTool, errorMessage: String?) {
        videoPushStatu = .imageUploadFailed
        if videoPushType == .pushTypeWorks {
            saveUploadTask()
        }
        imageUploadFailedHandler?(errorMessage ?? "封面图上传失败！")
    }
    
    func base64Encoding(plainString: String) -> String {
        let plainData = plainString.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        return base64String!
    }
   
    
}

// MARK: - UploadVideoDelegate
extension PushPresenter: UploadVideoDelegate {
    
    func uploadVideoMethod(_ uploadVideoTool: UploadVideoTool) -> String {
        guard let token = UserModel.share().userInfo?.api_token else {
            return ""
        }
        let dateNow = Date()
        let timeInterval: TimeInterval = dateNow.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        let platform = "I"
        let stringSet = token.aes128EncryptString(withKey: UploadVideoTool.secret) as String
        let signString = String(format: "%@%d%@%@", platform, timeStamp, UploadVideoTool.secret, stringSet)
        let sign = (signString.md5()?.uppercased() ?? "") as String
        //DLog("token == \(token) == tokenSert = \(String(describing: stringSet.urlEncodedForLink()))")
        return "/upload?platform=\(platform)&timestamp=\(timeStamp)&sign=\(sign)&nonce=\(stringSet.urlEncodedForLink())"
       
    }
    
    func uploadVideoSuccess(_ uploadVideoTool: UploadVideoTool, resultDic: [String : Any]?) {
        var paramsStep1 = [String: Any]()
        if let videoFileInfo = resultDic?["result"] as? [String: String], var params = pushModel.commitParams {
            params[PushVideoApi.kFile_name] = videoFileInfo["file_name"]
            params[PushVideoApi.kFile_path] = videoFileInfo["file_path"]
            paramsStep1 = params
        }
        pushModel.commitParams = paramsStep1
        /// 视频上传成功回调
        videoUploadSucceedHandler?()
        /// 上传图片
        uploadVideoCover()
    }
    
    func uploadVideoProgress(_ progress: Double) {
        videoProgress = progress
        videoUploadProgressHandler?(progress)
    }
    
    func uploadVideoFailed(_ uploadVideoTool: UploadVideoTool, errorMessage: String?) {
        videoPushStatu = .videoUploadFailed
        if videoPushType == .pushTypeWorks {
            saveUploadTask()
        }
        videoUploadFailedHandler?(errorMessage ?? "视频上传失败！")
    }
    
}

// MARK: - NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate
extension PushPresenter: NicooAPIManagerParamSourceDelegate, NicooAPIManagerCallbackDelegate {
    
    func paramsForAPI(_ manager: NicooBaseAPIManager) -> [String : Any]? {
        var params = pushModel.commitParams
        if params?[PushVideoController.kLocalTaskTalkTitle] != nil {
            params?.removeValue(forKey: PushVideoController.kLocalTaskTalkTitle)
        }
        if params?[PushVideoController.kLocalTaskTitles] != nil {
            params?.removeValue(forKey: PushVideoController.kLocalTaskTitles)
        }
        return params
    }
    
    func managerCallAPISuccess(_ manager: NicooBaseAPIManager) {
        if manager is PushVideoApi || manager is ApplyCheckApi {
            videoPushStatu = .videoChecking
            commitUploadSucceedHandler?()
        }
    }
    
    func managerCallAPIFailed(_ manager: NicooBaseAPIManager) {
        if manager is PushVideoApi || manager is ApplyCheckApi {
            videoPushStatu = .commitFailed
            if videoPushType == .pushTypeWorks {
                saveUploadTask()
            }
            commitUploadFailedHandler?(manager.errorMessage)
        }
    }
}

