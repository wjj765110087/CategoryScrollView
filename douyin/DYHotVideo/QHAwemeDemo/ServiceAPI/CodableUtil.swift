

/**
 用于解析JSON的全局方法 泛型, 可以处理一些公共的操作 例如：数据 的 解密， 加密等
 */

import Foundation

public func decode<T>(response: Data?, of: T.Type) throws -> T? where T: Codable {
    guard let responseData = response else { return nil }
    guard let decryptData = ConstValue.kIsEncryptoApi ? decryptJsonResultString(responseData) : responseData else { return nil }
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .millisecondsSince1970
    do {
        let model = try decoder.decode(T.self, from: decryptData)
        return model
    } catch {
        DLog("解析JSON出错: \(error)")
        return nil
    }
}

public struct ObjectResponse<T: Codable>: Codable {
   public let result: T?
}

fileprivate func decryptJsonResultString(_ responseData: Data) -> Data? {
    guard var jsonKeyValue = dataToJSON(data: responseData) else { return nil }
    guard let resultString = jsonKeyValue["result"] as? String else { return nil }
    let decodResultString = resultString.urlDecoded()
    if !decodResultString.isEmpty {
        if let decryptString = decodResultString.aes128DecryptString(withKey: ConstValue.kApiEncryptKey) {
            if let jdecryptData = decryptString.data(using: .utf8) {
                let dict = try? JSONSerialization.jsonObject(with: jdecryptData, options: .mutableContainers)
                DLog("decryptString \(decryptString)")
                jsonKeyValue["result"] = dict
            }
        }
    }
    if (!JSONSerialization.isValidJSONObject(jsonKeyValue)) {
        DLog("无法解析出JSONString")
        return nil
    }
    return try? JSONSerialization.data(withJSONObject: jsonKeyValue, options: [])
}

fileprivate func dataToJSON(data: Data) -> [String: Any]? {
    do {
        return try JSONSerialization.jsonObject(with: data , options: .mutableContainers) as? [String: Any]
    } catch {
        DLog(error)
    }
    return nil
}




