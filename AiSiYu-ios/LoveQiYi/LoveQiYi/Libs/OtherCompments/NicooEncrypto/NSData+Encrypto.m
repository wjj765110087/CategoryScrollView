//
//  NSData+Encrypto.m
//  Pods-TZEncrypto_Example
//
//
//  Created by 504672006@qq.com on 11/15/2018.
//  Copyright (c) 2018 504672006@qq.com. All rights reserved.
//

#import "NSData+Encrypto.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSData (Encrypto)

- (NSData *)AES128EncryptWithKey:(NSString *)key {
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,/*这里就是刚才说到的PKCS7Padding填充了*/
                                          keyPtr,
                                          kCCKeySizeAES128,
                                          NULL, /*初始化向量在ecb模式下为空*/
                                          [self bytes], dataLength, /*输入*/
                                          buffer, bufferSize, /*输出*/
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted freeWhenDone:true];
    }
    free(buffer);
    return nil;
}

- (NSData *)AES128DecryptWidthKey:(NSString *)key {
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,/*这里就是刚才说到的PKCS7Padding填充了*/
                                          keyPtr,
                                          kCCKeySizeAES128,
                                          NULL, /*初始化向量在ecb模式下为空*/
                                          [self bytes], dataLength, /*输入*/
                                          buffer, bufferSize, /*输出*/
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted freeWhenDone:true];
    }
    free(buffer);
    return nil;
}

// 解密
- (NSData *)xor_decryptWithKey:(NSString *)privateKey {
    return [self xor_encryptWithKey: privateKey];
}

// 加密
- (NSData *)xor_encryptWithKey:(NSString *)privateKey {
    // 获取key的长度
    NSInteger length = privateKey.length;
    
    // 将OC字符串转换为C字符串
    const char *keys = [privateKey cStringUsingEncoding: NSASCIIStringEncoding];
    
    unsigned char cKey[length];
    
    memcpy(cKey, keys, length);
    
    // 数据初始化，空间未分配 配合使用 appendBytes
    NSMutableData *encryptData = [[NSMutableData alloc] initWithCapacity:length];
    
    // 获取字节指针
    const Byte *point = self.bytes;
    
    for (int i = 0; i < self.length; i++) {
        int l = i % length;                     // 算出当前位置字节，要和密钥的异或运算的密钥字节
        char c = cKey[l];
        Byte b = (Byte) ((point[i]) ^ c);       // 异或运算
        [encryptData appendBytes:&b length:1];  // 追加字节
    }
    return encryptData.copy;
}

@end
