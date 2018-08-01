//
//  IDCMTableViewCell.m
//  IDCMWallet
//
//  Created by BinBear on 2017/11/21.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMTableViewCell.h"

@implementation IDCMTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    for (UIView *view in self.subviews) {
        if([view isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)view).delaysContentTouches = NO;
            break;
        }
    }
    return self;
}
/**
 获取重用的Cell
 
 @param tableView tableView
 @return 返回获取到的cell  如果不存在 会自动创建
 */
+ (instancetype)getTableViewContentCellWithTableView:(UITableView *)tableView;
{
    NSString *cellIdentifier = NSStringFromClass([self class]);
    id  iconDetailCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!iconDetailCell) {
        iconDetailCell = [[[self class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return iconDetailCell;
}
@end
