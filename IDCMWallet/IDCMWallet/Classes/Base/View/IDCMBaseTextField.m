//
//  IDCMBaseTextField.m
//  IDCMWallet
//
//  Created by BinBear on 2018/3/8.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBaseTextField.h"



@implementation IDCMBaseTextField

-(void)deleteBackward
{
    [super deleteBackward];
    if ([self.deleteDelegate respondsToSelector:@selector(textFieldDeleteBackward:)]) {
        [self.deleteDelegate textFieldDeleteBackward:self];
    }
}
//禁止复制粘帖
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if(menuController){
        menuController.menuVisible = NO;
    }
    return NO;
}
// 处理越南语
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//
//    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//
//    if ([textField.text containsString:@","]&&[string isEqualToString:@","]) {
//
//        [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_SendNumorrect", nil)];
//
//        return NO;
//    }
//    if ([textField.text isEqualToString:@""]&&[string isEqualToString:@","]) {
//        [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_SendNumorrect", nil)];
//        return NO;
//    }
//    if ([textField.text containsString:@"."] &&[string isEqualToString:@","]) {
//
//        [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_SendNumorrect", nil)];
//        return NO;
//    }
//
//
//    if ([textField.text containsString:@"."]&&[string isEqualToString:@"."]) {
//        [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_SendNumorrect", nil)];
//        return NO;
//    }
//    if ([textField.text isEqualToString:@""]&&[string isEqualToString:@"."]) {
//        [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_SendNumorrect", nil)];
//        return NO;
//    }
//    if ([string isEqualToString:@","]) {
//
//        textField.text = [toBeString stringByReplacingOccurrencesOfString:@"," withString:@"."];
//        return NO;
//    }
//    return YES;
//}
@end
