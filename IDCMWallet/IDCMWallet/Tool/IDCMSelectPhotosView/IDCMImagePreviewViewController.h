//
//  IDCMImagePreviewViewController.h
//  IDCMWallet
//
//  Created by huangyi on 2018/5/5.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "QMUIImagePreviewViewController.h"
#import "IDCMWhiteNavigationBar.h"


@interface IDCMImagePreviewViewController : QMUIImagePreviewViewController
@property (nonatomic,strong) IDCMWhiteNavigationBar *navigationBar;
@property (nonatomic,assign) NSInteger currentImageIndex;
@property (nonatomic,copy) CommandInputBlock deleteCallback;
@property (nonatomic,strong) UIButton *deleteBtn;
- (void)reloadImageIndex;
@end
