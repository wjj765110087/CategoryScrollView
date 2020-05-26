//
//  StringRegExpAssistant.swift
//  NicooExtension
//
//  Created by 小星星 on 2018/11/15.
//

import Foundation

public extension String {
    /// url正则验证
    ///
    /// - Returns: 是否为有效url
    func isValidUrl() -> Bool {
        let regex = "[a-zA-z]+://[^\\s]*"
        if let _ = self.range(of: regex, options: .regularExpression, range: nil, locale: nil) {
            return true
        }
        return false
    }
    /// 手机号验证
    func isValidPhoneNumber() -> Bool {
        let regex = "^1[3|4|5|7|8]\\d{9}$"
        if let _ = self.range(of: regex, options: .regularExpression, range: nil, locale: nil) {
            return true
        }
        return false
    }
    /// 身份证号验证
    func isIDCardNumber() -> Bool {
        let regex = "(^\\d{17}[X|x]{1}$)|(^\\d{1,18}$)"
        if let _ = self.range(of: regex, options: .regularExpression, range: nil, locale: nil) {
            return true
        }
        return false
    }
    
}
