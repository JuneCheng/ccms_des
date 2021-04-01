#import "CcmsDesPlugin.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation CcmsDesPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"ccms_des"
            binaryMessenger:[registrar messenger]];
  CcmsDesPlugin* instance = [[CcmsDesPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"encryptToHex" isEqualToString:call.method]) {
        NSArray<NSString *> *paramArray = call.arguments;
        result([self encryptUseDES:paramArray[0] key:paramArray[1]]);
    } else if ([@"decryptFromHex" isEqualToString:call.method]) {
        NSArray<NSString *> *paramArray = call.arguments;
        result([self decryptUseDES:paramArray[0] key:paramArray[1]]);
    } else {
      result(FlutterMethodNotImplemented);
    }
}

#pragma mark 自定义方法

/*
 * 字符串加密
 *
 * plainText : 待加密明文
 * key       : 密钥
 */
- (NSString *)encryptUseDES:(NSString *)plainText key:(NSString *)key {
    NSString *ciphertext = nil;
    NSData *baseData = [plainText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSUInteger dataLength = baseData.length + 10 + [key dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES].length;
    unsigned char buffer[dataLength];
    memset(buffer, 0, sizeof(char));
//    Byte iv[] = {1,2,3,4,5,6,7,8};
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          nil,
                                          [baseData bytes],
                                          [baseData length],
                                          buffer,
                                          dataLength,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        
//        ciphertext = [self encodeData:data];
        ciphertext = [self convertToHexString:data];
    }
    return ciphertext;
}

- (NSString *)convertToHexString:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}
 
/*
 * 字符串解密
 *
 * plainText : 加密密文
 * key       : 密钥
 */
- (NSString *)decryptUseDES:(NSString *)cipherText key:(NSString *)key {
    NSData *cipherData = [self convertHexStringToData:cipherText];
    NSUInteger dataLength = cipherData.length + 10 + [key dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES].length;
    unsigned char buffer[dataLength];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
//    Byte iv[] = {1,2,3,4,5,6,7,8};
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          nil,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          dataLength,
                                          &numBytesDecrypted);
    NSString *plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    } else {
        NSLog(@"解密失败！%d",cryptStatus);
    }
    return plainText;
}
 
- (NSData *)convertHexStringToData:(NSString *)hexString {
    if (!hexString || [hexString length] == 0) {
        return nil;
    }
        
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([hexString length] % 2 == 0) {
        range = NSMakeRange(0, 2);
    } else {
        range = NSMakeRange(0, 1);
    }
    for (NSInteger i = range.location; i < [hexString length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [hexString substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

@end
