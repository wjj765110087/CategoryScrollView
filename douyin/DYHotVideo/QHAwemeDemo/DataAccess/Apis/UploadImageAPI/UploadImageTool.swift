
import Foundation
import Alamofire

/// 图片上传代理
protocol UploadImageDelegate: class {
    
    /// 请求的参数，不包含图片参数
    func paramsForAPI(_ uploadImageTool: UploadImageTool) -> [String: String]?
    
    /// 请求method
    func uploadImageMethod(_ uploadImageTool: UploadImageTool) -> String
    
    /// 请求成功回调
    func uploadImageSuccess(_ uploadImageTool: UploadImageTool, resultDic: [String: Any]?)
    
    /// 请求失败的回调
    func uploadImageFailed(_ uploadImageTool: UploadImageTool, errorMessage: String?)
    
    /// token失效
    func uploadFailedByTokenError()
    
    // optional
    func uploadImageHTTPMethod() -> HTTPMethod
    
    func baseURLForUploadTool() -> String
    
    func paramsForHeader(_ uploadImageTool: UploadImageTool) -> [String: String]?
}

extension UploadImageDelegate {
    
    func paramsForHeader(_ uploadImageTool: UploadImageTool) -> [String: String]? {
        return nil
    }
    
    func baseURLForUploadTool() -> String {
        return AppInfo.share().static_url ?? ""
    }
    
    /// http请求方式
    func uploadImageHTTPMethod() -> HTTPMethod {
        return .post
    }
    
    func uploadFailedByTokenError() {
        // 发出被挤掉的消息
        NotificationCenter.default.post(name: NSNotification.Name.kUserBeenKickedOutNotification, object: nil)
    }
   
}

/// 图片上传封装
class UploadImageTool {
    
    static fileprivate let appVersion: String = {
        let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: filePath!)
        return dictionary!["CFBundleShortVersionString"] as! String
    }()
    private var image: UIImage?
    weak var delegate: UploadImageDelegate?
    
    var paramsKey: String = "image"
    
    func upload(_ img: UIImage?) {
        self.image = img
        request(img: img, data: nil, upImage: true)
    }
    func uploadGif(_ data: Data?) {
        request(img: nil, data: data, upImage: false)
    }
    
    private func request(img: UIImage?, data: Data?, upImage: Bool) {
        guard let requst = getRequest() else {
            delegate?.uploadImageFailed(self, errorMessage: "图片上传失败，请检查网络连接。")
            return
        }
        
        let param = delegate?.paramsForAPI(self)
        Alamofire.upload(multipartFormData: {[weak self] (multipartFormData) in
            guard let strongSelf = self else {
                return
            }
            if upImage { // 上传图片
                if let image = img {
                    let data =  UIImage.resetImgSize(sourceImage: image, maxImageLenght: screenHeight, maxSizeKB: 1024.0)  //UIImage.jpegData(image)(compressionQuality: 0.7)!
                    let fileN = String(describing: NSDate()) + ".jpg"
                    // withName:：是根据文档决定传入的字符串
                    multipartFormData.append(data as Data, withName: strongSelf.paramsKey, fileName: fileN, mimeType: "image/jpg")
                }
            } else { // 上传gif图
                if let imgData = data,  let scaleData = ImageCompress.compressImageData(imgData as Data, limitDataSize: Int(2048 * 1024)) { // gif图片压缩到2M以下
                    let fileN = String(describing: NSDate()) + ".gif"
                    // withName:：是根据文档决定传入的字符串
                    multipartFormData.append(scaleData, withName: strongSelf.paramsKey, fileName: fileN, mimeType: "image/gif")
                }
            }
            
            if let param = param {
                //因为这个方法的第一个参数接收的是NSData类型,所以要利用 NSUTF8StringEncoding 把字符串转为NSData
                for (key,value) in param {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
        }, with: requst) {[weak self] (encodingResult) in
            guard let strongSelf = self else {
                return
            }
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    strongSelf.response(response.result.value as? [String : Any] )
                }
            case .failure(_):
                strongSelf.delegate?.uploadImageFailed(strongSelf, errorMessage: "图片上传失败，请检查网络连接。")
            }
        }
    }
    
    private func response(_ response: [String: Any]?) {
        guard let value = response else {
            delegate?.uploadImageFailed(self, errorMessage: "图片上传失败，请检查网络连接。")
            return
        }
        if value["code"] as? Int == 0 {
            delegate?.uploadImageSuccess(self, resultDic: value)
        } else {
            if value["code"] as? Int == 500 {
                if let errorMsg = value["message"] as? String {
                    delegate?.uploadImageFailed(self, errorMessage: errorMsg)
                    return
                }
                // 发出强制登录的消息
                if let errorCode = value["code"] as? Int, errorCode == 401 {
                    delegate?.uploadFailedByTokenError()
                    return
                }
            }
            delegate?.uploadImageFailed(self, errorMessage: "图片上传失败，请检查网络连接。")
        }
    }
    
    private func extraHttpHeadParams() -> [String: String] {
        var param: [String : String] = [:]
        param["version"] = UploadImageTool.appVersion
        param["Accept"] = "application/json"
        if let token = UserModel.share().userInfo?.api_token {
            param["Authorization"] = "Bearer \(token)"
        }
        return param
    }
    
    private func getRequest() -> URLRequest? {
        guard let url = delegate?.uploadImageMethod(self) else {
            return nil
        }
        let baseURL = delegate?.baseURLForUploadTool()
        let finalURL = "\((baseURL ?? ""))\(url)"
        var header = extraHttpHeadParams()
        if let dict = delegate?.paramsForHeader(self) {
            for key in dict.keys {
                header[key] = dict[key]
            }
        }
        var httpMethod = HTTPMethod.post
        if let method = delegate?.uploadImageHTTPMethod() {
            httpMethod = method
        }
        return try? URLRequest(url: finalURL, method: httpMethod, headers: header)
    }
    
}
