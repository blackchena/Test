//
//  IDCMCenterTipView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/5.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMCenterTipView.h"


@interface IDCMCenterTipViewBtnConfigure ()
@property (nonatomic,strong) id centerTipView_btnTitle;
@property (nonatomic,assign) IDCMCenterTipViewBtnType centerTipView_btnType;
@property (nonatomic,copy) btnAction centerTipView_btnCallback;
@end
@implementation IDCMCenterTipViewBtnConfigure
+ (instancetype)btnConfigure {
    return [[self alloc] init];
}
- (id)getBtnTitle {
    return _centerTipView_btnTitle;
}
- (IDCMCenterTipViewBtnType)getBtnType {
    return _centerTipView_btnType;
}
- (btnAction)getBtnCallback {
    return _centerTipView_btnCallback;
}
- (btnConfigBlock)btnTitle {
    btnConfigBlock block = ^(id value){
        if (!value ||
            [value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[NSAttributedString class]] ||
            [value isKindOfClass:[NSMutableAttributedString class]]) {
            _centerTipView_btnTitle = value;
        } else {
            DDLogDebug(@"赋值btnTitle的类型不正确");
        }return self;
    };
    return block;
}
- (btnConfigBlock)btnType {
    btnConfigBlock block = ^(id value){
        _centerTipView_btnType = [value integerValue];
        return self;
    };
    return block;
}
- (btnCallbackConfigBlock)btnCallback {
    btnCallbackConfigBlock block = ^(btnAction action){
        _centerTipView_btnCallback = [action copy];
        return self;
    };
    return block;
}
@end


@interface IDCMCenterTipViewConfigure ()
@property (nonatomic,strong) id centerTipView_topTitle;
@property (nonatomic,strong) id centerTipView_title;
@property (nonatomic,strong) id centerTipView_image;
@property (nonatomic,strong) id centerTipView_subTitle;
@property (nonatomic,strong) NSMutableArray<IDCMCenterTipViewBtnConfigure *> *centerTipView_btnsConfig;
+ (instancetype)defaultConfigure; // 初始化默认配置
@end
@implementation IDCMCenterTipViewConfigure
+ (instancetype)defaultConfigure {
    IDCMCenterTipViewConfigure *configure = [[self alloc] init];
    configure.centerTipView_title = nil;
    configure.centerTipView_subTitle = nil;
    configure.centerTipView_image = nil;
    IDCMCenterTipViewBtnConfigure *btnConfigLeft = [[IDCMCenterTipViewBtnConfigure alloc] init];
    btnConfigLeft.btnTitle(NSLocalizedString(@"2.0_Cancel", nil)).btnType(@"0");
    
    IDCMCenterTipViewBtnConfigure *btnConfigRight = [[IDCMCenterTipViewBtnConfigure alloc] init];
    btnConfigRight.btnTitle(NSLocalizedString(@"2.1_PhraseDone", nil)).btnType(@"1");
    
    configure.centerTipView_btnsConfig = @[btnConfigLeft , btnConfigRight].mutableCopy;
    return configure;
}
- (id)getTopTitle {
    return _centerTipView_topTitle;
}
- (id)getTitle {
    return _centerTipView_title;
}
- (id)getSubTitle {
     return _centerTipView_subTitle;
}
- (id)getImage {
    return _centerTipView_image;
}
- (NSMutableArray *)getBtnsConfig {
    return _centerTipView_btnsConfig;
}
- (configBlock)topTitle {
    configBlock block = ^(id value){
        if (!value ||
            [value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[NSAttributedString class]] ||
            [value isKindOfClass:[NSMutableAttributedString class]]) {
            _centerTipView_topTitle = value;
        } else {
            DDLogDebug(@"赋值topTitle的类型不正确");
        }return self;
    };return block;
}
- (configBlock)title {
    configBlock block = ^(id value){
        if (!value ||
            [value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[NSAttributedString class]] ||
            [value isKindOfClass:[NSMutableAttributedString class]]) {
            _centerTipView_title = value;
        } else {
            DDLogDebug(@"赋值title的类型不正确");
        }return self;
    };return block;
}
- (configBlock)image {
    configBlock block = ^(id value){
        if (!value ||
            [value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[UIImage class]] ||
            [value isKindOfClass:[RACTuple class]]) {
            _centerTipView_image = value;
        } else {
            DDLogDebug(@"赋值image的类型不正确");
        }return self;
    };
    return block;
}
- (configBlock)subTitle {
    configBlock block = ^(id value){
        if (!value ||
            [value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[NSAttributedString class]] ||
            [value isKindOfClass:[NSMutableAttributedString class]]) {
            _centerTipView_subTitle = value;
            
        } else {
            DDLogDebug(@"赋值subTitle的类型不正确");
        }return self;
    };return block;
}
- (configBlock)btnsConfig {
    configBlock block = ^(id value){
        if (!value ||
            [self checkArray:value allClass:[IDCMCenterTipViewBtnConfigure class]]) {
            _centerTipView_btnsConfig = value;
        } else {
            DDLogDebug(@"赋值btnsConfig的类型不正确");
        }return self;
    };return block;
}

- (BOOL)checkArray:(NSArray *)array allClass:(Class)class {
    if (![array isKindOfClass:[NSArray class]] &&
        ![array isKindOfClass:[NSMutableArray class]]) {
        return NO;
    }
     __block BOOL isAllClass = YES;
    [array enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:class]) {
            isAllClass = NO;
            *stop = YES;
        }
    }];
    return isAllClass;
}
@end



@interface IDCMCenterTipView ()
@property (nonatomic,strong) UILabel *topTitleLabel;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subTitleLabel;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIView *btnsView;
@property (nonatomic,strong) IDCMCenterTipViewConfigure *viewConfigure;
@property (nonatomic,copy) centerTipViewConfigBlock tipBlock;
@property (nonatomic,weak) UIView *inView;

@property (nonatomic,assign) CGFloat topTitleLabelHeight;
@property (nonatomic,assign) CGSize imageViewSize;
@property (nonatomic,assign) CGFloat titleLabelHeight;
@property (nonatomic,assign) CGFloat subTitleLabelHeight;
@end


@implementation IDCMCenterTipView
+ (void)showWithConfigure:(centerTipViewConfigBlock)configure {
    
        [self showToView:nil
               configure:configure
        automaticDismiss:NO
          animationStyle:0
   tipViewStatusCallback:nil];
}

+ (void)showToView:(UIView *)view
         configure:(centerTipViewConfigBlock)configure {

        [self showToView:view
               configure:configure
        automaticDismiss:NO
          animationStyle:0
    tipViewStatusCallback:nil];
}

+ (void)showToView:(UIView *)view
         configure:(centerTipViewConfigBlock)configure
    animationStyle:(IDCMBaseTipViewAnimationStyle)animationStyle {

        [self showToView:view
               configure:configure
        automaticDismiss:NO
          animationStyle:animationStyle
   tipViewStatusCallback:nil];
}

+ (void)showToView:(UIView *)view configure:(centerTipViewConfigBlock)configure
                           automaticDismiss:(BOOL)automaticDismiss
                             animationStyle:(IDCMBaseTipViewAnimationStyle)animationStyle
                      tipViewStatusCallback:(void (^)(IDCMBaseTipViewShowStatus showStatus))tipViewStatusCallback {

    UIWindow *keyWindon = [UIApplication sharedApplication].keyWindow;
    UIView *inView = view ? view : keyWindon;

    IDCMCenterTipView *tipView = [[self alloc] init];
    IDCMCenterTipViewConfigure *config = [IDCMCenterTipViewConfigure defaultConfigure];
    tipView.tipBlock = configure;
    if (configure) { configure(config);}
    tipView.viewConfigure = config;
    tipView.inView = inView;
    
    CGSize size = [tipView getTipViewSize];
    tipView.size = size;
    [tipView configUI];
    
    tipView.layer.cornerRadius = 6.0f;
    tipView.layer.masksToBounds = YES;
    
    [self showTipViewToView:inView
                       size:size
                contentView:tipView
           automaticDismiss:automaticDismiss
             animationStyle:animationStyle
      tipViewStatusCallback:tipViewStatusCallback];
}

- (CGSize)getTipViewSize {

    CGFloat width = self.inView.width - 38 * 2;
    
    CGFloat top = 30;
    self.imageViewSize = [self getImageViewSize];
    CGFloat imageViewHeight = self.imageViewSize .height;
    CGFloat topTitleLabelHeight = [self getTopTitleLabelHeight];
    CGFloat titleLabelHeight = [self getTitleLabelHeight];
    CGFloat subTitleLabelHeight = [self getSubTitleLabelHeight];
    self.topTitleLabelHeight = topTitleLabelHeight;
    self.titleLabelHeight = titleLabelHeight;
    self.subTitleLabelHeight = subTitleLabelHeight;
    
   
    //    CGFloat height = top + imageViewHeight;
    CGFloat height = top + topTitleLabelHeight;
    
    if (imageViewHeight && topTitleLabelHeight) {
         height += (imageViewHeight + 20);
    } else {
        height += (imageViewHeight);
    }
    
    if (titleLabelHeight && imageViewHeight) {
        height += (titleLabelHeight + 20);
    } else {
        height += (titleLabelHeight);
    }
    
    if (subTitleLabelHeight && titleLabelHeight) {
        height += (subTitleLabelHeight + 10);
    } else if (subTitleLabelHeight && !titleLabelHeight) {
         height += (subTitleLabelHeight + 15);
    } else {
         height += (subTitleLabelHeight);
    }
    
    if (self.viewConfigure.centerTipView_btnsConfig.count) {
        if (subTitleLabelHeight || imageViewHeight || titleLabelHeight) {
            CGFloat subTitleLabelMargin = imageViewHeight ? 30 : 20;
            if (!imageViewHeight && !subTitleLabelHeight && titleLabelHeight) {
                subTitleLabelMargin = 30;
            }
            if (!imageViewHeight && subTitleLabelHeight && !titleLabelHeight) {
                 subTitleLabelMargin = 30;
            }
            height += (40 + subTitleLabelMargin);
        } else {
            height +=  40;
        }
    }
    height = height + 20;
//    if (self.imageViewSize.height &&
//        [self.viewConfigure.centerTipView_image isKindOfClass:[RACTuple class]]) {
//        height = height + 10;
//    }
    return CGSizeMake(width, height);
}

- (CGFloat)getTopTitleLabelHeight {
    CGFloat width = self.inView.width - 38 * 2;
    CGFloat contentWidth = width - 36;
    
    CGFloat titleHeith = 0.0;
    if ([self.viewConfigure.centerTipView_topTitle isKindOfClass:[NSString class]] &&
        ((NSString *)self.viewConfigure.centerTipView_topTitle).length) {
        titleHeith =
        [self.viewConfigure.centerTipView_topTitle heightForFont:self.topTitleLabel.font width:contentWidth - 4];
    }
    if ([self.viewConfigure.centerTipView_topTitle isKindOfClass:[NSAttributedString class]] ||
        [self.viewConfigure.centerTipView_topTitle isKindOfClass:[NSMutableAttributedString class]]) {
        
        NSMutableAttributedString *str = self.viewConfigure.centerTipView_topTitle;
        titleHeith =
        [str boundingRectWithSize:CGSizeMake(contentWidth - 4, MAXFLOAT)
                          options:NSStringDrawingUsesLineFragmentOrigin
                          context:nil].size.height;
    }
    return titleHeith;
}

- (CGFloat)getTitleLabelHeight {
    
    CGFloat width = self.inView.width - 38 * 2;
    CGFloat contentWidth = width - 36;
    
    CGFloat titleHeith = 0.0;
    if ([self.viewConfigure.centerTipView_title isKindOfClass:[NSString class]] &&
        ((NSString *)self.viewConfigure.centerTipView_title).length) {
        titleHeith =
        [self.viewConfigure.centerTipView_title heightForFont:self.titleLabel.font width:contentWidth - 4];
    }
    if ([self.viewConfigure.centerTipView_title isKindOfClass:[NSAttributedString class]] ||
        [self.viewConfigure.centerTipView_title isKindOfClass:[NSMutableAttributedString class]]) {
        
        NSMutableAttributedString *str = self.viewConfigure.centerTipView_title;
        titleHeith =
        [str boundingRectWithSize:CGSizeMake(contentWidth - 4, MAXFLOAT)
                          options:NSStringDrawingUsesLineFragmentOrigin
                          context:nil].size.height;
    }
    return titleHeith;
}

- (CGFloat)getSubTitleLabelHeight {
    
    CGFloat width = self.inView.width - 38 * 2;
    CGFloat contentWidth = width - 36;
    
    CGFloat subTitleHeight = 0.0;
    if ([self.viewConfigure.centerTipView_subTitle isKindOfClass:[NSString class]]) {
        subTitleHeight =
        [self.viewConfigure.centerTipView_subTitle heightForFont:textFontPingFangRegularFont(14) width:contentWidth - 4];
    }
    if ([self.viewConfigure.centerTipView_subTitle isKindOfClass:[NSAttributedString class]] ||
        [self.viewConfigure.centerTipView_subTitle isKindOfClass:[NSMutableAttributedString class]]) {
        
        NSMutableAttributedString *str = self.viewConfigure.centerTipView_subTitle;
        subTitleHeight =
        [str boundingRectWithSize:CGSizeMake(contentWidth - 4, MAXFLOAT)
                          options:NSStringDrawingUsesLineFragmentOrigin
                          context:nil].size.height;
    }
    return subTitleHeight;
}

- (CGSize)getImageViewSize {
    
    CGFloat width = self.inView.width - 38 * 2;
    CGFloat contentWidth = width - 36;
    
    CGSize size = CGSizeZero;
    if (self.viewConfigure.centerTipView_image) {
        
        UIImage *image = nil;
        CGSize imageSize = CGSizeZero;
        if ([self.viewConfigure.centerTipView_image isKindOfClass:[NSString class]]) {
            image = [UIImage imageNamed:self.viewConfigure.centerTipView_image];
        }
        if ([self.viewConfigure.centerTipView_image isKindOfClass:[UIImage class]]) {
            image = self.viewConfigure.centerTipView_image;
        }
        if ([self.viewConfigure.centerTipView_image isKindOfClass:[RACTuple class]]) {
            RACTuple *tuple = (RACTuple*)self.viewConfigure.centerTipView_image;
            imageSize = [tuple.last CGSizeValue];
        }
        
        CGSize sizeee = image ? image.size : imageSize;
        if (sizeee.width > contentWidth) {
            sizeee.width = contentWidth;
            sizeee.height = (sizeee.height / sizeee.width) * contentWidth;
        }
        size = sizeee;
    }
    return size;
}

- (void)configUI {
    
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.topTitleLabel];
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.btnsView];
}

- (void)btnAction:(UIButton *)btn {
    void(^action)(void) = self.viewConfigure.centerTipView_btnsConfig[btn.tag].centerTipView_btnCallback;
    [IDCMBaseCenterTipView dismissForView:self.inView completion:action];
    // 消除循环引用 外界使用不需要考虑循环引用
    self.tipBlock = nil;
    self.viewConfigure = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    
    self.topTitleLabel.width = self.width - 36;
    self.topTitleLabel.height = self.topTitleLabelHeight;
    self.topTitleLabel.left = 18;
    self.topTitleLabel.top = 30;
    
    self.imageView.size = self.imageViewSize;
    self.imageView.centerX = self.width / 2;
    if (self.imageView.height && self.topTitleLabelHeight) {
        self.imageView.top = self.topTitleLabel.bottom + 20;
    } else {
        self.imageView.top = self.topTitleLabel.bottom;
    }
    
    if ([self.viewConfigure.centerTipView_image isKindOfClass:[RACTuple class]]) {
        self.imageView.layer.cornerRadius = 8.0;
        self.imageView.layer.masksToBounds = YES;
    }
    
    self.titleLabel.width = self.width - 36;
    self.titleLabel.height = self.titleLabelHeight;
    self.titleLabel.left = 18;
    if (self.titleLabel.height && self.imageViewSize.height) {
        self.titleLabel.top = self.imageView.bottom + 20;
    } else {
        self.titleLabel.top = self.imageView.bottom;
    }
    
    self.subTitleLabel.width = self.titleLabel.width;
    self.subTitleLabel.height = self.subTitleLabelHeight;
    self.subTitleLabel.left = self.titleLabel.left;
    if (self.subTitleLabelHeight && self.titleLabel.height) {
        self.subTitleLabel.top = self.titleLabel.bottom + 10;
    } else if (self.subTitleLabelHeight && !self.titleLabel.height) {
        self.subTitleLabel.top = self.titleLabel.bottom + 15;
    } else {
        self.subTitleLabel.top = self.titleLabel.bottom;
    }
    
    self.btnsView.width = self.titleLabel.width;
    if (self.viewConfigure.centerTipView_btnsConfig.count) {
        self.btnsView.height = 40;
    } else {
        self.btnsView.height = 0;
    }
    
    if (self.subTitleLabelHeight ||
        self.imageViewSize.height ||
        self.titleLabelHeight) {
        CGFloat subTitleLabelMargin = self.imageView.height ? 30 : 20;
        if (!self.imageViewSize.height && !self.subTitleLabelHeight && self.titleLabelHeight) {
            subTitleLabelMargin = 30;
        }
        if (!self.imageViewSize.height && self.subTitleLabelHeight && !self.titleLabelHeight) {
            subTitleLabelMargin = 30;
        }
        if (self.imageViewSize.height &&
            [self.viewConfigure.centerTipView_image isKindOfClass:[RACTuple class]]) {
            subTitleLabelMargin = 25;
        }
        self.btnsView.top = self.subTitleLabel.bottom + subTitleLabelMargin;
    } else {
        self.btnsView.top = self.subTitleLabel.bottom;
    }
    self.btnsView.left = self.titleLabel.left;
    
    NSInteger btnCount = self.btnsView.subviews.count;
    CGFloat width = (self.btnsView.width - (btnCount - 1) * 12) / btnCount;
    [self.btnsView.subviews enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL *stop) {
        obj.top = 0;
        obj.width = width;
        obj.left = idx * (width + 12);
        obj.height = self.btnsView.height;
    }];
}

- (UILabel *)topTitleLabel {
    return SW_LAZY(_topTitleLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.textColor = textColor333333;
        label.font = textFontPingFangRegularFont(16);
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        if ([self.viewConfigure.centerTipView_topTitle isKindOfClass:[NSString class]]) {
            label.text = self.viewConfigure.centerTipView_topTitle;
        }
        if ([self.viewConfigure.centerTipView_topTitle isKindOfClass:[NSMutableAttributedString class]] ||
            [self.viewConfigure.centerTipView_topTitle isKindOfClass:[NSAttributedString class]]) {
            label.attributedText = self.viewConfigure.centerTipView_topTitle;
        }
        label;
    }));
}

- (UILabel *)titleLabel {
    return SW_LAZY(_titleLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.textColor = textColor333333;
        label.font = textFontPingFangRegularFont(16);
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        if ([self.viewConfigure.centerTipView_title isKindOfClass:[NSString class]]) {
            label.text = self.viewConfigure.centerTipView_title;
        }
        if ([self.viewConfigure.centerTipView_title isKindOfClass:[NSMutableAttributedString class]] ||
            [self.viewConfigure.centerTipView_title isKindOfClass:[NSAttributedString class]]) {
            label.attributedText = self.viewConfigure.centerTipView_title;
        }
        label;
    }));
}
- (UILabel *)subTitleLabel {
    return SW_LAZY(_subTitleLabel, ({

        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor666666;
        label.font = textFontPingFangRegularFont(14);
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;

        if ([self.viewConfigure.centerTipView_subTitle isKindOfClass:[NSString class]]) {
            label.text = self.viewConfigure.centerTipView_subTitle;
        }
        if ([self.viewConfigure.centerTipView_subTitle isKindOfClass:[NSMutableAttributedString class]] ||
            [self.viewConfigure.centerTipView_subTitle isKindOfClass:[NSAttributedString class]]) {
            label.attributedText = self.viewConfigure.centerTipView_subTitle;
        }
        label;
    }));
}
- (UIImageView *)imageView {
    return SW_LAZY(_imageView, ({
        UIImageView *imageView = [[UIImageView alloc] init];
        if ([self.viewConfigure.centerTipView_image isKindOfClass:[NSString class]]) {
            imageView.image = [UIImage imageNamed:self.viewConfigure.centerTipView_image];
        }
        if ([self.viewConfigure.centerTipView_image isKindOfClass:[UIImage class]]) {
            imageView.image = self.viewConfigure.centerTipView_image;
        }
        if ([self.viewConfigure.centerTipView_image isKindOfClass:[RACTuple class]]) {
            RACTuple *tuple = self.viewConfigure.centerTipView_image;
            if ([tuple.first isKindOfClass:[NSString class]]) {
                [imageView sd_setImageWithURL:
                 [NSURL URLWithString:tuple.first] placeholderImage:
                 [UIImage imageWithColor:[UIColor colorWithHexString:@"#9098AD"]]];
            }
        }
//      imageView.contentMode = UIViewContentModeScaleAspectFit;
//      imageView.clipsToBounds = YES;
        imageView;
    }));
}
- (UIView *)btnsView {
    return SW_LAZY(_btnsView, ({
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        for (IDCMCenterTipViewBtnConfigure *btnConfig in self.viewConfigure.centerTipView_btnsConfig) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:btnConfig.centerTipView_btnTitle forState:UIControlStateNormal];
            btn.layer.borderColor = kThemeColor.CGColor;
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 4.0;
            btn.layer.borderWidth = 1.0;
            btn.tag = [self.viewConfigure.centerTipView_btnsConfig indexOfObject:btnConfig];
            btn.backgroundColor = btnConfig.centerTipView_btnType ? kThemeColor : [UIColor whiteColor];
            [btn setTitleColor:btnConfig.centerTipView_btnType ? [UIColor whiteColor] : kThemeColor
                     forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
        }
        view;
    }));
}

@end






