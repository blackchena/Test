//
//  IDCMOTCExchangeDetailStateInfoView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/9.
//  Copyright © 2018年 BinBear. All rights reserved.
//


#import "IDCMOTCExchangeDetailStateInfoView.h"
#import "IDCMOTCExchangeDetailViewModel.h"
#import "IDCMSelectPhotosView.h"


@implementation NoHighlightedButton
- (void)setHighlighted:(BOOL)highlighted{};
@end


@interface IDCMOTCExchangeDetailStateInfoView ()

@property (nonatomic,strong) UIView *centerView;
@property (nonatomic,strong) UILabel *timerLabel;
@property (nonatomic,strong) UIButton *phoneBtn;

@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UIButton *centerBtn;
@property (nonatomic,strong) UILabel *centerLabel;
// 申诉图片View
@property (nonatomic,strong) UIView *selectPhotoView;
@property (nonatomic,strong) UIButton *uploadPhotoBtn;
@property (nonatomic,strong) UILabel *selectPhotoTipLabel;
@property (nonatomic,strong) IDCMSelectPhotosView *photoView;

@property (nonatomic,weak) IDCMOTCExchangeDetailViewModel *viewModel;
@property (nonatomic,strong) RACSubject *refreshInfoViewSignal;
@end


@implementation IDCMOTCExchangeDetailStateInfoView

+ (instancetype)detailStateInfoViewWithViewModel:(IDCMOTCExchangeDetailViewModel *)viewModel
                                animationCommand:(RACCommand *)animationCommand
                           refreshInfoViewSignal:(RACSubject *)refreshInfoViewSignal {
    IDCMOTCExchangeDetailStateInfoView *view = [[self alloc] init];
    view.size = CGSizeMake(SCREEN_WIDTH, viewModel.bottomStateViewHeight);
    view.viewModel = viewModel;
    [view initConfigure];
    view.refreshInfoViewSignal = refreshInfoViewSignal;
    view.bottomBtn.rac_command = animationCommand;
    view.bottomBtn.selected = NO;
    return view;
}

- (void)initConfigure {
    [self configUI];
    [self refreshStateIsfirst:YES];
    [self configSignal];
    [self configViewModel];
}

- (void)configViewModel {
    @weakify(self);
    void(^subscribeState)(id) = ^(id x){
        @strongify(self);
        if (self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_DoingDelay ||
            self.viewModel.detailModel.exchangeSellStateType == OTCExchangeSellStateType_DoingDelay) {
            [self handleTimeOut];
        } else {
            [self refreshStateIsfirst:NO];
        }
    };
    if (self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_DoingDelay ||
        self.viewModel.detailModel.exchangeSellStateType == OTCExchangeSellStateType_DoingDelay) {
        [self handleTimeOut];
    }
    if (self.viewModel.detailModel.exchangeType == OTCExchangeType_Buy) {
        [[[RACObserve(self.viewModel.detailModel, exchangeBuyStateType) skip:1] distinctUntilChanged]
         subscribeNext:subscribeState];
    } else {
        [[[RACObserve(self.viewModel.detailModel, exchangeSellStateType) skip:1] distinctUntilChanged]
         subscribeNext:subscribeState];
    }
    RAC(self.timerLabel, text) =  RACObserve(self.viewModel.detailModel, timeCountDownString);
}

- (void)handleTimeOut {
    @weakify(self);
    [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
        [configure.getBtnsConfig removeFirstObject];
        configure.image(@"3.2_时间到")
        .title(NSLocalizedString(@"3.0_Bin_RestTimeOver", nil))
        .subTitle(NSLocalizedString(@"3.0_Hy_OTCExchangeDetailHandleDelay", nil))
        .getBtnsConfig
        .firstObject
        .btnTitle(NSLocalizedString(@"3.0_IKnow", nil))
        .btnCallback(^{
            @strongify(self);
            if (self.viewModel.detailModel.exchangeType == OTCExchangeType_Buy) {
                self.viewModel.detailModel.exchangeBuyStateType = OTCExchangeBuyStateType_Cancelled;
            } else {
                self.viewModel.detailModel.exchangeSellStateType = OTCExchangeSellStateType_Cancelled;
            }
        });
    }];
}

- (void)configUI {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.centerView];
    [self addSubview:self.bottomBtn];
}

- (void)refreshStateIsfirst:(BOOL)isfirst {
    @weakify(self);
    CGFloat currentHeight = self.height;
    self.viewModel.detailModel.exchangeType == OTCExchangeType_Buy ?
    ({
        switch (self.viewModel.detailModel.exchangeBuyStateType) {
            case OTCExchangeBuyStateType_Doing:
            case OTCExchangeBuyStateType_DoingDelay:
            case OTCExchangeBuyStateType_DoingSetDelay:
            case OTCExchangeBuyStateType_Appeal:
            case OTCExchangeBuyStateType_AppealDelay:{
                [self refreshInfoViewWithArray:@[@1, @1, @1, @1, @0, @0, @0, @1]];
                [self.leftBtn setTitle:self.viewModel.bottomStateBtnTitles.firstObject forState:UIControlStateNormal];
                [self.rightBtn setTitle:self.viewModel.bottomStateBtnTitles.lastObject forState:UIControlStateNormal];
            }break;
            case OTCExchangeBuyStateType_Payed:
            case OTCExchangeBuyStateType_PayedHandleDelay:{
                [self refreshInfoViewWithArray:@[@1, @1, @0, @0, @0, @0, @0, @1]];
            }break;
            case OTCExchangeBuyStateType_AppealDoing:
            case OTCExchangeBuyStateType_AppealDoingDelay: {
                self.photoView.isShow = NO;
                [self refreshInfoViewWithArray:@[@1, @1, @0, @0, @0, @1, @1, @1]];
                 self.selectPhotoTipLabel.text = self.viewModel.bottomStateBtnTitles.lastObject;
            }break;
            case OTCExchangeBuyStateType_AppealCheching:{
                [self refreshInfoViewWithArray:@[@0, @0, @0, @0, @0, @0, @1, @1]];
                self.photoView.isShow = YES;
                [self.photoView
                 reloadWithPhotoUrlArray:self.viewModel.detailModel.CertificateImages canDelete:NO];
                [[RACScheduler mainThreadScheduler] afterDelay:.05 schedule:^{
                    @strongify(self);
                    [self.photoView scorllToCenterWithAnimated:NO];
                }];
            }break;
            case OTCExchangeBuyStateType_AppealCheched:{
                [self refreshInfoViewWithArray:@[@0, @0, @0, @0, @0, @0, @1, @0]];
                 self.photoView.isShow = YES;
                [self.photoView
                 reloadWithPhotoUrlArray:self.viewModel.detailModel.CertificateImages canDelete:NO];
                [[RACScheduler mainThreadScheduler] afterDelay:.05 schedule:^{
                    @strongify(self);
                    [self.photoView scorllToCenterWithAnimated:NO];
                }];
            }break;
            case OTCExchangeBuyStateType_Completed:
            case OTCExchangeBuyStateType_Cancelled: {
                [self refreshInfoViewWithArray:@[@0, @0, @0, @0, @0, @0, @0, @0]];
            }break;
            default:
            break;
        }
    }):({
        switch (self.viewModel.detailModel.exchangeSellStateType) {
            case OTCExchangeSellStateType_Doing:
            case OTCExchangeSellStateType_DoingDelay:{
                [self refreshInfoViewWithArray:@[@1, @1, @0, @0, @1, @0, @0, @1]];
                [self.centerBtn setTitle:self.viewModel.bottomStateBtnTitles.firstObject
                                forState:UIControlStateNormal];
            }break;
            case OTCExchangeSellStateType_DoingSetDelay:{
                [self refreshInfoViewWithArray:@[@1, @1, @0, @0, @0, @1, @0, @1]];
                self.centerLabel.text = self.viewModel.bottomStateBtnTitles.lastObject;
            }break;
            case OTCExchangeSellStateType_Cancelled:
            case OTCExchangeSellStateType_Completed:
            case OTCExchangeSellStateType_AppealCheched:{
                [self refreshInfoViewWithArray:@[@0, @0, @0, @0, @0, @0, @0, @0]];
            }break;
            case OTCExchangeSellStateType_Payed:
            case OTCExchangeSellStateType_PayedHandleDelay:{
                [self refreshInfoViewWithArray:@[@1, @1, @1, @1, @0, @0, @0, @1]];
                [self.leftBtn setTitle:self.viewModel.bottomStateBtnTitles.firstObject forState:UIControlStateNormal];
                [self.rightBtn setTitle:self.viewModel.bottomStateBtnTitles.lastObject forState:UIControlStateNormal];
            }break;
            case OTCExchangeSellStateType_AppealDoing:
            case OTCExchangeSellStateType_AppealDelay:
            case OTCExchangeSellStateType_AppealUploadWaitting:
            case OTCExchangeSellStateType_AppealUploadWaitDelay:{
                [self refreshInfoViewWithArray:@[@1, @1, @0, @0, @0, @0, @0, @1]];
            }break;
            case OTCExchangeSellStateType_AppealUploadedCheckPicture:{
                [self refreshInfoViewWithArray:@[@0, @0, @0, @0, @0, @0, @1, @1]];
                self.photoView.isShow = YES;
                [self.photoView
                 reloadWithPhotoUrlArray:self.viewModel.detailModel.CertificateImages canDelete:NO];
                [[RACScheduler mainThreadScheduler] afterDelay:.05 schedule:^{
                    @strongify(self);
                    [self.photoView scorllToCenterWithAnimated:NO];
                }];
            }break;
            case OTCExchangeSellStateType_AppealCheckPictureCompleted:{
                [self refreshInfoViewWithArray:@[@0, @0, @0, @0, @0, @0, @1, @0]];
                self.photoView.isShow = YES;
                [self.photoView
                 reloadWithPhotoUrlArray:self.viewModel.detailModel.CertificateImages canDelete:NO];
                [[RACScheduler mainThreadScheduler] afterDelay:.05 schedule:^{
                    @strongify(self);
                    [self.photoView scorllToCenterWithAnimated:NO];
                }];
            }break;
            default:
            break;
        }
    });
    [UIView animateWithDuration:isfirst ? 0.0 : .25
                     animations:^{
                         @strongify(self);
                         self.centerView.height = self.viewModel.bottomStateViewHeight - self.bottomBtn.height;
                         self.bottomBtn.bottom = self.viewModel.bottomStateViewHeight;
                     } completion:nil];
    
    if (!isfirst) {
       [self.refreshInfoViewSignal sendNext:@(self.viewModel.bottomStateViewHeight - currentHeight)];
    }
}

- (void)photoScorllToCenter {
    if (self.viewModel.detailModel.exchangeType == OTCExchangeType_Buy) {
        if (self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_AppealCheching ||
            self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_AppealCheched) {
             [self.photoView scorllToCenterWithAnimated:NO];
        }
    } else {
        if (self.viewModel.detailModel.exchangeSellStateType == OTCExchangeSellStateType_AppealUploadedCheckPicture ||
            self.viewModel.detailModel.exchangeSellStateType == OTCExchangeSellStateType_AppealCheckPictureCompleted) {
            [self.photoView scorllToCenterWithAnimated:NO];
        }
    }
}

- (void)refreshInfoViewWithArray:(NSArray *)array {
    self.timerLabel.hidden = ![array.firstObject boolValue];
    self.phoneBtn.hidden = ![array[1] boolValue];
    self.leftBtn.hidden = ![array[2] boolValue];
    self.rightBtn.hidden = ![array[3] boolValue];
    self.centerBtn.hidden = ![array[4] boolValue];
    self.centerLabel.hidden = ![array[5] boolValue];
    self.selectPhotoView.hidden = ![array[6] boolValue];
    self.bottomBtn.hidden = ![array.lastObject boolValue];
    
    BOOL canBuy = self.viewModel.detailModel.exchangeType == OTCExchangeType_Buy &&
    (self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_AppealCheching||
     self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_AppealCheched);
    
    BOOL sellBuy = self.viewModel.detailModel.exchangeType == OTCExchangeType_Sell &&
    (self.viewModel.detailModel.exchangeSellStateType == OTCExchangeSellStateType_AppealUploadedCheckPicture||
     self.viewModel.detailModel.exchangeSellStateType == OTCExchangeSellStateType_AppealCheckPictureCompleted);
    
    if (canBuy || sellBuy) {
        self.uploadPhotoBtn.hidden = YES;
        self.selectPhotoView.top = self.timerLabel.top;
        self.photoView.centerX = self.selectPhotoView.width / 2;
        self.photoView.top = 0;
    } else {
        self.selectPhotoView.top = self.centerBtn.top;
        self.photoView.left = 0;
        self.photoView.top = 0;
        if (self.viewModel.detailModel.exchangeType == OTCExchangeType_Buy &&
            (self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_AppealDoing ||
             self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_AppealDoingDelay)){
            self.uploadPhotoBtn.hidden = NO;
        } else {
            self.uploadPhotoBtn.hidden = YES;
        }
    }
}

- (void)configSignal {
    @weakify(self);

#pragma mark — 上传图片
    self.photoView.addPhotoCallback = ^(NSArray *photos) {
        @strongify(self);
        self.selectPhotoTipLabel.hidden = self.photoView.originPhotoImageArray.count;
        self.uploadPhotoBtn.enabled = self.photoView.originPhotoImageArray.count;
    };
    self.photoView.deletePhotoCallback = ^(NSInteger index) {
        @strongify(self);
        self.selectPhotoTipLabel.hidden = self.photoView.originPhotoImageArray.count;
        self.uploadPhotoBtn.enabled = self.photoView.originPhotoImageArray.count;
    };
    [[[self.uploadPhotoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(UIControl *x) {
         @strongify(self);
         [self.superview.superview endEditing:YES];
         [self.viewModel.uploadPayCertificateCommand
          execute:self.photoView.thumbnailPhotoImageArray];
     }];
    
#pragma mark — 打电话
    [[[self.phoneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(UIControl *x) {
         @strongify(self);
         NSString *mobile = self.viewModel.detailModel.customerPhone;
         [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
             configure.title(NSLocalizedString(@"3.0_Hy_OTCExchangeDetailOtherPhone", nil))
             .subTitle(mobile)
             .getBtnsConfig.lastObject
             .btnTitle(NSLocalizedString(@"3.0_Hy_OTCExchangeDetailCallPhone", nil))
             .btnCallback(^{
                 @strongify(self);
                 [self.superview.superview endEditing:YES];
                 [[UIApplication sharedApplication]
                  openURL:[NSURL URLWithString:
                          [NSString stringWithFormat:@"tel:%@", mobile]]];
             });
         }];
     }];

#pragma mark — 卖家延长时间
    [[[self.centerBtn rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(UIControl *x) {
         @strongify(self);
         [self.superview.superview endEditing:YES];
         [self.viewModel.setDelayConfirmCommand execute:nil];
     }];
    
    subscribeBlock (^subscribe)(NSNumber *number) = ^(NSNumber *number){
        @strongify(self);
        return ^(UIButton *btn){
            @strongify(self);
            [self.superview.superview endEditing:YES];
            [number boolValue] ?
            ({
                self.viewModel.detailModel.exchangeType == OTCExchangeType_Buy ?
                ({
                    if (self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_Doing ||
                        self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_DoingSetDelay) {
                        
                        [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
                            configure.title(NSLocalizedString(@"3.0_Hy_OTCExchangeDetailSurePayTitle", nil))
                            .subTitle(NSLocalizedString(@"3.0_Hy_OTCExchangeDetailSurePaySubTitle", nil))
                            .getBtnsConfig.lastObject.btnCallback(^{
#pragma mark —  买家设置已经转账
                                @strongify(self);
                                [self.viewModel.setTransferCommand execute:nil];
                            });
                        }];
                    } else {
#pragma mark —  买家点击上传凭证
                        [self.viewModel.setAppealingCommand execute:nil];
                    }
                }):
                ({
                    if (self.viewModel.detailModel.exchangeSellStateType == OTCExchangeSellStateType_Payed || self.viewModel.detailModel.exchangeSellStateType == OTCExchangeSellStateType_PayedHandleDelay) {
                        [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
                            configure.title(NSLocalizedString(@"3.0_Hy_OTCExchangeDetailSellReciveTitle", nil))
                            .subTitle(NSLocalizedString(@"3.0_Hy_OTCExchangeDetailSellReciveSubTitle", nil))
                            .getBtnsConfig.lastObject.btnCallback(^{
#pragma mark —   卖家确认收款
                                @strongify(self);
                                [self.viewModel.confirmArrivedCommand execute:nil];
                            });
                        }];
                    }
                });
            }):({
                self.viewModel.detailModel.exchangeType == OTCExchangeType_Buy ?
                ({
                    if (self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_Doing ||
                        self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_DoingSetDelay) {
                        IDCMSysSettingModel *set = [IDCMDataManager sharedDataManager].settingModel;
                        NSString *title = SWLocaloziString(@"3.0_WorkStation_CancelOrder");
                        NSString *str1 = [NSString stringWithFormat:@"%zd",[IDCMDataManager sharedDataManager].cancelCount];
                        NSString * language = [IDCMUtilsMethod getPreferredLanguage];
                        if ([language isEqualToString:@"en"]) {
                            NSInteger index = MAX(1, [IDCMDataManager sharedDataManager].cancelCount);
                            if(index < 4){
                                str1 = @[@"1st",@"2nd",@"3rd"][index-1];
                            }
                            else{
                                str1 = [NSString stringWithFormat:@"%zdth",index];
                            }
                        }
                        NSString *str2 = [NSString stringWithFormat:@"%zd",set.AllowCancelOrderDuration];
                        NSString *str3 = [NSString stringWithFormat:@"%zd",set.AllowCancelOrderCount];
                        NSString *str4 = [NSString stringWithFormat:@"%zd",set.CancelOrderForbidTradeDuration];
                        NSString *subTitle = [[[[[NSString stringWithFormat:SWLocaloziString(@"3.0_WorkStation_CancelOrderTip")]
                                                 stringByReplacingOccurrencesOfString:@"[IDC1]" withString:str1]
                                                stringByReplacingOccurrencesOfString:@"[IDC2]" withString:str2]
                                               stringByReplacingOccurrencesOfString:@"[IDC3]" withString:str3]
                                              stringByReplacingOccurrencesOfString:@"[IDC4]" withString:str4] ;
                        [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
                            configure.getBtnsConfig.firstObject.btnTitle(SWLocaloziString(@"3.0_jw_No"));
                            configure
                            .title(title)
                            .subTitle(subTitle)
                            .getBtnsConfig.lastObject.btnTitle(SWLocaloziString(@"3.0_jw_Yes")).btnCallback(^{
#pragma mark —   买家还未转账 买家取消订单
                                @strongify(self);
                                [self.viewModel.cancelOrderCommand execute:nil];
                            });
                        }];
                    }
                    if (self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_Appeal ||
                        self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_AppealDelay) {
                        
                        [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
                            configure.getBtnsConfig.firstObject.btnTitle(SWLocaloziString(@"3.0_jw_No"));
                            configure
                            .title(SWLocaloziString(@"3.0_WorkStation_CancelOrder"))
                            .subTitle(SWLocaloziString(@"3.0_Hy_OTCExchangeDetailCancelSubTitle"))
                            .getBtnsConfig.lastObject.btnTitle(SWLocaloziString(@"3.0_jw_Yes")).btnCallback(^{
#pragma mark —   卖家提起申述 买家取消订单
                                @strongify(self);
                                [self.viewModel.cancelOrderCommand execute:nil];
                            });
                        }];
                    }
                }):
                ({
                    if (self.viewModel.detailModel.exchangeSellStateType == OTCExchangeSellStateType_Payed ||
                        self.viewModel.detailModel.exchangeSellStateType == OTCExchangeSellStateType_PayedHandleDelay) {
#pragma mark — 买家已经转账 卖家提请申述
                        [self.viewModel.applyAppealCommand execute:nil];
                    }
                });
            });
        };
    };
    
    [[[self.leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:subscribe(@0)];
    [[[self.rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:subscribe(@1)];
}

- (UIView *)centerView {
    return SW_LAZY(_centerView, ({
        
        UIView *view = [[UIView alloc] init];
        view.size = CGSizeMake(SCREEN_WIDTH - 24, 90);
        view.left = 12;
        view.top = 8;
        
        UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [phoneBtn setImage:[UIImage imageNamed:@"3.2_detail_iphone"]
                  forState:UIControlStateNormal];
        phoneBtn.size = CGSizeMake(28, 28);
        phoneBtn.top = 5;
        phoneBtn.right = view.width;
        phoneBtn.hidden = YES;
        [view addSubview:phoneBtn];
        self.phoneBtn = phoneBtn;
        
        UILabel *timerLabel = [[UILabel alloc] init];
        timerLabel.font = textFontPingFangRegularFont(20);
        timerLabel.textColor = textColor333333;
        timerLabel.textAlignment = NSTextAlignmentCenter;
        timerLabel.height = 28;
        timerLabel.width = view.width - (phoneBtn.width * 2);
        timerLabel.left = phoneBtn.width;
        timerLabel.centerY = phoneBtn.centerY;
        timerLabel.hidden = YES;
        [view addSubview:timerLabel];
        self.timerLabel = timerLabel;
        
        self.selectPhotoView.top = timerLabel.bottom + 14;
        [view addSubview:self.selectPhotoView];
        self.selectPhotoView.hidden = YES;

        CGFloat btnWith = (view.width - 12) / 2;
        CGFloat btnHeigth = 40;
        
        UILabel *lable = [[UILabel alloc] init];
        lable.font = textFontPingFangRegularFont(14);
        lable.textColor = textColor333333;
        lable.textAlignment = NSTextAlignmentCenter;
        lable.height = 20;
        lable.width = view.width - 24;
        lable.left = 12;
        lable.top = timerLabel.bottom + 14;
        lable.hidden = YES;
        [view addSubview:lable];
        self.centerLabel = lable;
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.layer.borderColor = kThemeColor.CGColor;
        leftBtn.layer.masksToBounds = YES;
        leftBtn.layer.cornerRadius = 4.0;
        leftBtn.layer.borderWidth = 1.0;
        leftBtn.backgroundColor = [UIColor whiteColor];
        leftBtn.hidden = YES;
        [leftBtn setTitleColor:kThemeColor
                      forState:UIControlStateNormal];
        [view addSubview:leftBtn];
        self.leftBtn = leftBtn;
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.clipsToBounds = NO;
        rightBtn.layer.masksToBounds = YES;
        rightBtn.layer.cornerRadius = 4.0;
        rightBtn.backgroundColor = kThemeColor;
        rightBtn.hidden = YES;
        [rightBtn setTitleColor:[UIColor whiteColor]
                       forState:UIControlStateNormal];
        [view addSubview:rightBtn];
        self.rightBtn = rightBtn;
        
        UIButton *centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        centerBtn.layer.masksToBounds = YES;
        centerBtn.layer.cornerRadius = 4.0;
        centerBtn.backgroundColor = kThemeColor;
        centerBtn.hidden = YES;
        [centerBtn setTitleColor:[UIColor whiteColor]
                       forState:UIControlStateNormal];
        [view addSubview:centerBtn];
        self.centerBtn = centerBtn;
        
        leftBtn.size = rightBtn.size = CGSizeMake(btnWith, btnHeigth);
        leftBtn.top = rightBtn.top = timerLabel.bottom + 14;
        leftBtn.left = 0;
        rightBtn.right = view.width;
        
        centerBtn.size = CGSizeMake(SCREEN_WIDTH - 24, btnHeigth);
        centerBtn.top = timerLabel.bottom + 14;
        centerBtn.right = view.width;
        view;
    }));
}

- (NoHighlightedButton *)bottomBtn {
    return SW_LAZY(_bottomBtn, ({
        
        NoHighlightedButton *bottomBtn = [NoHighlightedButton buttonWithType:UIButtonTypeCustom];
        [bottomBtn setTitleColor:kThemeColor forState:UIControlStateNormal];
        [bottomBtn setImage:[UIImage imageNamed:@"3.2_detail_uparrow"]
                   forState:UIControlStateNormal];
        [bottomBtn setImage:[UIImage imageNamed:@"3.2_detail_downarrow"]
                   forState:UIControlStateSelected];
        bottomBtn.size = CGSizeMake(SCREEN_WIDTH, 35);
        bottomBtn.left = 0;
        bottomBtn.top = self.centerView.bottom;
//        [bottomBtn setImageEdgeInsets:UIEdgeInsetsMake(6, 1, 0, 0)];
        bottomBtn;
    }));
}

- (UIView *)selectPhotoView {
    return SW_LAZY(_selectPhotoView, ({
        
        CGFloat WH = (SCREEN_WIDTH - 30 - 24 - 20) / 5;
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.size = CGSizeMake(SCREEN_WIDTH - 24, WH);
        
        UIButton *uploadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        uploadBtn.enabled = NO;
        [uploadBtn setTitle:NSLocalizedString(@"3.0_Hy_OTCExchangeDetailUpload", nil) forState:UIControlStateNormal];
        uploadBtn.titleLabel.font =  textFontPingFangRegularFont(14);;
        UIImage *image1 = [UIImage imageWithColor:[UIColor colorWithHexString:@"#2E406B"]];
        UIImage *image2 = [UIImage imageWithColor:[UIColor colorWithHexString:@"#999FA5"]];
        [uploadBtn setBackgroundImage:image1 forState:UIControlStateNormal];
        [uploadBtn setBackgroundImage:image2 forState:UIControlStateDisabled];
        [uploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [uploadBtn setTitleColor:[UIColor colorWithWhite:1 alpha:.5] forState:UIControlStateDisabled];
        uploadBtn.size = CGSizeMake(WH, WH);
        uploadBtn.right = view.width;
        uploadBtn.layer.cornerRadius = 4;
        uploadBtn.layer.masksToBounds = YES;
        [view addSubview:uploadBtn];
        self.uploadPhotoBtn = uploadBtn;
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor999999;
        label.font = textFontPingFangRegularFont(12);
        label.numberOfLines = 0;
        label.height = WH;
        label.width = ((WH + 10) * 4 - 10) - WH - 10;
        label.centerY = view.height / 2;                                     
        label.left =  WH + 10;
        self.selectPhotoTipLabel = label;
        
        IDCMSelectPhotosView *photoView =
        [IDCMSelectPhotosView selectPhotosViewWithFrame:CGRectMake(0, 0, (WH + 10) * 4 - 10, WH)
                                               viewType:SelectPhotosViewType_SingleLine
                                        selectPhotoType:SelectPhotosType_Multiple
                                                canMove:NO
                                              canDelete:NO
                                         maxPhotosCount:3
                                              interRows:4
                                            maxLineRows:1
                                           contentInset:UIEdgeInsetsZero
                                            lineSpacing:10
                                       interitemSpacing:10];
        photoView.addCellPositionFirst = YES;
        [view addSubview:photoView];
        self.photoView = photoView;
        
        label.hidden = photoView.originPhotoImageArray.count;
        uploadBtn.enabled = photoView.originPhotoImageArray.count;
        [view addSubview:label];
        view;
    }));
}

@end





