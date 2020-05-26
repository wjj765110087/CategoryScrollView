
import Foundation
import Alamofire

/// 视频上传代理
protocol UploadVideoDelegate: class {
    
    /// 请求method
    func uploadVideoMethod(_ uploadVideoTool: UploadVideoTool) -> String
    
    /// 请求成功回调
    func uploadVideoSuccess(_ uploadVideoTool: UploadVideoTool, resultDic: [String: Any]?)
    /// 回调上传进度
    func uploadVideoProgress(_ progress: Double)
    
    /// 请求失败的回调
    func uploadVideoFailed(_ uploadVideoTool: UploadVideoTool, errorMessage: String?)
    
    /// token失效
    func uploadVideoFailedByTokenError()
    
    // optional
    
    func uploadVideoHTTPMethod() -> HTTPMethod
    
    func baseURLForUploadVideoTool() -> String
    
    func paramsForHeader(_ uploadVideoTool: UploadVideoTool) -> [String: String]?
}

extension UploadVideoDelegate {
    
    func paramsForHeader(_ uploadVideoTool: UploadVideoTool) -> [String: String]? {
        return nil
    }
    
    func baseURLForUploadVideoTool() -> String {
        return AppInfo.share().file_upload_url ?? ""
    }
    
    /// http请求方式
    func uploadVideoHTTPMethod() -> HTTPMethod {
        return .post
    }
    
    func uploadVideoFailedByTokenError() {
        // 发出被挤掉的消息
        NotificationCenter.default.post(name: NSNotification.Name.kUserBeenKickedOutNotification, object: nil)
    }
    
}

/// 视频上传封装
class UploadVideoTool {
    
    static fileprivate let appVersion: String = {
        let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: filePath!)
        return dictionary!["CFBundleShortVersionString"] as! String
    }()
    static let secret = "pb5pe0MXChXsic0N"
    
    private var videoPathURL: URL?
    weak var delegate: UploadVideoDelegate?
    
    func upload(_ videoPath: URL?) {
        self.videoPathURL = videoPath
        request()
    }
    
    private func extraHttpHeadParams() -> [String: String] {
        var param: [String : String] = [:]
        param["version"] = UploadVideoTool.appVersion
        param["Accept"] = "application/json"
        if let token = UserModel.share().userInfo?.api_token {
            param["Authorization"] = "Bearer \(token)"
        }
        return param
    }
    
    private func request() {
        guard let dataPath = self.videoPathURL else { return }
        guard let url = delegate?.uploadVideoMethod(self) else { return }
        let headers = extraHttpHeadParams()
        let upData = NSData.init(contentsOf: dataPath)
        var httpMethod = HTTPMethod.post
        if let method = delegate?.uploadVideoHTTPMethod() {
            httpMethod = method
        }
        let baseURL = delegate?.baseURLForUploadVideoTool()
        let finalURL = "\((baseURL ?? ""))\(url)"
        DLog("finalURL === \(finalURL)")
        Alamofire.upload(multipartFormData: { (MFData) in
            MFData.append(upData! as Data, withName: "file", fileName: "upload.mp4", mimeType: "video/mpeg4")
        }, to: finalURL, method: httpMethod, headers: headers) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _ ):
                upload.responseJSON(completionHandler: { (DResponse) in
                    self.response(DResponse.result.value as? [String : Any] )
                    if DResponse.result.isSuccess {
                        DLog("上传成功！！！")

                    }
                    if DResponse.result.isFailure {
                        DLog("responseJson.error = 视频上传失败，非网络问题!")
                        self.delegate?.uploadVideoFailed(self, errorMessage: "视频上传失败!")
                    }
                })
                upload.uploadProgress { [weak self] (progress) in
                    guard let strongSelf = self else { return }
                    let count = progress.fractionCompleted
                    strongSelf.delegate?.uploadVideoProgress(count)
                }
                break
            case .failure(_):
                DLog("responseJson.error =视频上传失败，请检查网络连接!")
                self.delegate?.uploadVideoFailed(self, errorMessage: "视频上传失败，请检查网络连接!")
                break
            }
        }
    }
    
    private func response(_ response: [String: Any]?) {
        guard let value = response else {
            delegate?.uploadVideoFailed(self, errorMessage: "视频上传失败，请检查网络连接!")
            return
        }
        if value["code"] as? Int == 0 {
            delegate?.uploadVideoSuccess(self, resultDic: value)
        } else {
            if value["code"] as? Int == 500 {
                if let errorMsg = value["message"] as? String {
                    delegate?.uploadVideoFailed(self, errorMessage: errorMsg)
                    return
                }
            }
            // 发出被挤掉的消息
            if let errorCode = value["code"] as? Int, errorCode == 401 {
                delegate?.uploadVideoFailedByTokenError()
                return
            }
            DLog("responseJson.error = 视频上传失败")
            delegate?.uploadVideoFailed(self, errorMessage: "视频上传失败!")
        }
    }
    
   
}


