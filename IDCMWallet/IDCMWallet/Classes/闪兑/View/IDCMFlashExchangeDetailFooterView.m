//
//  IDCMFlashExchangeDetailFooterView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/3/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//



#import "IDCMFlashExchangeDetailFooterView.h"
#import "IDCMFlashExchangeDetailViewModel.h"
#import "IDCMFlashExchangeDetailModel.h"



@interface IDCMFlashExchangeDetailFooterView () <QMUITextViewDelegate>
@property (nonatomic,strong) UILabel *minerFeeLabel;
@property (nonatomic,strong) UILabel *exchangeRateLabel;
@property (nonatomic,strong) UILabel *exchangeTimeLabel;
@property (nonatomic,strong) UIView  *bottomView;
@property (nonatomic,strong) UILabel *bottomViewTitleLabel;
@property (nonatomic,strong) QMUITextView *textView;
@property(nonatomic, assign) CGFloat textViewMinimumHeight;
@property(nonatomic, assign) CGFloat textViewMaximumHeight;
@end


@implementation IDCMFlashExchangeDetailFooterView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textViewMinimumHeight = 17;
        self.textViewMaximumHeight = 17 * 5;
        [self initConfigure];
    }
    return self;
}

- (void)initConfigure {
    [self configUI];
    [self configSignal];
}

- (void)setViewModel:(IDCMFlashExchangeDetailViewModel *)viewModel {
    _viewModel = viewModel;
    if (!viewModel) {
        return;
    }
    IDCMFlashExchangeDetailModel *model = (IDCMFlashExchangeDetailModel *)
    [viewModel getCellViewModelAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (!model) {
        return;
    }
    
    self.textView.userInteractionEnabled = YES;
    self.textView.text = model.Comment;
    self.minerFeeLabel.text = model.customerExchangeOutFee;
    self.exchangeTimeLabel.text = model.customerExchangeTime;
    self.exchangeRateLabel.text = model.customerExchangeRate;
}

- (void)configUI {
    self.backgroundColor = [UIColor whiteColor];
    
    self.minerFeeLabel = [[UILabel alloc] init];
    CGRect rect1 = CGRectMake(0, 0, SCREEN_WIDTH, 42);
    [self addSubview:
     [self createOneLineViewWithFrame:rect1
                       leftLabelTuple:RACTuplePack(nil, NSLocalizedString(@"3.0_ExchangeOutTotalMinerFee", nil))
                      rightLabelTuple:RACTuplePack(self.minerFeeLabel, @"")]];
    
    self.exchangeRateLabel = [[UILabel alloc] init];
    CGRect rect2 = CGRectMake(0, 42, SCREEN_WIDTH, 42);
    [self addSubview:
     [self createOneLineViewWithFrame:rect2
                       leftLabelTuple:RACTuplePack(nil, NSLocalizedString(@"3.0_ExchangeRate", nil))
                      rightLabelTuple:RACTuplePack(self.exchangeRateLabel, @"")]];
    
    self.exchangeTimeLabel = [[UILabel alloc] init];
    CGRect rect3 = CGRectMake(0, 42 * 2, SCREEN_WIDTH, 42);
    [self addSubview:
     [self createOneLineViewWithFrame:rect3
                       leftLabelTuple:RACTuplePack(nil, NSLocalizedString(@"3.0_ExchangeTimer", nil))
                      rightLabelTuple:RACTuplePack(self.exchangeTimeLabel, @"")]];
    
    [self addSubview:self.bottomView];
}

- (void)configSignal {
    [self.viewModel.editCommand.errors subscribeNext:^(NSError * _Nullable x) {
        [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"2.0_SendFail")];
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [[IQKeyboardManager sharedManager] reloadLayoutIfNeeded];
}

- (BOOL)textViewShouldReturn:(QMUITextView *)textView {
    [self.textView endEditing:YES];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    IDCMFlashExchangeDetailModel *model = (IDCMFlashExchangeDetailModel *)
    [self.viewModel getCellViewModelAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (!model) {
        return;
    }
    if (![textView.text isEqualToString:model.Comment] && !self.viewModel.isGestuerEdit) {
        model.Comment = textView.text;
        [self.viewModel.editCommand execute:nil];
    }
}

- (void)textView:(QMUITextView *)textView didPreventTextChangeInRange:(NSRange)range replacementText:(NSString *)replacementText {
     [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"2.1_Maximum")];
}

- (void)textView:(QMUITextView *)textView newHeightAfterTextChanged:(CGFloat)height {
    height = fmin(self.textViewMaximumHeight, fmax(height, self.textViewMinimumHeight));
    BOOL needsChangeHeight = CGRectGetHeight(textView.frame) != height;
    !needsChangeHeight ? :
    ({
        [self layoutSubviews];
        [[IQKeyboardManager sharedManager] reloadLayoutIfNeeded];
    });
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat left = self.bottomViewTitleLabel.right + 58;
    CGFloat width = SCREEN_WIDTH - left - 12;
    CGFloat top = 12;
    CGSize  textViewSize = [self.textView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    CGFloat height = fmin(self.textViewMaximumHeight, fmax(textViewSize.height, self.textViewMinimumHeight));
    
    self.textView.frame  = CGRectMake(left, top, width, height);
    self.bottomView.height = self.textView.bottom  + 16;
    self.height = self.bottomView.height + (42 * 3);
    
//    UITableView *tableView = (UITableView *)self.superview;
//    CGFloat bottom = CGRectGetMaxY([self.bottomView convertRect:self.bottomView.frame toView:tableView]) - 64;
//    if (bottom > tableView.height) {
//        tableView.contentSize = CGSizeMake(0, bottom);
//    }
}

- (UIView *)bottomView {
    return SW_LAZY(_bottomView, ({
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(0, 42 * 3, SCREEN_WIDTH, 60);
        
        NSString *title1 = NSLocalizedString(@"2.0_Describe", nil);
        NSString *title = [NSString stringWithFormat:@"%@ %@", title1, NSLocalizedString(@"2.1_Editable", nil)];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]
                                           initWithString:title];
        [attr addAttributes:@{ NSFontAttributeName : textFontPingFangRegularFont(12),
                               NSForegroundColorAttributeName : textColor666666
                               } range:NSMakeRange(0, title1.length)];
        
        [attr addAttributes:@{ NSFontAttributeName : textFontPingFangRegularFont(10),
                               NSForegroundColorAttributeName : textColor999999
                               } range:NSMakeRange(title1.length, attr.length - title1.length)];
        
        UILabel *label = [[UILabel alloc] init];
        label.attributedText = attr;
        [label sizeToFit];
        label.left = 12;
        label.top = 12;
        [view addSubview:label];
        self.bottomViewTitleLabel = label;
        
        QMUITextView *textView = [[QMUITextView alloc] init];
        textView.userInteractionEnabled = NO;
        textView.delegate = self;
        textView.maximumTextLength = 50;
        textView.placeholderColor = textColor999999;
        textView.enablesReturnKeyAutomatically = YES;
        textView.returnKeyType = UIReturnKeyDone;
        textView.textContainerInset = UIEdgeInsetsZero;
        textView.placeholder = NSLocalizedString(@"2.0_LeaveDes", nil);
        NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:17];
        paragraph.alignment = NSTextAlignmentRight;
        textView.typingAttributes = @{NSFontAttributeName: textFontPingFangRegularFont(12),
                                      NSForegroundColorAttributeName: textColor333333,
                                      NSParagraphStyleAttributeName: paragraph};
        [view addSubview:textView];
        self.textView = textView;
        
        view;
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
    
    if (!leftLabel) {
        leftLabel = [UILabel new];
    }
    leftLabel.textColor = textColor666666;
    leftLabel.font = textFontPingFangRegularFont(12);
    leftLabel.text = leftTitle;
    [leftLabel sizeToFit];
    leftLabel.left = 12;
    leftLabel.centerY = view.height / 2;
    [view addSubview:leftLabel];
    
    if (!rightLabel) {
        rightLabel = [UILabel new];
    }
    rightLabel.textColor = textColor333333;
    rightLabel.font = textFontPingFangRegularFont(12);
    rightLabel.textAlignment = NSTextAlignmentRight;
    if (rightTitle.length) {
        rightLabel.text = rightTitle;
    }
    
    rightLabel.width = SCREEN_WIDTH - leftLabel.right - 10 - 12 ;
    rightLabel.left = leftLabel.right + 10;
    rightLabel.height = leftLabel.height;
    rightLabel.centerY = leftLabel.centerY;
    [view addSubview:rightLabel];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    line.left = leftLabel.left;
    line.width = SCREEN_WIDTH - leftLabel.left;
    line.height = .5;
    line.bottom = view.height;
    [view addSubview:line];
    
    return view;
}

@end




