//
//  IDCMAcceptantApplyCompleteView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/11.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptantApplyCompleteView.h"

@interface IDCMAcceptantApplyCompleteView ()
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *infoLabel;
@property (nonatomic,strong) UIButton *btn;
@end


@implementation IDCMAcceptantApplyCompleteView
+ (instancetype)completeViewWithFrame:(CGRect)frame
                        completeInput:(CommandInputBlock)completeInput {
    
    IDCMAcceptantApplyCompleteView *view = [[self alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = frame;
    view.alwaysBounceVertical = YES;
    [view initConfigure];
    view.btn.rac_command = RACCommand.emptyCommand(completeInput);
    return view;
}


- (void)initConfigure {

    [self addSubview:self.imageView];
    [self addSubview:self.infoLabel];
    [self addSubview:self.btn];
}


- (UIImageView *)imageView {
    return SW_LAZY(_imageView, ({
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.image = [UIImage imageNamed:@"2.0_success"];
        imageView.size = CGSizeMake(60, 60);
        imageView.top = 60;
        imageView.centerX = self.width / 2;
        imageView;
    }));
}

- (UILabel *)infoLabel {
    return SW_LAZY(_infoLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.textColor = textColor333333;
        label.font = textFontPingFangRegularFont(14);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = NSLocalizedString(@"3.0_AcceptantApplySuccessInfo", nil);
        label.width = self.width - 24;
        CGFloat height =  [label.text heightForFont:label.font width:label.width - 5];
        label.height = height;
        label.top = self.imageView.bottom + 22;
        label.centerX = self.imageView.centerX;
        label;
    }));
}


- (UIButton *)btn {
    return SW_LAZY(_btn, ({
        
        UIButton *btn = [[UIButton alloc] init];
        btn.width = self.width - 68 * 2;
        btn.height = 40;
        btn.top = self.infoLabel.bottom + 80;
        btn.centerX = self.infoLabel.centerX;
        btn.layer.cornerRadius = 6.0;
        btn.layer.masksToBounds = YES;
        btn.adjustsImageWhenHighlighted = NO;
        [btn setTitle:NSLocalizedString(@"2.0_gongxiButton", nil) forState:UIControlStateNormal];
        btn.titleLabel.font = textFontPingFangRegularFont(16);
        UIImage *image1 = [UIImage imageWithColor:kThemeColor];
        [btn setBackgroundImage:image1 forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn;
    }));
}


@end









