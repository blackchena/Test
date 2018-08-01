//
//  IDCMSettingMemorizingWordsController.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/1.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMSettingMemorizingWordsController.h"
#import "IDCMSettingMemorizingWordsViewModel.h"
#import "IDCMWhiteNavigationBar.h"
#import "BetaNaoTextField.h"
#import "IDCMUnopendFindWalletPWController.h"

@interface IDCMSettingMemorizingWordsController ()
@property (nonatomic,strong) IDCMSettingMemorizingWordsViewModel *viewModel;
@property (nonatomic,strong) IDCMWhiteNavigationBar *navigationBar;
@property (nonatomic,strong) UIView *memorizingWordsView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *hintLabel;
@property (nonatomic,strong) UIButton *sureBtn;
@property (nonatomic,strong) QMUIPopupMenuView *popupView;
@end


@implementation IDCMSettingMemorizingWordsController
@dynamic viewModel;
#pragma mark — life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfigure];
}

#pragma mark — supper methods
- (void)bindViewModel {
    [super bindViewModel];
    

    @weakify(self);
    [self.memorizingWordsView.subviews enumerateObjectsUsingBlock:^(BetaNaoTextField *obj, NSUInteger idx, BOOL *stop) {
        @strongify(self);

        RACSignal *signal =  [RACObserve(obj, text) merge:obj.rac_textSignal];
        switch (obj.tag) {
            case 1:
            {
                RAC(self.viewModel, oneText) = signal;
            }break;
            case 2:
            {
                RAC(self.viewModel, twoText) = signal;
            }break;
            case 3:
            {
                RAC(self.viewModel, threeText) = signal;
            }break;
            case 4:
            {
                RAC(self.viewModel, fourText) = signal;
            }break;
            case 5:
            {
                RAC(self.viewModel, fiveText) = signal;
            }break;
            case 6:
            {
                RAC(self.viewModel, sixText) = signal;
            }break;
            case 7:
            {
                RAC(self.viewModel, sevenText) = signal;
            }break;
            case 8:
            {
                RAC(self.viewModel, eightText) = signal;
            }break;
            case 9:
            {
                RAC(self.viewModel, nineText) = signal;
            }break;
            case 10:
            {
                RAC(self.viewModel, tenText) = signal;
            }break;
            case 11:
            {
                RAC(self.viewModel, elevenText) = signal;
            }break;
            case 12:
            {
                RAC(self.viewModel, twelveText) = signal;
            }break;
            default:
            break;
        }
    }];
    
    [[[self.viewModel.sureCommand.executionSignals switchToLatest]
      deliverOnMainThread] subscribeNext:^(NSDictionary *response) {
        @strongify(self);
        NSString *status = [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
        
        if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
            
            // 保存用户登录信息
            IDCMUserInfoModel *model = [IDCMUserInfoModel yy_modelWithDictionary:response[@"data"]];
            [IDCMUtilsMethod keyedArchiverWithObject:model withKey:UserModelArchiverkey];
            [CommonUtils saveBoolValueInUD:YES forKey:IsLoginkey];
            
            // 保存助记词已备份状态
            IDCMUserStateModel *statusModel = [IDCMUtilsMethod getKeyedArchiverWithKey:UserStatusInfokey];
            statusModel.wallet_phrase = @"1";
            [IDCMUtilsMethod keyedArchiverWithObject:statusModel withKey:UserStatusInfokey];
            
            // 跳转
            [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMFindVerifySuccessController"
                                                               withViewModelName:@"IDCMFindVerifySuccessViewModel"
                                                                      withParams:nil];
        }else if([status isEqualToString:@"610"]){
            IDCMUnopendFindWalletPWController *vc = [IDCMUnopendFindWalletPWController new];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"2.2.3_InvalidSeed") withPosition:QMUIToastViewPositionBottom];
        }
    }];
    self.sureBtn.rac_command = self.viewModel.sureCommand;
    self.viewModel.endEditingCallback = ^(){
        @strongify(self);
        [self.view endEditing:YES];
    };
    
#ifdef DEBUG
    /*  开发调试使用，快速输入助记词（DEBUG） */
    [self configPopmenView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap rac_gestureSignal] subscribeNext:^(id x) {
        @strongify(self);
        [self.popupView showWithAnimated:YES];
    }];
    self.hintLabel.userInteractionEnabled = YES;
    
    if ([[IDCMServerConfig IDCMConfigEnv] isEqualToString:@"00"] || [[IDCMServerConfig IDCMConfigEnv] isEqualToString:@"03"]) { // 只有测试环境才添加手势
        [self.hintLabel addGestureRecognizer:tap];
    }
    
    [[[self.viewModel.testCommand.executionSignals switchToLatest]
      deliverOnMainThread] subscribeNext:^(NSDictionary *response) {
        @strongify(self);
        NSString *status = [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
        
        if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
            
            // 保存用户登录信息
            IDCMUserInfoModel *model = [IDCMUserInfoModel yy_modelWithDictionary:response[@"data"]];
            [IDCMUtilsMethod keyedArchiverWithObject:model withKey:UserModelArchiverkey];
            [CommonUtils saveBoolValueInUD:YES forKey:IsLoginkey];
            
            // 保存助记词已备份状态
            IDCMUserStateModel *statusModel = [IDCMUtilsMethod getKeyedArchiverWithKey:UserStatusInfokey];
            statusModel.wallet_phrase = @"1";
            [IDCMUtilsMethod keyedArchiverWithObject:statusModel withKey:UserStatusInfokey];
            
            // 跳转
            [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMFindVerifySuccessController"
                                                               withViewModelName:@"IDCMFindVerifySuccessViewModel"
                                                                      withParams:nil];
        }else if([status isEqualToString:@"610"]){
            IDCMUnopendFindWalletPWController *vc = [IDCMUnopendFindWalletPWController new];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"2.2.3_InvalidSeed") withPosition:QMUIToastViewPositionBottom];
        }
    }];
#endif
    
}

#pragma mark — private methods
- (void)configPopmenView{
    
    self.popupView = [[QMUIPopupMenuView alloc] init];
    self.popupView.automaticallyHidesWhenUserTap = YES;
    self.popupView.maskViewBackgroundColor = UIColorMaskWhite;
    self.popupView.maximumWidth = 200;
    self.popupView.maximumHeight = 200;
    self.popupView.shouldShowItemSeparator = YES;
    self.popupView.separatorInset = UIEdgeInsetsMake(0, self.popupView.padding.left, 0, self.popupView.padding.right);
    self.popupView.textEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    self.popupView.items = @[[self configItem:0],
                             [self configItem:1],
                             [self configItem:2],
                             [self configItem:3],
                             [self configItem:4],
                             [self configItem:5],
                             [self configItem:6],
                             [self configItem:7],
                             [self configItem:8],
                             [self configItem:9],
                             [self configItem:10],
                             [self configItem:11]];
    
}
- (QMUIPopupMenuItem *)configItem:(NSInteger)index{
    
    NSArray *arr = @[@"BinBear",@"Allen",@"HY",@"Fisker",@"ZJW",@"WP",@"test1",@"test4",@"test6",@"test7",@"test8",@"test10"];
    @weakify(self);
    return [QMUIPopupMenuItem itemWithImage:nil title:arr[index] handler:^(QMUIPopupMenuView *aMenuView, QMUIPopupMenuItem *aItem) {
        @strongify(self);
        [self.viewModel.testCommand execute:@(index)];
        [self.popupView hideWithAnimated:YES];
    }];
}

#pragma mark — 初始化配置
- (void)initConfigure {
    [self configUI];
    [self configLayout];
}

#pragma mark — 配置UI相关
- (void)configUI {
    
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navigationBar];
    [self.view addSubview:self.memorizingWordsView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.sureBtn];
    [self.view addSubview:self.hintLabel];
}

#pragma mark — 配置布局相关
- (void)configLayout {
    
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(kSafeAreaTop+kNavigationBarHeight);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom).offset(20);
        make.left.equalTo(@12);
        make.right.equalTo(@-12);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    [self.memorizingWordsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.left.equalTo(@40);
        make.right.equalTo(@-40);
        make.height.equalTo(@((180.0/295) * (SCREEN_WIDTH - 80)));
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.memorizingWordsView.mas_bottom).offset(40);
        make.left.equalTo(@38);
        make.right.equalTo(@-38);
        make.height.equalTo(@40);
    }];
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.sureBtn.mas_bottom).offset(20);
        make.height.equalTo(@20);
    }];
    
#ifdef DEBUG
    [self.popupView layoutWithTargetRectInScreenCoordinate:CGRectMake(0, SCREEN_HEIGHT*0.5+30, SCREEN_WIDTH, 40)];
#endif
}
#pragma mark - getters and setters
- (IDCMWhiteNavigationBar *)navigationBar {
    return SW_LAZY(_navigationBar, ({
        
        IDCMWhiteNavigationBar *view = [IDCMWhiteNavigationBar new];
        view.titlelable.text = NSLocalizedString(@"2.0_FindWalletPW", nil);;
        view;
    }));
}

- (UILabel *)titleLabel {
    return SW_LAZY(_titleLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.font = textFontPingFangRegularFont(14);
        label.textColor = textColor333333;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = NSLocalizedString(@"2.2.3_SettingMemorizingWordsTip", nil);;
        label;
    }));
}

- (UIView *)memorizingWordsView {
    return SW_LAZY(_memorizingWordsView, ({
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        
        for (NSInteger i = 1; i < 13; i++) {
            
            BetaNaoTextField *textField = [BetaNaoTextField new];
            textField.textAlignment = NSTextAlignmentCenter;
            textField.textColor = textColor333333;
            textField.font = textFontPingFangRegularFont(14);
            textField.borderStyle = UITextBorderStyleNone;
            textField.placeholder = [NSString stringWithFormat:@"%ld", (long)i];
            textField.tag = i;
            [view addSubview:textField];
        }
        [view.subviews mas_distributeSudokuViewsWithFixedLineSpacing:20
                                               fixedInteritemSpacing:20
                                                           warpCount:3
                                                          topSpacing:0 bottomSpacing:0 leadSpacing:0 tailSpacing:0];
        view;
    }));
}

- (UIButton *)sureBtn {
    return SW_LAZY(_sureBtn, ({
        
        UIButton *btn = [[UIButton alloc] init];
        btn.layer.cornerRadius = 4.0;
        btn.layer.masksToBounds = YES;
        btn.enabled = NO;
        btn.adjustsImageWhenHighlighted = NO;
        [btn setTitle:NSLocalizedString(@"2.0_Done", nil) forState:UIControlStateNormal];
        btn.titleLabel.font = textFontPingFangRegularFont(16);
        UIImage *image1 = [UIImage imageWithColor:kThemeColor];
        UIImage *image2 = [UIImage imageWithColor:[UIColor colorWithHexString:@"#999FA5"]];
        [btn setBackgroundImage:image1 forState:UIControlStateNormal];
        [btn setBackgroundImage:image2 forState:UIControlStateDisabled];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithWhite:1 alpha:.5] forState:UIControlStateDisabled];
        btn;
    }));
}
- (UILabel *)hintLabel {
    return SW_LAZY(_hintLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.font = textFontPingFangRegularFont(14);
        label.textColor = textColor333333;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = NSLocalizedString(@"2.2.3_UnsupportImport", nil);;
        label;
    }));
}
#pragma mark - statusBar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
@end





