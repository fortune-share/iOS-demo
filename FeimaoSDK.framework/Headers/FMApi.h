//
//  FMAPi.h
//  FeimaoSDK
//  Created by lidazhi on 2019/3/4.
//  Copyright © 2019 limohuyu01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FMApiObject.h"
@protocol FMApiDelegate <NSObject>


/*! @brief 发送一个sendReq后，收到飞猫的回应
 *
 * 收到一个来自飞猫的处理结果。调用一次sendReq后会收到onResp。
 * @param resp resp
 */
- (void)onResp:(FMBaseResp*)resp;

@end

@interface FMApi : NSObject
/**
 
 * 需要在每次启动第三方应用程序时调用。
 @param appkey 飞猫后台注册的拿到的APPkey
 */

+(void)registerAppkey:(NSString *)appkey;

/*! @brief 发送请求到飞猫，等待飞猫返回onResp
 *
 * 函数调用后，会切换到飞猫的界面。第三方应用程序等待飞猫返回onResp。飞猫在异步处理完成后一定会调用onResp。支持以下类型
 * @param req 具体的发送请求，在调用函数后，请自己释放。
 */
+(void)sendReq:(FMBaseReq*)req;

/*! @brief 处理飞猫通过URL启动App时传递的数据
 *
 * 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
 * @param url 飞猫启动第三方应用时传递过来的URL
 * @param delegate  FMApiDelegate对象，用来接收微信触发的消息。
 */
+(BOOL)handleOpenURL:(NSURL *)url  delegate:(nullable id<FMApiDelegate>)delegate;
@end

