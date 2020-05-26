//
//  DeviceRegisterApi.swift
//  XSVideo
//
//  Created by pro5 on 2019/1/5.
//  Copyright © 2019年 pro5. All rights reserved.
//

import Foundation
import NicooNetwork

/// 设备号注册
class DeviceRegisterApi: XSVideoBaseAPI {
    
    static let kDevice_code = "device_code"
    static let kInviteCode = "invite_code"
    static let kChannel = "channel"     /// 平台
    static let kFrom = "from"           /// 来自 途径
    
    static let kUrlValue = "/\(ConstValue.kApiVersion)/register-device"
    static let kMethodValue = "POST"
    
    override func loadData() -> Int {
        if self.isLoading {
            self.cancelAllRequests()
        }
        return super.loadData()
    }
    override func methodName() -> String {
        return ConstValue.kIsEncryptoApi ? super.methodName() : "\(ConstValue.kApiVersion)/register-device"
    }
    
    override func shouldCache() -> Bool {
        return false
    }
    
    override func requestType() -> NicooAPIManagerRequestType {
        return ConstValue.kIsEncryptoApi ? super.requestType() : .post
    }
    
    override func reform(_ params: [String: Any]?) -> [String: Any]? {
        var allParams: [String: Any] = [DeviceRegisterApi.kUrl: DeviceRegisterApi.kUrlValue,
                                        DeviceRegisterApi.kMethod: DeviceRegisterApi.kMethodValue]
        allParams[DeviceRegisterApi.kParams] = params ?? [String: Any]()
        return super.reform(ConstValue.kIsEncryptoApi ? allParams : params)
    }
}
