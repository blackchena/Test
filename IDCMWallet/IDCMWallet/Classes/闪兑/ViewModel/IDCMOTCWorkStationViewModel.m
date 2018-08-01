//
//  IDCMOTCWorkStationViewModel.m
//  IDCMWallet
//
//  Created by 数维科技 on 2018/5/4.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMOTCWorkStationViewModel.h"

@implementation IDCMOTCWorkStationViewModel

-(void)initialize{
    [super initialize];
//    @weakify(self);
    
//    self.cancelOrderCommand =
//    [RACCommand commandAuth:str
//                 serverName:nil
//                     params:^id(id input) { return  nil; }
//              handleCommand:^(id input, id response, id<RACSubscriber> subscriber) {
//                  ([response[kStatus] integerValue] == 100) ?
//                  ([subscriber sendError:nil]) :
//                  ({
//                      if ([response[kStatus] integerValue] == 1 && [response[kData] isKindOfClass:[NSDictionary class]]) {
//                          [subscriber sendNext:nil];
//                      }
//                      else{
//                          [IDCMShowMessageView showMessageWithCode:response[kStatus]];
//                      }
//                      [subscriber sendCompleted];
//                  });
//              }];
    
    self.confirmOfferOrderCommand =
    [RACCommand commandAuth:ConfirmOfferOrder_URL
                 serverName:nil
                     params:^id(id input) { return  input; }
              handleCommand:^(id input, id response, id<RACSubscriber> subscriber) {
                  NSInteger status = [response[kStatus] integerValue];
                  (status == 100) ?
                  ([subscriber sendError:nil]) :
                  ({
                      if (status == 1) {
                          
                          [subscriber sendNext:@(YES)];
                          [subscriber sendCompleted];
                      }
                      else{
                          [IDCMShowMessageView showMessageWithCode:[NSString stringWithFormat:@"%zd",status]];
                          [subscriber sendError:nil];
                      }
                  });
              }];
    
}

-(RACCommand *)cancelOrderCommand {
    return SW_LAZY(_cancelOrderCommand , ({
        NSString *str = [NSString stringWithFormat:@"%@?orderId=%ld", CancelOrder_URL, (long)self.orderModel.OrderId];
        
        [RACCommand commandAuth:str
                     serverName:nil
                         params:^id(id input) { return  nil; }
                  handleCommand:^(id input, id response, id<RACSubscriber> subscriber) {
                      NSInteger status = [response[kStatus] integerValue];
                      (status == 100) ?
                      ([subscriber sendError:nil]) :
                      ({
                          if (status == 1) {
                              
                              [subscriber sendNext:@(YES)];
                              [subscriber sendCompleted];
                          }
                          else{
                              [subscriber sendError:nil];
                              [IDCMShowMessageView showMessageWithCode:[NSString stringWithFormat:@"%zd",status]];
                          }
                          
                      });
                  }];
    }));
}
@end
