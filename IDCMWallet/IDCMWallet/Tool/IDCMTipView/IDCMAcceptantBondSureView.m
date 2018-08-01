//
//  IDCMAcceptantBondSureView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/11.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptantBondSureView.h"


@interface IDCMContentLabel : UIView
@property (nonatomic,strong) UILabel *leftLabel;
@property (nonatomic,strong) UILabel *rightLabel;
@property (nonatomic,strong) UIView *line;
@end


@implementation IDCMContentLabel
+ (instancetype)createOneLineViewWithFrame:(CGRect)frame
                             leftTitle:(id)leftTitle
                            rightTitle:(NSString *)rightTitle {
    
    IDCMContentLabel *view = [[IDCMContentLabel alloc] initWithFrame:frame];
    view.backgroundColor = UIColorWhite;
    
    [view initUIWithLeftTitle:leftTitle andRightTitle:rightTitle];
    
    return view;
}
- (void)initUIWithLeftTitle:(id)leftTitle andRightTitle:(NSString *)rightTitle{
    
    
    UILabel *leftLabel = [UILabel new];
    leftLabel.textColor = textColor666666;
    leftLabel.font = textFontPingFangRegularFont(12);
    if ([leftTitle isKindOfClass:[NSAttributedString class]] || [leftTitle isKindOfClass:[NSMutableAttributedString class]]) {
        leftLabel.attributedText = leftTitle;
    }else{
        leftLabel.text = leftTitle;
    }
    leftLabel.left = 12;
    leftLabel.top = 0;
    leftLabel.numberOfLines = 0;
    [leftLabel sizeToFit];
    self.leftLabel = leftLabel;
    [self addSubview:leftLabel];
    
    UILabel *rightLabel = [UILabel new];
    rightLabel.textColor = textColor666666;
    rightLabel.font = textFontPingFangRegularFont(12);
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.numberOfLines = 0;
    rightLabel.text = rightTitle;
    rightLabel.width = self.width - leftLabel.right - 10 - 12;
    if ([rightTitle isNotBlank]) {
        [rightLabel sizeToFit];
    }else{
        rightLabel.height = leftLabel.height;
    }
    
    rightLabel.right = self.width - 12;
    rightLabel.top = leftLabel.top;
    self.rightLabel = rightLabel;
    [self addSubview:rightLabel];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    line.width = self.width - 12;
    line.height = .5;
    line.left = leftLabel.left;
    line.bottom = self.height;
    self.line = line;
    [self addSubview:line];
}
@end

@interface IDCMAcceptantBondSureView ()
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) UILabel *currencyCountLabel;

@property (nonatomic,strong) UIButton *rechargeBtn;

@property (nonatomic,strong) NSMutableArray *contentLabelArr;

@end


@implementation IDCMAcceptantBondSureView

+ (instancetype)bondSureViewWithTitle:(NSString *)title
                             subTitle:(NSString *)subTitle
                         sureBtnTitle:(NSString *)btnTitle
                            confidArr:(NSArray<RACTuple *> *)arr
                        closeBtnInput:(CommandInputBlock)closeBtnInput
                         sureBtnInput:(CommandInputBlock)sureBtnInput
{
    IDCMAcceptantBondSureView *tipView = [[self alloc] init];
    CGSize size = CGSizeMake(SCREEN_WIDTH, 440+kSafeAreaBottom);
    tipView.size = size;
    tipView.backgroundColor = UIColorWhite;
    [tipView initTopViewWithTitle:title andSubTitle:subTitle andSureButtonTitle:btnTitle andButtonType:IDCMCloseButtonImageCloseType];
    [tipView initContentLabel:arr];
    tipView.closeBtn.rac_command = RACCommand.emptyCommand(closeBtnInput);
    tipView.rechargeBtn.rac_command = RACCommand.emptyCommand(sureBtnInput);
    return tipView;
}
+ (instancetype)bondSureViewWithCloseButtonType:(IDCMCloseButtonImageType)buttontype
                                          Title:(NSString *)title
                                       subTitle:(NSString *)subTitle
                                   sureBtnTitle:(NSString *)btnTitle
                                      confidArr:(NSArray<RACTuple *> *)arr
                                  closeBtnInput:(CommandInputBlock)closeBtnInput
                                   sureBtnInput:(CommandInputBlock)sureBtnInput
                               updateDataSignal:(RACSignal *)updateSignal
                                   templeSignal:(RACSignal *)templeSignal
{
    IDCMAcceptantBondSureView *tipView = [[self alloc] init];
    CGSize size = CGSizeMake(SCREEN_WIDTH, 440+kSafeAreaBottom);
    tipView.size = size;
    tipView.backgroundColor = UIColorWhite;
    [tipView initTopViewWithTitle:title andSubTitle:subTitle andSureButtonTitle:btnTitle andButtonType:buttontype];
    [tipView initContentLabel:arr];
    tipView.closeBtn.rac_command = RACCommand.emptyCommand(closeBtnInput);
    tipView.rechargeBtn.rac_command = RACCommand.emptyEnabledCommand(templeSignal,sureBtnInput);
    @weakify(tipView);
    [updateSignal subscribeNext:^(NSArray *tupeArr) {
        
        [tupeArr enumerateObjectsUsingBlock:^(RACTuple *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(tipView);
            
            NSInteger index = [obj.first integerValue];
            IDCMContentLabel *view = tipView.contentLabelArr[index];
            view.rightLabel.text = obj.second;
            
        }];
    }];
    
    return tipView;
}
#pragma mark - Private methods
- (void)initTopViewWithTitle:(NSString *)title andSubTitle:(NSString *)subTitle andSureButtonTitle:(NSString *)btnTitle andButtonType:(IDCMCloseButtonImageType)type{
    

    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, self.width, 48);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (type == IDCMCloseButtonImageBackType) {
        [btn setImage:UIImageMake(@"2.2.1_PINFanHui") forState:UIControlStateNormal];
    }else{
        [btn setImage:UIImageMake(@"2.0_closehui") forState:UIControlStateNormal];
    }
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    btn.size = CGSizeMake(view.height, view.height);
    [view addSubview:btn];
    self.closeBtn = btn;
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = textColor333333;
    label.font = textFontPingFangRegularFont(16);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    label.width = view.width - btn.width * 2;
    label.height = view.height;
    label.centerX = view.width / 2;
    [view addSubview:label];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    line.width = view.width;
    line.height = 1;
    line.bottom = view.height;
    [view addSubview:line];
    
    [self addSubview:view];
    self.topView = view;
    
    [self addSubview:self.currencyCountLabel];
    self.currencyCountLabel.text = subTitle;
    
    [self addSubview:self.rechargeBtn];
    [self.rechargeBtn setTitle:btnTitle forState:UIControlStateNormal];
    
}
- (void)initContentLabel:(NSArray <RACTuple *> *)arr
{
    __block CGFloat stepHeight = self.currencyCountLabel.bottom + 30;
    [arr enumerateObjectsUsingBlock:^(RACTuple * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *leftTitle = obj.first;
        NSString *rightTitle = obj.second;
        CGFloat height = [obj.third floatValue];
        
        CGRect rect = CGRectMake(0, stepHeight , self.width, height);
        IDCMContentLabel *view = [IDCMContentLabel createOneLineViewWithFrame:rect leftTitle:leftTitle rightTitle:rightTitle];
        [self addSubview:view];
        [self.contentLabelArr addObject:view];
        
        stepHeight = stepHeight + height + 20;
    }];
}

#pragma mark - getter
- (UILabel *)currencyCountLabel {
    return SW_LAZY(_currencyCountLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor333333;
        label.font = textFontPingFangMediumFont(20);
        label.textAlignment = NSTextAlignmentCenter;
        label.height = 28;
        label.width = self.width - 24;
        label.top = self.topView.bottom + 20;
        label.left = 12;
        label;
    }));
}

- (UIButton *)rechargeBtn {
    return SW_LAZY(_rechargeBtn, ({
        
        UIButton *btn = [[UIButton alloc] init];
        btn.width = self.width - 24;
        btn.height = 40;
        btn.bottom = self.height - 20-kSafeAreaBottom;
        btn.left = 12;
        btn.layer.cornerRadius = 4.0;
        btn.layer.masksToBounds = YES;
        btn.adjustsImageWhenHighlighted = NO;
        btn.titleLabel.font = textFontPingFangRegularFont(16);
        UIImage *image1 = [UIImage imageWithColor:kThemeColor];
        [btn setBackgroundImage:image1 forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn;
    }));
}
- (NSMutableArray *)contentLabelArr {
    
    return SW_LAZY(_contentLabelArr, @[].mutableCopy);
}
@end






