//
//  IDCMBaseTableViewHeaderFooterView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/5/25.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBaseTableViewHeaderFooterView.h"


@interface IDCMBaseTableViewHeaderFooterView ()
@property (nonatomic, assign) BOOL isHeader;
@property (nonatomic, assign) NSInteger section;
@end

@implementation IDCMBaseTableViewHeaderFooterView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initConfig];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initConfig];
    }
    return self;
}

+ (instancetype)headerFooterViewWithTableView:(UITableView *)tableView
                                      section:(NSInteger)section
                                     isHeader:(BOOL)isHeader
                                    viewModel:(IDCMBaseTableViewModel *)viewModel {
    IDCMBaseTableViewHeaderFooterView *headerFooterView =
    [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass(self)];
    headerFooterView.sectionViewModel = [viewModel getSectionViewModelAtSection:section];
    headerFooterView.section = section;
    headerFooterView.isHeader = isHeader;
    headerFooterView.viewModel = viewModel;
    [headerFooterView configureHeaderFooterView];
    return headerFooterView;
}

- (void)initConfig {self.contentView.backgroundColor = [UIColor whiteColor];}
- (void)reloadHeaderFooterViewData {}
- (void)configureHeaderFooterView{};

@end










