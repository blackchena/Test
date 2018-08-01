//
//  IDCMChooseBTypeBaseView.m
//  IDCMWallet
//
//  Created by wangpu on 2018/5/11.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMChooseBTypeBaseView.h"
#import "IDCMAlertWindow.h"
#import "IDCMBTypeCollectionViewCell.h"
@interface IDCMChooseBTypeBaseView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView * collectView;
    NSIndexPath * currenSelect;
    UIButton * dimissBackView;
    NSInteger left;
    BOOL isExchange;
}

@property (nonatomic,strong) UIImageView *animationImageView;
@end

@implementation IDCMChooseBTypeBaseView

-(instancetype) initWithFrame:(CGRect)frame bTypes:(NSArray *) types title:(NSString *) title{
    
    if (self =[super initWithFrame:frame]) {
        _iconsArr = [types copy];
        self.layer.cornerRadius = 10;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.delatCoinName = 0.0;
        self.delatTime = 0.0;
    }
    return self;
}
//
-(void)setUpView:(NSString *)viewTitle{
    
    //关闭按钮
    if (viewTitle.length>0) {
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
    }
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
    id model = _iconsArr[indexPath.row];
    cell.model = model;
    if ([model valueForKey:@"isSelect"]) {
        currenSelect = indexPath;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)createImageViewWithIndexPath:(NSIndexPath *)indexPath {
    
    IDCMBTypeCollectionViewCell *cell = (IDCMBTypeCollectionViewCell *)[collectView cellForItemAtIndexPath:indexPath];
    UIView *kewWindow = [UIApplication sharedApplication].keyWindow;
    CGRect convertRect = [cell.bTypeImage convertRect:cell.bTypeImage.frame toView:kewWindow];
    UIImageView *animationImageView = [[UIImageView alloc] initWithFrame:convertRect];
    animationImageView.image = cell.bTypeImage.image;
    [kewWindow addSubview:animationImageView];
    
    [UIView animateWithDuration:0.35
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         CGRect fromFrame = [self.converImageView convertRect:self.converImageView.bounds toView:kewWindow];
                         animationImageView.center =
                         CGPointMake(CGRectGetMidX(fromFrame) - self.delatCoinName,
                                     CGRectGetMinY(fromFrame) + self.converImageView.height / 2);
                         
                         CGFloat scale = self.converImageView.width / animationImageView.width;
                         animationImageView.transform = CGAffineTransformMakeScale(scale, scale);
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(self.delatTime * NSEC_PER_SEC)),
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




