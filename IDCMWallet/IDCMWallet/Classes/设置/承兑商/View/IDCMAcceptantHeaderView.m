//
//  IDCMAcceptantHeaderView.m
//  IDCMWallet
//
//  Created by wangpu on 2018/4/11.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptantHeaderView.h"
#import "iCarousel.h"
#import "IDCMAcceptantCoinModel.h"

@interface IDCMAcceptantHeaderView ()<iCarouselDelegate,iCarouselDataSource>


@property (nonatomic,strong) NSArray < IDCMAcceptantDepositModel *> * cointArr;

@property (nonatomic,strong) iCarousel *carousel;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UILabel * titleLabel ;
@property (nonatomic,strong) UIView *  lessThanTwoView ;
@end

@implementation IDCMAcceptantHeaderView

-(instancetype) initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {

        self.clipsToBounds  = YES;
        [self configUIView];
        [self configSignals];
        //[self requestWithdrawCoinList];
        
    }
    return self;
}



-(void)configSignals{
    
    @weakify(self);
    [[self.leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self);
        
        if (self.leftCallBack) {
            self.leftCallBack();
        }
    }];
    [[self.rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self);
        if (self.rightCallBack) {
            self.rightCallBack();
        }
    }];
    
   [[[self.viewModel.OTCGetStateCommand.executionSignals switchToLatest]  deliverOnMainThread]  subscribeNext:^(NSDictionary *  response ) {
       
       @strongify(self);
       NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
       if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSDictionary class]]) {
           NSArray * deppositList = response[@"data"][@"DepositList"];
           NSInteger accptantStatus  = [response[@"data"][@"Status"] integerValue];
           NSMutableArray *coinList = [[NSMutableArray alloc] init];
           if ([deppositList isKindOfClass:[NSArray class]]) {
               for (NSDictionary *dict in deppositList) {
                   IDCMAcceptantDepositModel *model = [IDCMAcceptantDepositModel yy_modelWithDictionary:dict];
                   [coinList addObject:model];
               }
           }
           self.cointArr = coinList;
           
           if (accptantStatus == 4) { //暂停
               [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
                   
                   configure.getBtnsConfig.firstObject.btnTitle(SWLocaloziString(@"3.0_DK_sayLatter"));
                   configure.getBtnsConfig.lastObject.btnTitle(SWLocaloziString(@"3.0_AcceptantBalanceRecharge")).btnCallback(^{
                       
                       [[IDCMMediatorAction sharedInstance] pushViewControllerWithClassName:@"IDCMAcceptantPickInBondController"
                                                                          withViewModelName:nil
                                                                                 withParams:nil
                                                                                   animated:YES];
                       
                   });
                   configure.title(SWLocaloziString(@"3.0_AcceptantBalanceNotEnough")).subTitle(SWLocaloziString(@"3.0_AcceptantFrozen"));
               }];
           }
       }
    }];
    
}
//
//获取当前保证金币种和余额
-(void)requestWithdrawCoinList{
    
    [self.viewModel.OTCGetStateCommand execute:nil];
}
//
-(void)configUIView{
    
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self addSubview:self.rightBtn];
    [self addSubview:self.leftBtn];
    [self setupConstraints];
}
-(void)setupConstraints{
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(15);
    }];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-15);
        make.left.equalTo(self).offset(12);
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-24-20)/2.0, 40));
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-15);
        make.right.equalTo(self).offset(-12);
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-24-20)/2.0, 40));
    }];
}

-(void)emptyView{
    

    //没有保证金和余额的展示页面
    
}
#pragma mark - iCarousel 代理

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return   self.cointArr.count;
}

-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    if (!view) {
     
        view =[[IDCMAcceptantiCarouselCell alloc] initWithFrame:CGRectMake(0, 0, 112, 70)];
    }
    
    [((IDCMAcceptantiCarouselCell *)view) setModel:[self.cointArr objectAtIndex:index]];
    return view ;
}

- (void)scrollToCurrentIndex:(NSInteger)index animation:(BOOL)animation{
    
    
    [self.carousel scrollToItemAtIndex:index animated:YES];
}

//item图片之间的间隔宽
-(CGFloat)carouselItemWidth:(iCarousel *)carousel {
    
    return 120;
}


-(void) addLessThanTwoView{
    
    if ( _cointArr.count >0 && _cointArr.count <4  ) {
        
        UIView  * contentView = [[UIView alloc] init];
        [self addSubview:contentView];
        CGFloat itemWidth = (SCREEN_WIDTH - 24 - 20)/3.0;
        
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(self);
            make.bottom.equalTo(self.rightBtn.mas_top).offset(-15);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        }];
        if (_cointArr.count == 1) {
            IDCMAcceptantiCarouselCell * view =[[IDCMAcceptantiCarouselCell alloc] initWithFrame:CGRectMake((self.frame.size.width - itemWidth)/2.0, 0 , itemWidth, 70)];
            [view setModel:_cointArr.firstObject];
            [contentView addSubview:view];
        }
        if (_cointArr.count == 2) {
            
            IDCMAcceptantiCarouselCell * view1 =[[IDCMAcceptantiCarouselCell alloc] initWithFrame:CGRectMake((self.frame.size.width - (itemWidth*2 +10) )/2.0, 0 , itemWidth, 70)];
            IDCMAcceptantiCarouselCell * view2 =[[IDCMAcceptantiCarouselCell alloc] initWithFrame:CGRectMake((self.frame.size.width - (itemWidth*2 +10))/2.0 + (itemWidth + 10), 0 , itemWidth, 70)];
            
            [view1 setModel:_cointArr.firstObject];
            [view2 setModel:_cointArr.lastObject];
            
            [contentView addSubview:view1];
            [contentView addSubview:view2];
        }
        
        if (_cointArr.count == 3) {
            
            for (NSInteger i = 0; i<_cointArr.count; i++) {
                IDCMAcceptantDepositModel * model = _cointArr [i];
                IDCMAcceptantiCarouselCell * view =[[IDCMAcceptantiCarouselCell alloc] initWithFrame:CGRectMake(12 + i * itemWidth +(i * 10), 0 , itemWidth, 70)];
                [view setModel:model];
                [contentView addSubview:view];
            }
        }
        self.lessThanTwoView = contentView ;
    }
}
#pragma mark -

-(void)setCointArr:(NSArray *)cointArr{
    _cointArr = cointArr;
    [self.lessThanTwoView removeFromSuperview];
    [self.carousel removeFromSuperview];
    if (cointArr.count <4 ) {
        [self addLessThanTwoView];
    }else{
        [self addSubview:self.carousel];
        [self.carousel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(self);
            make.bottom.equalTo(self.rightBtn.mas_top);
            make.top.equalTo(self.titleLabel.mas_bottom);
        }];
        [self.carousel reloadData];
        [self.carousel scrollToItemAtIndex:1 animated:YES];
    }
}
#pragma mark - life cycle
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setupConstraints];
}

#pragma mark - getter
- (iCarousel *)carousel
{
    return SW_LAZY(_carousel, ({
        
        iCarousel *carousel = [[iCarousel alloc] init];
        carousel.type = SWNewAddiCarouselTypeCustom;
        carousel.delegate = self;
        carousel.dataSource = self;
        carousel.pagingEnabled = YES;
        carousel;
    }));
}
//
-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.backgroundColor = [UIColor colorWithHexString:@"#2E406B"];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn setTitle:SWLocaloziString(@"3.0_AcceptantCashDepositManage") forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = SetFont(@"PingFangSC-Regular", 14);
        _rightBtn.layer.cornerRadius = 4;
        _rightBtn.clipsToBounds = YES;
    }
    return _rightBtn;
}

-(UIButton *)leftBtn{
    if (!_leftBtn) {
        _leftBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.backgroundColor = [UIColor colorWithHexString:@"#2E406B"];
        [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftBtn setTitle:SWLocaloziString(@"3.0_AcceptantBondPickIn") forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = SetFont(@"PingFangSC-Regular", 14);
        _leftBtn.layer.cornerRadius = 4;
        _leftBtn.clipsToBounds = YES;
    }
    return _leftBtn;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.font = SetFont(@"PingFangSC-Medium", 14);
        _titleLabel.text = SWLocaloziString(@"3.0_AcceptantBondCountBalance");
    }
    return _titleLabel;
}

-(IDCMAcceptantViewModel *)viewModel{
    
    if (!_viewModel) {
        _viewModel = [[ IDCMAcceptantViewModel alloc] initWithParams:nil];
    }
    return _viewModel;
}
@end


// cellView

@interface IDCMAcceptantiCarouselCell ()

@property (nonatomic,strong) UILabel * coinNameLabel ;
@property (nonatomic,strong) UILabel * mountLabel ;
@property (nonatomic,strong) UIImageView * iconImageView;
@property (nonatomic,strong) UIImageView * backImageView;
@end

@implementation IDCMAcceptantiCarouselCell

-(instancetype) initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 4;
        self.layer.shadowColor = [UIColor colorWithHexString:@"#CCD7F1"].CGColor;//阴影颜色
        self.layer.shadowOffset = CGSizeMake(0,1);//偏移距离
        self.layer.shadowOpacity = 1;//不透明度
        self.layer.shadowRadius = 2.0;//半径
        [self addSubview:self.backImageView];
        [self addSubview:self.coinNameLabel];
        [self addSubview:self.mountLabel];
        [self addSubview:self.iconImageView];
        [self setupConstraints];

    }
    return self;
}

-(void)setModel:(IDCMAcceptantDepositModel *)model
{
    _model = model;
    if (model) {
        [self.iconImageView sd_setImageWithURL:[[NSURL alloc] initWithString:model.logo] placeholderImage:nil options:SDWebImageRefreshCached];
        self.coinNameLabel.text = model.coinNameUpperStr;
        self.mountLabel.text = [IDCMUtilsMethod  separateNumberUseCommaWith:model.useAmountStr];
        
        CGRect titleRect = [IDCMViewTools boundsWithFontSize:SetFont(@"PingFangSC-Medium", 14) text:model.coinNameUpperStr size:CGSizeMake(MAXFLOAT, 20)];
        CGFloat leftMargin = (self.frame.size.width - (20 + 4 + titleRect.size.width))/ 2.0;
        
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(leftMargin);
            make.top.equalTo(self).offset(10);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [self.coinNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.iconImageView.mas_centerY);
            make.right.equalTo(self);
            make.left.equalTo(self.iconImageView.mas_right).offset(4);
        }];
    }
}
-(void)setupConstraints{
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(15);
    }];
    

    [self.mountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(self);
        make.bottom.equalTo(self).offset(-10);
    }];
}
-(UILabel *)mountLabel{
    if (!_mountLabel) {
        _mountLabel = [[UILabel alloc] init];
        _mountLabel.textAlignment = NSTextAlignmentCenter;
        _mountLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _mountLabel.font = SetFont(@"PingFangSC-Regular", 14);
    }
    return _mountLabel;
}

-(UILabel *)coinNameLabel{
    if (!_coinNameLabel) {
        _coinNameLabel = [[UILabel alloc] init];
        _coinNameLabel.textAlignment = NSTextAlignmentLeft;
        _coinNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _coinNameLabel.font = SetFont(@"PingFangSC-Medium", 14);
    }
    return _coinNameLabel;
}

-(UIImageView *)iconImageView{
    
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _iconImageView;
}

-(UIImageView *)backImageView{
    
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.backgroundColor =  [UIColor yellowColor];
        _backImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _backImageView;
}
@end
