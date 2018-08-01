//
//  IDCMAcceptantApplyReadController.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/10.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptantApplyReadController.h"
#import "IDCMAcceptantApplyReadViewModel.h"


@interface IDCMAcceptantApplyReadController ()
@property (nonatomic,strong) IDCMAcceptantApplyReadViewModel *viewModel;
@property (nonatomic,strong) UIScrollView *contentScrollView;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *ruleBtn;
@property (nonatomic,strong) UIButton *readBtn;
@end


@implementation IDCMAcceptantApplyReadController
@dynamic viewModel;
#pragma mark — life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfigure];
}

#pragma mark — supper method
- (void)bindViewModel {
    [super bindViewModel];
    
    [[[self.readBtn rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(UIControl *x) {
         [IDCMMediatorAction
          idcm_pushViewControllerWithClassName:@"IDCMAcceptantApplyStepsEndVC"
                             withViewModelName:@"IDCMAcceptantApplyStepsEndViewModel"
                                    withParams:@{@"currentStep":@"0"}
                                      animated:YES];
         
     }];
    [self.viewModel.timerCommand(@5) execute:self.readBtn];
    
    [[[self.ruleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(UIControl *x) {
         
         NSString *rulesUrl = [NSString stringWithFormat:@"%@%@?lang=%@",[IDCMServerConfig getIDCMWebAddr],AcceptanceRules_URL,[IDCMUtilsMethod getH5Language]];
         [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMWebViewController"
                                                            withViewModelName:@"IDCMWebViewModel"
                                                                   withParams:@{@"requestURL":rulesUrl,
                                                                                @"title":SWLocaloziString(@"3.0_AcceptantApplyBondRule")}];
     }];
}

#pragma mark — private methods
#pragma mark — 初始化配置
- (void)initConfigure {
    [self configUI];
}

#pragma mark — 配置UI相关
- (void)configUI {
    self.navigationItem.title = NSLocalizedString(@"3.0_AcceptantApply", nil);
    self.view.backgroundColor = viewBackgroundColor;
    [self.view addSubview:self.contentScrollView];
}

#pragma mark - getters and setters
- (UIScrollView *)contentScrollView {
    if (!_contentScrollView){
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.backgroundColor = viewBackgroundColor;
        _contentScrollView.frame = self.view.bounds;
        _contentScrollView.alwaysBounceVertical = YES;

        [_contentScrollView addSubview:self.topView];
        [_contentScrollView addSubview:self.bottomView];

        NSString *str1 = NSLocalizedString(@"3.0_AcceptantApplyBondDescribe", nil);
        CGFloat height1 =  [str1 heightForFont:textFontPingFangRegularFont(12) width:_contentScrollView.width - 24];
        UILabel *label1 = [[UILabel alloc] init];
        label1.textColor = textColor999999;
        label1.font = textFontPingFangRegularFont(12);
        label1.textAlignment = NSTextAlignmentCenter;
        label1.numberOfLines = 0;
        label1.text = str1;
        label1.height = height1;
        label1.width = _contentScrollView.width - 12 -12;
        label1.left = 12;
        label1.top = self.bottomView.bottom + 15;
        [_contentScrollView addSubview:label1];

        self.ruleBtn.centerX = label1.centerX;
        self.ruleBtn.top = label1.bottom + 2;
        [_contentScrollView addSubview:self.ruleBtn];

        self.readBtn.top = self.ruleBtn.bottom + 20;
        [_contentScrollView addSubview:self.readBtn];

        if (self.readBtn.bottom + 87 > _contentScrollView.height) {
            _contentScrollView.contentSize = CGSizeMake(0, self.readBtn.bottom + 87);
        }
    }
    return _contentScrollView;
}

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
        label.text = NSLocalizedString(@"3.0_AcceptantApplySwitch", nil);
        label.height = 20;
        label.width = upView.width - 12 -12;
        label.left = 12;
        label.centerY = upView.height / 2;
        [upView addSubview:label];

        UIView *downView = [[UIView alloc] init];
        downView.backgroundColor = [UIColor whiteColor];
        [view addSubview:downView];

        NSString *str = NSLocalizedString(@"3.0_AcceptantApplySwitchInfo", nil);
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

- (UIButton *)ruleBtn {
    return SW_LAZY(_ruleBtn, ({
        
        NSString *str = NSLocalizedString(@"3.0_AcceptantApplyBondRuleRead", nil);
        CGFloat width = [str widthForFont:textFontPingFangRegularFont(12)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:str forState:UIControlStateNormal];
        btn.titleLabel.font = textFontPingFangRegularFont(12);
        [btn setTitleColor:[UIColor colorWithHexString:@"#2968B9"]
                  forState:UIControlStateNormal];
        btn.height = 17;
        btn.width = width;
        btn;
    }));
}

- (UIView *)bottomView {
    return SW_LAZY(_bottomView, ({
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = viewBackgroundColor;
        
        UIView *upView = [[UIView alloc] init];
        upView.backgroundColor = [UIColor whiteColor];
        upView.frame = CGRectMake(0, 0, self.view.width, 44);
        [view addSubview:upView];
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor333333;
        label.font = textFontPingFangRegularFont(14);
        label.text = NSLocalizedString(@"3.0_AcceptantApplyObligation", nil);
        label.height = 20;
        label.width = upView.width - 12 -12;
        label.left = 12;
        label.centerY = upView.height / 2;
        [upView addSubview:label];
        
        
        UIView *downView = [[UIView alloc] init];
        downView.backgroundColor = [UIColor whiteColor];
        [view addSubview:downView];
        
        NSString *str = NSLocalizedString(@"3.0_AcceptantApplyObligationInfo", nil);
        
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
        view.frame = CGRectMake(self.topView.left, self.topView.bottom + 12, self.view.width, upView.height + 1 + downView.height);
        view;
    }));
}

- (UIButton *)readBtn {
    return SW_LAZY(_readBtn, ({
        
        UIButton *btn = [[UIButton alloc] init];
        btn.width = self.view.width - 24;
        btn.height = 40;
        btn.left = 12;
        btn.layer.cornerRadius = 6.0;
        btn.enabled = NO;
        btn.layer.masksToBounds = YES;
        btn.adjustsImageWhenHighlighted = NO;
        [btn setTitle:[NSString stringWithFormat:@"%@(20s)", NSLocalizedString(@"3.0_AcceptantApplyRead", nil)]
             forState:UIControlStateNormal];
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

@end


