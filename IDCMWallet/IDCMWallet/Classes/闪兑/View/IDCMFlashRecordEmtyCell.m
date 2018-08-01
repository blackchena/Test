//
//  IDCMFlashRecordEmtyCell.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/28.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMFlashRecordEmtyCell.h"

@implementation IDCMFlashRecordEmtyCell

- (void)initConfig {
    self.backgroundColor = viewBackgroundColor;
    self.contentView.backgroundColor = viewBackgroundColor;
    [IDCMHUD showEmptyViewToView:self.contentView
                       configure:^ (IDCMHUDConfigure *configure) {
                           configure.title(nil)
                           .subTitle(SWLocaloziString(@"3.0_ExchangeNoData"))
                           .backgroundImage([UIImage imageWithColor:viewBackgroundColor])
                           .positionConfigure(RACTuplePack(@(1), @(0)));
                       }
                  reloadCallback:nil];
}

+ (instancetype)cellWithTableView:(UITableView *)tableview
                        indexPath:(NSIndexPath *)indexPath {
    IDCMFlashRecordEmtyCell *cell = [tableview dequeueReusableCellWithIdentifier:NSStringFromClass(self)
                                                          forIndexPath:indexPath];
    return cell;
}

@end
