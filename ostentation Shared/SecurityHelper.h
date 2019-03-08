//
//  SecurityHelper.h
//  协助完成安全签名和签名校验
//  ostentation
//
//  Created by JiangCai on 2019/3/5.
//  Copyright © 2019 fortune. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SecurityHelper : NSObject

// 签名原数据包，并且返回完成签名的数据包。
-(NSDictionary*)signData:(NSDictionary*)input withOutTime:(BOOL)withOutTime;

// 检查平台返回数据包的签名
-(BOOL)verifySign:(NSDictionary*)data;

@end

NS_ASSUME_NONNULL_END
