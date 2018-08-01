//
//  IDCMSelectCountryController.h
//  IDCMExchange
//
//  Created by BinBear on 2017/12/6.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IDCMSelectCountryController,IDCMCountryListModel;

@protocol  IDCMSelectCountryControllerDelegate<NSObject>
@optional

/**
 pop回上一层控制器时传值

 @param vc IDCMSelectCountryController
 @param model IDCMCountryListModel
 */
- (void)selectCountryController:(IDCMSelectCountryController *)vc didAddContact:(IDCMCountryListModel *)model;
@end


@interface IDCMSelectCountryController : UIViewController

/**
 *  代理
 */
@property (nonatomic, weak) id <IDCMSelectCountryControllerDelegate> delegate;

@end
