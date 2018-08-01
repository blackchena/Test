//
//  IDCMFlashRecordDetailCell.m
//  IDCMWallet
//
//  Created by huangyi on 2018/3/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMFlashExchangeDetailCell.h"
#import "IDCMFlashExchangeDetailModel.h"


@interface IDCMFlashExchangeDetailCell ()
@property (nonatomic,strong) UILabel *cashOutLabel;
@property (nonatomic,strong) UILabel *cashOutTitleLabel;

@property (nonatomic,strong) UILabel *cashStateLabel;
@property (nonatomic,strong) UILabel *cashStateTitleLabel;

@property (nonatomic,strong) UILabel  *txidTitleLabel;
@property (nonatomic,strong) UILabel  *txidLabel;
@property (nonatomic,strong) UIButton *leftSeeBtn;
@property (nonatomic,strong) UIButton *rightCopyBtn;
@property (nonatomic,strong) UIView   *bottomView;

@property (nonatomic,weak) IDCMFlashExchangeDetailModel *cellViewModel;
@end


@implementation IDCMFlashExchangeDetailCell
@dynamic cellViewModel;
- (void)initConfig {
    [super initConfig];
    [self configUI];
    [self configSignal];
}

- (void)configureCell {
    [super configureCell];
    self.cellViewModel = (IDCMFlashExchangeDetailModel *)
    [self.viewModel getCellViewModelAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void)reloadCellData {
    if (self.indexPath.row) { // 兑入
        self.cashOutTitleLabel.text = NSLocalizedString(@"3.0_ExchangeEnter", nil);
        self.cashStateTitleLabel.text = NSLocalizedString(@"3.0_ExchangeEnterDetialState", nil);
        
        self.txidLabel.text = self.cellViewModel.ToTxId;
        self.cashOutLabel.text = self.cellViewModel.customerCashEnter;
        self.cashStateLabel.text = self.cellViewModel.customerCashEnterState;
    } else { // 对出
        self.cashOutTitleLabel.text = NSLocalizedString(@"3.0_ExchangeOut", nil);
        self.cashStateTitleLabel.text = NSLocalizedString(@"3.0_ExchangeOutDetialState", nil);
        
        self.txidLabel.text = self.cellViewModel.TxId;
        self.cashOutLabel.text = self.cellViewModel.customerCashOut;
        self.cashStateLabel.text = self.cellViewModel.customerCashOutState;
    }
}

- (void)configUI {
    self.contentView.backgroundColor = viewBackgroundColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.cashOutLabel = [[UILabel alloc] init];
    self.cashOutTitleLabel = [[UILabel alloc] init];
    CGRect rect1 = CGRectMake(0, 0, SCREEN_WIDTH, 42);
    [self.contentView addSubview:
     [self createOneLineViewWithFrame:rect1
                       leftLabelTuple:RACTuplePack(self.cashOutTitleLabel, NSLocalizedString(@"3.0_ExchangeOut", nil))
                      rightLabelTuple:RACTuplePack(self.cashOutLabel, nil)]];
    
    self.cashStateLabel = [[UILabel alloc] init];
    self.cashStateTitleLabel = [[UILabel alloc] init];
    CGRect rect2 = CGRectMake(0, 42, SCREEN_WIDTH, 42);
    [self.contentView addSubview:
     [self createOneLineViewWithFrame:rect2
                       leftLabelTuple:RACTuplePack( self.cashStateTitleLabel, NSLocalizedString(@"3.0_ExchangeOutState", nil))
                      rightLabelTuple:RACTuplePack(self.cashStateLabel, nil)]];
    
    [self.contentView addSubview:self.bottomView];
}

- (void)configSignal {
    
    RACSignal *validCopySignal = [[RACSignal combineLatest:@[RACObserve(self.txidLabel, text)]
                                   reduce:^(NSString *txidText) {
                                       return @(txidText.length > 0);
                                   }] distinctUntilChanged];
    RAC(self.leftSeeBtn,enabled) = validCopySignal;
    RAC(self.rightCopyBtn,enabled) = validCopySignal;
    
    @weakify(self); // 复制Txid
    [[[self.rightCopyBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
      deliverOnMainThread]
     subscribeNext:^(__kindof UIControl * _Nullable x) {
         @strongify(self);
         
         UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
         [pasteboard setString:self.txidLabel.text];
         [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_CopySuccess", nil)];
     }];
    
    // 区块查看
    [[[self.leftSeeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
    deliverOnMainThread] subscribeNext:^(__kindof UIControl * _Nullable x) {
                  @strongify(self);
        
                  NSString *urlStr = self.indexPath.row ? self.cellViewModel.ToBlockViewUrl : self.cellViewModel.BlockViewUrl;
                  if ([urlStr isNotBlank] && [self.txidLabel.text isNotBlank]) {
                      NSString *viewURL = [urlStr
                                           stringByReplacingOccurrencesOfString:@"{idcw_txid}" withString:self.txidLabel.text];
                      if (@available(iOS 10,*)) {
                          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:viewURL] options:@{} completionHandler:nil];
                      }else{
                          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:viewURL]];
                      }
                  }
     }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.cashOutTitleLabel sizeToFit];
    self.cashOutTitleLabel.left = 12;
    self.cashOutTitleLabel.centerY = 42 / 2;
    
    self.cashOutLabel.width = SCREEN_WIDTH - self.cashOutTitleLabel.right - 10 - 12 ;
    self.cashOutLabel.left = self.cashOutTitleLabel.right + 10;
    self.cashOutLabel.height = self.cashOutTitleLabel.height;
    self.cashOutLabel.centerY = self.cashOutTitleLabel.centerY;
    
    
    [self.cashStateTitleLabel sizeToFit];
    self.cashStateTitleLabel.left = 12;
    self.cashStateTitleLabel.centerY = 42 / 2;
    
    self.cashStateLabel.width = SCREEN_WIDTH - self.cashStateTitleLabel.right - 10 - 12 ;
    self.cashStateLabel.left = self.cashStateTitleLabel.right + 10;
    self.cashStateLabel.height = self.cashStateTitleLabel.height;
    self.cashStateLabel.centerY = self.cashStateTitleLabel.centerY;
}

#pragma mark — getters and setters
- (UIView *)bottomView {
    return SW_LAZY(_bottomView, ({
        
        UIView *view = [UIView new];
        view.frame = CGRectMake(0, 42 * 2, SCREEN_WIDTH, 94);
        view.backgroundColor = [UIColor whiteColor];
        
        [view addSubview:self.txidTitleLabel];
        [view addSubview:self.txidLabel];
        [view addSubview:self.leftSeeBtn];
        [view addSubview:self.rightCopyBtn];
        
        view;
    }));
}

- (UILabel *)txidTitleLabel {
    return SW_LAZY(_txidTitleLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.font = textFontPingFangRegularFont(12);
        label.textColor = textColor666666;
        label.text = @"TxID";
        [label sizeToFit];
        label.left = 12;
        label.top = 12;
        label;
    }));
}

- (UILabel *)txidLabel {
    return SW_LAZY(_txidLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor333333;
        label.font = textFontPingFangRegularFont(12);
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 2;
        label.width = SCREEN_WIDTH - 100;
        label.left = SCREEN_WIDTH - label.width - 12;
        label.height = 35;
        label.top = self.txidTitleLabel.top;
        label;
    }));
}

- (UIButton *)rightCopyBtn {
    return SW_LAZY(_rightCopyBtn, ({
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:NSLocalizedString(@"2.0_CopyID", nil) forState:UIControlStateNormal];
        [btn setTitleColor:kThemeColor forState:UIControlStateNormal];
        btn.titleLabel.font = textFontPingFangRegularFont(12);
        
        CGFloat width =
        [NSLocalizedString(@"2.0_CopyID", nil)
         widthForFont:textFontPingFangRegularFont(12)];
        
        btn.size = CGSizeMake(width + 24, 24);
        btn.top = self.txidLabel.bottom + 10;
        btn.right =self.txidLabel.right;
        btn.layer.borderColor = kThemeColor.CGColor;
        btn.layer.borderWidth = .5;
        btn.layer.masksToBounds = YES;
        btn;
    }));
}

- (UIButton *)leftSeeBtn {
    return SW_LAZY(_leftSeeBtn, ({
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:NSLocalizedString(@"2.1_ViewBlockchain", nil) forState:UIControlStateNormal];
        btn.titleLabel.font = textFontPingFangRegularFont(12);
        [btn setTitleColor:kThemeColor forState:UIControlStateNormal];
        
        CGFloat width =
        [NSLocalizedString(@"2.1_ViewBlockchain", nil)
         widthForFont:textFontPingFangRegularFont(12)];
        
        btn.size = CGSizeMake(width + 24, 24);
        btn.top = self.rightCopyBtn.top;
        btn.right = self.rightCopyBtn.left - 12;
        btn.layer.borderColor = kThemeColor.CGColor;
        btn.layer.borderWidth = .5;
        btn.layer.masksToBounds = YES;
        btn;
    }));
}

- (UIView *)createOneLineViewWithFrame:(CGRect)frame
                        leftLabelTuple:(RACTuple *)leftTuple
                       rightLabelTuple:(RACTuple *)rightTuple {
    
    RACTupleUnpack(UILabel *leftLabel,NSString *leftTitle) = leftTuple;
    RACTupleUnpack(UILabel *rightLabel,NSString *rightTitle) = rightTuple;
    
    UIView *view = [[UIView alloc] init];
    view.frame = frame;
    view.backgroundColor = [UIColor whiteColor];
    
    if (!leftLabel) { leftLabel = [UILabel new]; }
    leftLabel.textColor = textColor666666;
    leftLabel.font = textFontPingFangRegularFont(12);
    leftLabel.text = leftTitle;
    //    [leftLabel sizeToFit];
    //    leftLabel.left = 12;
    //    leftLabel.centerY = view.height / 2;
    [view addSubview:leftLabel];
    
    if (!rightLabel) { rightLabel = [UILabel new]; }
    rightLabel.textColor = textColor333333;
    rightLabel.font = textFontPingFangRegularFont(12);
    rightLabel.textAlignment = NSTextAlignmentRight;
    if (rightTitle.length) {
        rightLabel.text = rightTitle;
    }
    
    //    rightLabel.width = SCREEN_WIDTH - leftLabel.right - 10 - 12 ;
    //    rightLabel.left = leftLabel.right + 10;
    //    rightLabel.height = leftLabel.height;
    //    rightLabel.centerY = leftLabel.centerY;
    [view addSubview:rightLabel];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    line.left = 12;
    line.width = SCREEN_WIDTH - 12;
    line.height = .5;
    line.bottom = view.height;
    [view addSubview:line];
    return view;
}

@end






