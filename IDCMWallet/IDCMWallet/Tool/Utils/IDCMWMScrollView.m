//
//  IDCMWMScrollView.m
//  IDCMWallet
//
//  Created by BinBear on 2018/7/4.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMWMScrollView.h"

@implementation IDCMWMScrollView

#pragma mark - <UIGestureRecognizerDelegate>
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan &&
            self.contentOffset.x == 0) {
            return YES;
        }
    }
    return NO;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    //MARK: UITableViewCell 删除手势
    if ([NSStringFromClass(otherGestureRecognizer.view.class) isEqualToString:@"UITableViewWrapperView"] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}

@end
