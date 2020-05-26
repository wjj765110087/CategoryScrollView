//
//  LoginRegisterReformer.swift
//  XSVideo
//
//  Created by pro5 on 2018/12/25.
//  Copyright © 2018年 pro5. All rights reserved.
//

import Foundation
import NicooNetwork


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
