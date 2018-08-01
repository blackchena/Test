//
//  IDCMVerifyPhrasesController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/3/29.
//  Copyright © 2018年 BinBear. All rights reserved.
//
// @class IDCMVerifyPhrasesController
// @abstract <#类的描述#>
// @discussion <#类的功能#>
//
#import "IDCMVerifyBackUpPhrasesController.h"
#import "IDCMVerifyPhrasesOrderViewModel.h"
#import "IDCMWhiteNavigationBar.h"
#import "IDCMShowPhraseView.h"
#import "IDCMShowSelectPhraseView.h"
#import "KVOMutableArray+ReactiveCocoaSupport.h"
#import "IDCMPhrasesSuccessController.h"
#import "IDCMUserStateModel.h"

@interface IDCMVerifyBackUpPhrasesController ()
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMVerifyPhrasesOrderViewModel *viewModel;
/**
 *  导航栏
 */
@property (strong, nonatomic) IDCMWhiteNavigationBar *navigationBar;
/**
 *  提示语
 */
@property (strong, nonatomic) UILabel *tipesLabel;
/**
 *  选中的view
 */
@property (strong, nonatomic) IDCMShowPhraseView *phraseView;
/**
 *  选择的view
 */
@property (strong, nonatomic) IDCMShowSelectPhraseView *selectView;
/**
 *  验证按钮
 */
@property (strong, nonatomic) UIButton *verifyButton;
@end

@implementation IDCMVerifyBackUpPhrasesController
@dynamic viewModel;

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(kSafeAreaTop+kNavigationBarHeight);
    }];
    [self.tipesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.greaterThanOrEqualTo(@40);
        make.top.equalTo(self.navigationBar.mas_bottom).offset(30);
    }];
    [self.phraseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(30);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(180);
        make.top.equalTo(self.tipesLabel.mas_bottom).offset(20);
    }];
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(30);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(180);
        make.top.equalTo(self.phraseView.mas_bottom).offset(40);
    }];
    [self.verifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(30);
        make.right.equalTo(self.view.mas_right).offset(-30);
        make.height.mas_equalTo(40);
        make.top.equalTo(self.selectView.mas_bottom).offset(40);
    }];
}
#pragma mark - InitUI
- (void)initUI
{
    self.view.backgroundColor = UIColorWhite;
    
    self.fd_prefersNavigationBarHidden = YES;
    
    self.navigationBar.titlelable.text = SWLocaloziString(@"2.0_SetBackup");
    
}

#pragma mark - Bind
- (void)bindViewModel
{
    [super bindViewModel];
    
    self.selectView.listModelArray = self.viewModel.listModelArray;
    
    // 监听选中的单词
    @weakify(self);
    [[[RACObserve(self.selectView, selectIndex) deliverOnMainThread] filter:^BOOL(NSNumber *index) {
        if (index) {
            return YES;
        }else{
            return NO;
        }
    }] subscribeNext:^(NSNumber *index) {
         @strongify(self);
         NSInteger selectIndex = [index integerValue];
         IDCMPhraseModel *model = self.viewModel.listModelArray[selectIndex];
         self.phraseView.selectModel = model;
     }];
    
    // 监听删除的单词
    [[[RACObserve(self.phraseView, UnSelectModel) deliverOnMainThread] filter:^BOOL(IDCMPhraseModel *model) {
        if (model) {
            return YES;
        }else{
            return NO;
        }
    }] subscribeNext:^(IDCMPhraseModel *model) {
        @strongify(self);
        self.selectView.UnSelectModel = model;
    }];
    
    [[self.phraseView.selectArr changeSignal] subscribeNext:^(RACTuple *tuple) {
        if (tuple.count) {
            @strongify(self);
            NSMutableArray *arr = tuple.first;
            if (arr.count == 12) {
                self.verifyButton.enabled = YES;
                [self.verifyButton setBackgroundColor:kThemeColor];
                self.viewModel.userSelectedModelArray = arr;
            }else{
                self.verifyButton.enabled = NO;
                [self.verifyButton setBackgroundColor:kSubtopicGrayColor];
                self.viewModel.userSelectedModelArray = @[].mutableCopy;
            }
        }  
    }];


    // 验证助记词
    [[[self.verifyButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self);
         if (![self correctOrder]) {
             
             return;
         }
         //提交后台验证
         [self.viewModel.requestDataCommand execute:nil];
     }];
    
    [[[self.viewModel.requestDataCommand.executionSignals switchToLatest]
      deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         @strongify(self);
         NSString *data = [NSString idcw_stringWithFormat:@"%@",response[@"data"]];
         if ([data integerValue] == 1) {
             
             // 保存助记词已备份状态
             IDCMUserStateModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserStatusInfokey];
             model.wallet_phrase = @"1";
             [IDCMUtilsMethod keyedArchiverWithObject:model withKey:UserStatusInfokey];
             
             if ([self.viewModel.backupType isEqualToNumber:@(1)]) {
                 
                 IDCMPhrasesSuccessController *vc = [IDCMPhrasesSuccessController new];
                 [self.navigationController pushViewController:vc animated:YES];
             }else{
                 
                 // 如果是老用戶登录，备份成功后设为已登录
                 [CommonUtils saveBoolValueInUD:YES forKey:IsLoginkey];
                 [[IDCMMediatorAction sharedInstance]
                  pushViewControllerWithClassName:@"IDCMSetPINController"
                  withViewModelName:@"IDCMSetPINViewModel" withParams:@{@"setPINType":@(1)}];
             }
             
             
         }else{
             [IDCMControllerTool showAlertViewWithTitle:SWLocaloziString(@"2.1_ScanNotes") titleFont:textFontPingFangMediumFont(16) titleColor:textColor333333 message:SWLocaloziString(@"2.1_Word_Order_Error_Tips") messageFont:textFontPingFangRegularFont(14) messageColor:textColor333333 buttonArray:@[SWLocaloziString(@"2.1_PhraseDone")] colorIndex:0 actionBlock:nil];
         }
     }];
}


#pragma mark - Public Methods


#pragma mark - Privater Methods
- (BOOL)correctOrder
{
    BOOL correctOrder = YES;
    __block NSString *selectStr = @"";
    __block NSString *phraseStr = @"";
    
    [self.viewModel.userSelectedModelArray enumerateObjectsUsingBlock:^(IDCMPhraseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        selectStr = [NSString idcw_stringWithFormat:@"%@%@",selectStr,[obj.phrase lowercaseString]];
    }];
    [self.viewModel.listModel.RandomWord enumerateObjectsUsingBlock:^(IDCMPhraseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        phraseStr = [NSString idcw_stringWithFormat:@"%@%@",phraseStr,[obj.phrase lowercaseString]];
    }];
    if (![selectStr isEqualToString:phraseStr]) {
        correctOrder = NO;
    }
    
    if (!correctOrder) {
        //弹窗
        [IDCMControllerTool showAlertViewWithTitle:SWLocaloziString(@"2.1_ScanNotes") titleFont:textFontPingFangMediumFont(16) titleColor:textColor333333 message:SWLocaloziString(@"2.1_Word_Order_Error_Tips") messageFont:textFontPingFangRegularFont(14) messageColor:textColor333333 buttonArray:@[SWLocaloziString(@"2.1_PhraseDone")] colorIndex:0 actionBlock:nil];
    }
    
    
    return correctOrder;
}


#pragma mark - Action


#pragma mark - NetWork


#pragma mark - Delegate


#pragma mark - Getter & Setter
- (IDCMWhiteNavigationBar *)navigationBar
{
    return SW_LAZY(_navigationBar, ({
        IDCMWhiteNavigationBar *view = [IDCMWhiteNavigationBar new];
        [self.view addSubview:view];
        view;
    }));
}
- (UILabel *)tipesLabel
{
    return SW_LAZY(_tipesLabel, ({
        UILabel *label = [UILabel new];
        label.text = SWLocaloziString(@"2.1_Recover_Back_Order_tips");
        label.textColor = kSubtopicBlackColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.font = textFontPingFangRegularFont(14);
        [self.view addSubview:label];
        label;
    }));
}
- (IDCMShowPhraseView *)phraseView
{
    return SW_LAZY(_phraseView, ({
        IDCMShowPhraseView *view = [IDCMShowPhraseView new];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderColor = SetColor(225, 231, 255).CGColor;
        view.layer.borderWidth= 0.5;
        view.layer.cornerRadius = 5;
        view.layer.shadowOpacity = 1;// 阴影透明度
        view.layer.shadowColor = SetColor(204, 215, 241).CGColor;// 阴影的颜色
        view.layer.shadowRadius = 2;// 阴影扩散的范围控制
        view.layer.shadowOffset = CGSizeMake(0, 2);// 阴影的范围
        [self.view addSubview:view];
        view;
    }));
}
- (IDCMShowSelectPhraseView *)selectView
{
    return SW_LAZY(_selectView, ({
        IDCMShowSelectPhraseView *view = [IDCMShowSelectPhraseView new];
        [self.view addSubview:view];
        view;
    }));
}
- (UIButton *)verifyButton
{
    return SW_LAZY(_verifyButton, ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = SetFont(@"PingFang-SC-Regular", 16);
        [button setBackgroundColor:kSubtopicGrayColor];
        [button setTitle:SWLocaloziString(@"2.0_Verify") forState:UIControlStateNormal];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.enabled = NO;
        [self.view addSubview:button];
        button;
    }));
}
#pragma mark - statusBar
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
@end






