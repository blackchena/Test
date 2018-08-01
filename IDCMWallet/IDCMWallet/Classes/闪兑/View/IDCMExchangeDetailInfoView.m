//
//  IDCMExchangeDetailInfoView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/5/14.
//  Copyright © 2018年 IDCM. All rights reserved.
//


#import "IDCMQRCodeSaveTipView.h"
#import "IDCMSelectPayMethodsView.h"
#import "IDCMExchangeDetailInfoView.h"
#import "IDCMOTCExchangeDetailViewModel.h"
#import "IDCMOTCExchangeDetailStateInfoView.h"


@interface IDCMExchangeDetailBuyPaythodView : UIView
@property (nonatomic,strong) UIView *payMethodInfoView;
@property (nonatomic,strong) UIImageView *payMethodIcon;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *payMethodTitleLabel;
@property (nonatomic,strong) UILabel *payMethodAccountLabel;
@property (nonatomic,strong) UIButton *switchPayMethodBtn;
@property (nonatomic,strong) UILabel *payMethodNoLabel;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *codebtn;
@property (nonatomic,copy) NSString *QRCode;
@property (nonatomic,strong) IDCMOTCExchangeDetailViewModel *viewModel;
@end
@implementation IDCMExchangeDetailBuyPaythodView
+ (instancetype)buyPaythodViewWithViewModel:(IDCMOTCExchangeDetailViewModel *)viewModel {
    IDCMExchangeDetailBuyPaythodView *view = [[self alloc] init];
    view.viewModel = viewModel;
    [view initConfigure];
    view.clipsToBounds = YES;
    return view;
}

- (void)initConfigure {
    [self configUI];
    [self configSignal];
    [self configViewModel];
}

- (void)configSignal {
    @weakify(self);
    void(^subscribeState)(id) = ^(id x){
        @strongify(self);
        self.switchPayMethodBtn.hidden =
        !(self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_Doing ||
          self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_DoingSetDelay);
    };
    if (self.viewModel.detailModel.exchangeType == OTCExchangeType_Buy) {
        [RACObserve(self.viewModel.detailModel, exchangeBuyStateType) subscribeNext:subscribeState];
    }
    // 选择支付方式
    self.switchPayMethodBtn.rac_command = RACCommand.emptyCommand(^(UIButton *btn){
        @strongify(self);
        [self.superview endEditing:YES];
        
        [IDCMSelectPayMethodsView showWithTitle:NSLocalizedString(@"3.0_Hy_OTCExchangeDetailSwicthPayMethod", nil)
                                         models:self.viewModel.detailModel.paymentsArray
                              canMultipleSelect:NO
                                       isFilter:NO
                                  cellConfigure:^(SelectPayViewCell *cell, IDCMOTCExchangeDetailPaymentModel *model) {
                                      if ([model.PayTypeCode isEqualToString:@"AliPay"]) { //支付宝
                                          cell.payTitleLabel.text =  SWLocaloziString(@"3.0_DK_otcAlipay");
                                          cell.payAccountLabel.text = model.payAttributesModel.AccountNo;
                                          [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.PayTypeLogo]];
                                      }
                                      if ([model.PayTypeCode isEqualToString:@"Bankcard"]) { //银行卡
                                          cell.payTitleLabel.text = model.payAttributesModel.BankName;
                                          cell.payAccountLabel.text =
                                          [IDCMUtilsMethod addSpaceByString:model.payAttributesModel.AccountNo separateCount:4];
                                          [cell.iconImageView
                                           sd_setImageWithURL:[NSURL URLWithString:model.PayTypeLogo]];
                                      }
                                      if ([model.PayTypeCode isEqualToString:@"WeChat"]) { //微信
                                          cell.payTitleLabel.text =  SWLocaloziString(@"3.0_paylist_wechat");// paymentModel.PayAttributes.BankName;
                                          cell.payAccountLabel.text = model.payAttributesModel.AccountNo;
                                          [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.PayTypeLogo]];
                                      }
                                  }
                               selectedCallback:^(NSArray *models) {
                                   @strongify(self);
                                   if (!models.count) {return;}
                                   [self refreshPayMethodInfoWithModel:models.firstObject];
                               }];
    });
    
    
    [[[self.codebtn  rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(UIControl *x) {
         @strongify(self);
         [IDCMQRCodeSaveTipView showWithImageUrl:self.QRCode];
     }];
}

- (void)configViewModel {
    self.payMethodNoLabel.text = self.viewModel.detailModel.customerPayMethodNo;
    NSMutableArray *filterArray = @[].mutableCopy;
    [self.viewModel.detailModel.paymentsArray enumerateObjectsUsingBlock:^(IDCMOTCExchangeDetailPaymentModel *obj,
                                                                           NSUInteger idx, BOOL *stop) {
        if (obj.isSelected == YES) {
            [filterArray addObject:obj];
        }
    }];
    if (filterArray.count) {
        [self refreshPayMethodInfoWithModel:filterArray.firstObject];
    }
}

- (void)refreshPayMethodInfoWithModel:(IDCMOTCExchangeDetailPaymentModel *)model {
    if ([model.PayTypeCode isEqualToString:@"AliPay"] ||
        [model.PayTypeCode isEqualToString:@"WeChat"]) { //支付宝 微信
        self.QRCode = model.payAttributesModel.QRCode;
        self.nameLabel.text =
        [NSString stringWithFormat:@"%@ %@", model.payAttributesModel.UserName, model.payAttributesModel.AccountNo];
        [self.payMethodIcon
         sd_setImageWithURL:[NSURL URLWithString:model.PayTypeLogo]];
        self.codebtn.hidden = NO;
        self.payMethodTitleLabel.hidden =
        self.payMethodAccountLabel.hidden = YES;
    }
    if ([model.PayTypeCode isEqualToString:@"Bankcard"]) { //银行卡
        self.QRCode = @"";
        
        self.nameLabel.text = model.payAttributesModel.UserName;
        self.payMethodTitleLabel.text = model.payAttributesModel.BankName;
        self.payMethodAccountLabel.text =
        [IDCMUtilsMethod addSpaceByString:model.payAttributesModel.AccountNo separateCount:4];
        [self.payMethodIcon
         sd_setImageWithURL:[NSURL URLWithString:model.PayTypeLogo]];
        self.codebtn.hidden = YES;
        self.payMethodTitleLabel.hidden =
        self.payMethodAccountLabel.hidden = NO;
    }
    
    [self layoutSubviews];
}

- (void)configUI {
    self.backgroundColor = [UIColor whiteColor];
    self.size = CGSizeMake(SCREEN_WIDTH, 90);
    [self addSubview:self.payMethodInfoView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.nameLabel.height = 20;
    self.nameLabel.width = [self.nameLabel.text widthForFont:self.nameLabel.font];
    self.nameLabel.left = self.payMethodIcon.right + 8;
    self.nameLabel.centerY = self.payMethodIcon.centerY;
   
    if (self.QRCode.length) {
        if (self.nameLabel.right > self.switchPayMethodBtn.left - self.codebtn.width - 8 - 8) {
            self.nameLabel.width =
            self.switchPayMethodBtn.left - self.nameLabel.left-self.codebtn.width - 8 - 8;
        }
        self.codebtn.hidden = NO;
        self.codebtn.left = self.nameLabel.right + 8;
    } else {
        self.codebtn.hidden = YES;
        if (self.nameLabel.right > self.switchPayMethodBtn.left) {
            self.nameLabel.width = self.switchPayMethodBtn.left - self.nameLabel.left;
        }
    }
    
    self.payMethodTitleLabel.height = 14;
    self.payMethodTitleLabel.width = self.switchPayMethodBtn.left - self.nameLabel.right - 5;
    self.payMethodTitleLabel.left = self.nameLabel.right + 5;
    self.payMethodTitleLabel.top = 7;
    
    self.payMethodAccountLabel.height = 17;
    self.payMethodAccountLabel.width = self.payMethodTitleLabel.width;
    self.payMethodAccountLabel.left = self.payMethodTitleLabel.left;
    self.payMethodAccountLabel.top = self.payMethodTitleLabel.bottom;
}

- (UIView *)payMethodInfoView {
    return SW_LAZY(_payMethodInfoView, ({
        
        UIView *orderInfoView = [[UIView alloc] init];
        orderInfoView.backgroundColor = [UIColor whiteColor];
        orderInfoView.size = self.size;
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.size = CGSizeMake(SCREEN_WIDTH - 24, 80);
        view.top = 10;
        view.left = 12;
        view.clipsToBounds = NO;
        [orderInfoView addSubview:view];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"3.2_detail_bg"];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.clipsToBounds = NO;
        imageView.frame = CGRectMake(-5, -3, view.width + 10, view.height + 5);
        [view addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = textFontPingFangRegularFont(12);
        titleLabel.textColor = textColor999999;
        titleLabel.text = NSLocalizedString(@"3.0_Hy_OTCExchangeDetailPayMethodNoTitle", nil);
        [titleLabel sizeToFit];
        titleLabel.height = 36;
        titleLabel.left = 12;
        titleLabel.top = 0;
        [view addSubview:titleLabel];
        
        UILabel *payMethodNoLable = [[UILabel alloc] init];
        payMethodNoLable.font = textFontPingFangRegularFont(12);
        payMethodNoLable.textColor = textColor333333;
        payMethodNoLable.textAlignment = NSTextAlignmentRight;
        payMethodNoLable.height = 36;
        payMethodNoLable.width = view.width - titleLabel.width - 24;
        payMethodNoLable.left = titleLabel.right;
        payMethodNoLable.centerY = titleLabel.centerY;
        [view addSubview:payMethodNoLable];
        self.payMethodNoLabel = payMethodNoLable;
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
        line.frame = CGRectMake(-3, titleLabel.bottom, view.width + 6, .5);
        [view addSubview:line];
        
        UIView *bottomView = [[UIView alloc] init];
        bottomView.frame = CGRectMake(titleLabel.left, line.bottom, view.width - 12, 42);
        [view addSubview:bottomView];
        self.bottomView = bottomView;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.height = btn.width = bottomView.height;
        btn.right = bottomView.width + 5;
        [btn setImage:[UIImage imageNamed:@"3.2_detail_paymethodArraw"]
             forState:UIControlStateNormal];
        [bottomView addSubview:btn];
        self.switchPayMethodBtn = btn;
        self.switchPayMethodBtn.hidden =
        self.viewModel.detailModel.exchangeBuyStateType != OTCExchangeBuyStateType_Doing;
        
        UIImageView *methodIcon = [[UIImageView alloc] init];
        methodIcon.size = CGSizeMake(20, 20);
        methodIcon.centerY = bottomView.height / 2;
        [bottomView addSubview:methodIcon];
        self.payMethodIcon = methodIcon;
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = textFontPingFangRegularFont(14);
        nameLabel.textColor = textColor333333;
        [bottomView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        UILabel *payMethodTitleLabel = [[UILabel alloc] init];
        payMethodTitleLabel.font = textFontPingFangRegularFont(10);
        payMethodTitleLabel.textColor = textColor333333;
        [bottomView addSubview:payMethodTitleLabel];
        self.payMethodTitleLabel = payMethodTitleLabel;
        
        UILabel *payMethodAccountLabel = [[UILabel alloc] init];
        payMethodAccountLabel.font = textFontPingFangRegularFont(10);
        payMethodAccountLabel.textColor = textColor999999;
        [bottomView addSubview:payMethodAccountLabel];
        self.payMethodAccountLabel = payMethodAccountLabel;
        
        UIButton *codebtn = [[UIButton alloc] init];
        codebtn.size = CGSizeMake(20, 20);
        codebtn.centerY = bottomView.height / 2;
        codebtn.hidden = YES;
        [codebtn setImage:[UIImage imageNamed:@"3.2_PayMethodRQRCode"]
                 forState:UIControlStateNormal];
        [bottomView addSubview:codebtn];
        self.codebtn = codebtn;
        
        orderInfoView;
    }));
}
@end


@interface IDCMExchangeDetailOrderInfoView : UIView
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIView *contentImageView;
@property (nonatomic,strong) UILabel *orderNoLabel;
@property (nonatomic,strong) UILabel *orderTimeLabel;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) IDCMOTCExchangeDetailViewModel *viewModel;
@property (nonatomic,strong) NSArray<RACTuple *> *labelArray;
@end
@implementation IDCMExchangeDetailOrderInfoView
+ (instancetype)orderInfoViewWithViewModel:(IDCMOTCExchangeDetailViewModel *)viewModel {
    IDCMExchangeDetailOrderInfoView *view = [[self alloc] init];
    view.viewModel = viewModel;
    [view initConfigure];
    return view;
}

- (void)initConfigure {
    [self configUI];
    [self configViewModel];
    [self configSignal];
}

- (void)configUI {
    self.backgroundColor = UIColorWhite;
    self.labelArray = @[[self createOneLineView],
                        [self createOneLineView],
                        [self createOneLineView],
                        [self createOneLineView]];
    [self addSubview:self.contentView];
    [self refreshLayout];
}

- (void)configSignal {
    @weakify(self);
    void(^subscribeState)(id) = ^(id x){
        @strongify(self);
        if (self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_DoingDelay ||
            self.viewModel.detailModel.exchangeSellStateType == OTCExchangeSellStateType_DoingDelay) {
            return ;
        }
        [self refreshLabelText];
    };
    if (self.viewModel.detailModel.exchangeType == OTCExchangeType_Buy) {
        [[RACObserve(self.viewModel.detailModel, exchangeBuyStateType) skip:1] subscribeNext:subscribeState];
    } else {
        [[RACObserve(self.viewModel.detailModel, exchangeSellStateType) skip:1] subscribeNext:subscribeState];
    }
}

- (void)configViewModel {
    self.orderNoLabel.text = self.viewModel.detailModel.customerOrderNo;
    self.orderTimeLabel.text = self.viewModel.detailModel.customerOrderTime;
    [self refreshLabelText];
}

- (void)refreshLayout{
    NSInteger count = self.viewModel.orderInfoArray.count;
    CGFloat height = self.topView.height +  8 + (8 + 16) * count + 5;
    self.size = CGSizeMake(SCREEN_WIDTH, height);
    self.contentView.frame = CGRectMake(12, 0, self.width - 24, self.height);
    self.contentImageView.frame = CGRectMake(-5, - 3, self.contentView.width + 10, self.contentView.height + 5);
}

- (CGFloat)getChangeHeight {
    NSInteger count = self.viewModel.orderInfoArray.count;
    CGFloat height = self.topView.height +  8 + (8 + 16) * count + 5;
    return self.height - height;
}

- (void)refreshLabelText {
    NSArray *array = self.viewModel.orderInfoArray;
    NSInteger count = array.count;
    [self.labelArray enumerateObjectsUsingBlock:^(RACTuple * obj,
                                                  NSUInteger idx,
                                                  BOOL *stop) {
        RACTupleUnpack(UILabel *leftLabel,UILabel *rightLabel) = obj;
        if (idx >= count) {
            leftLabel.hidden = YES;
            rightLabel.hidden = YES;
        } else {
            leftLabel.hidden = NO;
            rightLabel.hidden = NO;
            RACTupleUnpack(NSString *leftText,NSString *rightText) = array[idx];
            leftLabel.text = leftText;
            rightLabel.text = rightText;
        }
    }];
}
- (UIView *)contentView {
    return SW_LAZY(_contentView, ({
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.size = CGSizeMake(SCREEN_WIDTH - 24, 130);
        view.top = 0;
        view.left = 12;
        view.clipsToBounds = NO;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"3.2_detail_bg"];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.clipsToBounds = NO;
        imageView.frame = CGRectMake(-5, -3, view.width + 10, view.height + 5);
        [view addSubview:imageView];
        self.contentImageView = imageView;
        
        [view addSubview:self.topView];
        [self.labelArray enumerateObjectsUsingBlock:^(RACTuple * obj,
                                                      NSUInteger idx,
                                                      BOOL *stop) {
            RACTupleUnpack(UILabel *leftLabel,UILabel *rightLabel) = obj;
            leftLabel.left = 12;
            leftLabel.top = 8 + (8 + leftLabel.height) * idx + self.topView.bottom;
            rightLabel.centerY = leftLabel.centerY;
            rightLabel.right = view.width - 12;
            
            [view addSubview:leftLabel];
            [view addSubview:rightLabel];
        }];
        view;
    }));
}
- (UIView *)topView {
    return SW_LAZY(_topView, ({
        
        UIView *topView = [[UIView alloc] init];
        topView.frame = CGRectMake(12, 0, SCREEN_WIDTH - 48, 36);
        
        UILabel *orderNoLabel = [[UILabel alloc] init];
        orderNoLabel.font = textFontPingFangRegularFont(12);
        orderNoLabel.textColor = textColor333333;
        orderNoLabel.textAlignment = NSTextAlignmentLeft;
        orderNoLabel.height = 16;
        orderNoLabel.width = topView.width * .65;
        orderNoLabel.left = 0;
        orderNoLabel.centerY = topView.height / 2;
        [topView addSubview:orderNoLabel];
        self.orderNoLabel = orderNoLabel;
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = textFontPingFangRegularFont(12);
        timeLabel.textColor = textColor999999;
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.height = 16;
        timeLabel.width = topView.width * .35;
        timeLabel.left = orderNoLabel.right;
        timeLabel.centerY = orderNoLabel.centerY;
        [topView addSubview:timeLabel];
        self.orderTimeLabel = timeLabel;
        
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
        line.frame = CGRectMake(-15, topView.bottom, topView.width + 30, .5);
        [topView addSubview:line];
        topView;
    }));
}
- (RACTuple *)createOneLineView {
    UILabel *LeftLabel = [[UILabel alloc] init];
    LeftLabel.font = textFontPingFangRegularFont(12);
    LeftLabel.textColor = textColor666666;
    LeftLabel.textAlignment = NSTextAlignmentLeft;
    LeftLabel.height = 17;
    LeftLabel.width = (SCREEN_WIDTH - 30) / 2;

    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.font = textFontPingFangMediumFont(12);
    rightLabel.textColor = textColor333333;
    rightLabel.textAlignment = NSTextAlignmentRight;
    rightLabel.height = LeftLabel.height;
    rightLabel.width = LeftLabel.width;
    return RACTuplePack(LeftLabel, rightLabel);
}
@end




@interface IDCMExchangeDetailInfoView ()
@property (nonatomic,strong) UIView *topTipView;
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) IDCMExchangeDetailOrderInfoView *orderInfoView;      // 订单信息
@property (nonatomic,strong) IDCMExchangeDetailBuyPaythodView *buyPaythodView;   //卖家付款信息
@property (nonatomic,strong) IDCMOTCExchangeDetailStateInfoView *stateInfoView; //订单状态
@property (nonatomic,weak) IDCMOTCExchangeDetailViewModel *viewModel;
@property (nonatomic,assign) CGFloat animationH;
@end


@implementation IDCMExchangeDetailInfoView
+ (instancetype)detailInfoViewWithViewModel:(IDCMOTCExchangeDetailViewModel *)viewModel {
    IDCMExchangeDetailInfoView *view = [[self alloc] init];
    view.backgroundColor = [UIColor clearColor];
    view.viewModel = viewModel;
    view.clipsToBounds = NO;
    [view initConfigure];
    return view;
}

- (void)photoScorllToCenter {
    [self.stateInfoView photoScorllToCenter];
}

- (BOOL)upAnimation{
    if (self.stateInfoView.bottomBtn.hidden) {
        return NO;
    }
    if (!self.stateInfoView.bottomBtn.selected) {
        self.stateInfoView.bottomBtn.selected = YES;
        [self upAnimationWithDuration:.25 completion:nil];
        return YES;
    }
    return NO;
}

- (void)initConfigure {
    self.isClickResignFirstResponse = NO;
    [self configUI];
    [self configViewModel];
}

- (void)configUI {
    [self addSubview:self.topTipView];
    [self addSubview:self.orderInfoView];
    if (self.viewModel.detailModel.exchangeType == OTCExchangeType_Buy) {
        [self addSubview:self.buyPaythodView];
        if (self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_AppealCheched ||
            self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_Completed ||
            self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_Cancelled ) {
            self.buyPaythodView.height = 0.0;
        }
    }
    [self addSubview:self.stateInfoView];
    self.height = self.stateInfoView.bottom;
    [self refreshShadow];
}

- (void)configViewModel {
    self.tipLabel.text = self.viewModel.exchangeStateTypeTopTipString;
    [self refreshTipTitleColor];
}

- (void)refreshTipTitleColor {
    if (self.viewModel.detailModel.exchangeType == OTCExchangeType_Buy) {
        if (self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_AppealCheched ||
            self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_Completed ||
            self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_Cancelled ) {
            self.tipLabel.textColor = textColor333333;
        } else {
            self.tipLabel.textColor = [UIColor colorWithHexString:@"#FF8730"];
        }
    } else {
        if (self.viewModel.detailModel.exchangeSellStateType == OTCExchangeSellStateType_Cancelled ||
            self.viewModel.detailModel.exchangeSellStateType == OTCExchangeSellStateType_Completed ||
            self.viewModel.detailModel.exchangeSellStateType == OTCExchangeSellStateType_AppealCheckPictureCompleted ||
            self.viewModel.detailModel.exchangeSellStateType == OTCExchangeSellStateType_AppealCheched) {
            self.tipLabel.textColor = textColor333333;
        } else {
            self.tipLabel.textColor = [UIColor colorWithHexString:@"#FF8730"];
        }
    }
}

- (void)refreshInfoView {
    if (self.stateInfoView.y <= 10) {
        [self.superview endEditing:YES];
        [self downAnimationWithDuration:.25 completion:^{
            [[RACScheduler mainThreadScheduler] afterDelay:.1 schedule:^{
                [self refreshLayout];
            }];
        }];
    } else {
        [self refreshLayout];
    }
}

- (void)refreshLayout {
    [self refreshTipTitleColor];
    self.tipLabel.text = self.viewModel.exchangeStateTypeTopTipString;
    CGFloat height =  [self.tipLabel.text heightForFont:self.tipLabel.font width:self.tipLabel.width];
    [UIView animateWithDuration:.25 animations:^{
        [self.orderInfoView refreshLayout];
        
        self.tipLabel.height = height;
        self.topTipView.height = self.tipLabel.height + 30;
        self.orderInfoView.top = self.topTipView.bottom;
        self.stateInfoView.height = self.viewModel.bottomStateViewHeight;
        if (self.viewModel.detailModel.exchangeType == OTCExchangeType_Buy) {
            if (self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_AppealCheched ||
                self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_Completed ||
                self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_Cancelled ) {
                self.buyPaythodView.height = 0.0;
            } else {
                self.buyPaythodView.height = 90;
            }
            self.buyPaythodView.top = self.orderInfoView.bottom;
            self.stateInfoView.top = self.buyPaythodView.bottom;
        } else {
            self.stateInfoView.top = self.orderInfoView.bottom;
        }
        [self refreshShadow];
    } completion:^(BOOL finished) {
        self.height = self.stateInfoView.bottom;
    }];
}

- (void)refreshShadow {
    self.stateInfoView.layer.shadowColor = [UIColor colorWithHexString:@"#BAC6E1"].CGColor;
    self.stateInfoView.layer.shadowOffset = CGSizeMake(0,2);
    self.stateInfoView.layer.shadowRadius = 2;
    self.stateInfoView.layer.shadowOpacity = 0.3;
    CGRect rect =  CGRectMake(0, 0, self.stateInfoView.width, self.stateInfoView.height);
    self.stateInfoView.layer.shadowPath = [UIBezierPath bezierPathWithRect:rect].CGPath;
}

static BOOL downAnimation = NO;
- (void)downAnimationWithDuration:(NSTimeInterval)duration
                       completion:(void(^)(void))completion {
    if (downAnimation) {return;}
    downAnimation = YES;
    if (duration < 0.3 ) {
        [self.heigthChangeSignal sendNext:@(self.animationH)];
    }
    [UIView animateWithDuration: duration
                          delay: .01
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.topTipView.transform =
                         self.orderInfoView.transform =
                         self.stateInfoView.transform = CGAffineTransformIdentity;
                         if (self.viewModel.detailModel.exchangeType == OTCExchangeType_Buy) {
                            self.buyPaythodView.transform = CGAffineTransformIdentity;
                         }
                     } completion:^(BOOL finished) {
                         downAnimation = NO;
                         self.stateInfoView.bottomBtn.selected = NO;
                         self.isClickResignFirstResponse = NO;
                         completion ? completion() : nil;
                         [[RACScheduler mainThreadScheduler] afterDelay:0.1 schedule:^{
                             self.height = self.stateInfoView.bottom;
                         }];
                     }];
}

static BOOL upAnimation = NO;
- (void)upAnimationWithDuration:(NSTimeInterval)duration
                     completion:(void(^)(void))completion {
    if (upAnimation) {return;}
    upAnimation = YES;
    CGFloat transH = - self.stateInfoView.top;
    CGFloat manTrans = - (self.stateInfoView.top - self.stateInfoView.height) - 3;
    if (duration > 0) {
        self.animationH = transH;
        [self.heigthChangeSignal sendNext:@(-transH)];
    }
    [UIView animateWithDuration: duration
                          delay: .01
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.topTipView.transform =
                         self.orderInfoView.transform = CGAffineTransformMakeTranslation(0, manTrans);
                         if (self.viewModel.detailModel.exchangeType == OTCExchangeType_Buy) {
                             self.buyPaythodView.transform = CGAffineTransformMakeTranslation(0, manTrans);
                         }
                         self.stateInfoView.transform = CGAffineTransformMakeTranslation(0, transH);
                     } completion:^(BOOL finished) {
                         upAnimation = NO;
                         self.stateInfoView.bottomBtn.selected = YES;
                         self.isClickResignFirstResponse = NO;
                         completion ? completion() : nil;
                         [[RACScheduler mainThreadScheduler] afterDelay:0.1 schedule:^{
                             if (duration > 0) {
                                  self.height = self.stateInfoView.bottom;
                             }
                         }];
                     }];
}

- (UIView *)topTipView {
    return SW_LAZY(_topTipView, ({
        
        UIView *view = [[UIView alloc] init];
        [view addSubview:self.tipLabel];
        view.backgroundColor = [UIColor whiteColor];
        view.width = SCREEN_WIDTH;
        view.height = self.tipLabel.height + 30;
        view.top = 0;
        view.left = 0;
        view;
    }));
}
- (UILabel *)tipLabel {
    return SW_LAZY(_tipLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.font = textFontPingFangRegularFont(14);
        label.textColor = [UIColor colorWithHexString:@"#FF8730"];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.text = self.viewModel.exchangeStateTypeTopTipString;
        label.width = SCREEN_WIDTH - 24;
        label.height =  [label.text heightForFont:label.font width:label.width];
        label.top = 16;
        label.left = 12;
        _topTipView.height = label.height + 30;
        label;
    }));
}
- (IDCMExchangeDetailOrderInfoView *)orderInfoView {
    return SW_LAZY(_orderInfoView, ({
        IDCMExchangeDetailOrderInfoView *view =
        [IDCMExchangeDetailOrderInfoView orderInfoViewWithViewModel:self.viewModel];
        view.top = self.topTipView.bottom;
        view;
    }));
}
- (IDCMExchangeDetailBuyPaythodView *)buyPaythodView {
    return SW_LAZY(_buyPaythodView, ({
        IDCMExchangeDetailBuyPaythodView *view =
        [IDCMExchangeDetailBuyPaythodView buyPaythodViewWithViewModel:self.viewModel];
        view.top = self.orderInfoView.bottom;
        view;
    }));
}
- (IDCMOTCExchangeDetailStateInfoView *)stateInfoView {
    return SW_LAZY(_stateInfoView, ({
        @weakify(self);
        RACCommand *(^animationCommand)(void) = ^{
            return RACCommand.emptyCommand(^(UIButton *btn){
                @strongify(self);
                self.isClickResignFirstResponse = YES;
                if (!btn.selected) {
                    [self upAnimationWithDuration:.25 completion:nil];
                } else {
                    self.isClickResignFirstResponse = YES;
                    [self.superview endEditing:YES];
                    [self downAnimationWithDuration:.25 completion:nil];
                }
            });
        };
        IDCMOTCExchangeDetailStateInfoView *view =
        [IDCMOTCExchangeDetailStateInfoView detailStateInfoViewWithViewModel:self.viewModel
                                                            animationCommand:animationCommand()
                                                       refreshInfoViewSignal:RACSubject.createSubject(^(id value){
            @strongify(self);
            CGFloat changeHeight = [value floatValue];
            self.tipLabel.text = self.viewModel.exchangeStateTypeTopTipString;
            CGFloat height =  [self.tipLabel.text heightForFont:self.tipLabel.font width:self.tipLabel.width];
            changeHeight = changeHeight - (self.tipLabel.height - height) - [self.orderInfoView getChangeHeight];
            if (self.viewModel.detailModel.exchangeType == OTCExchangeType_Buy) {
                if (self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_AppealCheched ||
                    self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_Completed ||
                    self.viewModel.detailModel.exchangeBuyStateType == OTCExchangeBuyStateType_Cancelled ) {
                    changeHeight = changeHeight - (self.buyPaythodView.height - 0.0);
                } else {
                    changeHeight = changeHeight - (self.buyPaythodView.height - 90);
                }
            }
            [self.heigthChangeSignal sendNext:@(-changeHeight)];
            [self refreshInfoView];
        })];
        if (self.viewModel.detailModel.exchangeType == OTCExchangeType_Buy) {
            view.top = self.buyPaythodView.bottom;
        } else {
            view.top = self.orderInfoView.bottom;
        }
        view;
    }));
}
@end













