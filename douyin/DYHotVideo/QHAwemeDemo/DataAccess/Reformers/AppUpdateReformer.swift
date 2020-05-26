//
//  AppUpdateReformer.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/28.
//  Copyright © 2018年 pro5. All rights reserved.
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
        return nil
    }
}
