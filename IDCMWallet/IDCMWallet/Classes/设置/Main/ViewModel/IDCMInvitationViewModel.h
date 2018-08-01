//
//  IDCMInvitationViewModel.h
//  IDCMWallet
//
//  Created by BinBear on 2018/7/2.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseViewModel.h"

@interface IDCMInvitationViewModel : IDCMBaseViewModel
/**
 *   邀请页面打开链接
 */
@property (copy, nonatomic) NSString *webLink;
/**
 *   分享的URL
 */
@property (copy, nonatomic) NSString *shareURL;
/**
 *   分享的标题
 */
@property (copy, nonatomic) NSString *shareTitle;
/**
 *   分享的描述
 */
@property (copy, nonatomic) NSString *shareSubTitle;
/**
 *   分享的图片
 */
@property (copy, nonatomic) NSString *shareImage;
/**
 *  分享邀请好友
 */
@property (strong, nonatomic) RACCommand *shareCommand;
/**
 *  分享第三方数据信号
 */
@property (strong, nonatomic) RACSignal *shareItemSignal;

@end
