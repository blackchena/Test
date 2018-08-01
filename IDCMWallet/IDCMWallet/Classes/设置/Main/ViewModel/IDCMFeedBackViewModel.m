//
//  IDCMFeedBackViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/2/5.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMFeedBackViewModel.h"

@implementation IDCMFeedBackViewModel
- (void)initialize
{
    [super initialize];
    
    self.validSubmitSignal = [[RACSignal
                               combineLatest:@[ RACObserve(self, feedText), RACObserve(self, contactText)]
                               reduce:^(NSString *feedText,NSString *contactText) {
                                   return @(feedText.length > 0  && contactText.length > 0 );
                               }]
                              distinctUntilChanged];
}
- (RACSignal *)executeRequestDataSignal:(id)input
{

    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {

        NSDictionary *para = @{@"content":self.feedText,
                               @"contact":self.contactText
                               };
        IDCMURLSessionTask *task = [IDCMRequestList requestNotAuth:FeedBack_URL params:para success:^(NSDictionary *response) {
            
            NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
            if ([status isEqualToString:@"100"]) {
                [subscriber sendError:nil];
            }else if([status isEqualToString:@"1"]){
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
}
@end
