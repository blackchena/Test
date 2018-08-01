//
//  IDCMBaseTableViewCell.m
//  IDCMWallet
//
//  Created by huangyi on 2018/5/25.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseTableViewCell.h"

@interface IDCMBaseTableViewCell ()
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) IDCMBaseTableCellModel *cellViewModel;
@end

@implementation IDCMBaseTableViewCell
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initConfig];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initConfig];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableview
                        indexPath:(NSIndexPath *)indexPath
                        viewModel:(IDCMBaseTableViewModel *)viewModel {
    IDCMBaseTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:NSStringFromClass(self)
                                                                  forIndexPath:indexPath];
    cell.cellViewModel = [viewModel getCellViewModelAtIndexPath:indexPath];
    cell.viewModel = viewModel;
    cell.indexPath = indexPath;
    [cell configureCell];
    return cell;
}

- (void)initConfig {
    self.opaque = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configureCell {};
- (void)reloadCellData {};
- (void)setCustomSubViewsArray:(NSArray<UIView *> *)customSubViewsArray {
    _customSubViewsArray = customSubViewsArray;
    for (UIView *subView in customSubViewsArray) {
        if ([subView isKindOfClass:[UIView class]]) {
          [self.contentView addSubview:subView];
        }
    }
}

@end















