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
    
    //判断手机号码合法性
    func isValid(mobilePhone phone: String) -> Bool {
        if phone.count != 11 {
            return false
        }
        
        let  CM = "(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
        let  CU = "(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
        let  CT = "(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
        
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        
        if regextestcm.evaluate(with: phone) || regextestct.evaluate(with: phone) || regextestcu.evaluate(with: phone){
            return true
        }else{
            return false
        }
    }
    
}
