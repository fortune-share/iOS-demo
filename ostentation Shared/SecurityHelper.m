//
//  SecurityHelper.m
//  ostentation
//
//  Created by JiangCai on 2019/3/5.
//  Copyright © 2019 fortune. All rights reserved.
//

#import "SecurityHelper.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>

@interface NSObject (JSON)

- (NSString*)toSimpleJSON;

@end

@implementation NSObject (JSON)


-(NSString*)toSimpleJSON{
    if ([self isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dict = (NSDictionary*)self;
        NSArray* keys = [[dict allKeys] sortedArrayUsingSelector:@selector(compare:)];
        NSMutableString* buffer= [[NSMutableString alloc] init];
        [buffer appendString:@"{"];
        for (NSString* key in keys) {
            [buffer appendFormat:@"\"%@\":%@,", key,[dict[key] toSimpleJSON]];
        }
        // 移除最后一个 ,
        if ([keys count]>0) {
            [buffer deleteCharactersInRange:NSMakeRange(buffer.length-1, 1)];
        }
        [buffer appendString:@"}"];
        return buffer;
        }else if([self isKindOfClass:[NSNull class]]){
            return @"null";
    }else if([self isKindOfClass:[NSString class]]){
        // 特俗的是 里面的换行符号应该替换为 明文 \n
        NSString* nstr = [(NSString*)self stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\\n"];
        NSString* nstr2 = [nstr stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
        return [NSString stringWithFormat:@"\"%@\"",nstr2];
    } else
        return [NSString stringWithFormat:@"%@",self];
}


@end

/** Converts NSData to a hexadecimal string. */
@interface NSData (NSData_hexadecimalString)
/** Changes NSData object to a hex string.
 @returns hexadecimal string of NSData. Empty string if data is empty.*/
- (NSString *)hexadecimalString;
@end


@implementation NSData (NSData_hexadecimalString)

- (NSString *)hexadecimalString {
    const unsigned char *dataBuffer = (const unsigned char *)[self bytes];
    if (!dataBuffer) return [NSString string];
    
    NSUInteger          dataLength  = [self length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}

@end


@implementation SecurityHelper

SecKeyRef getPrivateKeyRef() {
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"rsaPrivate" ofType:@"p12"];
    NSData *p12Data = [NSData dataWithContentsOfFile:resourcePath];
    
    NSMutableDictionary * options = [[NSMutableDictionary alloc] init];
    
    SecKeyRef privateKeyRef = NULL;
    
    //change to the actual password you used here
    [options setObject:@"123456" forKey:(id)kSecImportExportPassphrase];
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    
    OSStatus securityError = SecPKCS12Import((CFDataRef) p12Data,
                                             (CFDictionaryRef)options, &items);
    
    if (securityError == noErr && CFArrayGetCount(items) > 0) {
        CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
        SecIdentityRef identityApp =
        (SecIdentityRef)CFDictionaryGetValue(identityDict,
                                             kSecImportItemIdentity);
        
        securityError = SecIdentityCopyPrivateKey(identityApp, &privateKeyRef);
        if (securityError != noErr) {
            privateKeyRef = NULL;
        }
    }
//    [options release];
    CFRelease(items);
    return privateKeyRef;
}

-(NSDictionary*)signData:(NSDictionary*)input withOutTime:(BOOL)withOutTime{
    
    NSMutableDictionary* nm = [input mutableCopy];
    if(!withOutTime) {
        nm[@"timestamp"] = @(ceil([[NSDate date] timeIntervalSince1970]*1000));
    }
//    NSLog(@"origin: %@",nm);
    
//    NSData* json = [NSJSONSerialization dataWithJSONObject:nm options:NSJSONWritingSortedKeys error:nil];
    NSString* jsonText = [nm toSimpleJSON];
    NSLog(@"json: %@", jsonText);
    NSData* json = [jsonText dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"json hex: %@", [json hexadecimalString]);
    
    SecKeyRef privateKeyRef = getPrivateKeyRef();
    
    // kSecPaddingPKCS1 kSecPaddingPKCS1SHA1
    CFDataRef data = CFBridgingRetain(json);
    CFDataRef result2 = SecKeyCreateSignature(privateKeyRef, kSecKeyAlgorithmRSASignatureMessagePKCS1v15SHA1, data, nil);
    CFRelease(data);
    CFRelease(privateKeyRef);
    
    NSData* signedHash = CFBridgingRelease(result2);
    
//    NSLog(@"signature hex: %@", [signedHash hexadecimalString]);
    nm[@"signature"] =[signedHash base64EncodedStringWithOptions:0];
    
    NSLog(@"signature: %@",nm[@"signature"]);
    
    return nm;
}

SecKeyRef getPublicKey(){
    NSString * path = [[NSBundle mainBundle]pathForResource:@"platform" ofType:@"der"];
    NSData * derData = [NSData dataWithContentsOfFile:path];
    
    CFDataRef cfDerData = CFBridgingRetain(derData);
    SecCertificateRef myCertificate = SecCertificateCreateWithData(kCFAllocatorDefault, cfDerData);
    CFRelease(cfDerData);
    
    SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
    SecTrustRef myTrust;
    OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
    SecTrustResultType trustResult;
    if (status == noErr) { status = SecTrustEvaluate(myTrust, &trustResult); }
    SecKeyRef key = SecTrustCopyPublicKey(myTrust);
    CFRelease(myCertificate);
    CFRelease(myPolicy);
    CFRelease(myTrust);
    return key;
}

-(BOOL)verifySign:(NSDictionary *)data {
    // 取出签名。
    NSString* signatureText = data[@"signature"];
    
    NSData* signature = [[NSData alloc] initWithBase64EncodedString:signatureText options:0];
    
    // 将原来的signature移除
    NSMutableDictionary* nm= [data mutableCopy];
    [nm removeObjectForKey:@"signature"];
    
//    NSData* json = [NSJSONSerialization dataWithJSONObject:nm options:NSJSONWritingSortedKeys error:nil];
    NSString* jsonText = [nm toSimpleJSON];
    NSData* json = [jsonText dataUsingEncoding:NSUTF8StringEncoding];
    
    SecKeyRef key = getPublicKey();
    
    CFDataRef _signature = CFBridgingRetain(signature);
    CFDataRef _json = CFBridgingRetain(json);
    
    BOOL rs = SecKeyVerifySignature(key, kSecKeyAlgorithmRSASignatureMessagePKCS1v15SHA1, _json, _signature, nil);
    CFRelease(_signature);
    CFRelease(_json);
    
    CFRelease(key);
    return rs;
}

@end


