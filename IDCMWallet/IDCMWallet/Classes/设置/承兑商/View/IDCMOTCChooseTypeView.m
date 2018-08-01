//
//  IDCMOTCChooseTypeView.m
//  IDCMWallet
//
//  Created by wangpu on 2018/5/11.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMOTCChooseTypeView.h"
#import "IDCMLocalCurrencyModel.h"

@implementation IDCMOTCChooseTypeView

-(instancetype) initWithFrame:(CGRect)frame bTypes:(NSArray *)types title:(NSString *)title withModelType:(NSString *) modelClass{
    
    IDCMOTCChooseTypeView *  typeView =  [self initWithFrame:frame bTypes:types title:title];
    typeView.modelType = modelClass;
    typeView.delatTime = 0.35;
    [typeView  setUpView:title];
    return typeView;
}

#pragma mark - delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    self.selectIndex = indexPath;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                     (int64_t)(.05 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           [self createImageViewWithIndexPath:indexPath];
                       });
    [self performSelector:@selector(dismiss)];
}

-(NSString * )currentStr{
    
    if ([self.modelType isEqualToString:NSStringFromClass([IDCMLocalCurrencyModel class])]) {
      return  [self.iconsArr[self.selectIndex.row] localCurrencyCodeUpperString];
    }
    return nil;
}

-(NSString *)selectedStr{
    
    if ([self.modelType isEqualToString:NSStringFromClass([IDCMLocalCurrencyModel class])]) {
      return  [self.iconsArr[self.selectIndex.row] localCurrencyCodeUpperString];
    }
    return nil;
}

-(double)delatCoinName{

    CGFloat currentStrLenght = [self.currentStr widthForFont:SetFont(@"PingFangSC-Regular", 14)];
    CGFloat selectedStrLenght = [self.selectedStr widthForFont:SetFont(@"PingFangSC-Regular", 14)];
    return (currentStrLenght - selectedStrLenght);
}
@end




