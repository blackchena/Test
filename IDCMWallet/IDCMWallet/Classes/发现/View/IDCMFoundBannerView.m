//
//  IDCMFoundBannerView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/5/22.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMFoundBannerView.h"
#import <YJBannerView.h>
#import "IDCMBannerModel.h"

@interface IDCMFoundBannerView ()<YJBannerViewDataSource, YJBannerViewDelegate>
/**
 *  bannerView
 */
@property (strong, nonatomic) YJBannerView *bannerView;
/**
 *  数据源
 */
@property (strong, nonatomic) NSArray *data;
/**
 *  选择信号
 */
@property (strong, nonatomic) RACCommand *selection;
@end

@implementation IDCMFoundBannerView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self= [super initWithFrame:frame]) {
        [self addSubview:self.bannerView];
        self.data = @[];
    }
    return self;
}
- (void)bindingBannerViewForSourceSignal:(RACSignal *)source
                        selectionCommand:(RACCommand *)didSelectionCommand{
    
    @weakify(self);
    self.selection = didSelectionCommand;
    [source subscribeNext:^(id x) {
        @strongify(self);
        self.data = x;
        [self.bannerView reloadData];
    }];
    
}
#pragma mark - Public Methods
- (void)startTimerWhenAutoScroll{
    
    [self.bannerView startTimerWhenAutoScroll];
}
- (void)invalidateTimerWhenAutoScroll{
    [self.bannerView invalidateTimerWhenAutoScroll];
}
- (void)adjustBannerViewWhenCardScreen{
    [self.bannerView adjustBannerViewWhenCardScreen];
}
#pragma mark - Action
// 将网络图片或者本地图片 或者混合数组
- (NSArray *)bannerViewImages:(YJBannerView *)bannerView{
    
    NSMutableArray *arr = @[].mutableCopy;
    [self.data enumerateObjectsUsingBlock:^(IDCMBannerModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObject:obj.ImageUrl];
    }];
    return arr;
}
// 点击了哪个bannerView 的 第几个元素
-(void)bannerView:(YJBannerView *)bannerView didSelectItemAtIndex:(NSInteger)index{
    
    IDCMBannerModel *model = self.data[index];
    if (self.data.count > 0 && [model.Url isNotBlank]) {
        
        [self.selection execute:model.Url];
    }
}

#pragma mark - Getter & Setter
- (YJBannerView *)bannerView{
    
    return SW_LAZY(_bannerView, ({
        YJBannerView *view = [YJBannerView bannerViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)
                                                    dataSource:self
                                                      delegate:self
                                                    emptyImage:UIImageMake(@"3.0_Found_PlaceHolder")
                                              placeholderImage:UIImageMake(@"3.0_Found_PlaceHolder")
                                                selectorString:@"sd_setImageWithURL:placeholderImage:"];
        view.pageControlStyle = PageControlCustom;
        view.customPageControlHighlightImage = UIImageMake(@"3.0_Found_SelectDot");
        view.customPageControlNormalImage = UIImageMake(@"3.0_Found_NomalDot");
        view.pageControlBottomMargin = 10.0f;
        view.pageControlDotSize = CGSizeMake(20, 6);
        view.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        view;
    }));
}

@end
