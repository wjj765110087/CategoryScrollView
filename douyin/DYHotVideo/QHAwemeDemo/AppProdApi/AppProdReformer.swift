//
//  AppProdReformer.swift
//  XSVideo
//
//  Created by pro5 on 2019/1/9.
//  Copyright © 2019年 pro5. All rights reserved.
//

import Foundation
import NicooNetwork

/// App有效域名请求解析
class AppProdReformer: NSObject {
    
    /// AppProdUrl  Api
    private func reformAppProdUrlInfoDatas(_ data: Data?) -> Any? {
        guard let response = data else { return nil }
        guard var jsonKeyValue = dataToJSON(data: response) else { return nil }
        guard let resultString = jsonKeyValue["result"] as? String else { return nil }
        DLog("resultString  == \(resultString)")
        if ConstValue.kIsEncryptoApi {
            let decodResultString = resultString.urlDecoded()
            if !decodResultString.isEmpty {
                if var decryptString = decodResultString.aes128DecryptString(withKey: ConstValue.kApiEncryptKey) {
                    decryptString = decryptString.replacingOccurrences(of: "\"", with: "")
                     DLog("resultString  == \(decryptString)")
                    if decryptString.hasPrefix("http://") || decryptString.hasPrefix("https://") {
                        return decryptString
                    } else {
                        let apiBaseUrl = String(format: "%@%@", "http://",decryptString)
                        return apiBaseUrl
                    }
                }
            }
        } else {
            if resultString.hasPrefix("http://") || resultString.hasPrefix("https://") {
                return resultString
            } else {
                let apiBaseUrl = String(format: "%@%@", "http://",resultString)
                return apiBaseUrl
            }
        }
        return nil
    }
    
    private func dataToJSON(data: Data) -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: data , options: .mutableContainers) as? [String: Any]
        } catch {
            DLog(error)
        }
        return nil
    }
    
}

// MARK: - NicooAPIManagerDataReformProtocol
extension AppProdReformer: NicooAPIManagerDataReformProtocol {
    
    func manager(_ manager: NicooBaseAPIManager, reformData jsonData: Data?) -> Any? {
        if manager is XSVideoProdAPI {
            return reformAppProdUrlInfoDatas(jsonData)
        }
        return nil
    }
}
