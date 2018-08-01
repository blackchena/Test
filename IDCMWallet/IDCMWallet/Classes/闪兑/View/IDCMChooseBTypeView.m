//
//  IDCMChooseBTypeView.m
//  IDCMWallet
//
//  Created by wangpu on 2018/3/15.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMChooseBTypeView.h"
#import "IDCMCoinListModel.h"
#import "IDCMAlertWindow.h"
#import "IDCMAcceptantCoinModel.h"

@interface IDCMChooseBTypeView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView * collectView;
    NSIndexPath * currenSelect;
    UIButton * dimissBackView;
    NSInteger left;
    BOOL isExchange;
}
@property (nonatomic,strong) NSArray * iconsArr;
@property (nonatomic,strong) UIImageView *animationImageView;
@property (nonatomic,assign) IDCMAlertTypeType  type ;

@end


@implementation IDCMChooseBTypeView

-(instancetype) initWithFrame:(CGRect)frame bTypes:(NSArray *) types position:(NSInteger) position exchange:(BOOL) exchange{
    
    if (self =[super initWithFrame:frame]) {
        
        _iconsArr = [types copy];
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        left = position;
        isExchange = exchange;
        [self setUpUI];
    }
    return self;
}
-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    //适配屏幕底部边距
//    self.bottom = MIN(CGRectGetMaxY([self convertRect:self.frame toView:Screen_Window]), SCREEN_HEIGHT - 49 - kSafeAreaBottom-10);
    
}
-(instancetype) initWithFrame:(CGRect)frame bTypes:(NSArray *)types title:(NSString *)title withType:(IDCMAlertTypeType) type{
    
    IDCMChooseBTypeView *  typeView =  [self initWithFrame:frame bTypes:types title:title];
    typeView.type = type;
    return typeView;
}

-(instancetype) initWithFrame:(CGRect)frame bTypes:(NSArray *) types title:(NSString *) title{
    
    if (self =[super initWithFrame:frame]) {
        _iconsArr = [types copy];
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self setOTCUI:title];
    }
    return self;
}
-(void)setOTCUI:(NSString *)viewTitle{
    
    //title
    UILabel * title = [UILabel new];
    title.font =SetFont(@"PingFangSC-Regular", 16);
    title.textColor =[UIColor colorWithHexString:@"#333333"];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = viewTitle;
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(14);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@22);
        
    }];
    [self theSameView];
}


-(void)setUpUI{
    
    UILabel * title = [UILabel new];
    title.font =SetFont(@"PingFangSC-Regular", 16);
    title.textColor =[UIColor colorWithHexString:@"#333333"];
    title.textAlignment = NSTextAlignmentCenter;
    if (isExchange) {
        if (left ==401) {
            title.text = NSLocalizedString(@"3.0_SelectExchangIn", nil);
        }else{
            title.text = NSLocalizedString(@"3.0_SelectExchangOut", nil);
        }
    }else{
        
        if (left ==401) {
            title.text = NSLocalizedString(@"3.0_SelectExchangOut", nil);
        }else{
            title.text = NSLocalizedString(@"3.0_SelectExchangIn", nil);
        }
    }
    [self addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(14);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@22);
        
    }];
    
    [self theSameView];
}


-(void)theSameView{
    
    //关闭按钮
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setImage:[UIImage imageNamed:@"3.0_groupclose"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    //展示币icon列表
    UICollectionViewFlowLayout * layout=[[UICollectionViewFlowLayout alloc] init];
    //同一行相邻两个cell的最小间距
    layout.minimumInteritemSpacing = 10;
    //最小两行之间的间距
    layout.minimumLineSpacing = 20;
    layout.itemSize = CGSizeMake(70, 70);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    collectView=[[UICollectionView alloc]initWithFrame:CGRectMake(20, 52, self.frame.size.width-40, self.frame.size.height - 52) collectionViewLayout:layout];
    collectView.backgroundColor=[UIColor whiteColor];
    collectView.delegate=self;
    collectView.dataSource=self;
    collectView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    [collectView registerClass:[IDCMBTypeCollectionViewCell class]
    forCellWithReuseIdentifier:@"iconImageIdentifier"];
    
    [self addSubview:collectView];
    [collectView reloadData];
    
    [self show];
}


- (void)show {
    
    self.alpha = .0;
    self.transform = CGAffineTransformMakeTranslation(0, 30);
    collectView.hidden = YES;
    [UIView animateWithDuration: .2
                          delay: 0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         self.transform = CGAffineTransformIdentity;
                         self.alpha = 1.0;
                     } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(.05 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
         collectView.hidden = NO;
         [self showCell];
    });
}

- (void)showCell {
    
    NSArray<UICollectionViewCell *> *cells =  collectView.visibleCells;
    [cells enumerateObjectsUsingBlock:^(UICollectionViewCell *obj, NSUInteger idx, BOOL *stop) {
        
        obj.alpha = 0;
        obj.transform = CGAffineTransformMakeTranslation(0, 50);
        [self showAnimatinWithCell:obj Index:[collectView indexPathForCell:obj].item];
    }];
}

- (void)showAnimatinWithCell:(UICollectionViewCell *)cell
                       Index:(NSInteger)index  {
    
    CGFloat indexDelay = 0.0;
    NSInteger row = ((_iconsArr.count - 1) / 4 + 1);
    switch (row) {
        case 0:{
            indexDelay = 0.00;
        }break;
        case 1:{
            indexDelay = 0.05;
        }break;
        case 2:{
            indexDelay = 0.03;
        }break;
        case 3:{
            indexDelay = 0.02;
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

-(void)dismiss{
    if ( [[UIApplication sharedApplication].keyWindow isKindOfClass:[IDCMAlertWindow class]]) {
        [[UIApplication sharedApplication].keyWindow performSelector:@selector(dismiss)];
    }else{
        
        [IDCMBaseCenterTipView dismissWithCompletion:nil];
        
    }
    
}

#pragma mark - delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _iconsArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    IDCMBTypeCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"iconImageIdentifier" forIndexPath:indexPath];
    id iconModel =  _iconsArr[indexPath.row];
    cell.model = iconModel;
    if ([[iconModel valueForKey:@"isSelect"] boolValue]) {
        currenSelect = indexPath; //当前选择的
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == kIDCMCoinType ||self.type == kIDCMCurrencyType || self.type == kIDCMAcceptantCoinType ) {

        if (currenSelect) {
            if (indexPath.row != currenSelect.row ) { //不是当前选中的
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                             (int64_t)(.05 * NSEC_PER_SEC)),
                               dispatch_get_main_queue(), ^{
                                   
                                   [self createImageViewWithIndexPath:indexPath];
                               });
            }
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                             (int64_t)(.05 * NSEC_PER_SEC)),
                               dispatch_get_main_queue(), ^{
                                   
                                   [self createImageViewWithIndexPath:indexPath];
                               });
     
        }
        
        [self dismiss];
        
    }else{
       if (indexPath.row != currenSelect.row ) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                      (int64_t)(.05 * NSEC_PER_SEC)),
                      dispatch_get_main_queue(), ^{
                        [self createImageViewWithIndexPath:indexPath];
            });
        }
        [self dismiss];
    }
}

- (void)createImageViewWithIndexPath:(NSIndexPath *)indexPath {
    
    IDCMBTypeCollectionViewCell *cell = (IDCMBTypeCollectionViewCell *)[collectView cellForItemAtIndexPath:indexPath];
    UIView *kewWindow = [UIApplication sharedApplication].keyWindow;
    CGRect convertRect = [cell.bTypeImage convertRect:cell.bTypeImage.frame toView:kewWindow];
   //  CGRect convertRect = [cell convertRect:cell.frame toView:kewWindow];
    
    double delat = 0.0;
    NSString *currentStr ;
    NSString *selectedStr ;
    if (self.type == kIDCMCoinType) { //OTC选择币种
       currentStr = [_iconsArr[indexPath.row] dk_uppercaseLetter];
       selectedStr  = [_iconsArr[currenSelect.row] dk_uppercaseLetter];
    }else if (self.type == kIDCMCurrencyType){
        currentStr = [_iconsArr[indexPath.row] Name];
        selectedStr  = [_iconsArr[currenSelect.row] Name];
        
    }else if (self.type == kIDCMAcceptantCoinType){
        currentStr = [_iconsArr[indexPath.row] coinCodeUpperString];
        selectedStr  = [_iconsArr[currenSelect.row] coinCodeUpperString];
        
    }else{ //闪兑币种
         currentStr = [_iconsArr[indexPath.row] coinLabelUppercaseString];
         selectedStr  = [_iconsArr[currenSelect.row] coinLabelUppercaseString];
        
    }
    
    CGFloat currentStrLenght = [currentStr widthForFont:SetFont(@"PingFangSC-Regular", 14)];
    CGFloat selectedStrLenght = [selectedStr widthForFont:SetFont(@"PingFangSC-Regular", 14)];
    
    if (isExchange) {
        if (left == 401) {
            delat = (currentStrLenght - selectedStrLenght);
        }
    } else {
        if (left != 401) {
            delat = (currentStrLenght - selectedStrLenght);
        }
    }
    UIImageView *animationImageView = [[UIImageView alloc] initWithFrame:convertRect];
    animationImageView.image = cell.bTypeImage.image;
    [kewWindow addSubview:animationImageView];
    
    [UIView animateWithDuration:0.35
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                        CGRect fromFrame = [self.converImageView convertRect:self.converImageView.bounds toView:kewWindow];
                        animationImageView.center =
                        CGPointMake(CGRectGetMidX(fromFrame) - delat,
                                     CGRectGetMinY(fromFrame) + self.converImageView.height / 2);
                         
                        CGFloat scale = self.converImageView.width / animationImageView.width;
                        animationImageView.transform = CGAffineTransformMakeScale(scale, scale);
                        
                     } completion:^(BOOL finished) {
        
                     }];
    
    CGFloat del = 0.35;
    if (left != 401) {del = .32; }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(del * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       if ([self.delegate respondsToSelector:@selector(iconWindow:clickedButtonAtIndex: selectIndex:)]) {
                           [self.delegate iconWindow:self clickedButtonAtIndex:indexPath selectIndex:currenSelect];
                       }
                   });
    
    [UIView animateWithDuration:.4
                          delay:.15
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                          animationImageView.alpha = 0.0;
                          self.converImageView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:.5 animations:^{
                             self.converImageView.alpha = 1.0;
                         }];
                         [animationImageView removeFromSuperview];
                     }];   
}
@end

