//
//  IDCMAcceptantSectionHeadView.h
//  IDCMWallet
//
//  Created by wangpu on 2018/4/10.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SectionHeaderCallBackBlock) (NSInteger section);

typedef NS_ENUM(NSUInteger,IDCMApplyAcceptantSectionHeaderType) {
    kIDCMSectionHeaderTypeDefault                                      = 1, // 默认
    kIDCMSectionHeaderTypeSubTitle                                  = 2, // 有副标题
};
@interface IDCMAcceptantSectionHeadView : UIView

@property (nonatomic,copy) SectionHeaderCallBackBlock  sectionCallBackBlock;
@property (nonatomic,strong) NSArray *  subTitles;
@property (nonatomic,copy)   NSString *  subTitle;
@property (nonatomic,assign) NSInteger  sectionIndex;
@property (nonatomic,assign) IDCMApplyAcceptantSectionHeaderType  type;
-(instancetype) initWithFrame:(CGRect)frame titles:(NSArray *)titles callBack:(SectionHeaderCallBackBlock) block;
@end
