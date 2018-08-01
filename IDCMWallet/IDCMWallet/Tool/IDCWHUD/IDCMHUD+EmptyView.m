//
//  IDCMHUD+EmptyView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/3/29.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMHUD+EmptyView.h"

@interface IDCMHUDConfigure ()

// 背景图片 可以是 UIImage| NSString 当设置为nil 则为隐藏
@property (nonatomic,strong) id idcm_backgroundImage;

// 上面的logo 可以是 UIImage| NSString 当设置为nil 则为隐藏
@property (nonatomic,strong) id idcm_image;

// logo下面的标题 可以是 NSString| NSAttributedString | NSAttributedString 当设置为nil 则为隐藏
// 如果要改变字体大小 颜色等其他属性 可以用富文本 不提直接的属性
@property (nonatomic,strong) id idcm_title;

// title下面的复标题 可以是 NSString| NSAttributedString | NSAttributedString 当设置为nil 则为隐藏
// 如果要改变字体大小 颜色等其他属性 可以用富文本 不提供直接的属性
@property (nonatomic,strong) id idcm_subTitle;

// 按钮标题
@property (nonatomic,strong) NSString *idcm_btnTitle;
// 按钮 图片
@property (nonatomic,strong) id idcm_btnImage;
// 按钮背景图片
@property (nonatomic,strong) id idcm_btnBackgroundImage;
@property (nonatomic,assign) CGRect idcm_contentFrame;
@property (nonatomic,strong) RACTuple *idcm_positionConfigure;
+ (instancetype)defaultConfigure; // 初始化默认配置
@end


@implementation IDCMHUDConfigure
+ (instancetype)defaultConfigure {
    IDCMHUDConfigure *configure = [[self alloc] init];
    configure.idcm_backgroundImage = @"2.1_NoDataImage";
    configure.idcm_image = @"2.0_wushuju";
    configure.idcm_title = nil;
    configure.idcm_subTitle = nil;
    configure.idcm_btnTitle = NSLocalizedString(@"3.0_Refresh", nil);
    configure.idcm_btnImage = nil;
    configure.idcm_btnBackgroundImage = nil;
    return configure;
}
- (instancetypeBlock)backgroundImage {
    instancetypeBlock block = ^(id value){
        if (!value ||
            [value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[UIImage class]]) {
            _idcm_backgroundImage = value;
        } else {
            DDLogDebug(@"赋值backgroundImage的类型不正确");
        }return self;
    };
    return block;
}
- (instancetypeBlock)image {
    instancetypeBlock block = ^(id value){
        if (!value ||
            [value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[UIImage class]]) {
            _idcm_image = value;
        } else {
            DDLogDebug(@"赋值image的类型不正确");
        }return self;
    };
    return block;
}
- (instancetypeBlock)title {
    instancetypeBlock block = ^(id value){
        if (!value ||
            [value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[NSAttributedString class]] ||
            [value isKindOfClass:[NSMutableAttributedString class]]) {
            _idcm_title = value;
        } else {
            DDLogDebug(@"赋值title的类型不正确");
        }return self;
    };return block;
}
- (instancetypeBlock)subTitle {
    instancetypeBlock block = ^(id value){
        if (!value ||
            [value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[NSAttributedString class]] ||
            [value isKindOfClass:[NSMutableAttributedString class]]) {
            _idcm_subTitle = value;
        } else {
            DDLogDebug(@"赋值subTitle的类型不正确");
        }return self;
    };return block;
}
- (instancetypeBlock)btnTitle {
    instancetypeBlock block = ^(id value){
        if (!value ||
            [value isKindOfClass:[NSString class]] ) {
           _idcm_subTitle = value;
        } else {
            DDLogDebug(@"赋值btnTitle的类型不正确");
        }return self;
    };return block;
}
- (instancetypeBlock)btnImage {
    instancetypeBlock block = ^(id value){
        if (!value ||
            [value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[UIImage class]]) {
             _idcm_image = value;
        } else {
            DDLogDebug(@"赋值btnImage的类型不正确");
        }return self;
    };return block;
}
- (instancetypeBlock)btnBackgroundImage {
    instancetypeBlock block = ^(id value){
        if (!value ||
            [value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[UIImage class]]) {
            _idcm_backgroundImage = value;
        } else {
            DDLogDebug(@"赋值btnBackgroundImage的类型不正确");
        }return self;
    };return block;
}
- (instancetypeBlock)contentFrame {
    instancetypeBlock block = ^(id value){
        if (value) {
            _idcm_contentFrame = [value CGRectValue];
        } else {
            DDLogDebug(@"赋值contentFrame的类型不正确");
        }return self;
    };return block;
}
- (instancetypeBlock)positionConfigure {
    instancetypeBlock block = ^(id value){
        if (value) {
            _idcm_positionConfigure = value;
        } else {
            DDLogDebug(@"赋值idcm_positionConfigure的类型不正确");
        }return self;
    };return block;
}
@end


@interface IDCMHUDContentView : UIView
@property (nonatomic,strong) UIImageView *backgroundImageView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subTitleLabel;
@property (nonatomic,strong) UIButton *reloadBtn;
@property (nonatomic,strong) IDCMHUDConfigure *configure;
@property (nonatomic,copy) reloadBlock reloadCallback;
@property (nonatomic,copy) configureBlock configureBlock;
@end


@implementation IDCMHUDContentView

+ (instancetype)contentViewWithConfigure:(IDCMHUDConfigure *)configure
                          reloadCallback:(reloadBlock)reloadCallback {
    
    IDCMHUDContentView *contentView = [[IDCMHUDContentView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.configure = configure;
    contentView.reloadCallback = [reloadCallback copy];
    [contentView configUI];
    return contentView;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self observeFrame];
}

- (void)observeFrame {
    @weakify(self);
    
        [[[RACObserve(self.superview, frame) takeUntil:self.rac_willDeallocSignal]
          deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
            
            @strongify(self);
            if (self.configure.idcm_contentFrame.size.width) {
                self.frame = self.configure.idcm_contentFrame;
            } else {
                CGRect rect = [x CGRectValue];
                self.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
            }
        }];
}

- (void)configUI {
    
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.reloadBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundImageView.frame = self.bounds;
    
    
    RACTuple *tuple = self.configure.idcm_positionConfigure;
    EmptyViewPositon position = [tuple.first integerValue];
    CGFloat offset = [tuple.last floatValue];
    
    switch (position) {
        case EmptyViewPositon_Center: {
            self.reloadBtn.size = CGSizeMake(120, 40);
            self.reloadBtn.centerX = self.width / 2;
            self.reloadBtn.centerY = self.height / 2 + 30 + offset;
            
            self.reloadBtn.hidden = !self.reloadCallback;
            self.reloadBtn.layer.borderColor = kThemeColor.CGColor;
            self.reloadBtn.layer.cornerRadius = 4;
            self.reloadBtn.layer.masksToBounds = YES;
            
            [self.subTitleLabel sizeToFit];
            self.subTitleLabel.width = self.width - 24;
            self.subTitleLabel.left = 12;
            self.subTitleLabel.bottom = self.reloadBtn.top - 20 ;
            
            [self.titleLabel sizeToFit];
            self.titleLabel.width = self.subTitleLabel.width;
            self.titleLabel.left = self.subTitleLabel.left;
            if (self.configure.idcm_subTitle) {
                self.titleLabel.bottom = self.subTitleLabel.top - 10 ;
            } else {
                self.titleLabel.bottom = self.reloadBtn.top - 20;
            }
            
            self.imageView.size = self.imageView.image.size;
            self.imageView.centerX = self.reloadBtn.centerX;
            if (self.configure.idcm_title) {
                self.imageView.bottom = self.titleLabel.top - 20 ;
            } else if (self.configure.idcm_subTitle) {
                self.imageView.bottom = self.subTitleLabel.top - 20 ;
            } else if (!self.configure.idcm_title && !self.configure.idcm_subTitle) {
                self.imageView.bottom = self.reloadBtn.top - 20 ;
            }
        }break;
        case EmptyViewPositon_Top: {
            
            self.imageView.size = self.imageView.image.size;
            self.imageView.centerX = self.width / 2;
            self.imageView.top = offset ?: 30;
            
            [self.titleLabel sizeToFit];
            self.titleLabel.width = self.width - 24;
            self.titleLabel.left = 12;
            if (self.imageView.size.height) {
                self.titleLabel.top = self.imageView.bottom + 20 ;
            } else {
                self.titleLabel.top = self.imageView.bottom;
            }
            
            [self.subTitleLabel sizeToFit];
            self.subTitleLabel.width = self.width - 24;
            self.subTitleLabel.left = 12;
            if (self.titleLabel.height) {
                self.subTitleLabel.top = self.titleLabel.bottom + 10 ;
            } else {
                self.subTitleLabel.top = self.titleLabel.bottom;
            }
            
            self.reloadBtn.size = CGSizeMake(120, 40);
            self.reloadBtn.centerX = self.width / 2;
            self.reloadBtn.top = self.subTitleLabel.bottom + 20;
            
            self.reloadBtn.hidden = !self.reloadCallback;
            self.reloadBtn.layer.borderColor = kThemeColor.CGColor;
            self.reloadBtn.layer.cornerRadius = 4;
            self.reloadBtn.layer.masksToBounds = YES;
        }break;
        default:
        break;
    }
}

- (void)clickBtnAction {
//    [self removeFromSuperview];
    self.reloadCallback ? self.reloadCallback() : nil;
}

- (UIImageView *)backgroundImageView {
    return SW_LAZY(_backgroundImageView, ({
        
        UIImageView *imageView = [[UIImageView alloc] init];
        if ([self.configure.idcm_backgroundImage isKindOfClass:[NSString class]]) {
            imageView.image = [UIImage imageNamed:self.configure.idcm_backgroundImage];
        }
        if ([self.configure.idcm_backgroundImage isKindOfClass:[UIImage class]]) {
            imageView.image = self.configure.idcm_backgroundImage;
        }
//        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        imageView.clipsToBounds = YES;
        imageView;
    }));
}
- (UIImageView *)imageView {
    return SW_LAZY(_imageView, ({
        
        UIImageView *imageView = [[UIImageView alloc] init];
        if ([self.configure.idcm_image isKindOfClass:[NSString class]]) {
            imageView.image = [UIImage imageNamed:self.configure.idcm_image];
        }
        if ([self.configure.idcm_image isKindOfClass:[UIImage class]]) {
            imageView.image = self.configure.idcm_image;
        }
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        imageView;
    }));
}
- (UILabel *)titleLabel {
    return SW_LAZY(_titleLabel, ({
        
        UILabel *lable = [[UILabel alloc] init];
        lable.textColor = textColor333333;
        lable.font = textFontPingFangRegularFont(16);
        lable.textAlignment = NSTextAlignmentCenter;
        lable.numberOfLines = 2;
        if ([self.configure.idcm_title isKindOfClass:[NSString class]]) {
            lable.text = self.configure.idcm_title;
        }
        if ([self.configure.idcm_title isKindOfClass:[NSAttributedString class]] ||
            [self.configure.idcm_title isKindOfClass:[NSAttributedString class]]) {
            lable.attributedText = self.configure.idcm_title;
        }
        lable;
    }));
}
- (UILabel *)subTitleLabel {
    return SW_LAZY(_subTitleLabel, ({
        
        UILabel *lable = [[UILabel alloc] init];
        lable.textColor = textColor666666;
        lable.font = textFontPingFangRegularFont(12);
        lable.textAlignment = NSTextAlignmentCenter;
        lable.numberOfLines = 2;
        if ([self.configure.idcm_subTitle isKindOfClass:[NSString class]]) {
            lable.text = self.configure.idcm_subTitle;
        }
        if ([self.configure.idcm_subTitle isKindOfClass:[NSMutableAttributedString class]] ||
            [self.configure.idcm_subTitle isKindOfClass:[NSAttributedString class]]) {
            lable.attributedText = self.configure.idcm_subTitle;
        }
        lable;
    }));
}
- (UIButton *)reloadBtn {
    return SW_LAZY(_reloadBtn, ({
        
        UIButton *reloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        reloadBtn.titleLabel.font = textFontPingFangRegularFont(16);
        reloadBtn.backgroundColor = kThemeColor;
        [reloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [reloadBtn setTitle:self.configure.idcm_btnTitle forState:UIControlStateNormal];
        if ([self.configure.idcm_btnImage isKindOfClass:[NSString class]]) {
            [reloadBtn setImage:[UIImage imageNamed:self.configure.idcm_btnImage] forState:UIControlStateNormal];
        }
        if ([self.configure.idcm_btnImage isKindOfClass:[UIImage class]]) {
           [reloadBtn setImage:self.configure.idcm_btnImage forState:UIControlStateNormal];
        }
        if ([self.configure.idcm_btnBackgroundImage isKindOfClass:[NSString class]]) {
            [reloadBtn setBackgroundImage:[UIImage imageNamed:self.configure.idcm_btnBackgroundImage]
                                 forState:UIControlStateNormal];
        }
        if ([self.configure.idcm_btnBackgroundImage isKindOfClass:[UIImage class]]) {
            [reloadBtn setBackgroundImage:self.configure.idcm_btnBackgroundImage forState:UIControlStateNormal];
        }
        [reloadBtn addTarget:self action:@selector(clickBtnAction) forControlEvents:UIControlEventTouchUpInside];
        reloadBtn;
    }));
}
@end



@implementation IDCMHUD (EmptyView)

+ (void)showEmptyViewToView:(UIView *)view
                  configure:(configureBlock)configure
             reloadCallback:(reloadBlock)reloadCallback {
    
    if ([self getHasShowContentViewForView:view]) {
        return;
    }
    
    IDCMHUDConfigure *config = [IDCMHUDConfigure defaultConfigure];
    if (configure) {configure(config);}
    
    IDCMHUDContentView *contentView =
    [IDCMHUDContentView contentViewWithConfigure:config
                                  reloadCallback:reloadCallback];
    [view insertSubview:contentView atIndex:0];
    [view bringSubviewToFront:contentView];
}

+ (void)dismissEmptyViewForView:(UIView *)view {
    IDCMHUDContentView *contentView = [self getHasShowContentViewForView:view];
    if (contentView) {
        contentView.reloadCallback = nil;
        contentView.configure = nil;
        [contentView removeFromSuperview];
    }
}

+ (IDCMHUDContentView *)getHasShowContentViewForView:(UIView *)view {
    __block IDCMHUDContentView *contentView = nil;
    [view.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[IDCMHUDContentView class]]) {
            contentView = (IDCMHUDContentView *)obj;
            *stop = YES;
        }
    }];
    return contentView;
}

@end




