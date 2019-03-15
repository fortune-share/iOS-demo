//
//  FMApiObject.h
//  FeimaoSDK
//
//  Created by lidazhi on 2019/3/4.
//  Copyright © 2019 limohuyu01. All rights reserved.
//

#import <Foundation/Foundation.h>
/*! @brief 错误码
 *
 */
typedef NS_ENUM(NSInteger,FMErrCode) {
    FMSuccess           = 0,    /**< 成功    */
    FMErrCodeCommon     = 1,   /**< 普通错误类型    */
    FMErrCodeUserCancel = 2,   /**< 用户点击取消并返回    */
    FMErrCodeSentFail   = 3,   /**< 请求失败    */
    FMErrCodeUnsupport  = 4,   /**< 飞猫不支持    */
};


/*! @brief 该类为飞猫终端SDK所有请求类的基类
 *
 */
@interface FMBaseReq:NSObject
/** 请求类型 第三方不需要传递任何参数 该参数仅仅是FMApi内部使用*/
@property (nonatomic, assign) NSInteger type;
@end
/*! @brief 该类为飞猫终端SDK所有响应类的基类
 *
 */
@interface FMBaseResp:NSObject
/** 错误码 FMErrCode*/
@property (nonatomic, assign) NSInteger errCode;
/** 错误提示字符串 */
@property (nonatomic, copy) NSString *errStr;
/** 响应类型 */
@property (nonatomic, assign) NSInteger type;
@end


/**
 第三方APP向飞猫发起支付的消息体
 */
@interface FMPayReq:FMBaseReq
/** 预支付订单id */
@property (nonatomic, copy) NSString *prepayId;
@end

/*! @brief 飞猫终端返回给第三方的关于支付结果的结构体
 *
 *  飞猫终端返回给第三方的关于支付结果的结构体
 */
@interface FMPayResp:FMBaseResp

@end

/**
 第三方APP向飞猫发起授权登录的消息体
 */
@interface FMLoginReq:FMBaseReq
/** 预支付订单id */
@property (nonatomic, copy) NSString *accessToken;
@end

/*! @brief 飞猫终端返回给第三方的关于授权登录结果的结构体
 *
 *  飞猫终端返回给第三方的关于授权登录结果的结构体
 */
@interface FMLoginyResp:FMBaseResp

@end
