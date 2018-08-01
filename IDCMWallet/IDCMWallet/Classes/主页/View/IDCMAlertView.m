//
//  IDCMAlertView.m
//  IDCMWallet
//
//  Created by BinBear on 2017/12/19.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMAlertView.h"
#import "IDCMScanQrCodeController.h"


CGFloat const BackupsView_W = 300;

CGFloat const AlertView_W = 320.0f;
CGFloat const MessageMin_H = 60.0f;   //messagelab的最小高度
CGFloat const MessageMAX_H = 130.0f;  //messagelab的最大高度
#define KeyWindow [UIApplication sharedApplication].keyWindow
@interface IDCMAlertView ()

@property (nonatomic,strong)UIWindow *alertWindow;
@property (nonatomic,strong)UIView *alertView;
@property (nonatomic,strong)UILabel *titleLab;
@property (nonatomic,strong)UILabel *addressLab;
@property (nonatomic,strong)UILabel *messageLab;
@property (nonatomic,strong)UILabel *reciveLab;
@property (nonatomic,strong)UIButton *cancelBtn;
@property (nonatomic,strong)UIButton *otherBtn;
@property (nonatomic,strong)UIImageView *dottedLine;
@property (strong, nonatomic) UIImageView *qrCodeView;
@property (strong, nonatomic) UIImageView *logoqrCodeView;
@property (nonatomic,strong)UILabel *copylab;
@property (strong, nonatomic) UIImageView *currencyLogoView;
@end

@implementation IDCMAlertView


#pragma mark - init
+ (instancetype)sharedCheckManager
{
    IDCMAlertView *Manager = [[IDCMAlertView alloc] init];
    return Manager;
}
- (void)showViewWithType:(IDCMShowType)type
{
    self.frame = MainScreenRect;
    self.backgroundColor=[UIColor colorWithWhite:.3 alpha:.7];
    
    switch (type) {
        case IDCMShowNotBackups:
        {
            [self creatNoBackupViewWithTitle:NSLocalizedString(@"2.0_NoBackups", nil) withMessage:NSLocalizedString(@"2.0_NoBackupsMessage", nil) withDoneButtonTitle:NSLocalizedString(@"2.0_GoBackups", nil)];
        }
            break;
        case IDCMShowNotSetPayPw:
        {
            [self creatAlertViewWithTitle:NSLocalizedString(@"2.0_NoSetPayPw", nil) withMessage:NSLocalizedString(@"2.0_NoSetPayPwMessage", nil) withDoneButtonTitle:NSLocalizedString(@"2.0_GoSetPayPw", nil) withCancelTitle:NSLocalizedString(@"2.1_NextTime", nil)];
        }
            break;
        case IDCMShowReciveCoin:
        {
            [self creatReciveView];
        }
            break;
        default:
            break;
    }
    
    [self showAlertView];
}

- (void)creatReciveView
{
    _alertView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor=[UIColor whiteColor];
        view.layer.cornerRadius = 8;
        view;
    });
    _titleLab = ({
        NSString *addressText = [NSString stringWithFormat:@"%@ %@",self.showInfo[@"CoinName"],NSLocalizedString(@"2.0_Address", nil)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, BackupsView_W+40, 30)];
        label.text = addressText;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = SetColor(255, 128, 91);
        label.numberOfLines = 0;
        label.font = SetFont(@"PingFang-SC-Medium", 20);
        [_alertView addSubview:label];
        label;
    });
    _addressLab = ({
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_titleLab.frame)+15, BackupsView_W-20, 75)];
        label.text = self.showInfo[@"Address"];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = SetColor(51, 51, 51);
        label.numberOfLines = 0;
        label.layer.cornerRadius = 4;
        label.layer.masksToBounds = YES;
        label.layer.borderColor = SetColor(238, 238, 238).CGColor;
        label.layer.borderWidth = 1;
        label.font = SetFont(@"PingFang-SC-Regular", 18);
        [_alertView addSubview:label];
        label;
    });
    _otherBtn = ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, CGRectGetMaxY(_addressLab.frame)+10, BackupsView_W+40, 40);
        [button setTitle:NSLocalizedString(@"2.0_CopyAddress", nil) forState:UIControlStateNormal];
        [button setTitleColor:SetColor(59, 155, 252) forState:UIControlStateNormal];
        button.titleLabel.font = SetFont(@"PingFang-SC-Regular", 16);
        @weakify(button);
        @weakify(self);
        [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strongify(button);
            @strongify(self);
            _copylab.hidden = NO;
            button.enabled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _copylab.hidden = YES;
                button.enabled = YES;
            });
            if (self.alertViewBlock) {
                self.alertViewBlock();
            }
        }];
        [_alertView addSubview:button];
        button;
    });
    _messageLab = ({
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_otherBtn.frame)+10, BackupsView_W+10, 60)];
        label.text = NSLocalizedString(@"2.0_AddressHint", nil);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = SetColor(187, 187, 187);
        label.numberOfLines = 0;
        label.font = SetFont(@"PingFang-SC-Regular", 12);
        [_alertView addSubview:label];
        label;
    });
    _reciveLab = ({
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_messageLab.frame), BackupsView_W+10, 40)];
        label.text = [SWLocaloziString(@"2.0_ReciveHint") stringByReplacingOccurrencesOfString:@"[IDCW]" withString:self.showInfo[@"CoinName"]];
        label.textColor = SetColor(255, 128, 91);
        label.numberOfLines = 0;
        label.font = SetFont(@"PingFang-SC-Regular", 12);
        [_alertView addSubview:label];
        label;
    });
    _dottedLine = ({
        
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_reciveLab.frame)+15, BackupsView_W+40, 2)];
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.image = [UIImage imageNamed:@"2.0_dottedline"];
        [_alertView addSubview:view];
        view;
    });
    _qrCodeView = ({
        
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(115, CGRectGetMaxY(_dottedLine.frame)+14, 130, 130)];
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.image = [LBXScanNative createQRWithString:self.showInfo[@"Address"] QRSize:CGSizeMake(110, 110)];
        [_alertView addSubview:view];
        view;
    });
    _logoqrCodeView = ({
        
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        view.center = _qrCodeView.center;
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.image = [UIImage imageNamed:@"2.0_logo"];
//        [view sd_setImageWithURL:[NSURL URLWithString:self.showInfo[@"Logo"]] placeholderImage:[UIImage imageNamed:@"2.0_logo"]];
        [_alertView addSubview:view];
        view;
    });
    _cancelBtn = ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(BackupsView_W, 15, 25, 25);
        [button setImage:[UIImage imageNamed:@"2.0_closehui"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"2.0_closehui"] forState:UIControlStateHighlighted];
        @weakify(self);
        [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strongify(self);
            [self dismissAlertView];
        }];
        [_alertView addSubview:button];
        button;
    });
    
    
    _alertView.frame = CGRectMake(0, 0, BackupsView_W+40, 500);
    _alertView.center =  CGPointMake(self.center.x, self.center.y);
    [self addSubview:_alertView];
    
    _copylab = ({
        
        CGFloat increaseWidth = [NSLocalizedString(@"2.0_CopySuccess", nil) widthForFont:SetFont(@"PingFang-SC-Regular", 16)]+30;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.5-increaseWidth*0.5, CGRectGetMaxY(_alertView.frame)+14, increaseWidth, 35)];
        label.text = NSLocalizedString(@"2.0_CopySuccess", nil);
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = SetAColor(238, 238, 238, 0.5);
        label.textColor = [UIColor whiteColor];
        label.font = SetFont(@"PingFang-SC-Regular", 16);
        label.layer.cornerRadius = 4;
        label.layer.masksToBounds = YES;
        label.hidden = YES;
        [self addSubview:label];
        label;
    });
}
- (void)creatNoBackupViewWithTitle:(NSString *)title withMessage:(NSString *)message  withDoneButtonTitle:(NSString *)buttonTitle
{
    _alertView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor=[UIColor whiteColor];
        view.layer.cornerRadius = 8;
        view;
    });
    _titleLab = ({
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, BackupsView_W, 50)];
        label.text = title;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = SetColor(51, 51, 51);
        label.numberOfLines = 0;
        label.font = SetFont(@"PingFang-SC-Medium", 14);
        [_alertView addSubview:label];
        label;
    });
    _messageLab = ({
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_titleLab.frame)+5, BackupsView_W-60, 30)];
        label.text = message;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = SetColor(252, 137, 104);
        label.numberOfLines = 0;
        label.font = SetFont(@"PingFang-SC-Regular", 12);
        [_alertView addSubview:label];
        label;
    });
    
    _otherBtn = ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(40, CGRectGetMaxY(_messageLab.frame)+20, BackupsView_W-80, 40);
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = SetFont(@"PingFang-SC-Regular", 16);
        button.layer.cornerRadius = 4;
        button.layer.masksToBounds=YES;
        button.backgroundColor = kThemeColor;
        @weakify(self);
        [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strongify(self);
            if (self.alertViewBlock) {
                self.alertViewBlock();
                [self dismissAlertView];
            }
        }];
        [_alertView addSubview:button];
        button;
    });
    _cancelBtn = ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(40, CGRectGetMaxY(_otherBtn.frame)+10, BackupsView_W-80, 40);
        [button setTitle:SWLocaloziString(@"2.0_NoGoBackups") forState:UIControlStateNormal];
        [button setTitleColor:kThemeColor forState:UIControlStateNormal];
        button.titleLabel.font = SetFont(@"PingFang-SC-Regular", 16);
        @weakify(self);
        [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strongify(self);
            if (self.dismissBlock) {
                self.dismissBlock();
                [self dismissAlertView];
            }
        }];
        [_alertView addSubview:button];
        button;
    });
    
    _alertView.frame = CGRectMake(0, 0, BackupsView_W, 225);
    _alertView.center =  CGPointMake(self.center.x, self.center.y);
    [self addSubview:_alertView];
}
- (void)creatAlertViewWithTitle:(NSString *)title withMessage:(NSString *)message  withDoneButtonTitle:(NSString *)buttonTitle withCancelTitle:(NSString *)cancelTitle
{
    _alertView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor=[UIColor whiteColor];
        view.layer.cornerRadius = 8;
        view;
    });
    _titleLab = ({
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, BackupsView_W, 30)];
        label.text = title;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = SetColor(51, 51, 51);
        label.font = SetFont(@"PingFang-SC-Regular", 14);
        [_alertView addSubview:label];
        label;
    });
    _messageLab = ({
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_titleLab.frame)+5, BackupsView_W-60, 90)];
        label.text = message;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = SetColor(102, 102, 102);
        label.numberOfLines = 0;
        label.font = SetFont(@"PingFang-SC-Regular", 14);
        [_alertView addSubview:label];
        label;
    });
    
    _otherBtn = ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(40, CGRectGetMaxY(_messageLab.frame)+15, BackupsView_W-80, 40);
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = SetFont(@"PingFang-SC-Regular", 15);
        button.layer.cornerRadius = 4;
        button.layer.masksToBounds=YES;
        button.backgroundColor = kThemeColor;
        @weakify(self);
        [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strongify(self);
            if (self.alertViewBlock) {
                self.alertViewBlock();
                [self dismissAlertView];
            }
        }];
        [_alertView addSubview:button];
        button;
    });
    _cancelBtn = ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(40, CGRectGetMaxY(_otherBtn.frame)+15, BackupsView_W-80, 40);
        [button setTitle:cancelTitle forState:UIControlStateNormal];
        [button setTitleColor:kThemeColor forState:UIControlStateNormal];
        button.titleLabel.font = SetFont(@"PingFang-SC-Regular", 15);
        @weakify(self);
        [button addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strongify(self);
            [self dismissAlertView];
        }];
        [_alertView addSubview:button];
        button;
    });
    
    _alertView.frame = CGRectMake(0, 0, BackupsView_W, 280);
    _alertView.center =  CGPointMake(self.center.x, self.center.y);
    [self addSubview:_alertView];
}

-(void)showAlertView{
    

    [KeyWindow addSubview:self];
    
    [self setShowAnimation];
    
}

-(void)dismissAlertView{
    [self removeFromSuperview];
}
#pragma mark - Private Method
-(void)setShowAnimation{
    
    CGPoint startPoint = CGPointMake(self.center.x, -_alertView.frame.size.height);
    _alertView.layer.position=startPoint;
    
    //damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
    //velocity:弹性复位的速度
    [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _alertView.layer.position=CGPointMake(self.center.x, self.center.y);
        
    } completion:^(BOOL finished) {
        
    }];
    
}

@end
