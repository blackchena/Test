//
//  IDCMOTCExchangeDetailController.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/6.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMOTCExchangeRecordController.h"
#import "IDCMOTCExchangeDetailController.h"
#import "IDCMOTCExchangeDetailViewModel.h"
#import "IDCMTradingPageViewController.h"
#import "IDCMExchangeDetailInfoView.h"
#import "IDCMOTCChatController.h"



@interface IDCMOTCExchangeDetailController ()
@property (nonatomic,strong) IDCMExchangeDetailInfoView *detailInfoView;
@property (nonatomic,strong) IDCMOTCExchangeDetailViewModel *viewModel;
@property (nonatomic,weak)   IDCMOTCChatController *chatVc;
@property (nonatomic,weak)   UIViewController *recordVc;
@property (nonatomic,assign) CGFloat keyboardHeight;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,assign) BOOL stausChange;
@property (nonatomic,assign) BOOL isAppeared;
@property (nonatomic,assign) BOOL hasShow;
@end


@implementation IDCMOTCExchangeDetailController
@dynamic viewModel;
#pragma mark — life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConfigure];
    [[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:[IDCMOTCChatController class]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardddWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardddWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    if (self.isAppeared) {
        [self.detailInfoView photoScorllToCenter];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.isAppeared = YES;
    UIViewController *pageVc = [self.navigationController getViewControllerByIndex:0];
    __block UIViewController *recordVc = nil;
    [pageVc.childViewControllers enumerateObjectsUsingBlock:^(UIViewController *obj,
                                                              NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(@"IDCMOTCExchangeRecordController")]) {
            recordVc = obj;
            *stop = YES;
        }
    }];
    self.recordVc = recordVc;
}

- (BOOL)shouldHoldBackButtonEvent {
    return YES;
}

- (BOOL)canPopViewController {
    [self refreshExchangeRecord];
    return YES;
}

- (void)hookControllerBackGestureWithState:(ControllerBackGestureState)state {
    if (state == ControllerBackGestureState_SuccessPop) {
        [self refreshExchangeRecord];
    }
}

- (void)refreshExchangeRecord {
    if (self.stausChange) {
        [[RACScheduler mainThreadScheduler] afterDelay:.25 schedule:^{
            if (self.recordVc) {
                if ([self.recordVc respondsToSelector:NSSelectorFromString(@"refreshRecord")]) {
                    [self.recordVc performSelectorOnMainThread:NSSelectorFromString(@"refreshRecord")
                                                    withObject:nil waitUntilDone:nil];
                }
            }
        }];
    }
}

- (void)bindViewModel {
    [super bindViewModel];
    
    self.status = -1;
    @weakify(self);
    [[[self.viewModel.oTCExchangeDetailCommand.executionSignals switchToLatest]
      deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self);
        [self dismissEmptyView];
        [self configDetailInfoView];
    }];
    [self.viewModel.oTCExchangeDetailCommand.errors subscribeNext:^(NSError * x) {
        @strongify(self);
        [self showEmptyView];
    }];
    
    if (![self.viewModel.orderId isKindOfClass:[NSString class]] ||
        [self.viewModel.orderId integerValue] <= 0 ||
        !self.viewModel.orderId.length) {
        [self showEmptyView];
        return;
    }
    [self.viewModel.oTCExchangeDetailCommand execute:nil];
}

#pragma mark — private methods
#pragma mark — 初始化配置
- (void)initConfigure {
    [self configUI];
}

#pragma mark — 配置UI相关
- (void)configUI {
    self.view.height = SCREEN_HEIGHT  - 64 - kStatusBarDifferHeight;
    self.navigationItem.title = NSLocalizedString(@"3.0_Hy_OTCExchangeDetailTitle", nil);
    self.view.backgroundColor = [UIColor whiteColor];// viewBackgroundColor;
}


- (void)configDetailInfoView {
    @weakify(self);
    if (self.detailInfoView.superview) {return;}
    
    void (^detailInfoViewSignal)(id) = ^(id x){
        @strongify(self);
        CGFloat value = [x floatValue];
        if (!self.hasShow) {
            self.chatVc.view.top = value;
            self.chatVc.view.height = self.view.height - value - kSafeAreaBottom;
            [self.chatVc.view setNeedsLayout];
            [self.chatVc.view layoutIfNeeded];
        }
    };
    
    void (^detailInfoViewChangeSignal)(id) = ^(id x){
        @strongify(self);
        CGFloat currentTop = self.chatVc.view.top;
        CGFloat currentHeight = self.chatVc.view.height;
        CGFloat changeH = [x floatValue];
        CGFloat keyB = self.keyboardHeight;
        if (changeH < 0) {
            keyB = - self.keyboardHeight;
        }
        if (changeH > 0 && !self.detailInfoView.isClickResignFirstResponse) {
            [self scrollToBottomWithChangeHeight:changeH];
        }
        [UIView animateWithDuration:.25
                              delay:.01
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                              self.chatVc.view.top = currentTop - changeH;
                              self.chatVc.view.height = currentHeight + changeH - keyB;
                              [self.chatVc.view layoutIfNeeded];
                         } completion:nil];
    };
    
    [RACObserve(self.detailInfoView, height) subscribeNext:detailInfoViewSignal];
    [self.view addSubview:self.detailInfoView];
    self.detailInfoView.width = SCREEN_WIDTH;
    self.detailInfoView.heigthChangeSignal = RACSubject.createSubject(detailInfoViewChangeSignal);
    
    IDCMOTCChatController *chatVc = [[IDCMOTCChatController alloc] init];
    chatVc.orderID = self.viewModel.orderId;
    chatVc.isSell = self.viewModel.detailModel.exchangeType == OTCExchangeType_Sell;
    [self addChildViewController:chatVc];
    self.chatVc = chatVc;
    detailInfoViewSignal(@(self.detailInfoView.height));
    [self.view insertSubview:chatVc.view belowSubview:self.detailInfoView];
    
    void (^subscribType)(id) =  ^(id x) {
        @strongify(self);
        NSInteger value = [x integerValue];
        if (self.status != -1 && self.status != value) {
            self.stausChange = YES;
        }
        self.status = value;
        if ((value == 8 || value == 9 || value == 12)) {
            [self.chatVc orderDown];
        } else {
            [self.chatVc orderDoing];
        }
    };
    if (self.viewModel.detailModel.exchangeType == OTCExchangeType_Buy) {
        subscribType(@(self.viewModel.detailModel.exchangeBuyStateType));
        [RACObserve(self.viewModel.detailModel, exchangeBuyStateType) subscribeNext:subscribType];
    } else {
        subscribType(@(self.viewModel.detailModel.exchangeSellStateType));
        [RACObserve(self.viewModel.detailModel, exchangeSellStateType) subscribeNext:subscribType];
    }

    self.chatVc.view.alpha = 0.0;
    self.detailInfoView.alpha = 0.0;
    [UIView animateWithDuration:.5 animations:^{
        self.detailInfoView.alpha = 1.0;
        self.chatVc.view.alpha = 1.0;
    }];
}

static BOOL animation = NO;
static BOOL firstAnim = YES;
- (void)scrollToBottomWithChangeHeight:(CGFloat)changeHeight {
    if (animation) {return;}
    animation = YES;
    CGFloat ff = self.chatVc.tableView.contentSize.height - (self.chatVc.tableView.bounds.size.height + changeHeight - self.keyboardHeight);

    BOOL animated =
    ((self.chatVc.tableView.contentSize.height - self.chatVc.tableView.height) - self.chatVc.tableView.contentOffset.y + 6) >
    (self.chatVc.tableView.height - self.keyboardHeight + changeHeight);
    if (firstAnim) {
        animated = NO;
        firstAnim = NO;
    }
    
    CGPoint bottomOffset = CGPointMake(0, MAX(-6, ff + 6));
    if (self.chatVc.tableView.contentOffset.y != bottomOffset.y) {
        [self.chatVc.tableView setContentOffset:bottomOffset animated:animated];
    }
    [[RACScheduler mainThreadScheduler] afterDelay:.5 schedule:^{
        animation = NO;
    }];
}

- (void)showEmptyView{
    @weakify(self);
    [IDCMHUD showEmptyViewToView:self.view configure:^(IDCMHUDConfigure *configure) {
        configure.title(NSLocalizedString(@"3.0_NetWorkBusy", nil))
        .image(UIImageMake(@"2.1_NoDataImage"))
        .backgroundImage([UIImage imageWithColor:[UIColor whiteColor]]);
    } reloadCallback:^{
        @strongify(self);
        [self.viewModel.oTCExchangeDetailCommand execute:nil];
    }];
}

- (void)dismissEmptyView{
    [IDCMHUD dismissEmptyViewForView:self.view];
}

#pragma mark — observer
- (void)keyboardddWillShow:(NSNotification*)aNotification {

    self.hasShow = YES;
    CGFloat height =
    [[aNotification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat duration =
    [aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];

    self.keyboardHeight = height;
    BOOL booy = [self.detailInfoView upAnimation];
    if (!booy) {
//        [self scrollToBottomWithChangeHeight:0.0];
        
        BOOL animated =
        ((self.chatVc.tableView.contentSize.height - self.chatVc.tableView.height) - self.chatVc.tableView.contentOffset.y + 6) >
        (self.chatVc.tableView.height - self.keyboardHeight);
        if (firstAnim) {
            animated = NO;
            firstAnim = NO;
        }
        
        CGFloat currentTop = self.view.height - self.chatVc.view.top ;
        [UIView animateWithDuration:duration animations:^{
            self.chatVc.view.height = currentTop - height;
            [self.chatVc.view layoutIfNeeded];
            [self.chatVc setToBottom:animated];
        } completion:^(BOOL finished) {
               animation = NO;
        }];
    }
}

-(void)keyboardddWillHide:(NSNotification*)aNotification {
    if (!self.hasShow) {return;}
    
    CGFloat duration =
    [aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (!self.detailInfoView.isClickResignFirstResponse) {
        [UIView animateWithDuration:duration animations:^{
             self.chatVc.view.height = self.view.height - self.chatVc.view.top - kSafeAreaBottom ;
            [self.chatVc.view layoutIfNeeded];
        }];
    }
    [[RACScheduler mainThreadScheduler] afterDelay:.25 schedule:^{
        self.keyboardHeight = 0.0;
        self.hasShow = NO;
    }];
}

#pragma mark - getters and setters
- (IDCMExchangeDetailInfoView *)detailInfoView {
    return SW_LAZY(_detailInfoView, ({
        [IDCMExchangeDetailInfoView detailInfoViewWithViewModel:self.viewModel];
    }));
}

- (void)dealloc {
    [self.viewModel disposeAllSignal];
}

@end






