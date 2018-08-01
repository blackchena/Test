//
//  IDCMBaseTextField.h
//  IDCMWallet
//
//  Created by BinBear on 2018/3/8.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IDCMBaseTextField;

@protocol TextFieldDeleteDelegate <NSObject>

- (void)textFieldDeleteBackward:(IDCMBaseTextField *)textField;

@end


@interface IDCMBaseTextField : UITextField<UITextFieldDelegate>

@property (nonatomic, weak) id<TextFieldDeleteDelegate> deleteDelegate;

@end
