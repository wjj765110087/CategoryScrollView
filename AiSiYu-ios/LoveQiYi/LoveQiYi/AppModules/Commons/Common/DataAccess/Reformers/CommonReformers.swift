//
//  CommonReformers.swift
//  YellowBook
//
//  Created by mac on 2019/7/1.
//  Copyright © 2019年 mac. All rights reserved.
//

import Foundation
import NicooNetwork

/// App版本更新信息解析
class AppUpdateReformer: NSObject {
    
    /// AppVersionInfo    Api
    private func reformUpdateInfoDatas(_ data: Data?) -> Any? {
        guard let response = data else { return nil }
        if let info = try? decode(response: response, of: ObjectResponse<AppVersionInfo>.self)?.result {
            return info
        }
        return nil
    }
    /// 请求广告
    private func reformAdvertisementInfoDatas(_ data: Data?) -> Any? {
        guard let response = data else { return nil }
        if let info = try? decode(response: response, of: ObjectResponse<AdSplashModel>.self)?.result {
            return info
        }
        return nil
    }
    /// 系统公告列表
    private func reformNoticeLsApiDatas(_ data: Data?) -> Any? {
        if let videoModules = try? decode(response: data, of: ObjectResponse<[SystemMsgModel]>.self)?.result {
            return videoModules
        }
        return nil
    }
    
}

// MARK: - NicooAPIManagerDataReformProtocol
extension AppUpdateReformer: NicooAPIManagerDataReformProtocol {
    
    func manager(_ manager: NicooBaseAPIManager, reformData jsonData: Data?) -> Any? {
        if manager is AppUpdateApi {
            return reformUpdateInfoDatas(jsonData)
        }
        if manager is AdvertismentApi {
            return reformAdvertisementInfoDatas(jsonData)
        }
        if manager is AppMessageApi {
            return reformNoticeLsApiDatas(jsonData)
        }
        return nil
    }
}


class LoginRegisterReformer: NSObject {
    
    private func reformCodeDatas(_ data: Data?) -> Any? {
        if let code = try? decode(response: data, of: ObjectResponse<CodeModel>.self)?.result {
            return code
        }
        return nil
    }
    
    private func reformDeviceRegisterDatas(_ data: Data?) -> Any? {
        if let info = try? decode(response: data, of: ObjectResponse<UserInfoModel>.self)?.result {
            return info
        }
        return nil
    }
    
}

extension LoginRegisterReformer: NicooAPIManagerDataReformProtocol {
    
    func manager(_ manager: NicooBaseAPIManager, reformData jsonData: Data?) -> Any? {
        if manager is SendCodeApi {
            return reformCodeDatas(jsonData)
        }
        if manager is DeviceRegisterApi {
            return reformDeviceRegisterDatas(jsonData)
        }
        return nil
    }
}
