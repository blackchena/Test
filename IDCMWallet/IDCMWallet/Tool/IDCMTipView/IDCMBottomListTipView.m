//
//  IDCMBottomListTipView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/6.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBottomListTipView.h"


@interface IDCMBottomListTipViewItemConfigure ()
@property (nonatomic,assign) CGFloat item_height;
@property (nonatomic,strong) id item_title;
@property (nonatomic,strong) UIView *item_customView;
@property (nonatomic,copy) itemClickAction item_action;
@end
@implementation IDCMBottomListTipViewItemConfigure

- (itemConfigBlock)title {
    itemConfigBlock block = ^(id value){
        if (!value ||
            [value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[NSAttributedString class]] ||
            [value isKindOfClass:[NSMutableAttributedString class]]) {
            _item_title = value;
        } else {
            DDLogDebug(@"赋值title的类型不正确");
        }return self;
    };return block;
}
- (itemConfigBlock)customView {
    itemConfigBlock block = ^(id value){
        if (!value || [value isKindOfClass:[UIView class]]) {
            _item_customView = value;
        } else {
            DDLogDebug(@"赋值coustomView的类型不正确");
        }return self;
    };return block;
}
- (itemConfigBlock)height {
    itemConfigBlock block = ^(id value){
        _item_height = [value floatValue];
        return self;
    };return block;
}
- (clickItemConfigBlock)itemClick {
    clickItemConfigBlock block = ^(itemClickAction action){
        _item_action = [action copy];
        return self;
    };
    return block;
}
@end


@interface ListTipViewCell : UITableViewCell
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIView *customView;
@end
@implementation ListTipViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initConfig];
    }
    return self;
}

- (void)initConfig {
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleL.frame = self.bounds;
    self.customView.frame = self.bounds;
}

- (void)setCustomView:(UIView *)customView {
    _customView = customView;
    if (!customView.superview) {
        [self.titleL removeFromSuperview];
        [self.contentView addSubview:customView];
    }
}

- (void)setTitleStr:(id)titleStr {
    _titleStr = titleStr;
    
    if (!self.titleL.superview) {
        [self.customView removeFromSuperview];
        if ([titleStr isKindOfClass:[NSAttributedString class]] ||
            [titleStr isKindOfClass:[NSMutableAttributedString class]]) {
            self.titleL.attributedText = titleStr;
        }
        if ([titleStr isKindOfClass:[NSString class]]) {
           self.titleL.text = titleStr;
        }
        [self.contentView addSubview:self.titleL];
    }
}

- (void)setFrame:(CGRect)frame {
    frame.size.height -= 1;
    [super setFrame:frame];
}

- (UILabel *)titleL {
    return SW_LAZY(_titleL, ({
        
        UILabel *titleL = [[UILabel alloc] init];
        titleL.font = textFontPingFangRegularFont(14);
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.backgroundColor = [UIColor whiteColor];
        titleL.textColor = textColor666666;
        titleL.numberOfLines = 0;
        titleL;
    }));
}
@end

@interface IDCMBottomListTipView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) itemClickBlock itemClickCallback;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat showTime;
@property (nonatomic, assign) CGFloat dissmissTime;
@property (nonatomic, assign) BOOL isSigleTitle;
@property (nonatomic,strong) NSArray *disabledIndexs;

@property (nonatomic,weak) UIView *inView;
@property (nonatomic,assign) NSInteger  itemsCount;
@property (nonatomic,copy) BottomListTipViewConfigBlock configure;
@property (nonatomic,strong) NSArray<IDCMBottomListTipViewItemConfigure *> *itemConfigures;
@end

@implementation IDCMBottomListTipView


+ (void)showTipViewToView:(UIView *)toView
               titleArray:(NSArray *)titleArray
        itemClickCallback:(itemClickBlock)itemClickCallback {
    
    if (!titleArray.count) { return; }
    
    IDCMBottomListTipView *tipView = [[IDCMBottomListTipView alloc] init];
    tipView.backgroundColor = [UIColor whiteColor];
    tipView.isSigleTitle = YES;
    tipView.titleArray = titleArray;
    tipView.itemClickCallback = [itemClickCallback copy];
    CGSize size = CGSizeMake(SCREEN_HEIGHT, titleArray.count * 50 + kSafeAreaBottom);
    tipView.size = size;
    [tipView addSubview:tipView.tableView];
    tipView.inView = toView;
    
    [self showTipViewToView:toView
                       size:size
                contentView:tipView
      tipViewStatusCallback:nil];
}

+ (void)showTipViewToView:(UIView *)toView
               titleArray:(NSArray *)titleArray
           disabledIndexs:(NSArray *)disabledIndexs
        itemClickCallback:(itemClickBlock)itemClickCallback {
    
    if (!titleArray.count) { return; }
    
    IDCMBottomListTipView *tipView = [[IDCMBottomListTipView alloc] init];
    tipView.backgroundColor = [UIColor whiteColor];
    tipView.disabledIndexs = disabledIndexs;
    tipView.isSigleTitle = YES;
    tipView.titleArray = titleArray;
    tipView.itemClickCallback = [itemClickCallback copy];
    CGSize size = CGSizeMake(SCREEN_HEIGHT, titleArray.count * 50 + kSafeAreaBottom);
    tipView.size = size;
    [tipView addSubview:tipView.tableView];
    tipView.inView = toView;
    
    [self showTipViewToView:toView
                       size:size
                 blackAlpha:0.5
                blackAction:NO
                contentView:tipView
      tipViewStatusCallback:nil];
}

+ (void)showTipViewToView:(UIView *)toView
                itmeCount:(NSInteger)itemCount
                configure:(BottomListTipViewConfigBlock)configure {
    
    if (itemCount < 1) { return; }
    
    IDCMBottomListTipView *tipView = [[IDCMBottomListTipView alloc] init];
    tipView.backgroundColor = [UIColor whiteColor];
    tipView.isSigleTitle = NO;
    tipView.configure = [configure copy];
    tipView.itemsCount = itemCount;
    [tipView initItemConfigs];
    CGSize size = CGSizeMake(SCREEN_HEIGHT, [tipView getCustomViewHeight] + kSafeAreaBottom);
    tipView.size = size;
    [tipView addSubview:tipView.tableView];
    tipView.inView = toView;
    
    [self showTipViewToView:toView
                       size:size
                 blackAlpha:0.5
                blackAction:NO
                contentView:tipView
      tipViewStatusCallback:nil];
}

+ (void)showTipViewToView:(UIView *)toView
                itmeCount:(NSInteger)itemCount
           disabledIndexs:(NSArray *)disabledIndexs
                configure:(BottomListTipViewConfigBlock)configure {
    
    if (itemCount < 1) { return; }
    
    IDCMBottomListTipView *tipView = [[IDCMBottomListTipView alloc] init];
    tipView.backgroundColor = [UIColor whiteColor];
    tipView.disabledIndexs = disabledIndexs;
    tipView.isSigleTitle = NO;
    tipView.configure = [configure copy];
    tipView.itemsCount = itemCount;
    [tipView initItemConfigs];
    CGSize size = CGSizeMake(SCREEN_HEIGHT, [tipView getCustomViewHeight] + kSafeAreaBottom);
    tipView.size = size;
    [tipView addSubview:tipView.tableView];
    tipView.inView = toView;
    
    [self showTipViewToView:toView
                       size:size
                 blackAlpha:0.5
                blackAction:NO
                contentView:tipView
      tipViewStatusCallback:nil];
}

- (CGFloat)getCustomViewHeight {
    
    CGFloat totalHeight = 0.00;
    for (NSInteger i = 0; i < self.itemsCount; i++) {
        IDCMBottomListTipViewItemConfigure *itemConfigure = self.itemConfigures[i];
        if (self.configure) {
            self.configure(itemConfigure, i);
        }
        totalHeight += (itemConfigure.item_height);
    }
    return totalHeight;
}

- (void)initItemConfigs {
    NSMutableArray *tempArray = @[].mutableCopy;
    for (NSInteger i = 0; i < self.itemsCount; i++) {
        IDCMBottomListTipViewItemConfigure *itemConfigure = [[IDCMBottomListTipViewItemConfigure alloc] init];
        [tempArray addObject:itemConfigure];
    }
    self.itemConfigures = tempArray.copy;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.isSigleTitle ? self.titleArray.count : self.itemsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListTipViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ListTipViewCell class])
                                                            forIndexPath:indexPath];
    [self configureCell:cell forRowAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(ListTipViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.disabledIndexs && self.disabledIndexs.count) {
        if ([self.disabledIndexs containsObject:@(indexPath.row)]) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
    }

    if (self.isSigleTitle) {
        cell.titleStr = self.titleArray[indexPath.row];
    } else {
        IDCMBottomListTipViewItemConfigure *itemConfigure = self.itemConfigures[indexPath.row];
        if (itemConfigure.item_title) {
            cell.titleStr = itemConfigure.item_title;
        } else if (itemConfigure.item_customView) {
            cell.customView = itemConfigure.item_customView;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.disabledIndexs && self.disabledIndexs.count) {
        if ([self.disabledIndexs containsObject:@(indexPath.row)]) {
            return;
        }
    }
    
    typedef void(^action)(void);
    action (^singleTitleDismissCompletion)(itemClickBlock block) = ^(itemClickBlock block){
        return ^{
            block ? block(indexPath.row, self.titleArray[indexPath.row]) : nil;
        };
    };
    action (^customViewDismissCompletion)(IDCMBottomListTipViewItemConfigure *itemConfigure) = ^(IDCMBottomListTipViewItemConfigure *itemConfigure){
        return ^{
            id value = itemConfigure.item_title ? itemConfigure.item_title : itemConfigure.item_customView;
            itemConfigure.item_action ? itemConfigure.item_action(value) : nil;
            
        };
    };
    
    UIView *view = self.inView ?: [UIApplication sharedApplication].keyWindow;
    [IDCMBottomListTipView dismissForView:view
                               completion:(self.isSigleTitle ?
                                           singleTitleDismissCompletion(self.itemClickCallback) :
                                           customViewDismissCompletion(self.itemConfigures[indexPath.row]))];
     // 消除循环引用 外界使用不需要考虑循环引用
    if (self.isSigleTitle) {
        self.itemClickCallback = nil;
    } else {
        self.itemConfigures = nil;
        self.configure = nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.isSigleTitle ? 50 : self.itemConfigures[indexPath.row].item_height;
}

- (UITableView *)tableView {
    return SW_LAZY(_tableView, ({
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - kSafeAreaBottom)
                                                              style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.bounces = NO;
        tableView.rowHeight = 50;
        tableView.backgroundColor = viewBackgroundColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerCellWithCellClass:[ListTipViewCell class]];
        tableView;
    }));
}

@end
