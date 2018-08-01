//
//  IDCMImagePickerViewController.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/18.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "QMUIImagePickerViewController.h"


@interface IDCMImagePickerViewController : QMUIImagePickerViewController

@property (nonatomic,assign) BOOL animated;
@property (nonatomic,strong, readonly) NSMutableArray<UIImageView *> *selectedImageViews;

@end
