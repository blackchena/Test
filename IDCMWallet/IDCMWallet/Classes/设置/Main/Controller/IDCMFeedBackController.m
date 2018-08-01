//
//  IDCMFeedBackController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/2/5.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMFeedBackController.h"
#import "IDCMFeedBackViewModel.h"

@interface IDCMFeedBackController ()<QMUITextViewDelegate>
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMFeedBackViewModel *viewModel;
/**
 *  feedView
 */
@property (strong, nonatomic) UIView *feedView;
/**
 *  feedTextView
 */
@property (strong, nonatomic) QMUITextView *feedTextView;
/**
 *  contactView
 */
@property (strong, nonatomic) UIView *contactView;
/**
 *  contactTextFlid
 */
@property (strong, nonatomic) QMUITextField *contactTextField;
/**
 *  提交按钮
 */
@property (strong, nonatomic) UIButton *submitButton;
/**
 *  字数
 */
@property (strong, nonatomic) UILabel *numbelLable;
@end

@implementation IDCMFeedBackController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = viewBackgroundColor;
    self.title = SWLocaloziString(@"2.1_Feedback");
    [[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:[self class]];
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.feedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@164);
    }];
    [self.feedTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.feedView).with.insets(UIEdgeInsetsMake(10, 10, 12, 12));
    }];
    [self.contactView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.feedView.mas_bottom).offset(12);
        make.height.equalTo(@44);
    }];
    [self.contactTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contactView).with.insets(UIEdgeInsetsMake(12, 10, 12, 12));
    }];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(12);
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.top.equalTo(self.contactView.mas_bottom).offset(30);
        make.height.equalTo(@40);
    }];
    [self.numbelLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.feedView.mas_right).offset(-12);
        make.bottom.equalTo(self.feedView.mas_bottom).offset(-12);
        make.width.equalTo(@30);
        make.height.equalTo(@20);
    }];
}
- (void)bindViewModel
{
    [super bindViewModel];
    
    @weakify(self);
    
    
    RAC(self.viewModel,contactText) = [RACObserve(self.contactTextField, text) merge:self.contactTextField.rac_textSignal];
    
    [[self.viewModel.validSubmitSignal deliverOnMainThread]
     subscribeNext:^(NSNumber *value) {
         @strongify(self);
         if ([value integerValue] == 0) {
             self.submitButton.enabled = NO;
             [self.submitButton setTitleColor:SetAColor(255, 255, 255, 0.5) forState:UIControlStateNormal];
             
         }else{
             self.submitButton.enabled = YES;
             [self.submitButton setTitleColor:UIColorWhite forState:UIControlStateNormal];
         }
     }];
  
    // 点击提交按钮
    [[[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self);
         [self.view endEditing:YES];
         [self.viewModel.requestDataCommand execute:nil];
     }];
    // 监听提交状态
    [[[self.viewModel.requestDataCommand.executionSignals switchToLatest]
      deliverOnMainThread]
     subscribeNext:^(NSDictionary *resepon) {
         @strongify(self);
         [IDCMControllerTool showAlertViewWithTitle:SWLocaloziString(@"2.1_SubmitSuccessful") message:nil buttonArray:@[SWLocaloziString(@"2.0_Done")] actionBlock:^(NSInteger clickIndex) {
             @strongify(self);
             if (clickIndex == 0) {
                 [self.navigationController popToRootViewControllerAnimated:YES];
             }
         }];
     }];
}
#pragma mark - QMUITextViewDelegate
// 监听feedTextView的字数
- (void)textViewDidChangeSelection:(UITextView *)textView{
    
    self.viewModel.feedText = textView.text;
    self.numbelLable.text = [NSString stringWithFormat:@"%ld",160-textView.text.length];
}

#pragma mark - getter
- (UIView *)feedView
{
    return SW_LAZY(_feedView, ({
        UIView *view = [UIView new];
        view.backgroundColor = UIColorWhite;
        [self.view addSubview:view];
        view;
    }));
}
- (QMUITextView *)feedTextView
{
    return SW_LAZY(_feedTextView, ({
        QMUITextView *textView = [[QMUITextView alloc] init];
        textView.delegate = self;
        textView.textAlignment = NSTextAlignmentLeft;
        textView.maximumTextLength = 160;
        textView.returnKeyType = UIReturnKeyDone;
        textView.placeholder = SWLocaloziString(@"2.1_FeedBackPlaceHolder");
        textView.font = SetFont(@"PingFang-SC-Regular", 14);
        textView.textColor = SetColor(51, 51, 51);
        textView.delegate = self;
        [self.feedView addSubview:textView];
        textView;
    }));
}
- (UIView *)contactView
{
    return SW_LAZY(_contactView, ({
        UIView *view = [UIView new];
        view.backgroundColor = UIColorWhite;
        [self.view addSubview:view];
        view;
    }));
}
- (QMUITextField *)contactTextField
{
    return SW_LAZY(_contactTextField, ({
        QMUITextField *textField = [[QMUITextField alloc] init];
        textField.borderStyle = UITextBorderStyleNone;
        textField.textAlignment = NSTextAlignmentLeft;
        textField.font = SetFont(@"PingFang-SC-Regular", 14);
        textField.placeholder = SWLocaloziString(@"2.1_FeedBackAddress");
        textField.textColor = SetColor(51, 51, 51);
        textField.returnKeyType = UIReturnKeyDone;
        [self.contactView addSubview:textField];
        textField;
    }));
}
- (UIButton *)submitButton
{
    return SW_LAZY(_submitButton, ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = SetFont(@"PingFang-SC-Regular", 16);
        [button setBackgroundColor:kThemeColor];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.enabled = NO;
        [button setTitle:SWLocaloziString(@"2.1_Submit") forState:UIControlStateNormal];
        [button setTitleColor:SetAColor(255, 255, 255, 0.5) forState:UIControlStateNormal];
        [self.view addSubview:button];
        button;
    }));
}
- (UILabel *)numbelLable
{
    return SW_LAZY(_numbelLable, ({
        UILabel *label = [UILabel new];
        label.textColor = textColor999999;
        label.textAlignment = NSTextAlignmentRight;
        label.text = @"160";
        label.font = textFontPingFangRegularFont(14);
        [self.feedView addSubview:label];
        label;
    }));
}
@end
