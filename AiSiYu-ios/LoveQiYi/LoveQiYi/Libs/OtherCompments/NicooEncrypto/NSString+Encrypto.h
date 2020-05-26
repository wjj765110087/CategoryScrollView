//
//  NSString+Encrypto.h
//  Pods-TZEncrypto_Example
////
//  Created by 504672006@qq.com on 11/15/2018.
//  Copyright (c) 2018 504672006@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Encrypto)

/**
 MD5加密
 
 @return 加密后字符串
 */
- (NSString *)md5String;

/**
 sha384编码

 @return 编码字符串
 */
- (NSString *)sha384String;


/**
 AES128 加密
 
 @param key 加密钥匙
 @return 加密后字符串
 */
- (NSString *)AES128EncryptStringWithKey:(NSString *)key;


/**
 AES128解密
 
 @param key 加密钥匙
 @return 解密后字符串
 */
- (NSString *)AES128DecryptStringWithKey:(NSString *)key;

/**
 DES加密
 
 @param key 加密钥匙
 @return 加密后字符串
 */
- (NSString *)DESEncryptStringWithKey:(NSString *)key;


/**
 DES解密
 
 @param key 加密钥匙
 @return 解密后字符串
 */
- (NSString *)DESDecryptStringWithKey:(NSString *)key;

@end
