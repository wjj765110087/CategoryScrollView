//
//  StringExtension.swift
//  NicooExtension
//
//  Created by 小星星 on 2018/11/15.
//

/*
 Description:
 对String的扩展方法
 
 History:
 */

import UIKit

public extension String {
    
    func encodeStringToBase64String() -> String {
        let utf8Data: Data = self.data(using: String.Encoding.utf8)!
        let base64EncodedString = utf8Data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64EncodedString
    }
    
    func removeAllSpace() -> String? {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    
    func removeAllPoints() -> String? {
        return self.replacingOccurrences(of: ".", with: "", options: .literal, range: nil)
    }
    
    func isAvailableIdCard() -> Bool {
        if self.count != 18 {
            return false
        }
        var sum = 0
        for i in 0..<17 {
            let index1 = self.index(self.startIndex, offsetBy: i)
            let index2 = self.index(self.startIndex, offsetBy: i + 1)
            let idNum = self[index1 ..< index2]
            //            let idNum = String(self[self.index(self.startIndex, offsetBy: i) ..< self.index(self.startIndex, offsetBy: i + 1)])
            if let num = Int(idNum) {
                let x = powf(2, 17 - Float(i))
                let y = NSInteger(x) % 11
                sum += num * y
            } else {
                return false
            }
        }
        //        var checkCode = String(self[self.index(self.startIndex, offsetBy: 17) ..< self.index(self.startIndex, offsetBy: 18)])
        let index3 = self.index(self.startIndex, offsetBy: 17)
        let index4 = self.index(self.startIndex, offsetBy: 18)
        var checkCode = String(self[index3 ..< index4])
        checkCode = checkCode == "x" ? "X" : checkCode
        let x = sum % 11
        let checkDictionary:Dictionary<Int, String> = [0: "1", 1: "0", 2: "X", 3: "9", 4: "8", 5: "7", 6: "6", 7: "5", 8: "4", 9: "3", 10: "2"]
        if checkDictionary[x] == checkCode {
            return true
        }
        return false
    }
    
    // String to Dictionary
    func stringToDictioanry() -> NSDictionary? {
        if let data: Data = self.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            do {
                let json: Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                return json as? NSDictionary
            } catch {
                return nil
            }
        }
        return nil
    }
    
    func urlEncodedForLink() -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        var allowedCharacterSet = CharacterSet.urlHostAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
       
        return  encodeUrlString ?? ""
    }
    
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        return encodeUrlString ?? ""
    }
    
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
    
    func getLableHeight(font: UIFont, width: CGFloat) -> CGFloat {
        let size = CGSize.init(width: width, height:  CGFloat(MAXFLOAT))
        let dic = [NSAttributedString.Key.font: font] // swift 4.2
        let strSize = self.boundingRect(with: size, options: [.usesLineFragmentOrigin], attributes: dic, context:nil).size
        return ceil(strSize.height) + 1
    }
    
    func encodeWithXorByte(key: UInt8) -> String {
        return String(bytes: self.utf8.map{$0 ^ key}, encoding: String.Encoding.utf8) ?? ""
    }
    
}

open class TextSpaceManager: NSObject {
    
    open class func getAttributeStringWithString(_ string: String, lineSpace: CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        let paragraphStye = NSMutableParagraphStyle()
        //调整行间距
        paragraphStye.lineSpacing = lineSpace
        let rang = NSMakeRange(0, CFStringGetLength(string as CFString?))
        
        attributedString.addAttribute(.paragraphStyle, value: paragraphStye, range: rang)
        
        return attributedString
    }
    
    open class func configScoreString(allString: String) -> NSAttributedString? {
        let strings = allString.components(separatedBy: ".")
        if strings.count < 2 { return nil }
        
        let attribute = [NSAttributedString.Key.font : UIFont(name: "American Typewriter", size: 20) ?? UIFont.systemFont(ofSize: 20)] as [NSAttributedString.Key : Any]
        let attSting = strings.first
        if  attSting != nil && !attSting!.isEmpty {
            let pointString = NSMutableAttributedString(string: allString)
            pointString.addAttributes(attribute, range: NSRange.init(location: 0, length: attSting!.count))
            return pointString
        }
       return nil
    }
    
    open class func configColorString(allString: String, attribStr: String, _ attColor: UIColor? = UIColor(r: 255, g: 42, b: 49), _ font: UIFont = UIFont.systemFont(ofSize: 17), _ lineSpace: CGFloat? = 5.0) -> NSAttributedString? {
        var attribute = [NSAttributedString.Key: Any]()
        attribute = [NSAttributedString.Key.foregroundColor : attColor, NSAttributedString.Key.font : font]
        let attSting = attribStr
        if !attSting.isEmpty {
            let pointString = NSMutableAttributedString(string: allString)
            pointString.addAttributes(attribute, range: (allString as NSString).range(of: attribStr))
            //调整行间距
            let paragraphStye = NSMutableParagraphStyle()
            paragraphStye.lineSpacing = lineSpace ?? CGFloat(5.0)
            let rang = NSMakeRange(0, CFStringGetLength(allString as CFString?))
            pointString.addAttribute(.paragraphStyle, value: paragraphStye, range: rang)
            return pointString
        }
        return nil
    }
    
    open class func fixStringWithString(_ string: String, lineSpace: CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        let paragraphStye = NSMutableParagraphStyle()
        //调整行间距
        paragraphStye.lineSpacing = lineSpace
        let rang = NSMakeRange(0, CFStringGetLength(string as CFString?))
        
        attributedString.addAttribute(.paragraphStyle, value: paragraphStye, range: rang)
        
        return attributedString
    }
   
}
