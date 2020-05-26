//
//  AppProdService.swift
//  XSVideo
//
//  Created by pro5 on 2019/1/9.
//  Copyright © 2019年 pro5. All rights reserved.
//

import UIKit
import NicooNetwork

class AppProdService: NicooService {
    
    static let appVersion: String = {
        let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: filePath!)
        return dictionary!["CFBundleShortVersionString"] as! String
    }()
    static let appServerPath: String = {
        let filePath = Bundle.main.path(forResource: "Info", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: filePath!)
        return dictionary!["CustomServerPath"] as! String
    }()
    /**
     自定义拼接规则
     */
    override func urlGeneratingRule(_ apiMethodName: String) -> String {
        return String(format: "%@/%@", apiBaseURL ?? "", apiMethodName)
    }
}

extension AppProdService: NicooServiceProtocol {
    
    /// 标记是否是生产环境
    var isProductionEnvironment: Bool {
        return true
    }
    
    /// 生产环境API base url
    var productionAPIBaseURL: String {
        return AppProdService.appServerPath
    }
    /// 开发环境API base url
    var developmentAPIBaseURL: String {
        return AppProdService.appServerPath
    }
    
    /// 生产环境API版本
    var productionAPIVersion: String {
        return AppProdService.appVersion
    }
    /// 开发环境API版本
    var developmentAPIVersion: String {
        return AppProdService.appVersion
    }
    
    /// 生产环境公钥
    var productionPublicKey: String {
        return ""
    }
    /// 开发环境公钥
    var developmentPublicKey: String {
        return ""
    }
    
    /// 生产环境私钥
    var productionPrivateKey: String {
        return ""
    }
    /// 开发环境私钥
    var developmentPrivateKey: String {
        return ""
    }
    
    // MARK: - Optional functions
    
    /// 为某些Service需要拼凑额外字段到URL处
    open func extraParams() -> [String: Any]? {
        return nil
    }
    
    /// 为某些Service需要拼凑额外的HTTPToken，如accessToken
    open func extraHttpHeadParams(_ methodName: String) -> [String: String]? {
        var param: [String : String] = [:]
        let version = isProductionEnvironment ? productionAPIVersion : developmentAPIVersion
        param["version"] = version
        param["Accept"] = "application/json"
        return param
    }
    
    /**
     提供拦截器集中处理Service错误问题，比如token失效等做一些特殊的处理
     返回false：代表程序不再继续错误回调，比如需要强制登录，那么就直接回到登录界面
     返回true：代表程序还需继续往下执行
     */
    open func shouldCallBackByFailedOnCallingAPI(_ response: NicooURLResponse?) -> Bool {
        tokenError = false
        guard (response?.content as? [String: Any]) != nil else {
            return true
        }
        return true
    }
    
    /**
     如果上面那个方法检测到是token失效，则把isTokenError置为true
     */
    open func isTokenError() -> Bool {
        return tokenError
    }
    
}

