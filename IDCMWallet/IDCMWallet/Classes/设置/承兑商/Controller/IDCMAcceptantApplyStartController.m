//
//  IDCMAcceptantApplyStartController.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/10.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptantApplyStartController.h"


@interface IDCMAcceptantApplyStartController ()
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIButton *applyBtn;
@end


@implementation IDCMAcceptantApplyStartController
#pragma mark — life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfigure];
}

#pragma mark — supper method
- (void)bindViewModel {
    [super bindViewModel];
    
    [[[self.applyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(UIControl *x) {
         [IDCMMediatorAction idcm_pushViewControllerWithClassName:@"IDCMAcceptantApplyReadController"
                                                withViewModelName:@"IDCMAcceptantApplyReadViewModel"
                                                       withParams:nil
                                                         animated:YES];
     }];
}

#pragma mark — private methods
#pragma mark — 初始化配置
- (void)initConfigure {
    [self configUI];
}

#pragma mark — 配置UI相关
- (void)configUI {
    self.navigationItem.title = NSLocalizedString(@"3.0_Acceptant", nil);
    self.view.backgroundColor = viewBackgroundColor;
    [self.view addSubview:self.topView];
    [self.view addSubview:self.applyBtn];
}


#pragma mark - getters and setters
- (UIView *)topView {
    return SW_LAZY(_topView, ({
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = viewBackgroundColor;

        
        UIView *upView = [[UIView alloc] init];
        upView.backgroundColor = [UIColor whiteColor];
        upView.frame = CGRectMake(0, 0, self.view.width, 44);
        [view addSubview:upView];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor333333;
        label.font = textFontPingFangRegularFont(14);
        label.text = NSLocalizedString(@"3.0_AcceptantOfRight", nil);
        label.height = 20;
        label.width = upView.width - 12 -12;
        label.left = 12;
        label.centerY = upView.height / 2;
        [upView addSubview:label];
        
        UIView *downView = [[UIView alloc] init];
        downView.backgroundColor = [UIColor whiteColor];
        [view addSubview:downView];
        
        NSString *str = NSLocalizedString(@"3.0_AcceptantOfRightInfo", nil) ;
        CGFloat height =  [str heightForFont:textFontPingFangRegularFont(12) width:label.width - 5];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.textColor = textColor666666;
        label1.font = textFontPingFangRegularFont(12);
        label1.text = str;
        label1.numberOfLines = 0;
        label1.height = height;
        label1.width = label.width;
        label1.left = label.left;
        label1.top = 12;
        [downView addSubview:label1];
        
        downView.frame = CGRectMake(0, upView.bottom + 1, upView.width, label1.height + 24);
        view.frame = CGRectMake(0, 0, self.view.width, upView.height + 1 + downView.height);
        
        view;
    }));
}

- (UIButton *)applyBtn {
    return SW_LAZY(_applyBtn, ({
        
        UIButton *btn = [[UIButton alloc] init];
        btn.width = self.view.width - 24;
        btn.height = 40;
        btn.left = 12;
        btn.top = self.topView.bottom + 20;
        btn.layer.cornerRadius = 6.0;
        btn.layer.masksToBounds = YES;
        btn.adjustsImageWhenHighlighted = NO;
        [btn setTitle:NSLocalizedString(@"3.0_AcceptantApplyStart", nil) forState:UIControlStateNormal];
        btn.titleLabel.font = textFontPingFangRegularFont(16);
        UIImage *image1 = [UIImage imageWithColor:kThemeColor];
        [btn setBackgroundImage:image1 forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn;
    }));
}


@end








