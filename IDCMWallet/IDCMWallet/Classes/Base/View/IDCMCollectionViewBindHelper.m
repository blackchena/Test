//
//  IDCMCollectionViewBindHelper.m
//  IDCMWallet
//
//  Created by BinBear on 2018/5/22.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMCollectionViewBindHelper.h"
#import "IDCMCollectionViewProtocol.h"

@interface IDCMCollectionViewBindHelper ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    UICollectionView *_collectionView;
    NSArray *_data;
    UICollectionViewCell *_templateCell;
    RACCommand *_selection;
}
@property (nonatomic, strong, readwrite) NSString *reuseIdentifier;

@property (nonatomic, readwrite, assign) struct delegateMethodsCaching {

unsigned int didSelectRowAtIndexPath:1;

} delegateRespondsTo;

@end

@implementation IDCMCollectionViewBindHelper
#pragma mark - init
- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
                          sourceSignal:(RACSignal *)source
                      selectionCommand:(RACCommand *)didSelectionCommand
                          withCellType:(NSDictionary *)CellTypeDic
{
    if (self = [super init]) {
        
        _collectionView = collectionView;
        _data = @[];
        _selection = didSelectionCommand;
        
        
        
        NSString *cellType = CellTypeDic[@"cellType"];
        NSString *cellIdentifier = CellTypeDic[@"cellName"];
        self.reuseIdentifier = cellIdentifier;
        if ([cellType isEqualToString:@"codeType"]) {
            
            Class cell =  NSClassFromString(cellIdentifier);
            [_collectionView registerClass:cell forCellWithReuseIdentifier:self.reuseIdentifier];
            
        }else{
            
            UINib *templateCellNib = [UINib nibWithNibName:cellIdentifier bundle:nil];
            [_collectionView registerNib:templateCellNib forCellWithReuseIdentifier:self.reuseIdentifier];
        }
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        self.delegate = nil;
        
        @weakify(self);
        [source subscribeNext:^(id x) {
            @strongify(self);
            self->_data = x;
            [self->_collectionView reloadData];
        }];
    }
    return self;
}
+ (instancetype)bindingHelperForCollectionView:(UICollectionView *)collectionView
                                  sourceSignal:(RACSignal *)source
                              selectionCommand:(RACCommand *)didSelectionCommand
                                  templateCell:(NSString *)templateCell {
    
    NSDictionary *cellDic = @{@"cellType":@"codeType",@"cellName":templateCell};
    return [[IDCMCollectionViewBindHelper alloc] initWithCollectionView:collectionView
                                                           sourceSignal:source
                                                       selectionCommand:didSelectionCommand
                                                           withCellType:cellDic];
}
+ (instancetype)bindingHelperForCollectionView:(UICollectionView *)collectionView
                                  sourceSignal:(RACSignal *)source
                              selectionCommand:(RACCommand *)didSelectionCommand
                           templateCellWithNib:(NSString *)templateCell {
    
    NSDictionary *cellDic = @{@"cellType":@"nibType",@"cellName":templateCell};
    return [[IDCMCollectionViewBindHelper alloc] initWithCollectionView:collectionView
                                                           sourceSignal:source
                                                       selectionCommand:didSelectionCommand
                                                           withCellType:cellDic];
    
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    id<IDCMCollectionViewProtocol> cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    
    NSAssert([cell respondsToSelector:@selector(bindViewModel:)], @"cell必须支持IDCMTableViewProtocol这个协议");
    [cell bindViewModel:_data[indexPath.row]];
    
    return (UICollectionViewCell *)cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    [_selection execute:_data[indexPath.row]];
    
    if (_delegateRespondsTo.didSelectRowAtIndexPath == 1) {
        [self.delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - Setters
- (void)setDelegate:(id<UICollectionViewDelegate>)delegate {
    if (self.delegate != delegate) {
        _delegate = delegate;
        
        struct delegateMethodsCaching newMethodCaching;
        
        newMethodCaching.didSelectRowAtIndexPath = [_delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)];

        self.delegateRespondsTo = newMethodCaching;
    }
}
@end
