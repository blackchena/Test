//
//  UITableView+Extension.m
//  IDCMWallet
//
//  Created by huangyi on 2018/3/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "UITableView+Extension.h"

@implementation UITableView (Extension)

- (void)registerCellWithCellClasses:(NSArray<Class> *)cellClasses {
    
    if (!cellClasses.count) { return; }
    [cellClasses enumerateObjectsUsingBlock:^(Class obj,
                                              NSUInteger idx,
                                              BOOL *stop) {
        [self registerCellWithCellClass:obj];
    }];
}

- (void)registerCellWithCellClass:(Class)cellClass {
    
    if (!cellClass) { return; }
    
    NSString *cellClassString = NSStringFromClass(cellClass);
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:cellClassString ofType:@"nib"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:nibPath]) {
        [self registerNib:[UINib nibWithNibName:cellClassString
                                         bundle:nil] forCellReuseIdentifier:cellClassString];
    }else{
        [self registerClass:cellClass forCellReuseIdentifier:cellClassString];
    }
}

- (void)registerHeaderFooterWithViewClasses:(NSArray<Class> *)viewClasses {
    
    if (!viewClasses.count) { return; }
    [viewClasses enumerateObjectsUsingBlock:^(Class obj,
                                              NSUInteger idx,
                                              BOOL *stop) {
        [self registerHeaderFooterWithViewClass:obj];
    }];
}

- (void)registerHeaderFooterWithViewClass:(Class)viewClass {
    
    if (!viewClass) { return; }
    
    NSString *viewClassString = NSStringFromClass(viewClass);
    NSString *nibPath =  [[NSBundle mainBundle] pathForResource:viewClassString ofType:@"nib"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:nibPath]) {
        [self registerNib:[UINib nibWithNibName:viewClassString
                                         bundle:nil] forHeaderFooterViewReuseIdentifier:viewClassString];
    }else{
        [self registerClass:viewClass forHeaderFooterViewReuseIdentifier:viewClassString];
    }
}


@end
