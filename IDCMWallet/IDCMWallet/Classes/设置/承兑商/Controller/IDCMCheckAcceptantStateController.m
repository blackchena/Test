//
//  IDCMCheckAcceptantStateController.m
//  IDCMWallet
//
//  Created by wangpu on 2018/5/7.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMCheckAcceptantStateController.h"
#import "IDCMAcceptantApplyStartController.h"
#import "IDCMAcceptantViewController.h"
#import "IDCMAcceptantApplyStepsEndVC.h"
@interface IDCMCheckAcceptantStateController ()

@property (nonatomic,strong)  RACCommand * commandGetState;
@property (nonatomic,assign) NSInteger currentStep;
@property (nonatomic,assign) NSInteger acceptantStatus;

@end

@implementation IDCMCheckAcceptantStateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = SWLocaloziString(@"3.0_Bin_AcceptanceTitle");
    self.view.backgroundColor = UIColorWhite;
    [self requestAcceptantState];
}

-(void)requestAcceptantState{
    
    @weakify(self);
    [[self.commandGetState.executionSignals.switchToLatest deliverOnMainThread] subscribeNext:^(NSDictionary * response) {
        
        @strongify(self);
        
        NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
        if ([status isEqualToString:@"1"]) {
            if ([response[@"data"] isKindOfClass:[NSDictionary class]]) {
                NSString *statusCode = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"Status"]];
                NSString *currentStep = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"CurrentStep"]];
                if ([statusCode integerValue] ==  AcceptantStateNotPass) {
                    self.currentStep = [currentStep integerValue] -1;
                }
                self.acceptantStatus = [statusCode integerValue];
                [self showRealViewController];
            }
 
        }else{
            [IDCMShowMessageView showMessageWithCode:status];
        }
    }];
    [self.commandGetState execute:nil];
}

//
-(void)showRealViewController{
    
    switch (self.acceptantStatus) {
        case AcceptantStateNotPass:
        {
            if (self.currentStep ==0 ) {
                IDCMAcceptantApplyStartController *controller = [[IDCMAcceptantApplyStartController alloc] init];
                controller.view.frame = self.view.bounds;
                [self addChildViewController:controller];
                [self.view addSubview:controller.view];
                [controller didMoveToParentViewController:self];
            }else{
                IDCMAcceptantApplyStepsEndVC *controller = [[IDCMAcceptantApplyStepsEndVC alloc] init];
                controller.currentStep = self.currentStep;
                controller.view.frame = self.view.bounds;
                [self addChildViewController:controller];
                [self.view addSubview:controller.view];
                [controller didMoveToParentViewController:self];
            }
 
        }
            break;
        case AcceptantStatePass:
        {
            //完成
            IDCMAcceptantViewController *controller = [[IDCMAcceptantViewController alloc] init];
            controller.view.frame = self.view.bounds;
            [self addChildViewController:controller];
            [self.view addSubview:controller.view];
            [controller didMoveToParentViewController:self];
        }
            break;
        case AcceptantStateFrozen:
        case AcceptantStateCheck:
        {
            IDCMAcceptantViewController *controller = [[IDCMAcceptantViewController alloc] init];
            controller.view.frame = self.view.bounds;
            [self addChildViewController:controller];
            [self.view addSubview:controller.view];
            [controller didMoveToParentViewController:self];
        }
            break;
        default:
            break;
    }
}
-(RACCommand *)commandGetState{
    if (!_commandGetState) {
        _commandGetState = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            //请求余额
            return  [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
    
                IDCMURLSessionTask *task = [IDCMRequestList requestAuth:OTCAcceptant_URL params:nil success:^(NSDictionary *response) {
                    
                    NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
                    if (status.length>0) {
                        [subscriber sendNext:response];
                    }
                    [subscriber sendCompleted];
                    
                } fail:^(NSError *error, NSURLSessionDataTask *task) {
                    [subscriber sendError:error];
                }];
                return [RACDisposable disposableWithBlock:^{
                    [task cancel];
                }];
                
            }];
        }];
    }
    return _commandGetState;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
