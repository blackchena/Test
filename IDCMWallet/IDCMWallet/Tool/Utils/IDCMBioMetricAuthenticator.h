//
//  IDCMBioMetricAuthenticator.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/2.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

/**
 *  TouchID/FaceID 状态
 */
typedef NS_ENUM(NSUInteger, IDCMAuthType){
    
    /**
     *  当前设备不支持TouchID/FaceID
     */
    IDCMAuthTypeNotSupport = 0,
    /**
     *  TouchID/FaceID 验证失败
     */
    IDCMAuthTypeFail,
    /**
     *  TouchID/FaceID 被用户手动取消
     */
    IDCMAuthTypeUserCancel,
    /**
     *  用户不使用TouchID/FaceID,选择手动输入密码
     */
    IDCMAuthTypeFallback,
    /**
     *  TouchID/FaceID 被系统取消 (如遇到来电,锁屏,按了Home键等)
     */
    IDCMAuthTypeSystemCancel,
    /**
     *  TouchID/FaceID 无法启动,因为用户没有设置密码
     */
    IDCMAuthTypePasswordNotSet,
    /**
     *  用户没有设置TouchID/FaceID
     */
    IDCMAuthTypeNotEnrolled,
    /**
     *  TouchID/FaceID 无效
     */
    IDCMAuthTypeNotAvailable,
    /**
     *  TouchID/FaceID 被锁定(连续多次验证TouchID/FaceID失败,系统需要用户手动输入密码)
     */
    IDCMAuthTypeBiometryLockout,
    /**
     *  当前软件被挂起并取消了授权 (如App进入了后台等)
     */
    IDCMAuthTypeAppCancel,
    /**
     *  当前软件被挂起并取消了授权 (LAContext对象无效)
     */
    IDCMAuthTypeInvalidContext,
    /**
     *  系统版本不支持TouchID/FaceID (必须高于iOS 8.0才能使用)
     */
    IDCMAuthTypeVersionNotSupport,
    /**
     *  用户没有设置faceID/touchID
     */
    IDCMAuthTypeInvalid
};

typedef void (^AuthenticationFailure)(IDCMAuthType authenticationType, NSString *errorMessage);
typedef void (^AuthenticationSuccess)(void);

/**
 * 通常先调用BioMetrics,多次失败状态变为IDCMAuthTypeBiometryLockout时,调用Passcode
 *
 */
@interface IDCMBioMetricAuthenticator : NSObject

/**
 * reason使用默认
 * fallbackTitle,cancelTitle使用系统默认
 */
+ (void)authenticateWithBioMetricsSuccessBlock:(AuthenticationSuccess)success
                                  failureBlock:(AuthenticationFailure)failure;
/**
 * fallbackTitle,cancelTitle使用系统默认
 */
+ (void)authenticateWithBioMetricsOfReason:(NSString *)reason
                              successBlock:(AuthenticationSuccess)success
                              failureBlock:(AuthenticationFailure)failure;
/**
 * fallbackTitle 可传nil,若传nil,按钮显示系统默认,系统默认为"输入密码",若想隐藏此按钮,传"",iOS10后可用
 *
 */
+ (void)authenticateWithBioMetricsOfReason:(NSString *)reason
                             fallbackTitle:(NSString *)fallbackTitle
                               cancelTitle:(NSString *)cancelTitle
                              successBlock:(AuthenticationSuccess)success
                              failureBlock:(AuthenticationFailure)failure;

/**
 * reason使用默认
 * fallbackTitle,cancelTitle使用系统默认
 */
+ (void)authenticateWithPasscodeSuccessBlock:(AuthenticationSuccess)success
                                failureBlock:(AuthenticationFailure)failure;

/**
 * fallbackTitle,cancelTitle使用系统默认
 */
+ (void)authenticateWithPasscodeOfReason:(NSString *)reason
                            successBlock:(AuthenticationSuccess)success
                            failureBlock:(AuthenticationFailure)failure;

/**
 * 9.0之后调用可用,8.0没有LAPolicyDeviceOwnerAuthentication,调用没有效果
 * fallbackTitle 可传nil,若传nil,按钮显示系统默认,系统默认为"输入密码",若想隐藏此按钮,传"",iOS10后可用
 *
 */
+ (void)authenticateWithPasscodeOfReason:(NSString *)reason
                           fallbackTitle:(NSString *)fallbackTitle
                             cancelTitle:(NSString *)cancelTitle
                            successBlock:(AuthenticationSuccess)success
                            failureBlock:(AuthenticationFailure)failure;

/**
 * 判断是否支持touchID/FaceID
 */
+ (BOOL)canAuthenticate;
/**
 * 判断是否支持FaceID
 */
+ (BOOL)faceIDAvailable;

@end
