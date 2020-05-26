//
//  NSData+Encrypto.h
//  Pods-TZEncrypto_Example
//


#import <Foundation/Foundation.h>

@interface NSData (Encrypto)

/**
 使用AES128(算法)/EBC(工作模式)/PKCS5Padding(填充方式)加密啊

 @param key 密钥
 @return 加密后的数据
 */
- (NSData *)AES128EncryptWithKey:(NSString *)key;

/**
 解密

 @param key 密钥
 @return 解密后的明文
 */
- (NSData *)AES128DecryptWidthKey:(NSString *)key;


// 异或  解密（异或的解密其实就是再调一次加密）
- (NSData *)xor_decryptWithKey:(NSString *)privateKey;

// 加密 异或操作
- (NSData *)xor_encryptWithKey:(NSString *)privateKey;

@end
