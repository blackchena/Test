//
//  IDCMColletionTipView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/10.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMColletionTipView.h"

static NSString *_baseClassStr;

@interface IDCMColletionTipView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout *layout;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) Class cellClass;
@property (nonatomic,strong) NSArray *modelsArray;
@property (nonatomic,assign) NSInteger interRows;
@property (nonatomic,copy) NSString *animationProperty;
@property (nonatomic,strong) UIView *animationToView;
@property (nonatomic,assign) CGPoint animationOffSet;
@property (nonatomic,copy) colltionTipViewItemClickBlock itemClickCallback;
@property (nonatomic,assign) ColletionTipViewPositonType positionType;
@end


@implementation IDCMColletionTipView

+ (void)showWithTitle:(NSString *)title
            cellClass:(Class)cellClass
          modelsArray:(NSArray *)modelsArray
              wHRatio:(CGFloat)wHRatio
            interRows:(NSInteger)interRows
          maxLineRows:(NSInteger)maxLineRows
               margin:(CGFloat)margin
         contentInset:(UIEdgeInsets)contentInset
          lineSpacing:(CGFloat)lineSpacing
     interitemSpacing:(CGFloat)interitemSpacing
         positionType:(ColletionTipViewPositonType)positionType
    itemClickCallback:(colltionTipViewItemClickBlock)itemClickCallback {
    
    if (!cellClass) { return; }
    
    IDCMColletionTipView *tipView = [[self alloc] init];
    
    tipView.title = title;
    tipView.cellClass = cellClass;
    tipView.interRows = interRows;
    tipView.modelsArray = modelsArray;
    tipView.positionType = positionType;
    tipView.itemClickCallback = [itemClickCallback copy];    
    
    CGFloat W = SCREEN_WIDTH - 2 * margin;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = contentInset;
    layout.minimumLineSpacing = lineSpacing;
    layout.minimumInteritemSpacing = interitemSpacing;
    CGFloat WH = ((W - contentInset.left - contentInset.right) - (interitemSpacing * (interRows - 1))) / interRows;
    
    if (wHRatio <= 0) {wHRatio = 1.0;}
    CGFloat HW = WH * wHRatio;
    
    layout.itemSize = CGSizeMake(WH, HW);

    tipView.layout = layout;
    
    CGFloat topHeight  =  22 + 30;
    NSInteger totalRows = (modelsArray.count - 1) / interRows + 1;
    if (totalRows > maxLineRows) {
        totalRows = maxLineRows;
    }
    
    CGFloat collectionViewH = totalRows * (HW + lineSpacing) -
    lineSpacing +
    contentInset.bottom + contentInset.top;
    
    CGSize tipViewSize =  CGSizeMake(W, topHeight + collectionViewH);
    tipView.size = tipViewSize;
    tipView.layer.cornerRadius = 10.0;
    tipView.layer.masksToBounds = YES;
    [tipView initConfigure];
    
    if (positionType == ColletionTipViewPositonType_Center) {
        _baseClassStr = @"IDCMBaseCenterTipView";
        [IDCMBaseCenterTipView showTipViewToView:nil
                                            size:tipViewSize
                                     contentView:tipView
                                automaticDismiss:NO
                                  animationStyle:1
                           tipViewStatusCallback:nil];
        
    } else {
        _baseClassStr = @"IDCMBaseBottomTipView";
        [IDCMBaseBottomTipView showTipViewToView:nil
                                            size:tipViewSize
                                     contentView:tipView
                           tipViewStatusCallback:nil];
    }
    
    [tipView show];
}

+ (void)showWithTitle:(NSString *)title
            cellClass:(Class)cellClass
          modelsArray:(NSArray *)modelsArray
             itemSize:(CGSize)itemSize
            interRows:(NSInteger)interRows
          maxLineRows:(NSInteger)maxLineRows
               margin:(CGFloat)margin
         contentInset:(UIEdgeInsets)contentInset
          lineSpacing:(CGFloat)lineSpacing
     interitemSpacing:(CGFloat)interitemSpacing
         positionType:(ColletionTipViewPositonType)positionType
    itemClickCallback:(colltionTipViewItemClickBlock)itemClickCallback {
    
    if (!cellClass) { return; }
    
    IDCMColletionTipView *tipView = [[self alloc] init];
    
    
    tipView.title = title;
    tipView.cellClass = cellClass;
    tipView.interRows = interRows;
    tipView.modelsArray = modelsArray;
    tipView.positionType = positionType;
    tipView.itemClickCallback = [itemClickCallback copy];
    
    CGFloat W = SCREEN_WIDTH - 2 * margin;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = contentInset;
    layout.minimumLineSpacing = lineSpacing;
    layout.minimumInteritemSpacing = interitemSpacing;
    
    layout.itemSize = itemSize;
//    CGFloat WH = itemSize.width;

    tipView.layout = layout;
    
    CGFloat topHeight  =  22 + 30;
    NSInteger totalRows = (modelsArray.count - 1) / interRows + 1;
    if (totalRows > maxLineRows) {
        totalRows = maxLineRows;
    }

    CGFloat collectionViewH = totalRows * (itemSize.height + lineSpacing) -
    lineSpacing +
    contentInset.bottom + contentInset.top;
    
    CGSize tipViewSize =  CGSizeMake(W, topHeight + collectionViewH);
    tipView.size = tipViewSize;
    tipView.layer.cornerRadius = 10.0;
    tipView.layer.masksToBounds = YES;
    [tipView initConfigure];
    
    if (positionType == ColletionTipViewPositonType_Center) {
        _baseClassStr = @"IDCMBaseCenterTipView";
        [IDCMBaseCenterTipView showTipViewToView:nil
                                            size:tipViewSize
                                     contentView:tipView
                                automaticDismiss:NO
                                  animationStyle:1
                           tipViewStatusCallback:nil];
        
    } else {
        _baseClassStr = @"IDCMBaseBottomTipView";
        [IDCMBaseBottomTipView showTipViewToView:nil
                                            size:tipViewSize
                                     contentView:tipView
                           tipViewStatusCallback:nil];
    }
    
    [tipView show];
}

+ (void)showHUD {
    if ([_baseClassStr isEqualToString:@"IDCMBaseCenterTipView"]) {
        [IDCMBaseCenterTipView showHUD];
    } else {
        [IDCMBaseBottomTipView showHUD];
    }
}

+ (void)dismissHUD {
    if ([_baseClassStr isEqualToString:@"IDCMBaseCenterTipView"]) {
        [IDCMBaseCenterTipView dismissHUD];
    } else {
        [IDCMBaseBottomTipView dismissHUD];
    }
}

+ (void)reloadWithModels:(NSArray *)models {
    IDCMColletionTipView *tipView = [self getInstance];
    [tipView.collectionView reloadData];
    [tipView showCell];
}


- (void)show {
    
    self.alpha = .0;
    self.transform = CGAffineTransformMakeTranslation(0, 30);
    self.collectionView.hidden = YES;
//    [self.collectionView reloadData];
    [UIView animateWithDuration: .25
                          delay: 0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.transform = CGAffineTransformIdentity;
                         self.alpha = 1.0;
                     } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(.05 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       self.collectionView.hidden = NO;
                       [self showCell];
                   });
}

- (void)showCell {
    NSArray<UICollectionViewCell *> *cells =  self.collectionView.visibleCells;
    [cells enumerateObjectsUsingBlock:^(UICollectionViewCell *obj, NSUInteger idx, BOOL *stop) {
        obj.alpha = 0;
        obj.transform = CGAffineTransformMakeTranslation(0, 50);
        [self showAnimatinWithCell:obj
                             Index:[self.collectionView indexPathForCell:obj].item
                        totalCount:cells.count] ;
    }];
}

- (void)showAnimatinWithCell:(UICollectionViewCell *)cell
                       Index:(NSInteger)index
                  totalCount:(NSInteger)totalCount {
    
    CGFloat indexDelay = 0.0;
    NSInteger row = ((totalCount - 1) / self.interRows + 1);
    switch (row) {
        case 0:{
            indexDelay = 0.00;
        }break;
        case 1:{
            indexDelay = 0.08;
        }break;
        case 2:{
            indexDelay = 0.05;
        }break;
        case 3:{
            indexDelay = 0.03;
        }break;
        default: {
            indexDelay = 0.01;
        }break;
    }
    
    [UIView animateWithDuration:.35
                          delay:.1 + index * indexDelay
         usingSpringWithDamping:0.7
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         cell.alpha = 1.0;
                         cell.transform = CGAffineTransformIdentity;
                     } completion:nil];
}

+ (instancetype)getInstance {
    __block IDCMColletionTipView *tipView = nil;
    [[UIApplication sharedApplication].keyWindow.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([NSStringFromClass([obj class]) isEqualToString:_baseClassStr]) {
            [obj.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
                if ([obj isKindOfClass:[self class]] ||
                    [NSStringFromClass([obj class]) isEqualToString:@"IDCMColletionTipView"]) {
                    tipView = (IDCMColletionTipView *)obj;
                    *stop = YES;
                }
            }];
            *stop = YES;
        }
    }];
    return tipView;
}

+ (void)setAnimationFromViewForPropertyName:(NSString *)property
                                     toView:(UIView *)view
                                     offset:(CGPoint)offset;{
    if (!property.length || !view) {
        return;
    }
    IDCMColletionTipView *tipView = [self getInstance];
    if (![[self propertyListWithClass:tipView.cellClass] containsObject:property]) {
        return;
    }
    tipView.animationProperty = property;
    tipView.animationToView = view;
    tipView.animationOffSet = offset;
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

- (void)configSignal {
    self.closeBtn.rac_command = [self dismissCommandWithModel:nil];
}

- (RACCommand *)dismissCommandWithModel:(id)model {
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        void(^completion)(void) = ^{
            if (model) {
                self.itemClickCallback ? self.itemClickCallback(model) : nil;
            }
            self.itemClickCallback = nil;
            _baseClassStr =  nil;
        };
        if (self.positionType == ColletionTipViewPositonType_Center) {
            [IDCMBaseCenterTipView dismissWithCompletion:completion];
        } else {
            [IDCMBaseBottomTipView dismissWithCompletion:completion];
        }
        return [RACSignal empty];
    }];
}

- (void)configUI {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.closeBtn];
    [self addSubview:self.titleLabel];
    [self addSubview:self.collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    return self.modelsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.cellClass)
                                              forIndexPath:indexPath];
    if (cell) {
        if ([cell respondsToSelector:NSSelectorFromString(@"setModel:")]) {
            [cell performSelectorOnMainThread:NSSelectorFromString(@"setModel:")
                                   withObject:self.modelsArray[indexPath.row]
                                waitUntilDone:NO];
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if (self.animationProperty.length) {
        UIView *cellView = [cell valueForKeyPath:self.animationProperty];
        if ([cellView isKindOfClass:[UIView class]]) {
            UIView *kewWindow = [UIApplication sharedApplication].keyWindow;
            CGRect convertRect = [cellView convertRect:cellView.frame toView:kewWindow];
            UIView *animationView =  [[cellView.class alloc] initWithFrame:convertRect];
            if ([cellView.class isKindOfClass:[UIImageView class]]) {
                ((UIImageView *)animationView).image = ((UIImageView *)cellView).image;
            }
            animationView.backgroundColor = [UIColor redColor];
            [kewWindow addSubview:animationView];
            
            [[self dismissCommandWithModel:self.modelsArray[indexPath.row]] execute:nil];
            [UIView animateWithDuration:0.35
                                  delay:.25
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 
                                 CGRect fromFrame = [self.animationToView convertRect:self.animationToView.bounds toView:kewWindow];
                                 animationView.center =
                                 CGPointMake(CGRectGetMidX(fromFrame) + self.animationOffSet.x,
                                             CGRectGetMinY(fromFrame) + self.animationToView.height / 2 + self.animationOffSet.y);
                                 
                                 CGFloat scaleW = self.animationToView.width / animationView.width;
                                 CGFloat scaleH = self.animationToView.height / animationView.height;
                                 animationView.transform = CGAffineTransformMakeScale(scaleW, scaleH);
                             } completion:^(BOOL finished) {
                                 
                             }];
            
            [UIView animateWithDuration:.4
                                  delay:.15
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 animationView.alpha = 0.0;
                                 self.animationToView.alpha = 0.0;
                             } completion:^(BOOL finished) {
                                 [UIView animateWithDuration:.5 animations:^{
                                     self.animationToView.alpha = 1.0;
                                 }];
                                 [animationView removeFromSuperview];
                                 self.animationToView = nil;
                                 self.animationProperty = @"";
                             }];
        } else {
            [[self dismissCommandWithModel:self.modelsArray[indexPath.row]] execute:nil];
        }
    } else {
        [[self dismissCommandWithModel:self.modelsArray[indexPath.row]] execute:nil];
    }
}

-(UIButton *)closeBtn {
    return SW_LAZY(_closeBtn, ({
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = textFontPingFangRegularFont(12);
        [btn setImage:[UIImage imageNamed:@"3.0_groupclose"] forState:UIControlStateNormal];
        [btn setTitleColor:textColor333333 forState:UIControlStateNormal];
        btn.size = CGSizeMake(50, 50);
        btn.top = 0;
        btn.right = self.width;
        btn;
    }));
}
- (UILabel *)titleLabel {
    return SW_LAZY(_titleLabel, ({
       
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor333333;
        label.font = textFontPingFangRegularFont(16);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.title;
        label.height = 22;
        label.width = self.width - 2 * self.closeBtn.width;
        label.top = 15;
        label.centerX = self.width / 2;
        label;
    }));
}
- (UICollectionView *)collectionView {
    return SW_LAZY(_collectionView, ({
        
        CGRect rect = CGRectMake(0, self.titleLabel.bottom + 15, self.width, self.height - 22 - 30);
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:rect
                                                              collectionViewLayout:self.layout];
        [collectionView registerCellWithCellClass:self.cellClass];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView;
    }));
}


@end



