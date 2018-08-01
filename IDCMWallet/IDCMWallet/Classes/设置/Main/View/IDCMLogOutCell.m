//
//  IDCMLogOutCell.m
//  IDCMWallet
//
//  Created by BinBear on 2018/2/2.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMLogOutCell.h"

@interface IDCMLogOutCell()
@property (nonatomic,strong) UILabel *signOut;
@property (nonatomic,strong) UIView *grayView;
@end

@implementation IDCMLogOutCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    

    [self.signOut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.bottom.equalTo(self.contentView);
  
    }];
}
#pragma mark - getter

- (UILabel *)signOut
{
    return SW_LAZY(_signOut, ({
        UILabel *view = [UILabel new];
        view.backgroundColor = UIColorWhite;
        view.textColor = SetColor(51, 51, 51);
        view.userInteractionEnabled = YES;
        view.textAlignment = NSTextAlignmentCenter;
        view.text = SWLocaloziString(@"2.2.3_LogOutWallet");
        view.font = SetFont(@"PingFang-SC-Regular", 14);
        [self.contentView addSubview:view];
        view;
    }));
}
@end
