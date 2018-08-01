//
//  IDCMWalletIDSettingController.m
//  IDCMWallet
//
//  Created by huangyi on 2018/3/31.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMWalletIDSettingController.h"
#import "IDCMWalletIDSettingViewModel.h"
#import "IDCMWhiteNavigationBar.h"
#import "IDCMUserInfoModel.h"
#import "IDCMWalletIDView.h"

@interface IDCMWalletIDSettingController () <UITextFieldDelegate>
@property (nonatomic,strong) IDCMWhiteNavigationBar *navigationBar;
@property (nonatomic,strong) IDCMWalletIDSettingViewModel *viewModel;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) IDCMWalletIDView *walletIDView;
@property (nonatomic,strong) IDCMWalletIDView *invitationView;
@end


@implementation IDCMWalletIDSettingController
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
    RAC(self.viewModel,wallteID) = [RACObserve(self.walletIDView.textFiled, text) merge:self.walletIDView.textFiled.rac_textSignal];
    RAC(self.viewModel,inviteCode) = [RACObserve(self.invitationView.textFiled, text) merge:self.invitationView.textFiled.rac_textSignal];
    
    [[[self.viewModel.registerCommand.executionSignals switchToLatest]
       deliverOnMainThread] subscribeNext:^(NSDictionary *response) {
        
        NSString *status = [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
        
        if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
            
            IDCMUserInfoModel *model = [IDCMUserInfoModel yy_modelWithDictionary:response[@"data"]];
            [IDCMUtilsMethod keyedArchiverWithObject:model withKey:UserModelArchiverkey];
            [CommonUtils saveBoolValueInUD:YES forKey:IsLoginkey];
            
            [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMBackupMemorizingWordsController"
                                                               withViewModelName:@"IDCMBackupMemorizingWordsViewModel"
                                                                      withParams:@{@"backupType":@(0)}];
            
        }else if ([status isEqualToString:@"106"]){
            [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_UserNameBeing", nil)];
        }else if ([status isEqualToString:@"126"]){
            [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.2.3_IPRetry", nil)];
        }else {
            [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_RegisterFail", nil)];
        }
    }];
    
    self.btn.rac_command = self.viewModel.registerCommand;
    self.viewModel.endEditingCallback = ^(){
        @strongify(self);
        [self.view endEditing:YES];
    };
}

#pragma mark — private methods
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
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.walletIDView];
    [self.view addSubview:self.invitationView];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.btn];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqual: @" "]) {
        return NO;
    }
    if (self.walletIDView.textFiled == textField) {
        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (text.length > 16) {
            return NO;
        }
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.walletIDView.textFiled == textField) {
        self.walletIDView.line.backgroundColor = UIColorMake(41, 104, 185);
    }else{
        self.invitationView.line.backgroundColor = UIColorMake(41, 104, 185);
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.walletIDView.textFiled == textField) {
        self.walletIDView.line.backgroundColor = UIColorMake(160, 165, 171);
    }else{
        self.invitationView.line.backgroundColor = UIColorMake(160, 165, 171);
    }
}
#pragma mark — 配置布局相关
- (void)configLayout {
    
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(kSafeAreaTop+kNavigationBarHeight);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom).offset(26);
        make.left.equalTo(@12);
        make.right.equalTo(@-12);
        make.height.equalTo(@22);
    }];
    [self.walletIDView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(40);
        make.left.equalTo(@58);
        make.right.equalTo(@(-58));
        make.height.equalTo(@26);
    }];
    [self.invitationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.walletIDView.mas_bottom).offset(20);
        make.left.equalTo(@58);
        make.right.equalTo(@(-58));
        make.height.equalTo(@26);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.invitationView.mas_bottom).offset(25);
        make.left.right.equalTo(self.invitationView);
        make.height.equalTo(@46);
    }];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLabel.mas_bottom).offset(36);
        make.left.equalTo(@38);
        make.right.equalTo(@(-38));
        make.height.equalTo(@40);
    }];

}

#pragma mark - getters and setters
- (IDCMWhiteNavigationBar *)navigationBar {
    return SW_LAZY(_navigationBar, ({
        
        IDCMWhiteNavigationBar *view = [IDCMWhiteNavigationBar new];
        view.titlelable.text = @"";
        view;
    }));
}

- (UILabel *)titleLabel {
    return SW_LAZY(_titleLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor333333;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = textFontPingFangRegularFont(16);
        label.text = NSLocalizedString(@"2.2.3_WalletIDSettingTitle", nil);
        label;
    }));
}
- (IDCMWalletIDView *)walletIDView{
    return SW_LAZY(_walletIDView, ({
        IDCMWalletIDView *view = [IDCMWalletIDView new];
        view.textFiled.delegate = self;
        view.textFiled.placeholder = @"Wallet ID";
        view;
    }));
}
- (IDCMWalletIDView *)invitationView{
    return SW_LAZY(_invitationView, ({
        IDCMWalletIDView *view = [IDCMWalletIDView new];
        view.textFiled.delegate = self;
        view.textFiled.placeholder = SWLocaloziString(@"3.0_Bin_InvitationCode");
        view;
    }));
}
- (UILabel *)tipLabel {
    return SW_LAZY(_tipLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        
        NSString *str1 = NSLocalizedString(@"2.2.3_WalletIDSettingTipBlack", nil);
        NSString *str2 =NSLocalizedString(@"2.2.3_WalletIDSettingTipRed", nil);
        NSString *str = [NSString stringWithFormat:@"%@%@", str1, str2];

        NSMutableAttributedString *attr =
        [[NSMutableAttributedString alloc] initWithString:str];
        [attr addAttributes:@{ NSFontAttributeName : textFontPingFangRegularFont(14),
                               NSForegroundColorAttributeName : textColor666666
                               } range:NSMakeRange(0, str1.length)];
        
        [attr addAttributes:@{ NSFontAttributeName : textFontPingFangRegularFont(14),
                               NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#FC8968"]
                               } range:NSMakeRange(str1.length, attr.length - str1.length)];
        
        NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:20];
        paragraph.lineSpacing = 6;
        paragraph.alignment = NSTextAlignmentCenter;
        [attr addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, attr.length )];
        label.attributedText = attr;
        label;
    }));
}

- (UIButton *)btn {
    return SW_LAZY(_btn, ({
        
        UIButton *btn = [[UIButton alloc] init];
        btn.layer.cornerRadius = 4.0;
        btn.layer.masksToBounds = YES;
        btn.enabled = NO;
        btn.adjustsImageWhenHighlighted = NO;
        [btn setTitle:NSLocalizedString(@"2.0_NextStep", nil) forState:UIControlStateNormal];
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
#pragma mark - statusBar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
@end




