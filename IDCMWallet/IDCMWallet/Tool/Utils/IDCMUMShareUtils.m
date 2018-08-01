//
//  IDCMUMShareUtils.m
//  IDCMWallet
//
//  Created by BinBear on 2018/7/2.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMUMShareUtils.h"


/*********  配置类  ***********/
@interface IDCMUMShareUtilsConfig ()
/**
 *  分享类型
 */
@property (assign, nonatomic) IDCMShareType share_Type;
/**
 *  分享的第三方平台
 */
@property (assign, nonatomic) UMSocialPlatformType share_PlatformType;
/**
 *  分享的标题
 */
@property (strong, nonatomic) id share_Title;
/**
 *  分享的副标题
 */
@property (strong, nonatomic) id share_SubTitle;
/**
 *  分享的文本
 */
@property (strong, nonatomic) id share_Text;
/**
 *  分享的缩略图片
 */
@property (strong, nonatomic) id share_thumbImage;
/**
 *  分享的大图片
 */
@property (strong, nonatomic) id share_Image;
/**
 *  分享的网页链接
 */
@property (strong, nonatomic) id share_WebLink;
@end

@implementation IDCMUMShareUtilsConfig

- (shareUtilsTypeBlock)shareType{
    shareUtilsTypeBlock block = ^(NSInteger value){
        if (value) {
            _share_Type = value;
        }
        return self;
    };
    return block;
}
- (shareUtilsTypeBlock)sharePlatformType{
    shareUtilsTypeBlock block = ^(NSInteger value){
        if (value) {
            _share_PlatformType = value;
        }
        return self;
    };
    return block;
}
- (shareUtilsObjectBlock)shareText{
    
    shareUtilsObjectBlock block = ^(id value){
        if (value || [value isKindOfClass:[NSString class]]) {
            _share_Text = value;
        }else{
            DDLogDebug(@"分享文本类型不对");
        }
        return self;
    };
    return block;
}
- (shareUtilsObjectBlock)shareTitle{
    
    shareUtilsObjectBlock block = ^(id value){
        if (value || [value isKindOfClass:[NSString class]]) {
            _share_Title = value;
        }else{
            DDLogDebug(@"分享文本类型不对");
        }
        return self;
    };
    return block;
}
- (shareUtilsObjectBlock)shareSubTitle{
    shareUtilsObjectBlock block = ^(id value){
        if (value || [value isKindOfClass:[NSString class]]) {
            _share_SubTitle = value;
        }else{
            DDLogDebug(@"分享文本类型不对");
        }
        return self;
    };
    return block;
}
- (shareUtilsObjectBlock)shareThumbImage{
    shareUtilsObjectBlock block = ^(id value){
        if (value && [value isKindOfClass:[NSString class]]) {
            if ([value hasPrefix:@"https"] || [value hasPrefix:@"http"]) {
                _share_thumbImage = value;
            }else {
                _share_thumbImage = UIImageMake(value);
            }
        }else if([value isKindOfClass:[UIImage class]]){
            _share_thumbImage = value;
        }else{
            DDLogDebug(@"分享图片类型不对");
        }
        return self;
    };
    return block;
}
- (shareUtilsObjectBlock)shareImage{
    shareUtilsObjectBlock block = ^(id value){
        if (value && [value isKindOfClass:[NSString class]]) {
            if ([value hasPrefix:@"https"] || [value hasPrefix:@"http"]) {
                _share_Image = value;
            }else {
                _share_Image = UIImageMake(value);
            }
        }else if([value isKindOfClass:[UIImage class]]){
            _share_Image = value;
        }else{
            DDLogDebug(@"分享图片类型不对");
        }
        return self;
    };
    return block;
}
- (shareUtilsObjectBlock)shareWebLink{
    
    shareUtilsObjectBlock block = ^(id value){
        if (value && [value isKindOfClass:[NSString class]]) {
            _share_WebLink = value;
        }else{
            DDLogDebug(@"分享网页URL类型不对");
        }
        return self;
    };
    return block;
}
@end



/*********  分享工具类  ***********/
@interface IDCMUMShareUtils ()
/**
 *  配置Block
 */
@property (copy, nonatomic) shareConfigBlock shareBlock;
/**
 *  配置类
 */
@property (strong, nonatomic) IDCMUMShareUtilsConfig *shareConfigClass;
@end

@implementation IDCMUMShareUtils

#pragma mark - Public Methods
+ (void)configUMShareInfo{
    
    NSString *UmengKey =  @"";
    NSString *WeChatKey = @"";
    NSString *WeChatSecret = @"";
    NSString *QQKey = @"";
    NSString *SinaKey = @"";
    NSString *SinaSecret = @"";
    NSString *TwitterKey = @"";
    NSString *TwitterSecret = @"";
    NSString *FacebookKey = @"";
    NSString *FacebookSecret = @"";
    
    if ([[IDCMUtilsMethod getBundleIdentifier] isEqualToString:IDCWBudidfeKey]) { // 企业分发
        UmengKey = IDCWEnterpriseUmengKey;
        WeChatKey = IDCWEnterpriseWeChatShareKey;
        WeChatSecret = IDCWEnterpriseWeChatShareSecret;
        QQKey = IDCWEnterpriseQQShareKey;
        SinaKey = IDCWEnterpriseSinaShareKey;
        SinaSecret = IDCWEnterpriseSinaShareSecret;
        TwitterKey = IDCWEnterpriseTwitterShareKey;
        TwitterSecret = IDCWEnterpriseTwitterShareSecret;
        FacebookKey = IDCWEnterpriseFaceBookShareKey;
        FacebookSecret = IDCWEnterpriseFaceBookShareSecret;
    }else{  // App Store
        UmengKey = IDCWAppStoreUmengKey;
        WeChatKey = IDCWAppStoreWeChatShareKey;
        WeChatSecret = IDCWAppStoreWeChatShareSecret;
        QQKey = IDCWAppStoreQQShareKey;
        SinaKey = IDCWAppStoreSinaShareKey;
        SinaSecret = IDCWAppStoreSinaShareSecret;
        TwitterKey = IDCWAppStoreTwitterShareKey;
        TwitterSecret = IDCWAppStoreTwitterShareSecret;
        FacebookKey = IDCWAppStoreFaceBookShareKey;
        FacebookSecret = IDCWAppStoreFaceBookShareSecret;
    }
    [UMConfigure initWithAppkey:UmengKey channel:@"App Store"];
    // 微信
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WeChatKey appSecret:WeChatSecret redirectURL:nil];
    // QQ
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQKey appSecret:nil redirectURL:nil];
    // 新浪
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:SinaKey  appSecret:SinaSecret redirectURL:IDCMWebURL];
    // Twitter
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Twitter appKey:TwitterKey  appSecret:TwitterSecret redirectURL:nil];
    // Facebook
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Facebook appKey:FacebookKey  appSecret:nil redirectURL:nil];
    // 配置友盟分享可分享http
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}
+ (instancetype)shareInfoConfigure:(shareConfigBlock)configure{
    
    IDCMUMShareUtils *utils = [[self alloc] init];
    IDCMUMShareUtilsConfig *config = [[IDCMUMShareUtilsConfig alloc] init];
    if (configure) {
        configure(config);
    }
    utils.shareBlock = configure;
    utils.shareConfigClass = config;
    
    return utils;
}
+ (BOOL)isClientInstalled:(UMSocialPlatformType)platformType{
    
    if (platformType == UMSocialPlatformType_Twitter) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterauth://"]]) {
            return YES;
        }else{
            return NO;
        }
    }else if (platformType == UMSocialPlatformType_UserDefine_Begin){
        return YES;
    }else{
        return [[UMSocialManager defaultManager] isInstall:platformType];
    }
}
- (void)sharePlatform{
    
    [IDCMBaseBottomTipView dismissWithCompletion:nil];
    
    // 创建分享对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    // 创建文本内容对象
    UMShareObject *shareObject = [[UMShareObject alloc] init];
    // 创建图片内容对象
    UMShareImageObject *shareImageObject = [[UMShareImageObject alloc] init];
    // 创建图片内容对象
    UMShareWebpageObject *shareWebObject = [[UMShareWebpageObject alloc] init];
    
    if (self.shareConfigClass.share_thumbImage) { // 缩略图
        shareObject.thumbImage = self.shareConfigClass.share_thumbImage;
        shareImageObject.thumbImage = self.shareConfigClass.share_thumbImage;
        shareWebObject.thumbImage = self.shareConfigClass.share_thumbImage;
    }
    if (self.shareConfigClass.share_Image) { // 大图
        shareImageObject.shareImage = self.shareConfigClass.share_Image;
    }
    if ([self.shareConfigClass.share_Title isNotBlank]) { // 标题
        shareObject.title = self.shareConfigClass.share_Title;
        shareImageObject.title = self.shareConfigClass.share_Title;
        shareWebObject.title = self.shareConfigClass.share_Title;
    }
    if ([self.shareConfigClass.share_SubTitle isNotBlank]) { // 副标题
        shareObject.descr = self.shareConfigClass.share_SubTitle;
        shareImageObject.descr = self.shareConfigClass.share_SubTitle;
        shareWebObject.descr = self.shareConfigClass.share_SubTitle;
    }
    if ([self.shareConfigClass.share_WebLink isNotBlank]) { // 网页链接
        shareWebObject.webpageUrl = self.shareConfigClass.share_WebLink;
    }

    
    switch (self.shareConfigClass.share_Type) {
        case kIDCMShareTypePlainText: // 分享纯文本
        {
            messageObject.shareObject = shareObject;
        }
            break;
        case kIDCMShareTypeLocalSingleImage: // 分享本地单张图片
        case kIDCMShareTypeLocalMultipleImage: // 分享本地多张图片
        case kIDCMShareTypeNetworkImage: // 分享网络图片
        case kIDCMShareTypeTextImage: // 分享图片和文字
        {
            messageObject.shareObject = shareImageObject;
            if ([self.shareConfigClass.share_Text isNotBlank]) {
                messageObject.text = self.shareConfigClass.share_Text;
            }
        }
            break;
            
        default: // 分享链接
        {
            messageObject.shareObject = shareWebObject;
        }
            break;
    }
    

    if (self.shareConfigClass.share_PlatformType == UMSocialPlatformType_Twitter) { // Twitter调用原生
        if ([IDCMUMShareUtils isClientInstalled:UMSocialPlatformType_Twitter]) {
            // 已安装Twitter
            [self shareTwitter];
        }else{
            // 未安装Twitter
            [self webLinkShareWithSafari];
        }
    }else if(self.shareConfigClass.share_PlatformType == UMSocialPlatformType_UserDefine_Begin){ // Telegerm
        [self webLinkShareWithSafari];
    }else{
        
        //调用分享
        [[UMSocialManager defaultManager] shareToPlatform:self.shareConfigClass.share_PlatformType messageObject:messageObject currentViewController:[IDCMUtilsMethod currentViewController] completion:^(id data, NSError *error) {
            
            if (error) {
                DDLogDebug(@"%s, 分享失败, error:%@", __FUNCTION__, error);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    DDLogDebug(@"%s, 分享结果消息:%@", __FUNCTION__, resp.message);
                    DDLogDebug(@"%s, 第三方原始返回的数据:%@", __FUNCTION__, resp.originalResponse);
                }else{
                    DDLogDebug(@"%s, 分享结果:%@", __FUNCTION__, data);
                }
            }
        }];
    }
    
}

#pragma mark - Privater Methods
- (void)shareTwitter{
    
    if ([[Twitter sharedInstance].sessionStore hasLoggedInUsers]) {
        [self twitterConfig];
    }else{
        [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
            if (session) {
                [self twitterConfig];
            } else {
                DDLogDebug(@"%s, 登录失败, error:%@", __FUNCTION__, error);
            }
        }];
    }
}
- (void)twitterConfig{
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    [composer setText:[self.shareConfigClass.share_Title isNotBlank] ? self.shareConfigClass.share_Title : @"IDC Wallet"];
    [composer setImage:nil];
    [composer setURL:[NSURL URLWithString:[self.shareConfigClass.share_WebLink isNotBlank] ? self.shareConfigClass.share_WebLink : IDCMWebURL]];
    [composer showFromViewController:[IDCMUtilsMethod currentViewController] completion:^(TWTRComposerResult result){
        if(result == TWTRComposerResultCancelled) {
            //分享失败
        }else{
            //分享成功
        }
    }];
}
- (void)webLinkShareWithSafari{
    NSString *urlString = @"";
    if (self.shareConfigClass.share_PlatformType == UMSocialPlatformType_UserDefine_Begin) {
        urlString = [NSString idcw_stringWithFormat:@"https://telegram.me/share/url?url=%@&text=%@",self.shareConfigClass.share_WebLink,[self.shareConfigClass.share_Title stringByURLEncode]];
    }else if (self.shareConfigClass.share_PlatformType == UMSocialPlatformType_Twitter){
        urlString = [NSString idcw_stringWithFormat:@"https://twitter.com/intent/tweet?&text=%@&url=%@",[self.shareConfigClass.share_Title stringByURLEncode],self.shareConfigClass.share_WebLink];
    }else if (self.shareConfigClass.share_PlatformType == UMSocialPlatformType_Facebook){
        urlString = [NSString idcw_stringWithFormat:@"https://www.facebook.com/sharer.php?m2w&s=100&p[title]=%@&p[summary]=%@&p[url]=%@&p[images][0]=%@",[self.shareConfigClass.share_Title stringByURLEncode],[self.shareConfigClass.share_SubTitle stringByURLEncode],self.shareConfigClass.share_WebLink,self.shareConfigClass.share_Image];
    }

    if (@available(iOS 10,*)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
        }];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
}
@end
