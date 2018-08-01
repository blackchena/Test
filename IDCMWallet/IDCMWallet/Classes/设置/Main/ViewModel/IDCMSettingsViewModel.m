//
//  IDCMSettingsViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2017/12/25.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMSettingsViewModel.h"

@interface IDCMSettingsViewModel ()
@property (nonatomic, strong) NSString    *acceptantState;
@property (nonatomic, strong) NSString    *payMothodState;
@property (nonatomic, strong) NSString    *inviteTitle;
@property (nonatomic, strong) NSString    *inviteSubTitle;
@property (nonatomic, strong) NSString    *inviteIcon;
@property (nonatomic, assign) BOOL        isShow;
@end

@implementation IDCMSettingsViewModel
- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super initWithParams:params]) {
        
        self.acceptantState = @"";
        self.payMothodState = @"";
        self.webLink = @"";
        self.inviteTitle = @"";
        self.inviteSubTitle = @"";
        self.inviteIcon = @"";
        self.isShow = NO;
    }
    return self;
}
- (void)initialize
{
    [super initialize];
    
    self.checkUpdateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSString *input) {
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            
            // 区分客户端类型   1:企业分发   4:App Store
            NSString *clientName = [[IDCMUtilsMethod getBundleIdentifier] isEqualToString:IDCWBudidfeKey] ? @"1" : @"3";
            NSString *url = [NSString stringWithFormat:@"%@?clientName=%@",CheckVersion_URL,clientName];
            IDCMURLSessionTask *task = [IDCMRequestList requestGetNotAuth:url params:nil success:^(NSDictionary *response) {
                
                [subscriber sendNext:response];
                [subscriber sendCompleted];
                
            } fail:^(NSError *error, NSURLSessionDataTask *task) {
                [subscriber sendError:error];
            }];
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
            
        }];
    }];
    
    @weakify(self);
    self.getStatecommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return  [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            IDCMURLSessionTask *task = [IDCMRequestList requestPostAuthNoHUD:OTCAcceptant_URL params:nil success:^(NSDictionary *response) {
                
                @strongify(self);
                NSString *status = [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
                if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
                    //承兑商状态
                    NSString *statusCode = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"Status"]];
                    switch ([statusCode integerValue]) {
                        case 1:
                        {
                            self.acceptantState = SWLocaloziString(@"3.0_AcceptantStateNotPass");
                        }
                            break;
                        case 2:
                        {
                            self.acceptantState = SWLocaloziString(@"3.0_AcceptantStateCheck");
                        }
                            break;
                        case 3:
                        {
                           self.acceptantState = @"";
                        }
                            break;
                        case 4:
                        {
                            self.acceptantState = SWLocaloziString(@"3.0_AcceptantSuspend");
                        }
                            break;
                        default:
                        {
                            self.acceptantState = @"";
                        }
                            break;
                    }
                    //支付方式
                    self.payMothodState = [response[@"data"][@"HasPayment"] boolValue] ? @"" :  SWLocaloziString(@"3.0_AcceptantStateNotset");
                    
                    [subscriber sendNext:nil];
                }else{
                    
                    [IDCMShowMessageView showMessageWithCode:[NSString stringWithFormat:@"%ld",(long)status]];
                }
                [subscriber sendCompleted];
                
            } fail:^(NSError *error, NSURLSessionDataTask *task) {
                [subscriber sendError:error];
            }];
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
            
        }];
    }];
}
- (RACSignal *)executeRequestDataSignal:(id)input{
    
    @weakify(self);
    NSString *url = [NSString idcw_stringWithFormat:@"%@?client=1&lang=%@",GetInviteConfig_URL,[IDCMUtilsMethod getServiceLanguage]];
    return [RACSignal signalGetNoHUDAuth:url serverName:nil params:nil handleSignal:^(id response, id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString *status = [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
        if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
            
            // 标题
            if ([response[@"data"][@"lable_text"] isKindOfClass:[NSString class]]) {
                self.inviteTitle = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"lable_text"]];
            }
            // 副标题
            if ([response[@"data"][@"lable_text2"] isKindOfClass:[NSString class]]) {
                self.inviteSubTitle = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"lable_text2"]];
            }
            // 跳转链接
            if ([response[@"data"][@"link"] isKindOfClass:[NSString class]]) {
                self.webLink = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"link"]];
            }
            // 图片URL
            if ([response[@"data"][@"icon"] isKindOfClass:[NSString class]]) {
                self.inviteIcon = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"icon"]];
            }
            // 是否展示
            if ([response[@"data"][@"is_show"] isKindOfClass:[NSNumber class]]) {
                if ([response[@"data"][@"is_show"] integerValue] == 1) {
                    self.isShow = YES;
                }else{
                    self.isShow = NO;
                }
            }
            [subscriber sendNext:response];
        }
        
        [subscriber sendCompleted];
    }];
}
#pragma mark
#pragma mark - privete method
- (NSMutableArray *)getSettingListArray
{
    NSMutableArray *acount = [[NSMutableArray alloc] init];
    NSMutableArray *payList = [[NSMutableArray alloc] init];
    NSMutableArray *invitation = [[NSMutableArray alloc] init];
    NSMutableArray *list = [[NSMutableArray alloc] init];
    NSMutableArray *listArray = [[NSMutableArray alloc] init];
    
    NSArray *title = @[SWLocaloziString(@"2.2.3_AcountSafe"),
                       SWLocaloziString(@"3.0_Bin_PayTypeManager"),
                       SWLocaloziString(@"3.0_Bin_AcceptanceTitle"),
                       [self.inviteTitle isNotBlank] ? self.inviteTitle : @"",
                       SWLocaloziString(@"2.0_SetCurency"),
                       SWLocaloziString(@"2.0_SetLanguage"),
                       SWLocaloziString(@"2.1_Feedback"),
                       SWLocaloziString(@"2.1_Introduction"),
                       SWLocaloziString(@"2.1_About_App")];
    

    NSArray *detailTitle = @[@"",
                             [self.payMothodState isNotBlank] ? self.payMothodState : @"",
                             [self.acceptantState isNotBlank] ? self.acceptantState : @"",
                             [self.inviteSubTitle isNotBlank] ? self.inviteSubTitle : @"",
                             @"",
                             @"",
                             @"",
                             @"",
                             @""];
    
    NSArray *imageName = @[@"2.2.3_Safe",
                           @"3.0_Bin_PayType",
                           @"3.0_Bin_chengduishang",
                           [self.inviteIcon isNotBlank] ? self.inviteIcon : @"",
                           @"2.2.3_Local",
                           @"2.2.3_Language",
                           @"2.2.3_Relation",
                           @"2.2.3_Introduction",
                           @"2.2.3_About"];
    
    NSArray *className = @[@"IDCMAcountSafeController",
                           @"IDCMPayMethodsManagerController",
                           @"IDCMCheckAcceptantStateController",
                           @"IDCMInvitationViewController",
                           @"IDCMLocalCurrencyController",
                           @"IDCMLocalLanguageController",
                           @"IDCMFeedBackController",
                           @"IDCMIntroductionViewController",
                           @"IDCMContactController"];
    
    NSArray *viewModelName = @[@"IDCMAcountSafeViewModel",
                               @"IDCMPayMethodsManagerViewModel",
                               @"IDCMBaseViewModel",
                               @"IDCMInvitationViewModel",
                               @"IDCMLocalCurrencyViewModel",
                               @"IDCMLocalLanguageViewModel",
                               @"IDCMFeedBackViewModel",
                               @"IDCMIntroductionViewModel",
                               @"IDCMContactViewModel"];

    
    NSString *name = [title objectAtIndex:0];
    NSString *image = [imageName objectAtIndex:0];
    NSString *class = [className objectAtIndex:0];
    NSString *viewModel = [viewModelName objectAtIndex:0];
    NSString *contentName = [detailTitle objectAtIndex:0];
    IDCMSettingListModel *model = [[IDCMSettingListModel alloc] init];
    model.title = name;
    model.viewModel = viewModel;
    model.classString = class;
    model.detailTitle = contentName;
    model.imageName = image;
    [acount addObject:model];
    
    
    for (NSInteger i = 1; i < 3 ; i++) {
        NSString *name = [title objectAtIndex:i];
        NSString *detailName = [detailTitle objectAtIndex:i];
        NSString *image = [imageName objectAtIndex:i];
        NSString *class = [className objectAtIndex:i];
        NSString *viewModel = [viewModelName objectAtIndex:i];
        IDCMSettingListModel *model = [[IDCMSettingListModel alloc] init];
        model.title = name;
        model.detailTitle = detailName;
        model.viewModel = viewModel;
        model.classString = class;
        model.imageName = image;
        [payList addObject:model];
    }
    
    NSString *invitationName = [title objectAtIndex:3];
    NSString *invitationImage = [imageName objectAtIndex:3];
    NSString *invitationClass = [className objectAtIndex:3];
    NSString *invitationViewModel = [viewModelName objectAtIndex:3];
    NSString *initationName = [detailTitle objectAtIndex:3];
    IDCMSettingListModel *invitationModel = [[IDCMSettingListModel alloc] init];
    invitationModel.title = invitationName;
    invitationModel.viewModel = invitationViewModel;
    invitationModel.classString = invitationClass;
    invitationModel.imageName = invitationImage;
    invitationModel.detailTitle = initationName;
    [invitation addObject:invitationModel];
    
    
    for (NSInteger i = 4; i < 6; i++) {
        NSString *name = [title objectAtIndex:i];
        NSString *image = [imageName objectAtIndex:i];
        NSString *class = [className objectAtIndex:i];
        NSString *viewModel = [viewModelName objectAtIndex:i];
        NSString *detailName = [detailTitle objectAtIndex:i];
        IDCMSettingListModel *model = [[IDCMSettingListModel alloc] init];
        model.title = name;
        model.viewModel = viewModel;
        model.classString = class;
        model.imageName = image;
        model.detailTitle = detailName;
        [list addObject:model];
    }
    for (NSInteger i = 6; i < 9; i++) {
        NSString *name = [title objectAtIndex:i];
        NSString *image = [imageName objectAtIndex:i];
        NSString *class = [className objectAtIndex:i];
        NSString *viewModel = [viewModelName objectAtIndex:i];
        NSString *detailName = [detailTitle objectAtIndex:i];
        IDCMSettingListModel *model = [[IDCMSettingListModel alloc] init];
        model.title = name;
        model.imageName = image;
        model.viewModel = viewModel;
        model.classString = class;
        model.detailTitle = detailName;
        [listArray addObject:model];
    }
    
    if ([[IDCMUtilsMethod getBundleIdentifier] isEqualToString:IDCWBudidfeKey]) {  // 企业分发
        
        if (self.isShow) {
            return @[acount,payList,invitation,list,listArray].mutableCopy;
        }else{
            return @[acount,payList,list,listArray].mutableCopy;
        }
        
        
    }else{  // App Store
        
        if ([CommonUtils getBoolValueInUDWithKey:ControlHiddenKey] && self.isShow) {
            return @[acount,invitation,list,listArray].mutableCopy;
        }else if ([CommonUtils getBoolValueInUDWithKey:ControlHiddenKey] && !self.isShow){
            return @[acount,list,listArray].mutableCopy;
        }else if (![CommonUtils getBoolValueInUDWithKey:ControlHiddenKey] && self.isShow){
            return @[acount,payList,invitation,list,listArray].mutableCopy;
        }else{
            return @[acount,payList,list,listArray].mutableCopy;
        }
    }
}

@end
