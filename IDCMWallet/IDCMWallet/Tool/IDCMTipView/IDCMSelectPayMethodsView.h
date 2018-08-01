//
//  IDCMSelectPayMethodsView.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/9.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseBottomTipView.h"


@interface SelectPayViewCell : UITableViewCell
@property (nonatomic,strong) UIImageView *iconImageView;  // 图标
@property (nonatomic,strong) UILabel *countryLabel;      // 国家
@property (nonatomic,strong) UILabel *payTitleLabel;    // 付款方式名称
@property (nonatomic,strong) UILabel *payAccountLabel; // 账号
@end


typedef void(^cellConfigBlock)(SelectPayViewCell *cell, id model);
@interface IDCMSelectPayMethodsView : IDCMBaseCenterTipView


/**
 show

 @param title 标题
 @param models 模型数组
 @param canMultipleSelect 能不能复选
 @param isFilter 原始选中的能否取消
 @param cellConfigure 配置cell
 @param selectedCallback 回调
 */
+ (void)showWithTitle:(NSString *)title
               models:(NSArray<id>*)models
    canMultipleSelect:(BOOL)canMultipleSelect
             isFilter:(BOOL)isFilter
        cellConfigure:(cellConfigBlock)cellConfigure
     selectedCallback:(void(^)(NSArray *models))selectedCallback;

// 没有确认按钮 选择立即消失
+ (void)showWithTitle:(NSString *)title
               models:(NSArray<id>*)models
        cellConfigure:(cellConfigBlock)cellConfigure
     selectedCallback:(void(^)(id model))selectedCallback;


@end










