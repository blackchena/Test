//
//  IDCMAcceptantBondSuccessView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/13.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptantBondSuccessView.h"


@interface IDCMAcceptantBondSuccessView ()
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titlaLabel;
@property (nonatomic,strong) UILabel *subTitelLabel;
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) id title;
@property (nonatomic,strong) id subTitle;
@property (nonatomic,copy) NSString *btnTitle;
@end


@implementation IDCMAcceptantBondSuccessView

+ (instancetype)bondSuccessViewTitle:(id)title
                    subTitle:(id)subTitle
                    btnTitle:(NSString *)btnTitle
               completeInput:(CommandInputBlock)completeInput {
    
    IDCMAcceptantBondSuccessView *tipView = [[self alloc] init];
    tipView.title = title;
    tipView.subTitle = subTitle;
    tipView.btnTitle = btnTitle;
    tipView.backgroundColor = UIColorWhite;
    CGSize size = CGSizeMake(SCREEN_WIDTH, 440);
    tipView.size = size;
    [tipView initConfigure];
    tipView.btn.rac_command = RACCommand.emptyCommand(completeInput);;
    return tipView;
}

- (void)initConfigure {
    
    [self addSubview:self.imageView];
    [self addSubview:self.titlaLabel];
    if ([self.subTitle isKindOfClass:[NSString class]] ||
        [self.subTitle isKindOfClass:[NSMutableAttributedString class]] ||
        [self.subTitle isKindOfClass:[NSAttributedString class]]) {
        if (((NSString *)(self.subTitle)).length) {
            [self addSubview:self.subTitelLabel];
        }
    }
    [self addSubview:self.btn];
}

- (UIImageView *)imageView {
    return SW_LAZY(_imageView, ({
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.image = [UIImage imageNamed:@"2.0_success"];
        imageView.size = CGSizeMake(60, 60);
        imageView.top = 54;
        imageView.centerX = self.width / 2;
        imageView;
    }));
}

- (UILabel *)titlaLabel {
    return SW_LAZY(_titlaLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor colorWithHexString:@"#2968B9"];
        label.font = textFontPingFangRegularFont(18);
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.width = self.width - 24;
        CGFloat height = 0.0;;
        if ([self.title isKindOfClass:[NSString class]]) {
            label.text = self.title;
            height =  [label.text heightForFont:label.font width:label.width - 5];
        }
        if ([self.title isKindOfClass:[NSMutableAttributedString class]] ||
            [self.title isKindOfClass:[NSAttributedString class]]) {
            label.attributedText = self.title;
            NSMutableAttributedString *str = self.title;
            height =
            [str boundingRectWithSize:CGSizeMake(label.width - 5, MAXFLOAT)
                              options:NSStringDrawingUsesLineFragmentOrigin
                              context:nil].size.height;
        }
        label.height = height;
        label.top = self.imageView.bottom + 22;
        label.centerX = self.imageView.centerX;
        label;
    }));
}

- (UILabel *)subTitelLabel {
    return SW_LAZY(_subTitelLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor333333;
        label.font = textFontPingFangRegularFont(14);
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        CGFloat height = 0.0;
        label.width = self.width - 24;
        if ([self.title isKindOfClass:[NSString class]]) {
            label.text = self.subTitle;
            height =  [label.text heightForFont:label.font width:label.width - 5];
        }
        if ([self.title isKindOfClass:[NSMutableAttributedString class]] ||
            [self.title isKindOfClass:[NSAttributedString class]]) {
            label.attributedText = self.subTitle;
            NSMutableAttributedString *str = self.subTitle;
            height =
            [str boundingRectWithSize:CGSizeMake(label.width - 5, MAXFLOAT)
                              options:NSStringDrawingUsesLineFragmentOrigin
                              context:nil].size.height;
        };
        label.height = height;
        label.top = self.titlaLabel.bottom + 18;
        label.centerX = self.imageView.centerX;
        label;
    }));
}

- (UIButton *)btn {
    return SW_LAZY(_btn, ({
        
        UIButton *btn = [[UIButton alloc] init];
        btn.width = self.width - 68 * 2;
        btn.height = 40;
        btn.top = 314;
        btn.centerX = self.imageView.centerX;
        btn.layer.cornerRadius = 6.0;
        btn.layer.masksToBounds = YES;
        btn.adjustsImageWhenHighlighted = NO;
        [btn setTitle:self.btnTitle forState:UIControlStateNormal];
        btn.titleLabel.font = textFontPingFangRegularFont(16);
        UIImage *image1 = [UIImage imageWithColor:kThemeColor];
        [btn setBackgroundImage:image1 forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn;
    }));
}

@end







