//
//  IDCMImagePreviewViewController.m
//  IDCMWallet
//
//  Created by huangyi on 2018/5/5.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMImagePreviewViewController.h"


@implementation IDCMImagePreviewViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.navigationBar];
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(kSafeAreaTop+kNavigationBarHeight);
    }];
    @weakify(self);
    self.navigationBar.backBtnCallbak = ^{
        @strongify(self);
        [self exitPreviewByFadeOut];
    };
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     [IDCMBottomListTipView dismissHudForView:self.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationBar.hidden = NO;
    self.currentImageIndex = self.imagePreviewView.currentImageIndex;
    if ([self.imagePreviewView.delegate respondsToSelector:@selector(numberOfImagesInImagePreviewView:)]) {
       @weakify(self);
        [[RACObserve(self, currentImageIndex) deliverOnMainThread]
         subscribeNext:^(id  _Nullable x) {
             @strongify(self);
             NSInteger totalCount =
             [self.imagePreviewView.delegate numberOfImagesInImagePreviewView:self.imagePreviewView];
             self.navigationBar.titlelable.text =
             [NSString stringWithFormat:@"%zd/%zd", self.currentImageIndex + 1, totalCount];
         }];
    }
}

- (void)reloadImageIndex {
     self.currentImageIndex = self.imagePreviewView.currentImageIndex;
    if ([self.imagePreviewView.delegate respondsToSelector:@selector(numberOfImagesInImagePreviewView:)]) {
        NSInteger totalCount =
        [self.imagePreviewView.delegate numberOfImagesInImagePreviewView:self.imagePreviewView];
         self.navigationBar.titlelable.text =
         [NSString stringWithFormat:@"%zd/%zd", self.currentImageIndex + 1, totalCount];
    }
}

- (void)navDelete:(UIButton *)btn {
    !self.deleteCallback ?: self.deleteCallback(btn);
}

#pragma mark - getters and setters
- (IDCMWhiteNavigationBar *)navigationBar {
    return SW_LAZY(_navigationBar, ({
        
        IDCMWhiteNavigationBar *view = [IDCMWhiteNavigationBar new];
        view.backgroundColor = [UIColor blackColor];
        view.titlelable.textColor = UIColorWhite;
        [view.backButton setImage:[UIImage imageNamed:@"2.1_navBack"]
                         forState:UIControlStateNormal];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"navDelete"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navDelete"] forState:UIControlStateHighlighted];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button addTarget:self action:@selector(navDelete:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_right).offset(-35);
            make.centerY.equalTo(view.backButton);
            make.height.equalTo(@25);
            make.width.equalTo(@60);
        }];
        self.deleteBtn = button;
        view;
    }));
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)dealloc {
    [self removeBlackView];
    [IDCMBottomListTipView dismissHudForView:self.view];
}

- (void)removeBlackView {
    UIView *view = [[UIApplication sharedApplication].keyWindow viewWithTag:10245];
    if (!view) {return;}
    [UIView animateWithDuration:.3 animations:^{
        view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

@end














