//
//  IDCMBlockTextField.m
//  IDCMWallet
//
//  Created by huangyi on 2018/5/19.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMBlockTextField.h"

@interface IDCMBlockTextFieldConfigure()
@property (nonatomic,copy) TextFieldShouldChangeBlock TextFieldShouldChangeBlock;
@property (nonatomic,copy) TextFieldBoolBlock textFieldShouldBeginEditingBlock;
@property (nonatomic,copy) TextFieldBoolBlock textFieldShouldEndEditingBlock;
@property (nonatomic,copy) TextFieldBoolBlock textFieldShouldReturnBlock;
@property (nonatomic,copy) TextFieldVoiBlock textFieldDidBeginEditingBlock;
@property (nonatomic,copy) TextFieldVoiBlock textFieldDidEndEditingBlock;
@property (nonatomic,copy) TextFieldBoolBlock textFieldShouldClearBlock;
@end

@implementation IDCMBlockTextFieldConfigure
- (instancetype)textFieldShouldChange:(TextFieldShouldChangeBlock)block {
    self.TextFieldShouldChangeBlock = block;
    return self;
}
- (instancetype)textFieldShouldBeginEditing:(TextFieldBoolBlock)block {
    self.textFieldShouldBeginEditingBlock = block;
    return self;
}
- (instancetype)textFieldShouldEndEditing:(TextFieldBoolBlock)block {
    self.textFieldShouldEndEditingBlock = block;
    return self;
}
- (instancetype)textFieldShouldReturn:(TextFieldBoolBlock)block {
    self.textFieldShouldReturnBlock = block;
    return self;
}
- (instancetype)textFieldDidBeginEditing:(TextFieldVoiBlock)block {
    self.textFieldDidBeginEditingBlock = block;
    return self;
}
- (instancetype)textFieldDidEndEditing:(TextFieldVoiBlock)block {
    self.textFieldDidEndEditingBlock = block;
    return self;
}
- (instancetype)textFieldShouldClear:(TextFieldBoolBlock)block {
    self.textFieldShouldClearBlock = block;
    return self;
}
@end



@interface IDCMBlockTextField () <UITextFieldDelegate>
@property (nonatomic,strong) IDCMBlockTextFieldConfigure *configure;
@end


@implementation IDCMBlockTextField

+ (instancetype)BlockTextFieldWithFrame:(CGRect)frame
                        configureBlock:(textFieldConfigureBlock)configureBlock {
    IDCMBlockTextField *textField = [[self alloc] init];
    !configureBlock ?: configureBlock(textField.configure);
    textField.delegate = textField;
    textField.frame = frame;
    return textField;
}

+ (instancetype)BlockTextFieldWithFrame:(CGRect)frame
                             configure:(IDCMBlockTextFieldConfigure *)configure {
    IDCMBlockTextField *textField = [[self alloc] init];
    textField.configure = configure;
    textField.delegate = textField;
    textField.frame = frame;
    return textField;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return
    self.configure.textFieldShouldBeginEditingBlock ?
    self.configure.textFieldShouldBeginEditingBlock(textField) : YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.configure.textFieldDidBeginEditingBlock ?
    self.configure.textFieldDidBeginEditingBlock(textField) : nil;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return
    self.configure.textFieldShouldEndEditingBlock ?
    self.configure.textFieldShouldEndEditingBlock(textField) : YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.configure.textFieldDidEndEditingBlock ?
    self.configure.textFieldDidEndEditingBlock(textField) : nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
                                                       replacementString:(NSString *)string {
    return
    self.configure.TextFieldShouldChangeBlock ?
    self.configure.TextFieldShouldChangeBlock(textField, range, string) : YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return
    self.configure.textFieldShouldClearBlock ?
    self.configure.textFieldShouldClearBlock(textField) : YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return
    self.configure.textFieldShouldReturnBlock ?
    self.configure.textFieldShouldReturnBlock(textField) : YES;
}

- (IDCMBlockTextFieldConfigure *)configure {
    return SW_LAZY(_configure, ({
        [[IDCMBlockTextFieldConfigure alloc] init];
    }));
}

@end












