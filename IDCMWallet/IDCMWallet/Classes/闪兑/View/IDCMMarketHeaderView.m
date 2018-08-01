//
//  IDCMMarketHeaderView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/3/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMMarketHeaderView.h"

@interface HeaderViewBtn : UIButton
@property (nonatomic,assign) CGFloat  center_x;
@end
@implementation HeaderViewBtn
- (void)setHighlighted:(BOOL)highlighted {}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.size = CGSizeMake(46, 46);
    self.imageView.top = 12;
    self.imageView.centerX = self.center_x;
    
    [self.titleLabel sizeToFit];
    self.titleLabel.top = self.imageView.bottom + 10;
    self.titleLabel.centerX = self.imageView.centerX;
}
@end


@interface IDCMMarketHeaderView ()
@property (nonatomic,strong) HeaderViewBtn *flashBtn;
@property (nonatomic,strong) HeaderViewBtn *otcBtn;
@property (nonatomic,assign) CGFloat  itemWidth;
@end


@implementation IDCMMarketHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.flashBtn];
        [self addSubview:self.otcBtn];
        [self configSignal];
    }
    return self;
}

- (void)configSignal {
    RACSignal *flashBtnClickSignal = [[self.flashBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
                                                                     mapReplace:@(HeaderViewSignalType_clickFlashBtn)];
    
    RACSignal *otcBtnClickSignal = [[self.otcBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
                                                                 mapReplace:@(HeaderViewSignalType_clickOTCBtn)];
    
    self.actionSignal = [[RACSignal merge:@[flashBtnClickSignal, otcBtnClickSignal]]
                                takeUntil:[self rac_willDeallocSignal]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.flashBtn.width =
    self.otcBtn.width = self.width / 2;
    self.flashBtn.height =
    self.otcBtn.height = self.height;
    self.otcBtn.left = self.flashBtn.width;
}

- (HeaderViewBtn *)flashBtn {
    return SW_LAZY(_flashBtn, ({
        
        HeaderViewBtn *btn = [HeaderViewBtn buttonWithType:UIButtonTypeCustom];
        [btn setTitle:NSLocalizedString(@"3.0_FlashExchange", nil) forState:UIControlStateNormal];
        btn.titleLabel.font = textFontPingFangRegularFont(14);
        [btn setTitleColor:textColor333333 forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"3.0_flashExchange"] forState:UIControlStateNormal];
        btn.center_x = (SCREEN_WIDTH - (self.itemWidth * 2)) / 3 + self.itemWidth / 2;
        btn;
    }));
}

- (HeaderViewBtn *)otcBtn {
    return SW_LAZY(_otcBtn, ({
        
        HeaderViewBtn *btn = [HeaderViewBtn buttonWithType:UIButtonTypeCustom];
        [btn setTitle:NSLocalizedString(@"3.0_OTCExchange", nil) forState:UIControlStateNormal];
        btn.titleLabel.font = textFontPingFangRegularFont(14);
        [btn setTitleColor:textColor333333 forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"3.0_OTC"] forState:UIControlStateNormal];
        btn.center_x = ((SCREEN_WIDTH - (self.itemWidth * 2)) / 3) / 2 + self.itemWidth / 2;
        btn;
    }));
}

- (CGFloat)itemWidth {
    return SW_LAZY(_itemWidth, ({
        
        CGFloat leftProgressWidth = [NSLocalizedString(@"3.0_FlashExchangeRecord", nil)
                                     widthForFont:textFontPingFangRegularFont(14)];
        leftProgressWidth = leftProgressWidth > (SCREEN_WIDTH / 2) ? (SCREEN_WIDTH / 2) : leftProgressWidth;
        
        CGFloat rightProgressWidth = [NSLocalizedString(@"3.0_OTCExchangeRecord", nil)
                                      widthForFont:textFontPingFangRegularFont(14)];
        rightProgressWidth = rightProgressWidth > (SCREEN_WIDTH / 2) ? (SCREEN_WIDTH / 2) : rightProgressWidth;
        
        CGFloat itemWidth = MAX(130, MAX(leftProgressWidth, rightProgressWidth));
        
        itemWidth;
    }));
}

@end

