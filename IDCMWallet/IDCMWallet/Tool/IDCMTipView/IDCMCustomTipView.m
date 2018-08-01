//
//  IDCMCustomTipView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/5/26.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMCustomTipView.h"


@interface IDCMCustomTipView ()
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) RACTuple *titleConfigure;

@property (nonatomic,copy) NSString *message;
@property (nonatomic,strong) UILabel *messageLabel;
@property (nonatomic,strong) RACTuple *messageConfigure;

@property (nonatomic,strong) UIView *buttonsView;
@property (nonatomic,assign) NSNumber *colorIndex;
@property (nonatomic,strong) NSArray<NSString *>* buttonTitleArray;
@property (nonatomic,strong) void (^clickButtonCallback)(NSInteger clickIndex);
@end


@implementation IDCMCustomTipView
+ (void)showWithTitle:(NSString *)title
       titleConfigure:(RACTuple *)titleConfigure
              message:(NSString *)message
     messageConfigure:(RACTuple *)messageConfigure
     buttonTitleArray:(NSArray<NSString *>*)buttonTitleArray
           colorIndex:(NSNumber *)index
  clickButtonCallback:(void(^)(NSInteger clickIndex))clickButtonCallback {
    
    IDCMCustomTipView *tipView = [[self alloc] init];
    tipView.backgroundColor = UIColorWhite;
    tipView.width = SCREEN_WIDTH - 70;
    
    tipView.title = title;
    tipView.titleConfigure = titleConfigure;
    tipView.message = message;
    tipView.messageConfigure = messageConfigure;
    tipView.buttonTitleArray = buttonTitleArray;
    tipView.colorIndex = index;
    tipView.clickButtonCallback = [clickButtonCallback copy];
    [tipView initConfigure];
    
    CGFloat bottomMargin = (buttonTitleArray.count - 1) != [index integerValue] ? 10 : 30;
    
    tipView.layer.cornerRadius = 6.0;
    tipView.layer.masksToBounds = YES;
    
    [self showTipViewToView:nil
                       size:CGSizeMake(tipView.width, tipView.buttonsView.bottom + bottomMargin)
                contentView:tipView
           automaticDismiss:NO
             animationStyle:2
      tipViewStatusCallback:nil];
}

- (void)initConfigure {
    [self configUI];
}

- (void)configUI {
    [self addSubview:self.titleLabel];
    [self addSubview:self.messageLabel];
    [self addSubview:self.buttonsView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

#pragma mark  -- setter && getter
-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = textColor333333;
        _titleLabel.font = textFontPingFangRegularFont(16);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = self.title;
        
        if (self.titleConfigure && self.titleConfigure.count == 2) {
            _titleLabel.font = self.titleConfigure.first;
            _titleLabel.textColor = self.titleConfigure.last;
        }
        
        _titleLabel.width = self.width - 60;
        _titleLabel.height = [self.title heightForFont:_titleLabel.font width:_titleLabel.width - 4];
        if (!self.title.length) {
             _titleLabel.height = 0.0;
        }
        _titleLabel.top = (self.message.length && self.title.length) ? 20 : 30;
        _titleLabel.centerX = self.width / 2;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = textColor666666;
        _messageLabel.font = textFontPingFangRegularFont(12);
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.numberOfLines = 0;
        _messageLabel.text = self.message;
        
        if (self.messageConfigure && self.messageConfigure.count == 2) {
            _messageLabel.font = self.messageConfigure.first;
            _messageLabel.textColor = self.messageConfigure.last;
        }
        _messageLabel.width = self.titleLabel.width;
        _messageLabel.height = [self.message heightForFont:_messageLabel.font width:_messageLabel.width - 4];
        if (self.title.length && self.message.length) {
             _messageLabel.top = self.titleLabel.bottom + 20;
        
        }else {
            _messageLabel.top = self.titleLabel.bottom;
            _messageLabel.height = 0.0;
        }
        _messageLabel.centerX = self.titleLabel.centerX;
    }
    return _messageLabel;
}


- (UIView *)buttonsView {
    if (!_buttonsView){
        _buttonsView = [[UIView alloc] init];
        
        _buttonsView.width = self.titleLabel.width;
        if (self.buttonTitleArray.count) {
            _buttonsView.height = self.buttonTitleArray.count * 40 + (self.buttonTitleArray.count - 1) * 20;
            for (NSString *title in self.buttonTitleArray) {
                [_buttonsView addSubview:[self createButtonWithTitle:title]];
            }
        }
        if (self.title.length || self.message.length) {
            _buttonsView.top = self.messageLabel.bottom + 30;
        } else {
            _buttonsView.top = self.messageLabel.bottom;
        }
        _buttonsView.centerX = self.titleLabel.centerX;
    }
    return _buttonsView;
}

- (UIButton *)createButtonWithTitle:(NSString *)title {
    UIButton *btn = [UIButton creatCustomButtonNormalStateWithTitile:title
                                                           titleFont:textFontPingFangRegularFont(16)
                                                          titleColor:textColorFFFFFF
                                                        butttonImage:nil
                                                     backgroundImage:nil
                                                     backgroundColor:nil
                                                    clickThingTarget:nil
                                                              action:nil];
    
    NSInteger index = [self.buttonTitleArray indexOfObject:title];
    btn.width = _buttonsView.width;
    btn.height = 40;
    btn.left = 0;
    btn.top = index * (btn.height + 10);
    btn.layer.cornerRadius = 4.0f;
    btn.layer.masksToBounds = YES;
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateSelected];
    if (self.colorIndex) {
        btn.selected = !(index == [self.colorIndex integerValue]);
    } else {
         btn.selected = !(index == 0);
    }
    
    [btn ba_buttonSetBackgroundColor:textColorFFFFFF forState:UIControlStateSelected  animated:NO];
    [btn setTitleColor:UIColorFromRGB(0x2E406B) forState:UIControlStateSelected];
    
    [btn ba_buttonSetBackgroundColor:UIColorFromRGB(0x2E406B) forState:UIControlStateNormal animated:NO];
    [btn setTitleColor:textColorFFFFFF forState:UIControlStateNormal];
     
    @weakify(self)
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [IDCMCustomTipView dismissWithCompletion:^{
           !self.clickButtonCallback ?: self.clickButtonCallback(index);
        }];
    }];
    
    return btn;
}

@end








