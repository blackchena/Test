//
//  IDCMAcceptantPickInBondController.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/13.
//  Copyright © 2018年 BinBear. All rights reserved.
//  充值保证金

#import "IDCMAcceptantPickInBondController.h"
#import "IDCMAcceptantPickinBondView.h"
#import "IDCMCheckAcceptantStateController.h"
#import "IDCMAcceptantViewController.h"
#import "UINavigationController+Extensions.h"
@interface IDCMAcceptantPickInBondController ()
@property (nonatomic,strong) IDCMAcceptantPickinBondView *bondView;
@end


@implementation IDCMAcceptantPickInBondController
@dynamic viewModel;
#pragma mark — life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfigure];
}

- (void)bindViewModel{
    [super bindViewModel];
 
}
#pragma mark — private methods
#pragma mark — 初始化配置
- (void)initConfigure {
    [self configUI];
}

#pragma mark — 配置UI相关
- (void)configUI {
    
    self.navigationItem.title = NSLocalizedString(@"3.0_AcceptantBondPickIn", nil);
    self.view.backgroundColor = viewBackgroundColor;
    [self.view addSubview:self.bondView];
    [[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:[self class]];
}

-(void)refreshDepositPage{
 
    IDCMCheckAcceptantStateController * stateVC = ( IDCMCheckAcceptantStateController * ) [self.navigationController getViewControllerByname:@"IDCMCheckAcceptantStateController"];
    NSArray * childs = stateVC.childViewControllers;
    
    if (childs.count>0  &&  [childs.firstObject isKindOfClass:[IDCMAcceptantViewController class]]) {
        IDCMAcceptantViewController * vc = (IDCMAcceptantViewController *)  childs.firstObject;
        vc.isNeedRefresh = YES;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark — getters and setters
- (IDCMAcceptantPickinBondView *)bondView {
    return SW_LAZY(_bondView, ({
        @weakify(self);
        [IDCMAcceptantPickinBondView bondViewWithFrame:self.view.bounds
                                       completeSignal:RACSubject.createSubject(^(id value){
            @strongify(self);
            //更新
            [self refreshDepositPage];
        })];
    }));
}

@end











