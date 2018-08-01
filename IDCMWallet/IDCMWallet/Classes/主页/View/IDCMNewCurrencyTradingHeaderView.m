//
//  IDCMNewCurrencyTradingHeaderView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/5/28.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMNewCurrencyTradingHeaderView.h"
#import "iCarousel.h"


typedef NS_ENUM(NSInteger,IDCMCurrencyActionType) {
    IDCMCurrencyActionType_Recieve = 0,
    IDCMCurrencyActionType_Send,
    IDCMCurrencyActionType_All,
};

@interface CurrencyListViewCell : UIView //
@property (nonatomic,strong) UIImageView *currencyIcon;
@property (nonatomic,strong) UILabel *currencyNameLabel;
@property (nonatomic,strong) UIView *selectLine;
@property (nonatomic,strong) UIImageView *selectBgImageView;
@property (nonatomic,strong) IDCMCurrencyMarketModel *currencyMarketModel;
@end
@implementation CurrencyListViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.selectBgImageView];
        [self addSubview:self.currencyIcon];
        [self addSubview:self.currencyNameLabel];
        [self addSubview:self.selectLine];
    }
    return self;
}

- (void)setCurrencyMarketModel:(IDCMCurrencyMarketModel *)currencyMarketModel {
    _currencyMarketModel = currencyMarketModel;
    if (_currencyMarketModel.currentSelect) {
        self.currencyNameLabel.textColor = textColor333333;
        self.currencyNameLabel.font = textFontPingFangMediumFont(14);
        self.currencyIcon.alpha = 1;
        self.selectLine.hidden = self.selectBgImageView.hidden = NO;
    } else {
        self.currencyNameLabel.textColor = textColor666666;
        self.currencyIcon.alpha = 0.5;
        self.currencyNameLabel.font = textFontPingFangRegularFont(14);
        self.selectLine.hidden =self.selectBgImageView.hidden = YES;
    }
    self.currencyNameLabel.text = [currencyMarketModel.currency_unit uppercaseString];
    [self.currencyIcon sd_setImageWithURL:[NSURL URLWithString:currencyMarketModel.logo_url]
                         placeholderImage:nil
                                  options:SDWebImageRefreshCached];
}

- (UIImageView *)selectBgImageView {
    return SW_LAZY(_selectBgImageView, ({
        UIImageView *selectBgImageView =
        [UIImageView createImageViewWithSuperView:self
                                      contentMode:UIViewContentModeScaleAspectFill
                                            image:[UIImage imageNamed:@"2.1_current_selected_currency_bg_image"]
                                    clipsToBounds:YES];
        
        selectBgImageView.width = 68;
        selectBgImageView.height = 76;
        selectBgImageView.centerX = self.width / 2;
        selectBgImageView.top = 0;
        selectBgImageView;
    }));
}

- (UIImageView *)currencyIcon {
    return SW_LAZY(_currencyIcon, ({
        UIImageView *currencyIcon = [[UIImageView alloc] init];
        currencyIcon.contentMode = UIViewContentModeScaleAspectFill;
        currencyIcon.clipsToBounds = YES;
        currencyIcon.width = 40;
        currencyIcon.height = 40;
        currencyIcon.top = 18;
        currencyIcon.centerX = self.selectBgImageView.centerX;
        currencyIcon;
    }));
}

- (UILabel *)currencyNameLabel {
    return SW_LAZY(_currencyNameLabel, ({
        UILabel *currencyNameLabel =
        [UILabel createLabelWithTitle:@" "
                           titleColor:textColor333333
                                 font:textFontPingFangRegularFont(14)
                        textAlignment:NSTextAlignmentCenter];
        
        [currencyNameLabel sizeToFit];
        currencyNameLabel.width  = self.width - 20;
        currencyNameLabel.top = self.currencyIcon.bottom + 20;
        currencyNameLabel.centerX = self.currencyIcon.centerX;
        currencyNameLabel;
    }));
}

- (UIView *)selectLine {
    return SW_LAZY(_selectLine, ({
        UIView *selectLine = [[UIView alloc] init];
        selectLine.backgroundColor = UIColorFromRGB(0x2E406B);
        selectLine.layer.cornerRadius = 1;
        selectLine.width = 40;
        selectLine.height = 2;
        selectLine.top = self.currencyNameLabel.bottom + 2;
        selectLine.centerX = self.currencyNameLabel.centerX;
        selectLine;
    }));
}
@end

@interface IDCMHeaderButtonView : UIView
@property (nonatomic,strong) void (^didClickButtonActionBlock)(IDCMCurrencyActionType type);
@property (nonatomic,assign) IDCMCurrencyActionType currentActionType;
@property (nonatomic,strong) NSMutableArray  *buttonArray;
@property (nonatomic,strong) UIView *animationLine;
@end
@implementation IDCMHeaderButtonView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI {
    self.currentActionType = IDCMCurrencyActionType_All;
    self.buttonArray = [[NSMutableArray alloc] init];
    NSArray *title = @[SWLocaloziString(@"2.0_AllButton"),
                       SWLocaloziString(@"2.0_ReciveRecordButton"),
                       SWLocaloziString(@"2.0_SendRecordButton")];
    
    NSArray<NSNumber *> *tags = @[@(IDCMCurrencyActionType_All),
                                  @(IDCMCurrencyActionType_Recieve),
                                  @(IDCMCurrencyActionType_Send)];
    
    self.animationLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 2, 43.5, 2)];
    self.animationLine.backgroundColor = UIColorFromRGB(0x2E406B);
    self.animationLine.layer.cornerRadius = 1;
    CGFloat height = self.height;
    CGFloat itemW = self.width/title.count;
    
    for (NSInteger i = 0;  i < title.count; i ++) {
        UIButton *btn =
        [UIButton creatCustomButtonNormalStateWithTitile:[title objectAtIndex:i]
                                               titleFont:textFontPingFangRegularFont(12)
                                              titleColor:textColor333333
                                            butttonImage:nil
                                         backgroundImage:nil
                                         backgroundColor:[UIColor clearColor]
                                        clickThingTarget:self
                                                  action:@selector(buttonClick:)];
        [self addSubview:btn];
        btn.tag = [tags objectAtIndex:i].integerValue;
        [btn setTitleColor:UIColorFromRGB(0x2E406B) forState:UIControlStateSelected];
        [self.buttonArray addObject:btn];
        btn.frame = CGRectMake(i * itemW, 0, itemW, height);
        if (i == 0) {
            [self addSubview:self.animationLine];
            self.animationLine.centerX = btn.centerX;
            btn.selected = YES;
        }
    }
}
- (void)buttonClick:(UIButton *)sender {
    self.currentActionType = sender.tag;
    !self.didClickButtonActionBlock ?:
    self.didClickButtonActionBlock(self.currentActionType);
}
-(void)setCurrentActionType:(IDCMCurrencyActionType)currentActionType {
    if (currentActionType == _currentActionType) {
        return;
    }
    _currentActionType = currentActionType;
    UIButton *sender = nil;
    if (currentActionType == IDCMCurrencyActionType_All) {
        sender = [self.buttonArray firstObject];
    }else if (currentActionType == IDCMCurrencyActionType_Send) {
        sender = [self.buttonArray lastObject];
    }else {
        sender = [self.buttonArray objectAtIndex:1];
    }
    for (UIButton *btn in self.buttonArray) {
        btn.selected =NO;
    }
    sender.selected = YES;
    [UIView animateWithDuration:0.2 animations:^{
        self.animationLine.centerX = sender.centerX;
    }];
}
@end

@interface IDCMNewCurrencyTradingHeaderView ()<iCarouselDataSource,iCarouselDelegate>
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIView *currencyListView;
@property (nonatomic,strong) iCarousel *carouselView;

@property (nonatomic,strong) UIView *moneyInfoView;
@property (nonatomic,strong) UILabel *moneyTopTitleLabel;
@property (nonatomic,strong) UILabel *moneyTopCountLabel;
@property (nonatomic,strong) UILabel *moneyBottomTitleLabel;
@property (nonatomic,strong) UILabel *moneyBottomCountLabel;

@property (nonatomic,strong) QMUIButton *recieveButon;
@property (nonatomic,strong) QMUIButton *sendButton;

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) IDCMHeaderButtonView *buttonView;
@property (nonatomic,strong) IDCMHeaderButtonView *selectTitleView;
@property (nonatomic,strong) IDCMNewCurrencyTradingViewModel *viewModel;
@end


@implementation IDCMNewCurrencyTradingHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initConfigre];
    }
    return self;
}

+ (instancetype)headerViewWithViewModel:(IDCMNewCurrencyTradingViewModel *)viewModel {
    IDCMNewCurrencyTradingHeaderView *view = [[self alloc] init];
    view.size = CGSizeMake(view.bottomView.width, headerViewTopHeight + headerViewBottomHeight);
    view.viewModel = viewModel;
    [view configSignal];
    [view configViewModel];
    return view;
}

- (void)recoveryUI {
    [self carouselViewScrollToCenter:NO];
}

- (void)initConfigre {
    [self configUI];
}

- (void)configUI {
    self.backgroundColor = viewBackgroundColor;
    [self addSubview:self.topView];
    [self addSubview:self.bottomView];
}

- (void)configSignal {
  @weakify(self);
    [[[self.recieveButon rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(UIControl *x) {
         @strongify(self);
         [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMReceiveViewController"
                                                            withViewModelName:@"IDCMReceiveViewModel"
                                                                   withParams:@{@"marketModel":self.viewModel.marketModel}];
     }];
    [[[self.sendButton rac_signalForControlEvents:UIControlEventTouchUpInside] deliverOnMainThread]
     subscribeNext:^(UIControl *x) {
         @strongify(self);
         
         [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMSendCoinController"
                                                            withViewModelName:@"IDCMSendCoinViewModel"
                                                                   withParams:@{@"marketModel":self.viewModel.marketModel}];
     }];
}

- (void)configViewModel {
    
    @weakify(self);
    [RACObserve(self.viewModel, blanceDict) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (x) {
            NSDictionary *dic = (NSDictionary *)x;
            if (dic.count > 0) {
                self.moneyTopTitleLabel.text = dic[@"CoinType"];
                self.moneyTopCountLabel.text = dic[@"CoinBalance"];
                self.moneyBottomTitleLabel.text = dic[@"CurrencyType"];
                self.moneyBottomCountLabel.text = dic[@"CurrencyNumber"];
            }
        }
    }];
    [self clearMoneyInfoView];
    [self judgeSendOrRecieve:self.viewModel.marketModel];
    self.carouselView.type =
    (self.viewModel.currencyListData.count >= 4) ? SWNewAddiCarouselTypeCustom:iCarouselTypeLinear;
    self.carouselView.bounces = NO;
    [self carouselViewScrollToCenter:NO];
}

- (void)clearMoneyInfoView {
    IDCMCurrencyMarketModel *market = self.viewModel.marketModel;
    self.viewModel.blanceDict = @{@"CoinBalance":@"",
                                  @"CoinType":[market.currency uppercaseString],
                                  @"CurrencyNumber":@"",
                                  @"CurrencyType":[market.localCurrencyName uppercaseString]
                                  };
}


- (void)judgeSendOrRecieve:(IDCMCurrencyMarketModel *)model{
    if (model.is_enable_ransceiver) {
        self.sendButton.enabled = YES;
        self.recieveButon.enabled = YES;
        [self.sendButton setBackgroundImage:UIImageMake(@"2.1_recieve_sender_btn_bg_icon_image")
                                   forState:UIControlStateNormal];
        [self.recieveButon setBackgroundImage:UIImageMake(@"2.1_recieve_sender_btn_bg_icon_image")
                                     forState:UIControlStateNormal];
        [self.sendButton setBackgroundImage:UIImageMake(@"2.1_recieve_sender_btn_bg_icon_image")
                                   forState:UIControlStateHighlighted];
        [self.recieveButon setBackgroundImage:UIImageMake(@"2.1_recieve_sender_btn_bg_icon_image")
                                     forState:UIControlStateHighlighted];
    }else{ 
        self.sendButton.enabled = NO;
        self.recieveButon.enabled = NO;
        [self.sendButton setBackgroundImage:UIImageMake(@"3.0_UnSendOrRecive") forState:UIControlStateNormal];
        [self.recieveButon setBackgroundImage:UIImageMake(@"3.0_UnSendOrRecive") forState:UIControlStateNormal];
    }
}

#pragma mark  -- iCarouselDataSource && iCarouselDelegate
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.viewModel.currencyListData.count;
}

- (UIView *)carousel:(__unused iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    CGFloat itemWith = carousel.width / 5.0f;
    if (view == nil) {
        view = [[CurrencyListViewCell alloc] initWithFrame:CGRectMake(0, 0, itemWith, carousel.height)];
    }
    [((CurrencyListViewCell *)view) setCurrencyMarketModel:[self.viewModel.currencyListData objectAtIndex:index]];
    return view;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    return carousel.width / 5.0f;;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    
    @weakify(self);
    [self.viewModel.currencyListData enumerateObjectsUsingBlock:^(IDCMCurrencyMarketModel *obj,
                                                                  NSUInteger idx,
                                                                  BOOL *stop) {
        @strongify(self);
        obj.currentSelect = idx == index;
        if (index == idx) {
            self.viewModel.marketModel = obj;
        }
    }];
    [self carouselViewScrollToCenter:YES];
    [self clickCurrency];
}

- (void)clickCurrency {
    [self.viewModel cancelAllRequest];
    self.viewModel.tradeType = IDCMCurrencyActionType_All;
    self.buttonView.currentActionType = IDCMCurrencyActionType_All;
    [self clearMoneyInfoView];
    [self judgeSendOrRecieve:self.viewModel.marketModel];
    [self.viewModel.tableViewExecuteCommand(0) execute:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self carouselViewScrollToCenter:YES];
}

- (void)carouselViewScrollToCenter:(BOOL)animated {
    [self.carouselView reloadData];
    [self.carouselView scrollToItemAtIndex:[self.viewModel.currencyListData indexOfObject:self.viewModel.marketModel]
                                  animated:animated];
}

#pragma mark — getters and setters
- (UIView *)topView {
    if (!_topView){
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
        _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH,    6 + 112 + 10 + 72 + 15 + 60); // 275
        
        UIView *topColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _topView.width, 36)];
        topColorView.backgroundColor = UIColorFromRGB(0x2E406B);
        [_topView addSubview:topColorView];
        
        [_topView addSubview:self.currencyListView];
        [_topView addSubview:self.moneyInfoView];
        [_topView addSubview:self.recieveButon];
        [_topView addSubview:self.sendButton];
    }
    return _topView;
}

- (UIView *)bottomView {
    return SW_LAZY(_bottomView, ({
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.width = self.topView.width;
        view.height = 40;
        view.top = self.topView.bottom + 10;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(12, (40 - 12)/2.0f,3, 12)];
        lineView.backgroundColor = UIColorFromRGB(0x2E406B);
        lineView.layer.cornerRadius = 2;
        [view addSubview:lineView];
        
        UILabel *label =
        [UILabel createLabelWithTitle:SWLocaloziString(@"2.0_TradingTitle")
                           titleColor:textColor333333
                                 font:textFontPingFangRegularFont(12)
                        textAlignment:NSTextAlignmentLeft];
        [label sizeToFit];
        label.width = MIN(label.width, 150);
        label.left = lineView.right + 5;
        label.centerY = lineView.centerY;
        [view addSubview:label];
        
        IDCMHeaderButtonView *buttonView =
        [[IDCMHeaderButtonView alloc] initWithFrame:CGRectMake(view.width - 200 - 12, 0,200, 40)];
        @weakify(self);
        buttonView.didClickButtonActionBlock = ^(IDCMCurrencyActionType type) {
            @strongify(self);
            [self carouselViewScrollToCenter:YES];
            if (type == self.viewModel.tradeType) {return;}
            self.viewModel.tradeType = type;
            [self.viewModel.tableViewExecuteCommand(0) execute:nil];
        };
        [view addSubview:buttonView];
        self.buttonView = buttonView;
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = viewBackgroundColor;
        line.height = 1;
        line.width = view.width;
        line.bottom = view.height;
        line.left = 0;
        [view addSubview:line];
        view;
    }));
}

- (UIView *)currencyListView {
    if (!_currencyListView){
        _currencyListView = [[UIView alloc] init];
        _currencyListView.backgroundColor = [UIColor whiteColor];
        _currencyListView.height = 112;
        _currencyListView.width = SCREEN_WIDTH - 24;
        _currencyListView.left = 12;
        _currencyListView.top = 6;
        [self configShadowWithView:_currencyListView];
        [_currencyListView addSubview:self.carouselView];
    }
    return _currencyListView;
}

- (iCarousel *)carouselView {
    return SW_LAZY(_carouselView, ({
        CGFloat margin = 10;
        CGFloat itemWith = (_currencyListView.width - margin *2)/ 5.0f;
        iCarousel *carousel = [[iCarousel alloc] initWithFrame:CGRectMake(margin, 0,itemWith *5,_currencyListView.height)];
        carousel.type = 0;
        carousel.clipsToBounds = YES;
        carousel.backgroundColor = [UIColor clearColor];
        carousel.delegate = self;
        carousel.dataSource = self;
        carousel.bounceDistance = 20;
        carousel;
    }));
}

- (UIView *)moneyInfoView {
    if (!_moneyInfoView){
        _moneyInfoView= [[UIView alloc] init];
        _moneyInfoView.backgroundColor = [UIColor whiteColor];
        _moneyInfoView.width = self.currencyListView.width;
        _moneyInfoView.height = 72;
        _moneyInfoView.top = self.currencyListView.bottom + 10;
        _moneyInfoView.left = self.currencyListView.left;
        [self configShadowWithView:_moneyInfoView];
        
        [_moneyInfoView addSubview:self.moneyTopTitleLabel];
        [_moneyInfoView addSubview:self.moneyTopCountLabel];
        [_moneyInfoView addSubview:self.moneyBottomTitleLabel];
        [_moneyInfoView addSubview:self.moneyBottomCountLabel];
    }
    return _moneyInfoView;
}

- (UILabel *)moneyTopTitleLabel {
    return SW_LAZY(_moneyTopTitleLabel, ({
        UILabel *label =
        [UILabel createLabelWithTitle:@""
                           titleColor:textColor333333
                                 font:textFontPingFangMediumFont(20)
                        textAlignment:NSTextAlignmentLeft];
        label.width = 60;
        label.height = 21;
        label.left = 12;
        label.top = 12;
        label;
    }));
}

- (UILabel *)moneyTopCountLabel {
    return SW_LAZY(_moneyTopCountLabel, ({
        UILabel *label =
        [UILabel createLabelWithTitle:@""
                           titleColor:textColor333333
                                 font:textFontPingFangMediumFont(20)
                        textAlignment:NSTextAlignmentLeft];
        
        label.width = _moneyInfoView.width - self.moneyTopTitleLabel.right - 8 - 12;
        label.height = self.moneyTopTitleLabel.height;
        label.left = self.moneyTopTitleLabel.right + 8;
        label.centerY = self.moneyTopTitleLabel.centerY;
        label;
    }));
}

- (UILabel *)moneyBottomTitleLabel {
    return SW_LAZY(_moneyBottomTitleLabel, ({
        UILabel *label =
        [UILabel createLabelWithTitle:@""
                           titleColor:textColor666666
                                 font:textFontPingFangMediumFont(14)
                        textAlignment:NSTextAlignmentLeft];
        
        label.width = self.moneyTopTitleLabel.width;
        label.height = self.moneyTopTitleLabel.height;
        label.left = self.moneyTopTitleLabel.left;
        label.top = self.moneyTopTitleLabel.bottom + 6;
        label;
    }));
}

- (UILabel *)moneyBottomCountLabel {
    return SW_LAZY(_moneyBottomCountLabel, ({
        UILabel *label =
        [UILabel createLabelWithTitle:@""
                           titleColor:textColor666666
                                 font:textFontPingFangMediumFont(14)
                        textAlignment:NSTextAlignmentLeft];
        
        label.width = self.moneyTopCountLabel.width;
        label.height = self.moneyTopCountLabel.height;
        label.left = self.moneyTopCountLabel.left;
        label.centerY = self.moneyBottomTitleLabel.centerY;
        label;
    }));
}

- (UIButton *)recieveButon {
    return SW_LAZY(_recieveButon, ({
        
        QMUIButton *btn = [[QMUIButton alloc] init];
        [btn setTitle:SWLocaloziString(@"2.0_ReciveButton") forState:UIControlStateNormal];
        [btn setTitleColor:textColorFFFFFF forState:UIControlStateNormal];
        btn.titleLabel.font = textFontPingFangRegularFont(14);
        [btn setImage:[UIImage imageNamed:@"2.1_receieve_white_button_icon"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"2.1_receieve_white_button_icon"] forState:UIControlStateNormal];
        btn.spacingBetweenImageAndTitle = 6;
        btn.adjustsButtonWhenHighlighted = NO;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 5, 0);
        btn.width = 166*SCREEN_WIDTH/375;
        btn.height = 50;
        btn.top = self.moneyInfoView.bottom + 15;
        btn.left = self.moneyInfoView.left;
        btn;
    }));
}

- (UIButton *)sendButton {
    return SW_LAZY(_sendButton, ({
        
        QMUIButton *btn = [[QMUIButton alloc] init];
        [btn setTitle:SWLocaloziString(@"2.0_SendButton") forState:UIControlStateNormal];
        [btn setTitleColor:textColorFFFFFF forState:UIControlStateNormal];
        btn.titleLabel.font = textFontPingFangRegularFont(14);
        [btn setImage:[UIImage imageNamed:@"2.1_send_white_button_icon"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"2.1_recieve_sender_btn_bg_icon_image"] forState:UIControlStateNormal];
        btn.spacingBetweenImageAndTitle = 6;
        btn.adjustsButtonWhenHighlighted = NO;
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 5, 0);
        btn.width = self.recieveButon.width;
        btn.height = self.recieveButon.height;
        btn.centerY = self.recieveButon.centerY;
        btn.right = self.moneyInfoView.right;
        btn;
    }));
}

- (void)configShadowWithView:(UIView *)View {
    View.layer.borderColor = SetColor(225, 231, 255).CGColor;
    View.layer.borderWidth= 0.5;
    View.layer.cornerRadius = 5;
    View.layer.shadowOpacity = 1;// 阴影透明度
    View.layer.shadowColor = SetColor(214, 223, 245).CGColor;// 阴影的颜色
    View.layer.shadowRadius = 2;// 阴影扩散的范围控制
    View.layer.shadowOffset = CGSizeMake(0, 2);// 阴影的范围
}

@end












