//
//  IDCMSelectPhotosView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/18.
//  Copyright © 2018年 BinBear. All rights reserved.
//


#import "IDCMImagePreviewViewController.h"
#import "IDCMSelectPhotosView.h"
#import "LewReorderableLayout.h"
#import "IDCMSelectPhotosTool.h"
#import <SDImageCache.h>



@interface IDCMSelectPhotosViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic,assign) BOOL urlPhotoCanDelete;
@property (nonatomic,assign) BOOL canDelete;
@property (nonatomic, copy) void(^deleteCallback)(IDCMSelectPhotosViewCell *cell);
@end
@implementation IDCMSelectPhotosViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.photoImageView];
        [self.contentView addSubview:self.deleteBtn];
    }
    return  self;
}
- (void)setImage:(UIImage *)image {
    _image = image;
    image ?
    ({
        self.photoImageView.image = image;
        self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.photoImageView.clipsToBounds = YES;
        self.deleteBtn.hidden = !self.canDelete;
    }):
    ({
        self.photoImageView.image = [UIImage imageNamed:@"3.2_detail_upload"];
        self.deleteBtn.hidden = YES;
    });
}
- (void)setImageUrl:(NSString *)imageUrl {
    _imageUrl = imageUrl;
    imageUrl ?
    ({
        self.deleteBtn.hidden = !self.urlPhotoCanDelete;
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                               placeholderImage:[UIImage imageWithColor:viewBackgroundColor]];
    }):
    ({
        self.photoImageView.image = [UIImage imageWithColor:viewBackgroundColor];
        self.deleteBtn.hidden = YES;
    });
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.photoImageView.frame = self.contentView.bounds;
    self.deleteBtn.size = CGSizeMake(15, 15);
    self.deleteBtn.top = 0;
    self.deleteBtn.right = self.contentView.width;
    
    self.contentView.layer.cornerRadius = 4.0;
    self.contentView.layer.masksToBounds = YES;
}
- (UIImageView *)photoImageView {
    return SW_LAZY(_photoImageView, ({
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView;
    }));
}
- (UIButton *)deleteBtn {
    return SW_LAZY(_deleteBtn, ({
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"deletePhoto"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor redColor];
        btn;
    }));
}
- (void)delete {
    !self.deleteCallback ?: self.deleteCallback(self);
}
@end


@interface IDCMSelectPhotosView ()<UICollectionViewDelegate,
                                   UICollectionViewDataSource,
                                   LewReorderableLayoutDelegate,
                                   LewReorderableLayoutDataSource,
                                   QMUIImagePreviewViewDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout *layout;
@property (nonatomic,strong) NSMutableArray<NSString *> *photoUrlArray;
@property (nonatomic,strong) NSMutableArray<NSMutableDictionary *> *photoDicArray;
@property(nonatomic, strong) IDCMImagePreviewViewController *imagePreviewViewController;
@property (nonatomic,assign) SelectPhotosType selectPhotoType;
@property (nonatomic,assign) SelectPhotosViewType viewType;
@property (nonatomic,assign) NSInteger maxPhotosCount;
@property (nonatomic,assign) BOOL urlPhotoCanDelete;
@property (nonatomic,assign) NSInteger interRows;
@property (nonatomic,assign) BOOL canDelete;
@property (nonatomic,assign) BOOL canMove;
@end

@implementation IDCMSelectPhotosView
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
                         interitemSpacing:(CGFloat)interitemSpacing {
    
    IDCMSelectPhotosView *view = [[self alloc] init];
    view.frame = frame;
    view.canMove = canMove;
    view.viewType = viewType;
    view.interRows = interRows;
    view.canDelete = canDelete;
    view.maxPhotosCount = maxPhotosCount;
    view.selectPhotoType = selectPhotoType;
    
    LewReorderableLayout *layout = [[LewReorderableLayout alloc] init];
    layout.delegate = view;
    layout.dataSource = view;
    layout.sectionInset = contentInset;
    layout.minimumLineSpacing = lineSpacing;
    layout.minimumInteritemSpacing = interitemSpacing;
    CGFloat W = ((view.width - contentInset.left - contentInset.right) -
                 (interitemSpacing * (interRows - 1))) / interRows;
    CGFloat H = view.height - contentInset.top - contentInset.bottom;
    layout.itemSize = CGSizeMake(W, H);
    if (viewType == SelectPhotosViewType_SingleLine) {
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    view.layout = layout;
    [view initConfigure];
    return view;
}

- (void)initConfigure {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.collectionView];
}

- (void)hiddenSelectPhotoCell {
    NSInteger totalCount = self.maxPhotosCount;
    self.maxPhotosCount = 0;
    self.isShow = YES;
    [self.collectionView reloadData];
    [[RACScheduler mainThreadScheduler] afterDelay:.5 schedule:^{
        self.maxPhotosCount = totalCount;
    }];
}

- (void)scorllToCenterWithAnimated:(BOOL)animated {
    if (!self.photoDicArray.count) {return;}
    
    CGFloat contentInsetWidth = self.collectionView.width - self.collectionView.contentInset.left - self.collectionView.contentInset.right;
    CGFloat contentWidth = self.collectionView.contentSize.width;
    if (contentWidth < contentInsetWidth) {
        CGFloat contentWidthDate = (contentInsetWidth - contentWidth) / 2;
        [self.collectionView setContentOffset:CGPointMake(-contentWidthDate, 0) animated:animated];
        self.collectionView.scrollEnabled = NO;
    }
}

- (void)reloadWithPhotoUrlArray:(NSArray<NSString *> *)photoUrlArray
                      canDelete:(BOOL)canDelete {
    
    if (photoUrlArray != nil &&
        [photoUrlArray isKindOfClass:[NSArray class]] &&
        photoUrlArray.count > 0) {
        
        [self.photoDicArray removeAllObjects];
        for (NSString *url in photoUrlArray) {
            if ([photoUrlArray indexOfObject:url] < self.maxPhotosCount) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:url forKey:@"url"];
                [dict setObject:@"" forKey:@"image"];
                [dict setObject:[UIImage new] forKey:@"thumbnail"];
                [self.photoDicArray addObject:dict];
            }
        }
        self.urlPhotoCanDelete = canDelete;
        [self.collectionView reloadData];
        [self resetFrame];
    } else {
        [self.collectionView reloadData];
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self resetFrameWithAnimation:NO];
}

- (void)resetFrame {
    [self resetFrameWithAnimation:YES];
}

- (void)resetFrameWithAnimation:(BOOL)animation {
    if (self.viewType == SelectPhotosViewType_SingleLine) {
        return;
    }
    NSInteger currentCount = self.photoDicArray.count + 1;
    if (self.photoDicArray.count > self.maxPhotosCount) {
        currentCount = self.maxPhotosCount;
    }
    [UIView animateWithDuration:animation ? 0.15 : 0
                     animations:^{
        self.height =  (((currentCount - 1) / self.interRows) + 1) *
                         (self.layout.itemSize.height + self.layout.minimumLineSpacing) -
                         self.layout.minimumLineSpacing +
                         self.layout.sectionInset.top +
                         self.layout.sectionInset.bottom;
        self.collectionView.height =  self.height;
    }];
    !self.heightChangeCallback ? : self.heightChangeCallback(self.height);
}

#pragma mark — UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    if (self.isShow) {
        return self.photoDicArray.count;
    } else if (self.addCellPositionFirst) {
        return self.photoDicArray.count + 1;
    } else {
        return self.photoDicArray.count < self.maxPhotosCount ?
               self.photoDicArray.count + 1 :
               self.photoDicArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IDCMSelectPhotosViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([IDCMSelectPhotosViewCell class])
                                              forIndexPath:indexPath];
    [self configureCell:cell forItemAtIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(IDCMSelectPhotosViewCell *)cell
   forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.canDelete = self.canDelete;
    cell.urlPhotoCanDelete = self.urlPhotoCanDelete;
    
    BOOL can = indexPath.row < self.photoDicArray.count;
    NSInteger index = indexPath.row;
    if (self.addCellPositionFirst && !self.isShow) {
        can = indexPath.row;
        index = indexPath.row - 1;
    }
    if (can) {
        cell.userInteractionEnabled = YES;
        NSString *url = self.photoDicArray[index][@"url"];
        id image = self.photoDicArray[index][@"image"];
        if ([image isKindOfClass:[UIImage class]]) {
             cell.image = image;
        } else {
            cell.imageUrl = url;
        }
    } else {
        cell.image = nil;
        if (self.addCellPositionFirst && self.photoDicArray.count == self.maxPhotosCount) {
            cell.userInteractionEnabled = NO;
            cell.photoImageView.image = [UIImage imageNamed:@"3.2_detail_unUpload"];
        } else {
            cell.userInteractionEnabled = YES;
        }
    }
    @weakify(self);
    cell.deleteCallback = ^(IDCMSelectPhotosViewCell *cell) {
        @strongify(self);
        [self.superview endEditing:YES];
        [self deletePhoto:[self.collectionView indexPathForCell:cell]];
    };
}

- (void)collectionView:(UICollectionView *)collectionView 
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    NSInteger currentPhotoCount = self.photoDicArray.count;
    BOOL can = indexPath.row == self.photoDicArray.count;
    if (self.addCellPositionFirst && !self.isShow) {
        can = !indexPath.row;
    }
    if (can) {
        [IDCMBottomListTipView showTipViewToView:nil
                                      titleArray:@[NSLocalizedString(@"3.0_Chat_TakePhoto", nil),
                                                   NSLocalizedString(@"3.0_Chat_Photo", nil),
                                                   NSLocalizedString(@"3.0_Chat_Cancle", nil)]
                               itemClickCallback:^(NSInteger index, id title) {
                                 @strongify(self);
                                
                                [[IDCMSelectPhotosTool sharedSelectPhotosTool] setAnimationImageViews:^NSArray<UIImageView *> *(NSInteger photoCount) {
                                    @strongify(self);
                                        if (photoCount <= 0) {
                                            return nil;
                                        } else if (photoCount == 1) {

                                            if (!self.addCellPositionFirst) {
                                                if (indexPath.row < self.maxPhotosCount) {
                                                    return @[((IDCMSelectPhotosViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath]).photoImageView];
                                                } else {
                                                    return nil;
                                                }
                                            } else {
                                                if (self.photoDicArray.count < self.maxPhotosCount + 1) {
                                                    NSIndexPath *signleIndexPath =
                                                    [NSIndexPath indexPathForRow:self.photoDicArray.count inSection:0];
                                                   IDCMSelectPhotosViewCell *cell = (IDCMSelectPhotosViewCell *)
                                                    [self.collectionView cellForItemAtIndexPath:signleIndexPath];
                                                    return @[cell.photoImageView];
                                                } else {
                                                    return nil;
                                                }
                                            }
                                        } else {

                                            NSInteger startIndex = indexPath.row;
                                            NSInteger canMax = self.maxPhotosCount;
                                            if (self.addCellPositionFirst) {
                                                startIndex = currentPhotoCount + 1;
                                                canMax = self.maxPhotosCount + 1;
                                            }
                                            NSMutableArray *imageViewArray = @[].mutableCopy;
                                            for (NSInteger i = startIndex; i < startIndex + photoCount; i++) {
                                                if (i < canMax) {
                                                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                                                    IDCMSelectPhotosViewCell *cell = (IDCMSelectPhotosViewCell *)
                                                    [self.collectionView cellForItemAtIndexPath:indexPath];
                                                    if (cell) {
                                                        [imageViewArray addObject:cell.photoImageView];
                                                    }
                                                }
                                            }
                                            return imageViewArray;
                                        }
                                   }
                                  animationCompletionCallback:^(NSInteger photoCount) {
                                      @strongify(self);
                                      if (self.addCellPositionFirst) {
                                          [[RACScheduler mainThreadScheduler] afterDelay:.1 schedule:^{
                                              [self.collectionView reloadData];
                                          }];
                                      }
                                  }];
                                   
                                   switch (index) {
                                       case 0:
                                       {
                                           if (self.addCellPositionFirst && self.photoDicArray.count == self.maxPhotosCount) {
                                               break;
                                           }
                                           [[IDCMSelectPhotosTool sharedSelectPhotosTool]
                                            selectSiglePhotoFromCamera:YES
                                            thumbnailWithSize:self.layout.itemSize
                                            completeCallback:^(UIImage *thumbnailPhoto, UIImage *originPhoto) {

                                                NSInteger currentIndex = self.photoDicArray.count;
                                                if (self.addCellPositionFirst) {
                                                    currentIndex = self.photoDicArray.count + 1;
                                                }
                                                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                                                [dict setObject:@"" forKey:@"url"];
                                                [dict setObject:originPhoto forKey:@"image"];
                                                UIImage *thumbnaiImg = [UIImage imageWithData:UIImageJPEGRepresentation(originPhoto, 0.2)];
                                                [dict setObject:thumbnaiImg forKey:@"thumbnail"];
                                                [self.photoDicArray addObject:dict];
                                                !self.addPhotoCallback ?: self.addPhotoCallback(@[originPhoto]);
                                                [self addPhotosWithIndexpaths:@[[NSIndexPath indexPathForRow:currentIndex inSection:0]]];
                                           }];
                                           
                                       }break;
                                       case 1:
                                       {
                                           if (self.selectPhotoType == SelectPhotosType_Single) {
                                               if (self.addCellPositionFirst && self.photoDicArray.count == self.maxPhotosCount) {
                                                   break;
                                               }
                                               [[IDCMSelectPhotosTool sharedSelectPhotosTool]
                                                selectSiglePhotoFromCamera:NO
                                                thumbnailWithSize:self.layout.itemSize
                                                completeCallback:^(UIImage *thumbnailPhoto, UIImage *originPhoto) {
                                                   
                                                    NSInteger currentIndex = self.photoDicArray.count;
                                                    if (self.addCellPositionFirst) {
                                                        currentIndex = self.photoDicArray.count + 1;
                                                    }
                                                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                                                    [dict setObject:@"" forKey:@"url"];
                                                    [dict setObject:originPhoto forKey:@"image"];
                                                    UIImage *thumbnaiImg = [UIImage imageWithData:UIImageJPEGRepresentation(originPhoto, 0.2)];
                                                    [dict setObject:thumbnaiImg forKey:@"thumbnail"];
                                                    [self.photoDicArray addObject:dict];
                                                    !self.addPhotoCallback ?: self.addPhotoCallback(@[originPhoto]);
                                                    [self addPhotosWithIndexpaths:@[[NSIndexPath indexPathForRow:currentIndex inSection:0]]];
                                               }];
                                               
                                           } else {
                                               
                                               [[IDCMSelectPhotosTool sharedSelectPhotosTool]
                                                selectMultiplePhotoWithMaxCount:self.maxPhotosCount - self.photoDicArray.count
                                                thumbnailWithSize:self.layout.itemSize
                                                completeCallback:^(NSArray<UIImage *> *thumbnailPhotos,
                                                                   NSArray<UIImage *> *originPhotos) {
                                                    
                                                    NSMutableArray <NSMutableDictionary *> *dictArray = @[].mutableCopy;
                                                    NSMutableArray <UIImage *> *imageArray = @[].mutableCopy;
                                                    for (UIImage *image in originPhotos) {
                                                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                                                        [dict setObject:@"" forKey:@"url"];
                                                        [dict setObject:image forKey:@"image"];
                                                        UIImage *img = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.2)];
                                                        [dict setObject:img forKey:@"thumbnail"];
                                                        [imageArray addObject:image];
                                                        [dictArray addObject:dict];
                                                    }
                                                   
                                                    NSInteger currentIndex = self.photoDicArray.count;
                                                    NSInteger canMMax = self.maxPhotosCount - 1;
                                                    if (self.addCellPositionFirst) {
                                                        currentIndex = self.photoDicArray.count + 1;
                                                        canMMax = self.maxPhotosCount + 1;
                                                    }
                                                    [self.photoDicArray addObjectsFromArray:dictArray];
                                                    !self.addPhotoCallback ?: self.addPhotoCallback(imageArray);
                                                    NSMutableArray *indexpaths = @[].mutableCopy;
                                                    for (NSInteger index = currentIndex; index < (currentIndex + imageArray.count); index++) {
                                                        if (index < canMMax) {
                                                            [indexpaths addObject:
                                                             [NSIndexPath indexPathForRow:index inSection:0]];
                                                        }
                                                    }
                                                    [self addPhotosWithIndexpaths:indexpaths];
                                                }];
                                           }
                                       }break;
                                       default:
                                        break;
                                   }
                               }];
    } else {
        IDCMSelectPhotosViewCell *cell = (IDCMSelectPhotosViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        NSInteger index = indexPath.row;
        if (self.addCellPositionFirst && !self.isShow) {
            index = indexPath.row - 1;
        }
        self.imagePreviewViewController.imagePreviewView.currentImageIndex = index;
        self.imagePreviewViewController.deleteBtn.hidden = self.isShow;
        @weakify(self);
        self.imagePreviewViewController.deleteCallback = ^(id input) {
            @strongify(self);
            [self deleteBigPhoto];
        };
        [self.imagePreviewViewController startPreviewFromRectInScreenCoordinate:cell.photoImageView.frame];
        
    }
}

- (void)deleteBigPhoto{
    
    NSString *str1 = NSLocalizedString(@"3.0_Hy_SureDeletePhoto", nil);
    NSString *str2 = NSLocalizedString(@"2.0_Done", nil);
    NSAttributedString *attr1 =
    [[NSAttributedString alloc] initWithString:str1
                                    attributes:@{
                                             NSFontAttributeName : textFontPingFangRegularFont(14),
                                             NSForegroundColorAttributeName : textColor999999
                                        }];
    NSAttributedString *attr2 =
    [[NSAttributedString alloc] initWithString:str2
                                    attributes:@{
                                                 NSFontAttributeName : textFontPingFangRegularFont(14),
                                                 NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#FF6666"]
                                                 }];
    
    [IDCMBottomListTipView showTipViewToView:self.imagePreviewViewController.view
                                  titleArray:@[attr1, attr2 , NSLocalizedString(@"3.0_Hy_cancel", nil)]
                              disabledIndexs:@[@0]
                           itemClickCallback:^(NSInteger index, id title) {
                               if (index == 1) {
                                   NSInteger currentIndex = self.imagePreviewViewController.currentImageIndex;
                                   [self.photoDicArray removeObjectAtIndex:currentIndex];
                                   if (!self.photoDicArray.count) {
                                       [self.collectionView reloadData];
                                       [self.imagePreviewViewController exitPreviewByFadeOut];
                                   } else {
                                       [self.collectionView reloadData];
                                       [self.imagePreviewViewController.imagePreviewView.collectionView reloadData];
                                       if (self.imagePreviewViewController.currentImageIndex ==     self.photoDicArray.count) {
                                           self.imagePreviewViewController.currentImageIndex -= 1;
                                           self.imagePreviewViewController.imagePreviewView.currentImageIndex -= 1;
                                       }
                                       [self.imagePreviewViewController reloadImageIndex];
                                   }
                                   !self.deletePhotoCallback ?: self.deletePhotoCallback(currentIndex);
                               }
                           }];
}

#pragma mark — LewReorderableLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return ((LewReorderableLayout *)collectionViewLayout).itemSize;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.canMove) {
        if (self.photoDicArray.count == 0) {
            return NO;
        } else {
            if (!self.addCellPositionFirst) {
               return indexPath != [NSIndexPath indexPathForRow:self.photoDicArray.count inSection:0];
            } else {
                return indexPath != [NSIndexPath indexPathForRow:0 inSection:0];
            }
        }
    } else {
        return NO;
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView
       itemAtIndexPath:(NSIndexPath *)fromIndexPath
    canMoveToIndexPath:(NSIndexPath *)toIndexPath {
    if (self.canMove) {
        if (!self.addCellPositionFirst) {
           return toIndexPath != [NSIndexPath indexPathForRow:self.photoDicArray.count inSection:0];
        } else {
            return toIndexPath != [NSIndexPath indexPathForRow:0 inSection:0];
        }
    }else {
        return NO;
    }
}

- (void)collectionView:(UICollectionView *)collectionView
       itemAtIndexPath:(NSIndexPath *)fromIndexPath
    didMoveToIndexPath:(NSIndexPath *)toIndexPath {
    
    NSInteger fromIndex = fromIndexPath.item;
    NSInteger toIndex = toIndexPath.item;
    if (self.addCellPositionFirst) {
        fromIndex = fromIndexPath.item - 1;
        toIndex = toIndexPath.item - 1;
    }
    NSMutableDictionary *dict = self.photoDicArray[fromIndex];
    [self.photoDicArray removeObject:dict];
    [self.photoDicArray insertObject:dict atIndex:toIndex];
}

- (void)deletePhoto:(NSIndexPath *)indexPath {
    [self.superview endEditing:YES];
    
    NSInteger index = indexPath.item;
    if (self.addCellPositionFirst) {
        index = indexPath.item - 1;
    }
    [self.photoDicArray removeObjectAtIndex:index];
    !self.deletePhotoCallback ?: self.deletePhotoCallback(indexPath.item);
    
    if (self.photoDicArray.count == self.maxPhotosCount - 1) {
        [self.collectionView reloadData];
    } else {
        [self.collectionView performBatchUpdates:^{
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:^(BOOL finished) {
            [self resetFrame];
        }];
    }
}

- (void)addPhotosWithIndexpaths:(NSArray<NSIndexPath * > *)indexpaths {
    
#pragma mark — 动画处理
    void(^chechAction)(void) = ^{
        [[RACScheduler mainThreadScheduler] afterDelay:.3 schedule:^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.photoDicArray.count - 1 inSection:0];
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
            if (cell) {
                [UIView animateWithDuration:.25 animations:^{
                    cell.alpha = 0.0;
                } completion:^(BOOL finished) {
                    cell.alpha = 1.0;
                    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                }];
            } else {
                [[RACScheduler mainThreadScheduler] afterDelay:.25 schedule:^{
                    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                }];
            }
        }];
    };
    
    if (!indexpaths.count) {
        chechAction();return;
    }
    
    [self resetFrame];
    void (^finishBlock)(BOOL finish) = ^(BOOL finish){
        
        if (self.addCellPositionFirst && self.photoDicArray.count == self.maxPhotosCount) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            IDCMSelectPhotosViewCell *cell =
            (IDCMSelectPhotosViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            cell.userInteractionEnabled = NO;
            cell.photoImageView.image = [UIImage imageNamed:@"3.2_detail_unUpload"];
        }
        
        if (self.photoDicArray.count < self.maxPhotosCount) {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.photoDicArray.count inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        } else {
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.photoDicArray.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
        
        [[RACScheduler mainThreadScheduler] afterDelay:.1 schedule:^{
            [indexpaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSArray *cells = self.collectionView.visibleCells;
                [UIView animateWithDuration:.3 animations:^{
                    [cells enumerateObjectsUsingBlock:^(IDCMSelectPhotosViewCell *cell, NSUInteger cellIdx, BOOL * _Nonnull stop) {
                        if ( [self.collectionView indexPathForCell:cell].row == obj.row) {
                            cell.photoImageView.alpha = 1.0;
                        }
                    }];
                }];
            }];
        }];
    };
    
    if (!self.addCellPositionFirst &&
        self.photoDicArray.count == self.maxPhotosCount) {
        chechAction();
    }
    
    if (indexpaths.count) {
        [[RACScheduler mainThreadScheduler] afterDelay:.1 schedule:^{
            [self.collectionView performBatchUpdates:^{
                [self.collectionView insertItemsAtIndexPaths:indexpaths];
                
                [[RACScheduler mainThreadScheduler] afterDelay:.05 schedule:^{
                    [indexpaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        IDCMSelectPhotosViewCell *cell = (IDCMSelectPhotosViewCell *)
                        [self.collectionView cellForItemAtIndexPath:obj];
                        cell.photoImageView.alpha = 0.0;
                    }];
                }];
            } completion:finishBlock];
        }];
    } else {
        finishBlock(YES);
    }
}
#pragma mark - <QMUIImagePreviewViewDelegate>
- (NSUInteger)numberOfImagesInImagePreviewView:(QMUIImagePreviewView *)imagePreviewView {
    return self.photoDicArray.count;
}

- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView renderZoomImageView:(QMUIZoomImageView *)zoomImageView atIndex:(NSUInteger)index {
    
    zoomImageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    NSDictionary *dict = self.photoDicArray[index];
    NSString *url = dict[@"url"];
    id image = dict[@"image"];
    
    if ([image isKindOfClass:[UIImage class]]) {
        zoomImageView.image = image;
    } else {
        NSInteger ind = index;
        if (self.addCellPositionFirst  && !self.isShow) {
            ind = index + 1;
        }
        IDCMSelectPhotosViewCell *cell =
        (IDCMSelectPhotosViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:ind inSection:0]];
        if (cell.photoImageView.image) {
            zoomImageView.image = cell.photoImageView.image;
        } else {
            [zoomImageView.imageView sd_setImageWithURL:[NSURL URLWithString:url]];
        }
    }
}

- (QMUIImagePreviewMediaType)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView assetTypeAtIndex:(NSUInteger)index {
    return QMUIImagePreviewMediaTypeImage;
}

- (void)imagePreviewView:(QMUIImagePreviewView *)imagePreviewView didScrollToIndex:(NSUInteger)index {
    self.imagePreviewViewController.currentImageIndex = index;
}

#pragma mark - <QMUIZoomImageViewDelegate>
- (void)singleTouchInZoomingImageView:(QMUIZoomImageView *)zoomImageView location:(CGPoint)location {
    self.imagePreviewViewController.navigationBar.hidden = YES;
    NSInteger currentIndex = self.imagePreviewViewController.imagePreviewView.currentImageIndex;
    if (self.addCellPositionFirst && !self.isShow) {
        currentIndex = currentIndex + 1;
    }
    IDCMSelectPhotosViewCell *cell =(IDCMSelectPhotosViewCell *)
    [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0]];
    [self.imagePreviewViewController startPreviewFromRectInScreenCoordinate:cell.photoImageView.frame];
}

- (UICollectionView *)collectionView {
    return SW_LAZY(_collectionView, ({
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds
                                                              collectionViewLayout:self.layout];
        collectionView.backgroundColor = [UIColor whiteColor];
        [collectionView registerCellWithCellClass:[IDCMSelectPhotosViewCell class]];
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView;
    }));
}

- (NSMutableArray<UIImage *> *)originPhotoImageArray {
    NSMutableArray *photoImageArray = @[].mutableCopy;
    for (NSMutableDictionary *dict in self.photoDicArray) {
        if ([dict[@"image"] isKindOfClass:[UIImage class]]) {
            [photoImageArray addObject:dict[@"image"]];
        }
    }
    return photoImageArray;
}

- (NSMutableArray<UIImage *> *)thumbnailPhotoImageArray {
    NSMutableArray *photoImageArray = @[].mutableCopy;
    for (NSMutableDictionary *dict in self.photoDicArray) {
        if ([dict[@"thumbnail"] isKindOfClass:[UIImage class]]) {
            [photoImageArray addObject:dict[@"thumbnail"]];
        }
    }
    return photoImageArray;
}

- (NSMutableArray<UIImage *> *)photoUrlImageArray {
    NSMutableArray *photoUrlImageArray = @[].mutableCopy;
    for (NSMutableDictionary *dict in self.photoDicArray) {
        if (dict[@"url"]) {
            NSInteger index = [self.photoDicArray indexOfObject:dict];
            IDCMSelectPhotosViewCell *cell = (IDCMSelectPhotosViewCell *)
            [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            [photoUrlImageArray addObject:cell.photoImageView.image];
        }
    }
    return photoUrlImageArray;
}

- (NSMutableArray<NSMutableDictionary *> *)photoDicArray {
    if (!_photoDicArray) {
        _photoDicArray= [NSMutableArray array];
    }
    return _photoDicArray;
}

- (IDCMImagePreviewViewController *)imagePreviewViewController {
    return SW_LAZY(_imagePreviewViewController, ({
        
        IDCMImagePreviewViewController *imagePreviewViewController = [[IDCMImagePreviewViewController alloc] init];
        imagePreviewViewController.imagePreviewView.delegate = self;
        imagePreviewViewController;
    }));
}


@end





