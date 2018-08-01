//
//  IDCMSelectPhotosView.h
//  IDCMWallet
//
//  Created by huangyi on 2018/4/18.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, SelectPhotosViewType) {
    SelectPhotosViewType_SingleLine,    // 单行
    SelectPhotosViewType_MultipleLine  // 多行
};

typedef NS_ENUM(NSUInteger, SelectPhotosType) {
    SelectPhotosType_Single,    // 单选
    SelectPhotosType_Multiple  //  可以多选
};



typedef void(^AddPhotoBlock)(NSArray *photos);
typedef void(^HeightChangeBlock)(CGFloat height);
typedef void(^DeletePhotoBlock)(NSInteger index);
@interface IDCMSelectPhotosView : UIView

+ (instancetype)selectPhotosViewWithFrame:(CGRect)frame
                                 viewType:(SelectPhotosViewType)viewType
                          selectPhotoType:(SelectPhotosType)selectPhotoType
                                  canMove:(BOOL)canMove
                                canDelete:(BOOL)canDelete
                           maxPhotosCount:(NSInteger)maxPhotosCount
                                interRows:(NSInteger)interRows
                              maxLineRows:(NSInteger)maxLineRows
                             contentInset:(UIEdgeInsets)contentInset
                              lineSpacing:(CGFloat)lineSpacing
                         interitemSpacing:(CGFloat)interitemSpacing;

@property (nonatomic,assign) BOOL isShow;
@property (nonatomic,assign) BOOL addCellPositionFirst;
- (void)reloadWithPhotoUrlArray:(NSArray<NSString *> *)photoUrlArray
                      canDelete:(BOOL)canDelete;

- (NSMutableArray<UIImage *> *)originPhotoImageArray;     ///< 原图
- (NSMutableArray<UIImage *> *)thumbnailPhotoImageArray; ///< 缩略图
- (NSMutableArray<UIImage *> *)photoUrlImageArray;

- (void)hiddenSelectPhotoCell;
- (void)scorllToCenterWithAnimated:(BOOL)animated;

@property (nonatomic, copy) AddPhotoBlock addPhotoCallback;
@property (nonatomic, copy) DeletePhotoBlock deletePhotoCallback;
@property (nonatomic, copy) HeightChangeBlock heightChangeCallback;
@end








