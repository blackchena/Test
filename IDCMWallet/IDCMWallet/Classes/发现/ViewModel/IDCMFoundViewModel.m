//
//  IDCMFoundViewModel.m
//  IDCMWallet
//
//  Created by BinBear on 2018/5/21.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMFoundViewModel.h"
#import "IDCMBannerModel.h"
#import "IDCMFoundDappModel.h"

@interface IDCMFoundViewModel ()
/**
 *
 */
@property (strong, nonatomic) NSMutableArray *bannerData;
/**
 *
 */
@property (strong, nonatomic) NSMutableArray *dappData;
@end

@implementation IDCMFoundViewModel
#pragma mark - Life Cycle
- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super initWithParams:params]) {
        
    }
    return self;
}
- (void)initialize
{
    [super initialize];
    
    self.bannerCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMWebViewController"
                                                           withViewModelName:@"IDCMWebViewModel"
                                                                  withParams:@{@"requestURL":input}];
        
        return [RACSignal empty];
    }];
}
- (RACSignal *)executeRequestDataSignal:(id)input{
    
    @weakify(self);
    NSString *url = [NSString stringWithFormat:@"%@?lang=%@&client=1",FoundShow_URL,[IDCMUtilsMethod getServiceLanguage]];
    return [[RACSignal signalGetNoHUDAuth:url serverName:nil params:nil handleSignal:^(id response, id<RACSubscriber> subscriber) {
        @strongify(self);
        NSString *status = [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
        if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
            
            if ([response[@"data"][@"BannerList"] isKindOfClass:[NSArray class]]) {
                [self.bannerData removeAllObjects];
                
                [response[@"data"][@"BannerList"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    IDCMBannerModel *bannerModel = [IDCMBannerModel yy_modelWithDictionary:obj];
                    [self.bannerData addObject:bannerModel];
                }];
            }
            if ([response[@"data"][@"ModuleList"] isKindOfClass:[NSArray class]]) {
                [self.dappData removeAllObjects];
                [response[@"data"][@"ModuleList"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    IDCMFoundDappModel *dappModel = [IDCMFoundDappModel yy_modelWithDictionary:obj];
                    [self.dappData addObject:dappModel];
                }];

            }
            [subscriber sendNext:response];
        }else{
            
            [IDCMShowMessageView showMessageWithCode:status];
        }
        
        [subscriber sendCompleted];
    }] doNext:^(id  _Nullable x) {
        @strongify(self);
        
        if (self.dappData.count > 0) {
            
            self.dappList = [NSArray arrayWithArray:self.dappData];
        }
        if (self.bannerData.count > 0) {
            
            self.bannerList = [NSArray arrayWithArray:self.bannerData];
        }
        
    }];
}
#pragma mark - Privater Methods


#pragma mark - Getter & Setter
- (NSMutableArray *)bannerData{
    
    return SW_LAZY(_bannerData, @[].mutableCopy);
}
- (NSMutableArray *)dappData{
    
    return SW_LAZY(_dappData, @[].mutableCopy);
}
@end
