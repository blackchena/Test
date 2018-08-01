//
//  IDCMTableViewBindHelper.m
//  IDCMWallet
//
//  Created by BinBear on 2018/5/10.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMTableViewBindHelper.h"
#import "IDCMTableViewProtocol.h"

/*********  配置类  ***********/
@interface IDCMTableViewBindHelperConfig ()
/**
 *  TableView的动画类型
 */
@property (assign, nonatomic) IDCMTableViewAnimationType animationType;
/**
 *  TableView的组数
 */
@property (assign, nonatomic) NSInteger numberSections;
/**
 *  TableView的组的头部视图的高度
 */
@property (assign, nonatomic) CGFloat headerSectionHeight;
/**
 *  TableView的组的底部视图的高度
 */
@property (assign, nonatomic) CGFloat footerSectionHeight;
/**
 *  TableView的组的头部视图
 */
@property (strong, nonatomic) id sectionHeaderView;
/**
 *  TableView的组的底部视图
 */
@property (strong, nonatomic) id sectionFooterView;
@end

@implementation IDCMTableViewBindHelperConfig

- (tableViewBindIntTypeBlock)tableViewAnimationType{
    
    tableViewBindIntTypeBlock block = ^(NSInteger value){
        if (value) {
            _animationType = value;
        }
        return self;
    };
    return block;
}
- (tableViewBindIntTypeBlock)numberOfSections{
    
    tableViewBindIntTypeBlock block = ^(NSInteger value){
        if (value) {
            _numberSections = value;
        }
        return self;
    };
    return block;
}
- (tableViewBindFloatTypeBlock)headerSectionViewHeight{
    tableViewBindFloatTypeBlock block = ^(CGFloat value){
        if (value) {
            _headerSectionHeight = value;
        }
        return self;
    };
    return block;
}
- (tableViewBindFloatTypeBlock)footerSectionViewHeight{
    tableViewBindFloatTypeBlock block = ^(CGFloat value){
        if (value) {
            _footerSectionHeight = value;
        }
        return self;
    };
    return block;
}
- (tableViewBindObjectBlock)headerInSectionView{
    
    tableViewBindObjectBlock block = ^(id value){
        if (value && [value isKindOfClass:[UIView class]]) {
            _sectionHeaderView = value;
        }else{
            DDLogDebug(@"头视图的类型❎");
        }
        return self;
    };
    return block;
}
- (tableViewBindObjectBlock)footerInSectionView{
    
    tableViewBindObjectBlock block = ^(id value){
        if (value && [value isKindOfClass:[UIView class]]) {
            _sectionFooterView = value;
        }else{
            DDLogDebug(@"底视图的类型❎");
        }
        return self;
    };
    return block;
}
@end


@interface IDCMTableViewBindHelper () <UITableViewDataSource, UITableViewDelegate>


/**
 *  TableView
 */
@property (strong, nonatomic) UITableView *tableView;
/**
 *  cell的复用标识
 */
@property (copy, nonatomic) NSString *reuseIdentifier;
/**
 *  数据源
 */
@property (strong, nonatomic) NSArray *data;
/**
 *  TableView的组数
 */
@property (assign, nonatomic) NSInteger numberOfSections;
/**
 *  TableView的组的头部视图
 */
@property (strong, nonatomic) UIView *sectionHeaderView;
/**
 *  TableView的组的底部视图
 */
@property (strong, nonatomic) UIView *sectionFooterView;
/**
 *  数据Signal
 */
@property (strong, nonatomic) RACSignal *signal;
/**
 *  点击command
 */
@property (strong, nonatomic) RACCommand *selection;
/**
 *  配置Block
 */
@property (copy, nonatomic) tableViewBindConfigBlock tableViewBindBlock;
/**
 *  配置类
 */
@property (strong, nonatomic) IDCMTableViewBindHelperConfig *tableViewBindConfigClass;

@end

@implementation IDCMTableViewBindHelper

#pragma mark - init
- (instancetype)initWithTableView:(UITableView *)tableView
                     sourceSignal:(RACSignal *)source
                 selectionCommand:(RACCommand *)didSelectionCommand
                     withCellType:(NSDictionary *)CellTypeDic
{
    if (self = [super init]) {
        
        self.tableView = tableView;
        self.data = @[];
        self.selection = didSelectionCommand;
        self.signal = source;
        
        NSString *cellType = CellTypeDic[@"cellType"];
        NSString *cellIdentifier = CellTypeDic[@"cellName"];
        self.reuseIdentifier = cellIdentifier;
        if ([cellType isEqualToString:@"codeType"]) {
            
            Class cell =  NSClassFromString(cellIdentifier);
            [self.tableView registerClass:cell forCellReuseIdentifier:self.reuseIdentifier];
            
        }else{
            
            UINib *templateCellNib = [UINib nibWithNibName:cellIdentifier bundle:nil];
            [self.tableView registerNib:templateCellNib forCellReuseIdentifier:self.reuseIdentifier];
        }
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        
        @weakify(self);
        [self.signal subscribeNext:^(id x) {
            @strongify(self);
            self.data = x;
            [self.tableView reloadData];
        }];
    }
    return self;
}
+ (instancetype)bindingHelperForTableView:(UITableView *)tableView
                             sourceSignal:(RACSignal *)source
                         selectionCommand:(RACCommand *)didSelectionCommand
                             templateCell:(NSString *)templateCell{
    
    NSDictionary *cellDic = @{@"cellType":@"codeType",@"cellName":templateCell};
    return [[IDCMTableViewBindHelper alloc] initWithTableView:tableView
                                                 sourceSignal:source
                                             selectionCommand:didSelectionCommand
                                                 withCellType:cellDic];
}
+ (instancetype)bindingHelperForTableView:(UITableView *)tableView
                             sourceSignal:(RACSignal *)source
                         selectionCommand:(RACCommand *)didSelectionCommand
                      templateCellWithNib:(NSString *)templateCell{
    
    NSDictionary *cellDic = @{@"cellType":@"nibType",@"cellName":templateCell};
    return [[IDCMTableViewBindHelper alloc] initWithTableView:tableView
                                                 sourceSignal:source
                                             selectionCommand:didSelectionCommand
                                                 withCellType:cellDic];
}
+ (instancetype)bindingHelperForTableView:(UITableView *)tableView
                             sourceSignal:(RACSignal *)source
                         selectionCommand:(RACCommand *)didSelectionCommand
                             templateCell:(NSString *)templateCell
                     tableviewConfigBlock:(tableViewBindConfigBlock)configBlock{
    
    
    IDCMTableViewBindHelper *helper = [[self alloc] init];
    IDCMTableViewBindHelperConfig *config = [[IDCMTableViewBindHelperConfig alloc] init];
    if (configBlock) {
        configBlock(config);
    }
    helper.tableViewBindBlock = configBlock;
    helper.tableViewBindConfigClass = config;
    
    helper.tableView = tableView;
    helper.data = @[];
    helper.selection = didSelectionCommand;
    helper.signal = source;
    
    helper.tableView.dataSource = helper;
    helper.tableView.delegate = helper;
    helper.reuseIdentifier = templateCell;
    
    Class cell =  NSClassFromString(helper.reuseIdentifier);
    [helper.tableView registerClass:cell forCellReuseIdentifier:helper.reuseIdentifier];
    
    @weakify(helper);
    [helper.signal subscribeNext:^(id x) {
        @strongify(helper);
        helper.data = x;
        [helper.tableView reloadData];
        if (helper.tableViewBindConfigClass && helper.tableViewBindBlock && helper.tableViewBindConfigClass.animationType) {
            [IDCMTableViewAnimationKit showWithAnimationType:helper.tableViewBindConfigClass.animationType tableView:helper.tableView];
        }
    }];
    
    
    return helper;
}
#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    if (self.tableViewBindConfigClass && self.tableViewBindBlock && self.tableViewBindConfigClass.numberSections > 1) {
        return self.tableViewBindConfigClass.numberSections;
    }else{
        return 1;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if (self.tableViewBindConfigClass && self.tableViewBindBlock && self.tableViewBindConfigClass.numberSections > 1) {
        if (self.data.count > 0) {
            return [self.data[section] count];
        }else{
            return 0;
        }
    }else{
        return self.data.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<IDCMTableViewProtocol> cell = [tableView dequeueReusableCellWithIdentifier:self.reuseIdentifier];
    
    NSAssert([cell respondsToSelector:@selector(bindViewModel:)], @"cell必须支持IDCMTableViewProtocol这个协议");
    
    if (self.tableViewBindConfigClass && self.tableViewBindBlock && self.tableViewBindConfigClass.numberSections > 1) {
        [cell bindViewModel:self.data[indexPath.section][indexPath.row]];
    }else{
        [cell bindViewModel:self.data[indexPath.row]];
    }
    
    return (UITableViewCell *)cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (self.tableViewBindConfigClass && self.tableViewBindBlock && self.tableViewBindConfigClass.numberSections > 1) {
        [self.selection execute:self.data[indexPath.section][indexPath.row]];
    }else{
        [self.selection execute:self.data[indexPath.row]];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.tableViewBindConfigClass && self.tableViewBindBlock && self.tableViewBindConfigClass.headerSectionHeight) {
        return self.tableViewBindConfigClass.headerSectionHeight;
    }else{
        return 0.0f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.tableViewBindConfigClass && self.tableViewBindBlock && self.tableViewBindConfigClass.footerSectionHeight) {
        return self.tableViewBindConfigClass.footerSectionHeight;
    }else{
        return 0.0f;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.tableViewBindConfigClass && self.tableViewBindBlock && self.tableViewBindConfigClass.sectionHeaderView) {
        return self.tableViewBindConfigClass.sectionHeaderView;
    }else{
        return [UIView new];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.tableViewBindConfigClass && self.tableViewBindBlock && self.tableViewBindConfigClass.sectionHeaderView) {
        return self.tableViewBindConfigClass.sectionFooterView;
    }else{
        return [UIView new];
    }
}
@end
