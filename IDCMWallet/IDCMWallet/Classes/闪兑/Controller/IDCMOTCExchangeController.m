//
//  IDCMOTCExchangeController.m
//  IDCMWallet
//
//  Created by huangyi on 2018/3/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMOTCExchangeController.h"
#import "IDCMOTCExchangeSellCurrencyViewModel.h"
#import "IDCMOTCExchangeSellCurrencyView.h"
#import "IDCMOTCExchangeSellCurrencyViewModel.h"
#import "IDCMOTCWorkStationController.h"
#import "IDCMOTCWorkStationViewModel.h"
@interface IDCMOTCExchangeController ()
@property (nonatomic,strong) IDCMOTCExchangeSellCurrencyViewModel *viewModel;
/**
 购买View
 */
@property(nonatomic,strong)IDCMOTCExchangeSellCurrencyView * sellCurrencyView ;

@property (nonatomic,strong) UIView *switchView;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,weak)   UIButton *selectedBtn;

/**
 0 : 买入 1 卖出
 */
@property(nonatomic,assign)NSInteger purchaseType ;

@end



@implementation IDCMOTCExchangeController
@dynamic viewModel;
#pragma mark — life cycle
-  (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.sellCurrencyView.purchaseType = self.purchaseType;//清除之前选中状态
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfigure];
    
    self.sellCurrencyView.subject= [RACSubject subject];
    @weakify(self);
    [[self.sellCurrencyView.subject deliverOnMainThread] subscribeNext:^(id  _Nullable x) {

        IDCMOTCWorkStationViewModel *  workStationViewModel = [[IDCMOTCWorkStationViewModel alloc] initWithParams:nil];
        [workStationViewModel yy_modelSetWithDictionary:x];
        IDCMOTCWorkStationController * workStationVC = [[IDCMOTCWorkStationController  alloc] initWithViewModel:workStationViewModel];
        workStationVC.popBackBlock = ^{
             @strongify(self);
            [self.sellCurrencyView resetNewData];
        };
        [self.navigationController pushViewController:workStationVC animated:YES];
        
    }];
}

- (void)bindViewModel {
    [super bindViewModel];
    
    @weakify(self);
    void(^subscribe)(UIButton *btn) = ^(UIButton *btn){
        @strongify(self);
        if (btn != self.selectedBtn) {
            btn.selected = YES;
            self.selectedBtn.selected = NO;
            self.selectedBtn = btn;
            if ([btn isEqual:self.leftBtn]) { //买入
                self.purchaseType = BUYTYPE;
                self.sellCurrencyView.purchaseType = BUYTYPE;
                
            }
            if ([btn isEqual:self.rightBtn]) {//卖出
                self.purchaseType = SELLTYPE;
                self.sellCurrencyView.purchaseType = SELLTYPE;
            }
        }
    };
    
    [[[self.leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:subscribe];
    [[[self.rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:subscribe];
}


#pragma mark — private methods
#pragma mark — 初始化配置
- (void)initConfigure {
    [self configUI];
}

#pragma mark — 配置UI相关
- (void)configUI {
    self.view.backgroundColor = viewBackgroundColor;
    self.view.size = CGSizeMake(SCREEN_WIDTH, 365);
    [self.view addSubview:self.switchView];
    [self.view addSubview:self.sellCurrencyView];
    
    
    self.view.size = CGSizeMake(SCREEN_WIDTH, self.sellCurrencyView.bottom + 8);

}

- (IDCMOTCExchangeSellCurrencyView *)sellCurrencyView {
    return SW_LAZY(_sellCurrencyView, ({
        IDCMOTCExchangeSellCurrencyView *view =
        [IDCMOTCExchangeSellCurrencyView OTCSellCurrencyViewViewModel:self.viewModel];
        view.top = self.switchView.bottom;
        view.purchaseType = BUYTYPE;
        self.purchaseType = view.purchaseType;
        view;
    }));
}

- (UIView *)switchView {
    if (!_switchView){
        _switchView = [[UIView alloc] init];
        _switchView.backgroundColor = UIColorWhite;
        _switchView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
        
        [_switchView addSubview:self.leftBtn];
        [_switchView addSubview:self.rightBtn];
    }
    return _switchView;
}

- (UIButton *)leftBtn {
    return SW_LAZY(_leftBtn, ({
        [self createBtnWithTitle:NSLocalizedString(@"3.0_OTCExchangeBuyCurrency", nil)];
    }));
}

- (UIButton *)rightBtn {
    return SW_LAZY(_rightBtn, ({
        [self createBtnWithTitle:NSLocalizedString(@"3.0_OTCExchangeSellCurrency", nil)];
    }));
}

- (UIButton *)createBtnWithTitle:(NSString *)title {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.adjustsImageWhenHighlighted = NO;
    btn.titleLabel.font = textFontPingFangRegularFont(16);
    [btn setBackgroundImage:[UIImage imageNamed:@"2.1_back_phrases_bg_image_box"]
                   forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"2.1_back_phrases_bg_image_box_select"]
                   forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor colorWithHexString:@"#8191BB"] forState:UIControlStateNormal];
    [btn setTitleColor:kThemeColor forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.size = CGSizeMake((SCREEN_WIDTH - 24-11) / 2, 40);
    btn.centerY = 60 / 2;
    if ([title isEqualToString:NSLocalizedString(@"3.0_OTCExchangeBuyCurrency", nil)]) {
        btn.left = 12;
        btn.selected = YES;
        self.selectedBtn = btn;
    } else {
        btn.left = (self.leftBtn.right+11);
    }
    return btn;
}


@end





