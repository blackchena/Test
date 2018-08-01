//
//  IDCMNowTimeExhangeRecordView.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/7.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IDCMNewOrderNoticeAcceptantModel.h"

@interface IDCMNowTimeExhangeRecordView : UIView

//+ (IDCMNowTimeExhangeRecordView *)share;

- (void)showWithDismissCallback:(void(^)(void))dismissCallback;

- (BOOL)isEmpty;

- (void)fetchHisCallback:(void(^)(void))callback;

- (NSString *)getCountString;
@property (nonatomic,strong) RACSignal *countSignal;

@end
