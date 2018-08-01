//
//  IDCMOTCAcceptanceOrderDetailHeaderView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/5/8.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMOTCAcceptanceOrderDetailHeaderView.h"
#import "UIView+UIViewController.h"

@interface IDCMOTCAcceptanceOrderDetailHeaderView ()
/**
 *  closeButton
 */
@property (strong, nonatomic) UIButton *closeButton;
/**
 *  剩余时间
 */
@property (strong, nonatomic) UILabel *restLabel;
/**
 *  提示语
 */
@property (strong, nonatomic) UILabel *tipsLabel;

@end

@implementation IDCMOTCAcceptanceOrderDetailHeaderView
#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self initUI];
        
        [self bindData];
    }
    return self;
}


#pragma mark - Public Methods
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.restLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kSafeAreaTop+2);
        make.height.mas_equalTo(42);
        make.left.equalTo(self.closeButton.mas_right);
        make.right.equalTo(self.mas_right).offset(-60);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.restLabel.mas_centerY);
        make.height.equalTo(@35);
        make.width.equalTo(@60);
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.restLabel.mas_bottom).offset(5);
        make.left.right.equalTo(self);
        make.height.greaterThanOrEqualTo(@20);
    }];
}

#pragma mark - Privater Methods
- (void)initUI{
    [self addSubview:self.closeButton];
    [self addSubview:self.restLabel];
    [self addSubview:self.tipsLabel];
}

#pragma mark - Action
- (void)bindData{
    
    self.dataSubject = [RACSubject subject];
    
    @weakify(self);
    [[self.dataSubject deliverOnMainThread]
     subscribeNext:^(RACTuple *tupe) {
        @strongify(self);
         
         if ([tupe.first isKindOfClass:[NSString class]]) {
             self.tipsLabel.text = tupe.first;
         }else{
             NSInteger restTime = [tupe.first integerValue];
             restTime = MAX(0, restTime);
             self.restLabel.attributedText = [self attributedStringByTime:restTime];
         }
         
         
         if ([tupe count] > 1) {
             self.tipsLabel.text = tupe.second;
         }

    }];
    
    self.closeButton.rac_command = RACCommand.emptyCommand(^(UIButton *btn){
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    });

    
}
- (NSAttributedString *)attributedStringByTime:(NSInteger)time {
    NSString *timeStr = [NSString stringWithFormat:@"%lds",(long)time];
    NSString *rest = SWLocaloziString(@"3.0_Bin_RestTime");
    NSString *allStr = [NSString stringWithFormat:@"%@ %@",rest ,timeStr];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:allStr];
    UIFont *font = textFontPingFangMediumFont(30);
    UIColor *color = time > 30 ? SetColor(59, 153, 251) :  SetColor(255, 102, 102);
    [attStr addAttributes:@{NSForegroundColorAttributeName:color,
                            NSFontAttributeName:font
                            }
                    range:[allStr rangeOfString:timeStr]];
    return attStr.copy;
}

#pragma mark - Getter & Setter
- (UIButton *)closeButton{
    
    return SW_LAZY(_closeButton, ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"2.0_close"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"2.0_close"] forState:UIControlStateHighlighted];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button;
    }));
}
- (UILabel *)restLabel{
    
    return SW_LAZY(_restLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangMediumFont(14);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = SetColor(188, 203, 223);
        label;
    }));
}
- (UILabel *)tipsLabel{
    
    return SW_LAZY(_tipsLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangRegularFont(14);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = textColor333333;
        label.numberOfLines = 2;
        label;
    }));
}
@end
