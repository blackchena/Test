//
//  IDCMInvitationViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/7/2.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMInvitationViewModel.h"

@interface IDCMInvitationViewModel ()

@end

@implementation IDCMInvitationViewModel
#pragma mark - Life Cycle
- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super initWithParams:params]) {
        self.webLink = params[@"WebLink"];
    }
    return self;
}
- (void)initialize
{
    [super initialize];
    
    NSArray *arr = @[RACTuplePack(@"3.0_Bin_Wechat",SWLocaloziString(@"3.0_Bin_ShareWechat"),@(UMSocialPlatformType_WechatSession)),
                     RACTuplePack(@"3.0_Bin_Moments",SWLocaloziString(@"3.0_Bin_ShareMoments"),@(UMSocialPlatformType_WechatTimeLine)),
                     RACTuplePack(@"3.0_Bin_weibo",SWLocaloziString(@"3.0_Bin_ShareWeibo"),@(UMSocialPlatformType_Sina)),
                     RACTuplePack(@"3.0_Bin_twitter",SWLocaloziString(@"3.0_Bin_ShareTwitter"),@(UMSocialPlatformType_Twitter)),
                     RACTuplePack(@"3.0_Bin_facebook",SWLocaloziString(@"3.0_Bin_ShareFacebook"),@(UMSocialPlatformType_Facebook)),
                     RACTuplePack(@"3.0_Bin_telegram",SWLocaloziString(@"3.0_Bin_ShareTelegram"),@(UMSocialPlatformType_UserDefine_Begin))];
    
    self.shareItemSignal = [RACSignal return:arr];
    
    @weakify(self);
    self.shareCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(RACTuple *tupe) {
        
        if ([tupe.third integerValue] == UMSocialPlatformType_WechatSession || [tupe.third integerValue] == UMSocialPlatformType_WechatTimeLine) {
            if (![IDCMUMShareUtils isClientInstalled:UMSocialPlatformType_WechatSession] || ![IDCMUMShareUtils isClientInstalled:UMSocialPlatformType_WechatTimeLine]) {
                
                [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"3.0_Bin_InstallWeChat")];
                
            }
        }
        IDCMUMShareUtils *shareUtils = [IDCMUMShareUtils shareInfoConfigure:^(IDCMUMShareUtilsConfig *configure) {
            @strongify(self);
            configure.sharePlatformType([tupe.third integerValue])
            .shareType(kIDCMShareTypeLink)
            .shareWebLink(self.shareURL)
            .shareTitle(self.shareTitle)
            .shareSubTitle(self.shareSubTitle)
            .shareThumbImage(self.shareImage)
            .shareImage(self.shareImage);
        }];
        [shareUtils sharePlatform];
        
        return [RACSignal empty];
    }];
}

@end
