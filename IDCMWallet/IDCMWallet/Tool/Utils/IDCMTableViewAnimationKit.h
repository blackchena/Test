//
//  IDCMTableViewAnimationKit.h
//  IDCMWallet
//
//  Created by BinBear on 2017/12/16.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,IDCMTableViewAnimationType){
    XSTableViewAnimationTypeMove = 0,
    XSTableViewAnimationTypeMoveSpring = 0,
    XSTableViewAnimationTypeAlpha,
    XSTableViewAnimationTypeFall,
    XSTableViewAnimationTypeShake,
    XSTableViewAnimationTypeOverTurn,
    XSTableViewAnimationTypeToTop,
    XSTableViewAnimationTypeSpringList,
    XSTableViewAnimationTypeShrinkToTop,
    XSTableViewAnimationTypeLayDown,
    XSTableViewAnimationTypeRote,
};

@interface IDCMTableViewAnimationKit : NSObject<UICollisionBehaviorDelegate>


+ (void)showWithAnimationType:(IDCMTableViewAnimationType)animationType tableView:(UITableView *)tableView;

+ (void)moveAnimationWithTableView:(UITableView *)tableView;
+ (void)moveSpringAnimationWithTableView:(UITableView *)tableView;
+ (void)alphaAnimationWithTableView:(UITableView *)tableView;
+ (void)fallAnimationWithTableView:(UITableView *)tableView;
+ (void)shakeAnimationWithTableView:(UITableView *)tableView;
+ (void)overTurnAnimationWithTableView:(UITableView *)tableView;
+ (void)toTopAnimationWithTableView:(UITableView *)tableView;
+ (void)springListAnimationWithTableView:(UITableView *)tableView;
+ (void)shrinkToTopAnimationWithTableView:(UITableView *)tableView;
+ (void)layDownAnimationWithTableView:(UITableView *)tableView;
+ (void)roteAnimationWithTableView:(UITableView *)tableView;

@end
