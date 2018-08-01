//
//  IDCMSelectPayMethodsView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/9.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMSelectPayMethodsView.h"

@interface SelectPayViewCell ()
@property (nonatomic,strong) UIView  *customContentView;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) UIButton *selectBtn;
@end
@implementation SelectPayViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initConfig];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableview
                        indexPath:(NSIndexPath *)indexPath {
    SelectPayViewCell *cell = [tableview dequeueReusableCellWithIdentifier:NSStringFromClass(self)
                                                                         forIndexPath:indexPath];
    cell.indexPath = indexPath;
    return cell;
}

- (void)initConfig {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.customContentView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.countryLabel.width = self.countryLabel.text.length ? 40 : 0;
    self.countryLabel.left = self.countryLabel.text.length ? self.selectBtn.right + 12 : self.selectBtn.right + 6;
    self.iconImageView.left = self.countryLabel.right + 12;
    self.payTitleLabel.width = self.customContentView.width - self.iconImageView.right - 15 - 12;
    self.payTitleLabel.left = self.iconImageView.right + 15;
    self.payAccountLabel.width = self.payTitleLabel.width;
    self.payAccountLabel.left = self.payTitleLabel.left;
    
    if (self.payAccountLabel.text.length) {
        self.payTitleLabel.top = 12;
    } else {
        self.payTitleLabel.centerY = self.iconImageView.centerY;
    }
}

- (void)setBorderColorWithSelected:(BOOL)selected {
    self.customContentView.layer.cornerRadius = 10.0;
    self.customContentView.layer.borderWidth =  0.5 ;
    self.customContentView.layer.borderColor = selected ?
    [UIColor colorWithHexString:@"#2968B9"].CGColor :
    [UIColor colorWithHexString:@"#E1E7F7"].CGColor;
    self.customContentView.layer.masksToBounds = YES;
}

- (UIView *)customContentView {
    if (!_customContentView) {
        
        _customContentView = [[UIView alloc] init];
        _customContentView.backgroundColor = [UIColor whiteColor];
        _customContentView.frame = CGRectMake(0, 10, SCREEN_WIDTH - 24 - 40, 55);
        
        [_customContentView addSubview:self.selectBtn];
        [_customContentView addSubview:self.countryLabel];
        [_customContentView addSubview:self.iconImageView];
        [_customContentView addSubview:self.payTitleLabel];
        [_customContentView addSubview:self.payAccountLabel];
    }
    return _customContentView;
}
- (UIButton *)selectBtn {
    return SW_LAZY(_selectBtn, ({
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"3.0_unSelectArrow"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"3.0_selectArrow"] forState:UIControlStateSelected];
        btn.userInteractionEnabled = NO;
        btn.size = CGSizeMake(20, 20);
        btn.centerY = _customContentView.height / 2;
        btn.left = 20;
        btn;
    }));
}
- (UILabel *)countryLabel {
    return SW_LAZY(_countryLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor333333;
        label.font = textFontPingFangRegularFont(12);
        label.textAlignment = NSTextAlignmentCenter;
        label.height = 16;
        label.width = 40;
        label.centerY = self.selectBtn.centerY;
        label.left = self.selectBtn.right + 12;
        label;
    }));
}
- (UIImageView *)iconImageView {
    return SW_LAZY(_iconImageView, ({
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.size = CGSizeMake(25, 25);
        imageView.centerY = self.selectBtn.centerY;
        imageView.left = self.countryLabel.right + 12;
        imageView;
    }));
}
- (UILabel *)payTitleLabel {
    return SW_LAZY(_payTitleLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor333333;
        label.font = textFontPingFangRegularFont(12);
        label.height = 16;
        label.width = _customContentView.width - self.iconImageView.right - 15 - 12;
        label.top = 12;
        label.left = self.iconImageView.right + 15;
        label;
    }));
}
- (UILabel *)payAccountLabel {
    return SW_LAZY(_payAccountLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor999999;
        label.font = textFontPingFangRegularFont(10);
        label.height = 14;
        label.width = self.payTitleLabel.width;
        label.top = self.payTitleLabel.bottom + 3;
        label.left = self.payTitleLabel.left;
        label;
    }));
}
@end


@interface IDCMSelectPayMethodsView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) UIButton *sureBtn;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,assign) NSInteger  totalCount;
@property (nonatomic,assign) BOOL canMultipleSelect;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) BOOL isFilter;
@property (nonatomic,assign) BOOL noSureBtn;

@property (nonatomic,strong) NSMutableArray *models;
@property (nonatomic,strong) NSArray *originSelectedIndexArray;
@property (nonatomic,copy) cellConfigBlock cellConfigure;
@property (nonatomic,copy) void(^selectedCallback)(id model);
@end
@implementation IDCMSelectPayMethodsView

+ (void)showWithTitle:(NSString *)title
               models:(NSArray<id>*)models
    canMultipleSelect:(BOOL)canMultipleSelect
             isFilter:(BOOL)isFilter
        cellConfigure:(cellConfigBlock)cellConfigure
     selectedCallback:(void(^)(NSArray *models))selectedCallback {
    
    if (!models.count) {return;}
    NSArray *chechIndexArray = [self chechModelsArray:models];
    if (!chechIndexArray) {
        DDLogDebug(@"模型中没有isSelected这个属性, 请添加.....");
        return;
    }
    if (!canMultipleSelect && chechIndexArray.count > 1) {
        DDLogDebug(@"设置单选但是 选中的有多个");
        return;
    }
    
    IDCMSelectPayMethodsView *tipView = [[self alloc] init];
    tipView.canMultipleSelect = canMultipleSelect;
    tipView.cellConfigure = [cellConfigure copy];
    tipView.selectedCallback = [selectedCallback copy];
    tipView.models = models.mutableCopy;
    tipView.isFilter = isFilter;
    tipView.title = title;
    tipView.totalCount = models.count>5?5:models.count;
    if (chechIndexArray.count > 0 ) {
        tipView.originSelectedIndexArray = chechIndexArray;
    }
    
    CGSize size = CGSizeMake(SCREEN_WIDTH - 24, 46 + (66 * tipView.totalCount) + 20 + 40 + 20);
    tipView.size = size;
    [tipView initConfigure];
    [tipView checkBtnSelected];
    tipView.layer.cornerRadius = 10.0;
    tipView.layer.masksToBounds = YES;
    [self showTipViewToView:nil
                       size:size
                contentView:tipView
           automaticDismiss:NO
             animationStyle:1
      tipViewStatusCallback:nil];
}

+ (void)showWithTitle:(NSString *)title
               models:(NSArray<id>*)models
        cellConfigure:(cellConfigBlock)cellConfigure
     selectedCallback:(void(^)(id model))selectedCallback {
    
    if (!models.count) {return;}
    NSArray *chechIndexArray = [self chechModelsArray:models];
    if (!chechIndexArray) {
        DDLogDebug(@"模型中没有isSelected这个属性, 请添加.....");
        return;
    }

    IDCMSelectPayMethodsView *tipView = [[self alloc] init];
    tipView.cellConfigure = [cellConfigure copy];
    tipView.selectedCallback = [selectedCallback copy];
    tipView.models = models.mutableCopy;
    tipView.title = title;
    tipView.totalCount = models.count>5?5:models.count;
    if (chechIndexArray.count > 0 ) {
        tipView.originSelectedIndexArray = chechIndexArray;
    }
    tipView.noSureBtn = YES;
    
    CGSize size = CGSizeMake(SCREEN_WIDTH - 24, 46 + (66 * tipView.totalCount) + 20);
    tipView.size = size;
    [tipView initConfigure];
    tipView.layer.cornerRadius = 10.0;
    tipView.layer.masksToBounds = YES;
    [self showTipViewToView:nil
                       size:size
                contentView:tipView
           automaticDismiss:NO
             animationStyle:1
      tipViewStatusCallback:nil];
}

+ (NSArray *)chechModelsArray:(NSArray *)models {
    __block BOOL check = YES;
    __block NSMutableArray *indexsArray = @[].mutableCopy;
    [models enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![self checkPropertyWithInstance:obj propertyName:@"isSelected"]) {
            check = NO;
            *stop = YES;
        }
    }];
    if (check) {
        [models enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([[obj valueForKey:@"isSelected"] boolValue]) {
                [indexsArray addObject:@(idx)];
            }
        }];
        return indexsArray;
    } else {
        return nil;
    }
}

+ (BOOL)checkPropertyWithInstance:(id)instance
                     propertyName:(NSString *)propertyName {
    NSArray *propertyList =  [self propertyListWithClass:[instance class]];
    for (NSString *property in propertyList) {
        if ([property isEqualToString:propertyName]) {
            return YES;
        }
    }
    return NO;
}

+ (NSArray *)propertyListWithClass:(Class)cls {
    NSMutableArray *Plist = [NSMutableArray array];
    unsigned int count = 0;
    objc_property_t *propertys = class_copyPropertyList(cls, &count);
    for (int i = 0; i<count; i++) {
        objc_property_t property = propertys[i];
        const char *name = property_getName(property);
        NSString *key = [NSString stringWithUTF8String:name];
        [Plist addObject:key];
    }
    free(propertys);
    return Plist;
}

- (void)initConfigure {
    [self configUI];
    [self configSignal];
}

- (void)configUI {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.closeBtn];
    [self addSubview:self.titleLabel];
    [self addSubview:self.tableView];
    if (!self.noSureBtn) {
        [self addSubview:self.sureBtn];
    }
}

- (void)configSignal {
    @weakify(self);
    
    void(^clearBlock)(void) = ^{
        self.selectedCallback = nil;
        self.cellConfigure = nil;
    };
    
    self.closeBtn.rac_command = RACCommand.emptyCommand(^(id input){
        @strongify(self);
        if (!self.noSureBtn) {
            [self.models enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL *stop) {
                if ([self.originSelectedIndexArray containsObject:@(idx)]) {
                    [obj setValue:@YES forKey:@"isSelected"];
                } else {
                    [obj setValue:@NO forKey:@"isSelected"];
                }
            }];
        }
        [IDCMBaseCenterTipView dismissWithCompletion:clearBlock];
    });
    
    if (!self.noSureBtn) {
        self.sureBtn.rac_command = RACCommand.emptyCommand(^(id input){
            [IDCMBaseCenterTipView dismissWithCompletion:^{
                @strongify(self);
                NSArray *selectedModels = [self getSelectedModels];
                !self.selectedCallback ?: self.selectedCallback(selectedModels);
                clearBlock();
            }];
        });
    }
}

- (NSMutableArray *)getSelectedModels {
    NSMutableArray *array  = @[].mutableCopy;
    for (id model in self.models) {
        if ([[model valueForKeyPath:@"isSelected"] boolValue]) {
            [array addObject:model];
        }
    }
    return array;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return  self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   return [SelectPayViewCell cellWithTableView:tableView
                                     indexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(SelectPayViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id model = self.models[indexPath.row];
    !self.cellConfigure ?: self.cellConfigure(cell, model);
    cell.selectBtn.selected = [[model valueForKeyPath:@"isSelected"] boolValue];
    [cell setBorderColorWithSelected:cell.selectBtn.selected];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectPayViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton * btn = cell.selectBtn;
    
    // 选中立即消失
    if (self.noSureBtn) {
        if (!btn.selected) {
            [self.models enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if (idx == indexPath.row) {
                    [self.models[idx] setValue:@YES forKeyPath:@"isSelected"];
                } else {
                    [self.models[idx] setValue:@NO forKeyPath:@"isSelected"];
                }
            }];
            [self.tableView reloadData];
        }
        
        @weakify(self);
        [IDCMBaseCenterTipView dismissWithCompletion:^{
            @strongify(self);
            !self.selectedCallback ?: self.selectedCallback(self.models[indexPath.row]);
            self.selectedCallback = nil;
            self.cellConfigure = nil;
        }];
        
        return;
    }
    
    if (self.isFilter &&
        self.canMultipleSelect &&
        [self.originSelectedIndexArray containsObject:@(indexPath.row)]) {
        return;
    }
    
    if (self.isFilter && !self.canMultipleSelect && cell.selectBtn.selected) {
        return;
    }
    
   
    if (self.canMultipleSelect) {
        [self.models[indexPath.row] setValue:@(!btn.selected) forKeyPath:@"isSelected"];
    } else {
        [self.models enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if (idx == indexPath.row) {
                [self.models[idx] setValue:@(!btn.selected) forKeyPath:@"isSelected"];
            } else {
                [self.models[idx] setValue:@NO forKeyPath:@"isSelected"];
            }
        }];
    }
    [self.tableView reloadData];
    [self checkBtnSelected];
}

- (void)checkBtnSelected {
    NSArray *array = [self getSelectedModels];
    self.sureBtn.enabled = array.count;
}

- (UITableView *)tableView {
    return SW_LAZY(_tableView, ({
        CGRect rect = CGRectMake(20, self.titleLabel.bottom + 10, self.width - 40, 66 * self.totalCount);
        UITableView *tableView = [[UITableView alloc] initWithFrame:rect
                                                              style:UITableViewStylePlain];
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.bounces = NO;
        tableView.rowHeight = 66;
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerCellWithCellClass:[SelectPayViewCell class]];
        tableView;
    }));
}
- (UIButton *)closeBtn {
    return SW_LAZY(_closeBtn, ({
        
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:[UIImage imageNamed:@"3.0_close"] forState:UIControlStateNormal];
        btn.size = CGSizeMake(26, 26);
        btn.right = self.width - 10;
        btn;
    }));
}
- (UILabel *)titleLabel {
    return SW_LAZY(_titleLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor333333;
        label.font = textFontPingFangRegularFont(16);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.title.length ? self.title : SWLocaloziString(@"3.0_DK_otcChooseType");
        label.height = 22;
        label.top = 15;
        label.width = self.width - 2 * self.closeBtn.width ;
        label.centerX = self.width / 2;
        self.closeBtn.centerY = label.centerY;
        label;
    }));
}
- (UIButton *)sureBtn {
    return SW_LAZY(_sureBtn, ({
        
        UIButton *btn = [[UIButton alloc] init];
        btn.width = self.width - 56 * 2;
        btn.height = 40;
        btn.centerX = self.titleLabel.centerX;
        btn.top = self.tableView.bottom + 20;
        
        btn.layer.cornerRadius = 4.0;
        btn.layer.masksToBounds = YES;
        btn.adjustsImageWhenHighlighted = NO;
        [btn setTitle:NSLocalizedString(@"2.1_PhraseDone", nil)
             forState:UIControlStateNormal];
        btn.titleLabel.font = textFontPingFangRegularFont(16);
        
        UIImage *image1 = [UIImage imageWithColor:kThemeColor];
        UIImage *image2 = [UIImage imageWithColor:[UIColor colorWithHexString:@"#999FA5"]];
        [btn setBackgroundImage:image1 forState:UIControlStateNormal];
        [btn setBackgroundImage:image2 forState:UIControlStateDisabled];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithWhite:1 alpha:.5] forState:UIControlStateDisabled];
        btn;
    }));
}

- (NSMutableArray *)models {
    return SW_LAZY(_models, @[].mutableCopy);
}

- (NSArray *)originSelectedIndexArray {
    return SW_LAZY(_originSelectedIndexArray, @[]);
}

@end
















