//
//  IDCMBlockTextField.h
//  IDCMWallet
//
//  Created by huangyi on 2018/5/19.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^TextFieldVoiBlock)(UITextField *textField);
typedef BOOL(^TextFieldBoolBlock)(UITextField *textField);
typedef BOOL(^TextFieldShouldChangeBlock)(UITextField *textField,
                                          NSRange range,
                                          NSString *replacementString);

@interface IDCMBlockTextFieldConfigure : NSObject
- (instancetype)textFieldShouldChange:(TextFieldShouldChangeBlock)block;
- (instancetype)textFieldShouldBeginEditing:(TextFieldBoolBlock)block;
- (instancetype)textFieldShouldEndEditing:(TextFieldBoolBlock)block;
- (instancetype)textFieldShouldReturn:(TextFieldBoolBlock)block;
- (instancetype)textFieldDidBeginEditing:(TextFieldVoiBlock)block;
- (instancetype)textFieldDidEndEditing:(TextFieldVoiBlock)block;
- (instancetype)textFieldShouldClear:(TextFieldBoolBlock)block;
@end



typedef void(^textFieldConfigureBlock)(IDCMBlockTextFieldConfigure *configure);
@interface IDCMBlockTextField : UITextField


/**
 创建方式
 
 @param frame frame
 @param configure configure
 @return IDCMBlockTextField
 */
+ (instancetype)BlockTextFieldWithFrame:(CGRect)frame
                              configure:(IDCMBlockTextFieldConfigure *)configure;


/**
 block 创建方式

 @param frame frame
 @param configureBlock configureBlock
 @return IDCMBlockTextField
 */
+ (instancetype)BlockTextFieldWithFrame:(CGRect)frame
                         configureBlock:(textFieldConfigureBlock)configureBlock;


@end























