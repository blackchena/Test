//
//  IDCMShareView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/7/2.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMShareView.h"

@interface IDCMShareView ()
/**
 *  BindHelper
 */
@property (strong, nonatomic) IDCMCollectionViewBindHelper *collectionViewBindHelper;
/**
 *  取消按钮
 */
@property (strong, nonatomic) UIButton *cancelButton;
/**
 *  collectionView
 */
@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation IDCMShareView

+ (instancetype)bondSureViewWithSureBtnTitle:(NSString *)btnTitle
                                confidSignal:(RACSignal *)dataSignal
                                sureBtnInput:(CommandInputBlock)sureBtnInput
                                shareCommand:(RACCommand *)shareCommand{
    
    IDCMShareView *view = [[self alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [view configSureButtonTitle:btnTitle andShareCommand:shareCommand andDataSignal:dataSignal];
    view.cancelButton.rac_command = RACCommand.emptyCommand(sureBtnInput);
    return view;
}

#pragma mark - Config
- (void)configSureButtonTitle:(NSString *)buttonTitle andShareCommand:(RACCommand *)command andDataSignal:(RACSignal *)dataSignal{
    
    self.collectionViewBindHelper = [IDCMCollectionViewBindHelper bindingHelperForCollectionView:self.collectionView
                                                                                    sourceSignal:dataSignal
                                                                                selectionCommand:command
                                                                                    templateCell:@"IDCMShareViewCell"];
    
    self.cancelButton.frame = CGRectMake(0, 210, SCREEN_WIDTH-30, 50);
    
    if ([buttonTitle isKindOfClass:[NSString class]]) {
        [self.cancelButton setTitle:buttonTitle forState:UIControlStateNormal];
    }
}

#pragma mark - getter
- (UIButton *)cancelButton{
    
    return SW_LAZY(_cancelButton, ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = 10;
        button.layer.masksToBounds = YES;
        [button setBackgroundColor:UIColorWhite];
        [button setTitleColor:textColor333333 forState:UIControlStateNormal];
        button.titleLabel.font = textFontPingFangRegularFont(14);
        [self addSubview:button];
        button;
    }));
}
- (UICollectionView *)collectionView{
    return SW_LAZY(_collectionView, ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(15, 10, 15, 10);
        CGFloat itemWidth = (SCREEN_WIDTH-70)/3.0f;
        layout.itemSize = CGSizeMake(itemWidth, 75);
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 200) collectionViewLayout:layout];
        view.pagingEnabled = YES;
        view.showsHorizontalScrollIndicator = NO;
        view.showsVerticalScrollIndicator = NO;
        view.backgroundColor = UIColorWhite;
        view.layer.cornerRadius = 10;
        view.layer.masksToBounds = YES;
        [self addSubview:view];
        view;
    }));
}
@end
