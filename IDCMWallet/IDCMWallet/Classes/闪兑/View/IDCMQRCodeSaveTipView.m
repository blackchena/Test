//
//  IDCMQRCodeSaveTipView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/6/14.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMQRCodeSaveTipView.h"


@interface IDCMQRCodeSaveTipView ()
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) UIButton *saveBtn;
@property (nonatomic,strong) UIImage *image;
@end


@implementation IDCMQRCodeSaveTipView
static BOOL loading = NO;
+ (void)showWithImageUrl:(NSString *)imageUrl {
    
    if (loading) {return;}
    loading = YES;
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager loadImageWithURL:[NSURL URLWithString:imageUrl]
                      options:SDWebImageRefreshCached
                     progress:nil
                    completed:^(UIImage *image, NSData *data,
                                NSError *error, SDImageCacheType cacheType,
                                BOOL finished, NSURL *imageURL) {
                        
                        IDCMQRCodeSaveTipView *view = [[self alloc] init];
                        view.backgroundColor = UIColorWhite;
                        view.width = SCREEN_WIDTH - 24;
                        view.image = image;
                        [view initConfigure];
                        view.height = view.saveBtn.bottom + 20;
                        [self showTipViewToView:nil
                                           size:view.size
                                    contentView:view
                               automaticDismiss:NO
                                 animationStyle:1
                          tipViewStatusCallback:nil];
                        [[RACScheduler mainThreadScheduler] afterDelay:.3 schedule:^{
                           loading = NO;
                        }];
                    }];
}

#pragma mark  -- Prevete Method
- (void)initConfigure {
    [self configUI];
    [self configSignal];
}

- (void)configUI {
    [self addSubview:self.closeBtn];
    [self addSubview:self.imageView];
    [self addSubview:self.saveBtn];
}

- (void)configSignal {
    @weakify(self);
    [[[self.closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(UIControl *x) {
         [IDCMBaseCenterTipView dismissWithCompletion:nil];
     }];
    
    if (self.imageView.image) {
        [[[self.saveBtn rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
         subscribeNext:^(UIControl *x) {
             @strongify(self);
             UIImageWriteToSavedPhotosAlbum(self.imageView.image, self,
                                            @selector(image:didFinishSavingWithError:contextInfo:), NULL);
         }];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"2.1_Save_To_Album_Failure")];
    }else
    {
        [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"2.1_Save_To_Album_Success")];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layer.cornerRadius = 10.0;
    self.layer.masksToBounds = YES;
}

- (UIImageView *)imageView {
    return SW_LAZY(_imageView, ({
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.image = self.image;
        imageView.width = self.width - 56 * 2;
        if (imageView.image) {
            imageView.height = (imageView.image.size.height / imageView.image.size.width) * imageView.width;
            if (imageView.height > imageView.width * 1.2) {
                imageView.height = imageView.width * 1.2;
            }
            imageView.centerX = self.width / 2;
            imageView.top = 40;
            imageView.layer.cornerRadius = 10;
            imageView.layer.masksToBounds = YES;
        }
        imageView;
    }));
}

- (UIButton *)closeBtn {
    return SW_LAZY(_closeBtn, ({
        
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:[UIImage imageNamed:@"3.0_close"] forState:UIControlStateNormal];
        btn.size = CGSizeMake(30, 30);
        btn.top = 5;
        btn.right = self.width - 3;
        btn;
    }));
}

- (UIButton *)saveBtn {
    return SW_LAZY(_saveBtn, ({
        
        UIButton *btn = [[UIButton alloc] init];
        btn.width = self.width - 56 * 2;
        btn.height = 40;
        btn.centerX = self.width / 2;
        btn.top = self.imageView.bottom + 30;
        btn.layer.cornerRadius = 4.0;
        btn.layer.masksToBounds = YES;
        btn.adjustsImageWhenHighlighted = NO;
        [btn setTitle:NSLocalizedString(@"3.0_Save", nil)
             forState:UIControlStateNormal];
        btn.titleLabel.font = textFontPingFangRegularFont(16);
        UIImage *image1 = [UIImage imageWithColor:kThemeColor];
        [btn setBackgroundImage:image1 forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn;
    }));
}

@end







