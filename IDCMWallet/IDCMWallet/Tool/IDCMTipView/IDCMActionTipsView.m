//
//  IDCMActionTipsView.m
//  IDCMExchange
//
//  Created by BinBear on 2018/6/27.
//  Copyright © 2018年 IDC. All rights reserved.
//

#import "IDCMActionTipsView.h"

@interface IDCMActionTipViewBtnConfigure ()
@property (nonatomic,strong) id centerTipView_btnTitle;
@property (nonatomic,copy) actionBtnAction centerTipView_btnCallback;
@end
@implementation IDCMActionTipViewBtnConfigure
+ (instancetype)btnConfigure {
    return [[self alloc] init];
}
- (id)getBtnTitle {
    return _centerTipView_btnTitle;
}

- (actionBtnAction)getBtnCallback {
    return _centerTipView_btnCallback;
}
- (actionBtnConfigBlock)btnTitle {
    actionBtnConfigBlock block = ^(id value){
        if (!value ||
            [value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[NSAttributedString class]] ||
            [value isKindOfClass:[NSMutableAttributedString class]]) {
            self->_centerTipView_btnTitle = value;
        } else {
            DDLogDebug(@"赋值btnTitle的类型不正确");
        }return self;
    };
    return block;
}
- (actionBtnCallbackConfigBlock)btnCallback {
    actionBtnCallbackConfigBlock block = ^(actionBtnAction action){
        self->_centerTipView_btnCallback = [action copy];
        return self;
    };
    return block;
}
@end


@interface IDCMActionTipViewConfigure ()
@property (nonatomic,strong) id centerTipView_imageName;
@property (nonatomic,strong) id centerTipView_title;
@property (nonatomic,strong) id centerTipView_subTitle;
@property (nonatomic,copy) actionTapAction action;
@property (nonatomic,strong) NSMutableArray<IDCMActionTipViewBtnConfigure *> *centerTipView_btnsConfig;
+ (instancetype)defaultConfigure; // 初始化默认配置
@end
@implementation IDCMActionTipViewConfigure
+ (instancetype)defaultConfigure {
    IDCMActionTipViewConfigure *configure = [[self alloc] init];
    configure.centerTipView_title = nil;
    configure.centerTipView_subTitle = nil;
    configure.centerTipView_imageName = nil;
    IDCMActionTipViewBtnConfigure *btnConfigLeft = [[IDCMActionTipViewBtnConfigure alloc] init];
    btnConfigLeft.btnTitle(NSLocalizedString(@"2.0_Cancel", nil));
    
    IDCMActionTipViewBtnConfigure *btnConfigRight = [[IDCMActionTipViewBtnConfigure alloc] init];
    btnConfigRight.btnTitle(NSLocalizedString(@"2.1_PhraseDone", nil));
    
    configure.centerTipView_btnsConfig = @[btnConfigLeft , btnConfigRight].mutableCopy;
    return configure;
}
- (id)getTitle {
    return _centerTipView_title;
}
- (id)getSubTitle {
    return _centerTipView_subTitle;
}
- (id)getImageName{
    return _centerTipView_imageName;
}
- (configTapActionBlock)tapCallback{
    return ^IDCMActionTipViewConfigure *(actionTapAction action) {
        _action = [action copy];
        return self;
    };
}

- (NSMutableArray *)getBtnsConfig {
    return _centerTipView_btnsConfig;
}
- (actionConfigBlock)title {
    actionConfigBlock block = ^(id value){
        if (!value ||
            [value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[NSAttributedString class]] ||
            [value isKindOfClass:[NSMutableAttributedString class]]) {
            self->_centerTipView_title = value;
        } else {
            DDLogDebug(@"赋值title的类型不正确");
        }return self;
    };return block;
}
- (actionConfigBlock)subTitle {
    actionConfigBlock block = ^(id value){
        if (!value ||
            [value isKindOfClass:[NSString class]] ||
            [value isKindOfClass:[NSAttributedString class]] ||
            [value isKindOfClass:[NSMutableAttributedString class]]) {
            self->_centerTipView_subTitle = value;
            
        } else {
            DDLogDebug(@"赋值subTitle的类型不正确");
        }return self;
    };return block;
}
- (actionConfigBlock)imageName{
    actionConfigBlock block = ^(id value){
        if (!value || [value isKindOfClass:[NSString class]]) {
            self->_centerTipView_imageName = value;
        } else {
            DDLogDebug(@"赋值imageName的类型不正确");
        }return self;
    };return block;
}
- (actionConfigBlock)btnsConfig {
    actionConfigBlock block = ^(id value){
        if (!value ||
            [self checkArray:value allClass:[IDCMActionTipViewBtnConfigure class]]) {
            self->_centerTipView_btnsConfig = value;
        } else {
            DDLogDebug(@"赋值btnsConfig的类型不正确");
        }return self;
    };return block;
}

- (BOOL)checkArray:(NSArray *)array allClass:(Class)class {
    if (![array isKindOfClass:[NSArray class]] &&
        ![array isKindOfClass:[NSMutableArray class]]) {
        return NO;
    }
    __block BOOL isAllClass = YES;
    [array enumerateObjectsUsingBlock:^(id  obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:class]) {
            isAllClass = NO;
            *stop = YES;
        }
    }];
    return isAllClass;
}
@end




@interface IDCMActionTipsView ()

@property (nonatomic,strong) IDCMActionTipViewConfigure *viewConfigure;
@property (nonatomic,copy)   actionTipViewConfigBlock tipBlock;
@end

@implementation IDCMActionTipsView

+ (void)showWithConfigure:(actionTipViewConfigBlock)configure{
    
    IDCMActionTipsView *tipView = [[self alloc] init];
    IDCMActionTipViewConfigure *config = [IDCMActionTipViewConfigure defaultConfigure];
    tipView.tipBlock = configure;
    if (configure) { configure(config);}
    tipView.viewConfigure = config;
    [tipView configUI];
}

- (UIView *)createCustomViewWithImage:(NSString *)image
                                Title:(NSString *)title
                              message:(NSString *)message
                               alertC:(QMUIAlertController *)alert{
    UIView *customV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 227, 143)];
    
    UIImageView *imageV = [[UIImageView alloc] initWithImage:UIImageMake(image)];
    imageV.size = CGSizeMake(60, 60);
    imageV.top = 5;
    imageV.centerX = customV.centerX;
    [customV addSubview:imageV];
    
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.text = title;
    titleLbl.numberOfLines = 0;
    titleLbl.textColor = UIColor.whiteColor;
    titleLbl.font = textFontPingFangRegularFont(14);
    titleLbl.textAlignment = NSTextAlignmentCenter;
    
    [customV addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom).offset(25);
        make.left.mas_equalTo(6.0);
        make.right.mas_equalTo(-6.0);
        make.centerX.equalTo(customV.mas_centerX);
    }];
    
    if (message) {
        UILabel *subTieleLbl = [[UILabel alloc] init];
        subTieleLbl.text = message;
        subTieleLbl.textColor = UIColorMake(58, 157, 255);
        subTieleLbl.font = textFontPingFangRegularFont(14);
        subTieleLbl.userInteractionEnabled = YES;
        subTieleLbl.textAlignment = NSTextAlignmentCenter;
        [subTieleLbl addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            if (self.viewConfigure.action) {
                self.viewConfigure.action();
                [alert hideWithAnimated:YES];
            }
        }]];
        [customV addSubview:subTieleLbl];
        [subTieleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLbl.mas_bottom).offset(15);
            make.centerX.equalTo(customV.mas_centerX);
        }];
    }
    else{
        customV.height = 110;
    }

    
    return customV;
}

- (void)configUI{
    NSString *imageName = @"";
    NSString *title = @"";
    NSString *message = @"";
    NSString *cancelTitle = @"";
    NSString *confirmTitle = @"";
    if ([self.viewConfigure.centerTipView_imageName isKindOfClass:[NSString class]] && [self.viewConfigure.centerTipView_imageName isNotBlank]) {
        imageName = self.viewConfigure.centerTipView_imageName;
    }
    if ([self.viewConfigure.centerTipView_title isKindOfClass:[NSString class]] && [self.viewConfigure.centerTipView_title isNotBlank]) {
        title = self.viewConfigure.centerTipView_title;
    }
    if ([self.viewConfigure.centerTipView_subTitle isKindOfClass:[NSString class]] && [self.viewConfigure.centerTipView_subTitle isNotBlank]) {
        message = self.viewConfigure.centerTipView_subTitle;
    }
    
    if (self.viewConfigure.centerTipView_btnsConfig.count > 1) {
        IDCMActionTipViewBtnConfigure *cancelbtnConfig = self.viewConfigure.centerTipView_btnsConfig[0];
        cancelTitle = cancelbtnConfig.centerTipView_btnTitle;
        IDCMActionTipViewBtnConfigure *confirmbtnConfig = self.viewConfigure.centerTipView_btnsConfig[1];
        confirmTitle = confirmbtnConfig.centerTipView_btnTitle;
    }else{
        IDCMActionTipViewBtnConfigure *confirmbtnConfig = self.viewConfigure.centerTipView_btnsConfig[0];
        confirmTitle = confirmbtnConfig.centerTipView_btnTitle;
    }
    
    // 取消按钮
    QMUIAlertAction *cancelButton = [QMUIAlertAction actionWithTitle:cancelTitle style:QMUIAlertActionStyleCancel handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {

        if (_viewConfigure.centerTipView_btnsConfig.firstObject.centerTipView_btnCallback) {
            _viewConfigure.centerTipView_btnsConfig.firstObject.centerTipView_btnCallback();
        };
        _tipBlock = nil;
        _viewConfigure = nil;
    }];
    cancelButton.buttonAttributes = @{NSForegroundColorAttributeName:UIColorMake(0, 122, 255),NSFontAttributeName:textFontPingFangRegularFont(16)};
    cancelButton.button.backgroundColor = UIColorWhite;
    
    // 确定按钮
    QMUIAlertAction *confirmButton = [QMUIAlertAction actionWithTitle:confirmTitle style:QMUIAlertActionStyleDestructive handler:^(__kindof QMUIAlertController *aAlertController, QMUIAlertAction *action) {
        if (_viewConfigure.centerTipView_btnsConfig.lastObject.centerTipView_btnCallback) {
            _viewConfigure.centerTipView_btnsConfig.lastObject.centerTipView_btnCallback();
        };
        _tipBlock = nil;
        _viewConfigure = nil;
    }];
    confirmButton.buttonAttributes = @{NSForegroundColorAttributeName:UIColorMake(0, 122, 255),NSFontAttributeName:textFontPingFangRegularFont(16)};
    confirmButton.button.backgroundColor = UIColorWhite;

    QMUIAlertController *alertController;
    if ([imageName isNotBlank]) {
        alertController = [QMUIAlertController alertControllerWithTitle:nil message:nil preferredStyle:QMUIAlertControllerStyleAlert];
        UIView *customV = [self createCustomViewWithImage:imageName Title:title message:message alertC:alertController];
        [alertController addCustomView:customV];
    }
    else{
        alertController = [QMUIAlertController alertControllerWithTitle:title message:message preferredStyle:QMUIAlertControllerStyleAlert];
    }
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByWordWrapping;
    textStyle.alignment = NSTextAlignmentCenter;//水平居中

    alertController.alertTitleAttributes = @{NSForegroundColorAttributeName:textColor333333,NSFontAttributeName:textFontPingFangRegularFont(16), NSParagraphStyleAttributeName:textStyle};
    alertController.alertMessageAttributes = @{NSForegroundColorAttributeName:textColor333333,NSFontAttributeName:textFontPingFangRegularFont(13), NSParagraphStyleAttributeName:textStyle};
    alertController.alertHeaderBackgroundColor = UIColorWhite;
    alertController.alertButtonBackgroundColor = UIColorWhite;
    alertController.alertTitleMessageSpacing = 15;
    alertController.sheetSeparatorColor = kThemeColor;
    
    
    
    if ([cancelTitle isNotBlank] && [confirmTitle isNotBlank]) {
        // 两个按钮都有
        [alertController addAction:cancelButton];
        [alertController addAction:confirmButton];
        
    }else{
        
        [alertController addAction:confirmButton];
    }
    
    [alertController showWithAnimated:YES];
    
}

@end
