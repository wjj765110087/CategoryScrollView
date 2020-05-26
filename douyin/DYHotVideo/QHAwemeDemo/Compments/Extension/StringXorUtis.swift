//
//  StringXorUtis.swift
//  QHAwemeDemo
//
//  Created by mac on 2019/4/22.
//  Copyright © 2019年 AnakinChen Network Technology. All rights reserved.
//

import Foundation

class StringXor: NSObject {
    
    private static let secretKey: NSString = "20190101"
    
    /* XOr encrypt
     
     * @param input NString to be encrypted
     
     * @return Encrypted NString
     
     */
    
    class func xorEncrypt(input: NSString) -> NSString? {
        
        let chars = (0..<input.length).map({
            
            input.character(at: $0)^secretKey.character(at: $0 % secretKey.length)
            
        })
        return  String(utf16CodeUnits: chars, count: chars.count).hexadecimalString()! as NSString
        
    }
    
    
    
    /* XOr Decrypt
     
     * @param input NString to decrypt
     
     * @return Decrypted NString
     
     */
    
    class func xorDecrypt(input: NSString) -> NSString? {
        
        let hexString = String(hexadecimal: input as String)! as NSString
        
        let chars = (0..<hexString.length).map({
            
            hexString.character(at: $0)^secretKey.character(at: $0 % secretKey.length)
            
        })
        
        return NSString(characters: chars, length: chars.count)
        
    }
    
    
    
    
    
    /* XOr encrypt
     
     * @param input String to be encrypted
     
     * @return Encrypted string
     
     */
    
    class func xorEncrypt(input: String) -> String {
        
        let str = input as NSString
        
        let chars = (0..<str.length).map({
            
            str.character(at: $0)^secretKey.character(at: $0 % secretKey.length)
            
        })
        
        return  String(utf16CodeUnits: chars, count: chars.count)
    }
    
    
    
    /* XOr Decrypt
     
     * @param input String to decrypt
     
     * @return Decrypted string
     
     */
    
    class func xorDecrypt(input: String) -> String {
        
        let hexString = String(hexadecimal: input)! as NSString
        
        let chars = (0..<hexString.length).map({
            
            hexString.character(at: $0)^secretKey.character(at: $0 % secretKey.length)
            
        })
        
        return String(utf16CodeUnits: chars, count: chars.count)
        
    }
}


extension Data {
    
    /// Create hexadecimal string representation of `Data` object.
    
    /// - returns: `String` representation of this `Data` object.
    
    func hexadecimal() -> String {
        
        return map { String(format: "%02x", $0) }
            
            .joined(separator: "")
        
    }
}

extension String {
    /// Create `String` representation of `Data` created from hexadecimal string representation
    
    /// This takes a hexadecimal representation and creates a String object from that. Note, if the string has any spaces, those are removed. Also if the string started with a `<` or ended with a `>`, those are removed, too.
    
    /// For example,
    
    ///     String(hexadecimal: "<666f6f>")
    
    /// is
    
    ///     Optional("foo")
    
    /// - returns: `String` represented by this hexadecimal string.
    
    init?(hexadecimal string: String, encoding: String.Encoding = .utf8) {
        
        guard let data = string.hexadecimal() else {
            
            return nil
            
        }
        
        self.init(data: data, encoding: encoding)
        
    }
    
    
    
    /// Create `Data` from hexadecimal string representation
    
    /// This takes a hexadecimal representation and creates a `Data` object. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
    
    /// - returns: Data represented by this hexadecimal string.
    
    func hexadecimal() -> Data? {
        
        var data = Data(capacity: count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        
        regex.enumerateMatches(in: self, range: NSMakeRange(0, utf16.count)) { match, flags, stop in
            
            let byteString = (self as NSString).substring(with: match!.range)
            
            var num = UInt8(byteString, radix: 16)!
            
            data.append(&num, count: 1)
            
        }
        
        guard data.count > 0 else { return nil }
        
        return data
        
    }
    
    
    
    /// Create hexadecimal string representation of `String` object.
    
    /// For example,
    
    ///     "foo".hexadecimalString()
    
    /// is
    
    ///     Optional("666f6f")
    
    /// - parameter encoding: The `String.Encoding` that indicates how the string should be converted to `Data` before performing the hexadecimal conversion.
    
    /// - returns: `String` representation of this String object.
    
    func hexadecimalString(encoding: String.Encoding = .utf8) -> String? {
        
        return data(using: encoding)?
            
            .hexadecimal()
    }
}
