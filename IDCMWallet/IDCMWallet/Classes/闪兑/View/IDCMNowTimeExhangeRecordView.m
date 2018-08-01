//
//  IDCMNowTimeExhangeRecordView.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/7.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMNowTimeExhangeRecordView.h"
#import "IDCMCircleProgressView.h"
#import "IDCMPTCConfirmQuoteOrderModel.h"
#import "KVOMutableArray+ReactiveCocoaSupport.h"
#define KeyWindow [UIApplication sharedApplication].keyWindow

typedef void(^NowTimeExhangeRecordCellBlock)(UITableViewCell *cell);

@interface NowTimeExhangeRecordCell : UITableViewCell
@property (nonatomic,strong) UIView *customContentView;
@property (nonatomic,strong) UIView *leftDotView;
@property (nonatomic,strong) UILabel *leftTitleLabel;
@property (nonatomic,strong) UILabel *leftSubTitleLabel;
@property (nonatomic,strong) UILabel *centerTitleLabel;
@property (nonatomic,strong) IDCMCircleProgressView *rightTimeView;
@property (nonatomic,strong) UIButton *rightDeleteBtn;
@property (nonatomic,strong) IDCMNewOrderNoticeAcceptantModel * cellViewModel;
@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic,copy ) NowTimeExhangeRecordCellBlock nowTimeExhangeRecordCellBlock;
@end


@implementation NowTimeExhangeRecordCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initConfigure];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableview
                        indexPath:(NSIndexPath *)indexPath
                    cellViewModel:(IDCMNewOrderNoticeAcceptantModel *)cellViewModel{
    NowTimeExhangeRecordCell *cell = [tableview dequeueReusableCellWithIdentifier:NSStringFromClass(self)
                                                          forIndexPath:indexPath];

//    [[cell.rightDeleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        [deleteBtnCommand execute:cell];
//    }];
    cell.cellViewModel = cellViewModel;
    cell.indexPath = indexPath;
    [cell.rightTimeView refreshTotalCount:cellViewModel.defDeadLineSeconds];
    return cell;
}

- (void)btnClick{
    !self.nowTimeExhangeRecordCellBlock?:self.nowTimeExhangeRecordCellBlock(self);
}

- (void)reloadCellData{
    BOOL didOffer = self.cellViewModel.didOffer;
    BOOL didSelected = self.cellViewModel.didSelected;
    BOOL isBuy = self.cellViewModel.Direction == 1;
    self.leftDotView.hidden = didOffer || didSelected;
    self.rightTimeView.hidden = didSelected;
    self.rightDeleteBtn.hidden = didOffer || didSelected;
    self.leftTitleLabel.text = self.cellViewModel.UserName;
    NSString *didOffStr = [[NSString stringWithFormat:SWLocaloziString(@"3.0_JWAcceptance_DidOffer")] stringByReplacingOccurrencesOfString:@"[IDC]" withString:isBuy ? SWLocaloziString(@"3.0_JWAcceptance_Buyer"):SWLocaloziString(@"3.0_JWAcceptance_Seller") ] ;
    self.leftSubTitleLabel.text = didSelected ? SWLocaloziString(@"3.0_JWAcceptance_OfferDidSelected") : didOffer ? didOffStr : SWLocaloziString(@"3.0_JWAcceptance_NOOffer");
    
    NSString *num = [IDCMUtilsMethod precisionControl:self.cellViewModel.Num];
    NSString *str = [IDCMUtilsMethod separateNumberUseCommaWith:[NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:num] fractionDigits:4]];
    self.centerTitleLabel.text = [NSString stringWithFormat:@"%@ %@ %@",isBuy ? SWLocaloziString(@"3.0_JWAcceptance_Buy"):SWLocaloziString(@"3.0_JWAcceptance_Sell"),str,[self.cellViewModel.CoinCode uppercaseString]];
    
    self.centerTitleLabel.textColor = isBuy ? UIColorMake(41, 104, 185) : UIColorMake(254, 135, 48);
    
    [self refreshProgress];
    
}

-(void)refreshProgress{
    if (self.cellViewModel.DeadLineSeconds >= 0) {
        [self.rightTimeView refreshProgressWithCount:self.cellViewModel.DeadLineSeconds];
    }
}


- (void)initConfigure {
    [self configUI];
    [self configSignal];
}

- (void)configUI {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.customContentView];
    
//    self.leftTitleLabel.text = @"drameLL";
//    self.leftSubTitleLabel.text = @"说说到了我哈哈了哈勒";
//    self.centerTitleLabel.text = @"买3.23243BTC";
    
}

- (void)configSignal {
 
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat centerTitleWidth= [self.centerTitleLabel.text widthForFont:self.centerTitleLabel.font];
    CGFloat maxCenterTitleWidth =  (self.rightTimeView.left - (self.centerTitleLabel.centerX) - 12) * 2;
    
    if (centerTitleWidth > maxCenterTitleWidth) {
        centerTitleWidth = maxCenterTitleWidth;
    }
    self.centerTitleLabel.width = centerTitleWidth;
    self.leftTitleLabel.width = self.centerTitleLabel.left - self.leftTitleLabel.left - 12;
}

- (UIView *)customContentView {
    if (!_customContentView) {
        
        _customContentView = [[UIView alloc] init];
        _customContentView.backgroundColor = [UIColor whiteColor];
        _customContentView.frame = CGRectMake(12, 6, SCREEN_WIDTH - 24, 66);
        _customContentView.layer.cornerRadius = 4.0;
        _customContentView.layer.masksToBounds = YES;
        
        [_customContentView addSubview:self.leftDotView];
        [_customContentView addSubview:self.rightTimeView];
        [_customContentView addSubview:self.rightDeleteBtn];
        [_customContentView addSubview:self.centerTitleLabel];
        [_customContentView addSubview:self.leftTitleLabel];
        [_customContentView addSubview:self.leftSubTitleLabel];
    }
    return _customContentView;
}

- (UIView *)leftDotView {
    return SW_LAZY(_leftDotView, ({
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorMakeWithHex(@"#FF6666");
        view.size = CGSizeMake(8, 8 );
        view.left = 15;
        view.centerY = _customContentView.height / 2;
        view.layer.cornerRadius = view.width / 2;
        view.layer.masksToBounds = YES;
        view;
    }));
}
- (UIButton *)rightDeleteBtn {
    return SW_LAZY(_rightDeleteBtn, ({
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.size = CGSizeMake(16 + 14, 16 + 14);
        btn.centerY = _customContentView.height / 2;
        btn.right = _customContentView.width - 5 ;//- 15;
        [btn setImage:UIImageMake(@"3.2_Bin_AcceptanceCellClose")
             forState:UIControlStateNormal];
        [btn setImage:UIImageMake(@"3.2_Bin_AcceptanceCellClose")
             forState:UIControlStateHighlighted];
        [btn addTarget:self
                action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        btn;
    }));
}
- (IDCMCircleProgressView *)rightTimeView {
    return SW_LAZY(_rightTimeView, ({
        
        CGRect rect = CGRectMake(0, 0, 34, 34);
        IDCMCircleProgressView *view =
        [IDCMCircleProgressView circleProgressViewWithFrame:rect
                                                 totalCount:300
                                                 titleColor:[UIColor colorWithHexString:@"#3677C5"]
                                                  titleFont:textFontPingFangRegularFont(12)
                                            circleLineWidth:1
                                            circleBackColor:[UIColor colorWithHexString:@"#E4EEFC"]
                                                circleColor:[UIColor colorWithHexString:@"#2F4776"]
                                             finishCallback:nil];
        view.centerY = self.rightDeleteBtn.centerY;
        view.right = self.rightDeleteBtn.left - 18;
        view;
    }));
}
- (UILabel *)centerTitleLabel {
    return SW_LAZY(_centerTitleLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = kThemeColor;
        label.font = textFontPingFangMediumFont(14);
        label.height = 16;
        label.width = 100;
        label.centerX = _customContentView.width / 2 - 30;
        label.top = 15;
        label;
    }));
}
- (UILabel *)leftTitleLabel {
    return SW_LAZY(_leftTitleLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor333333;
        label.font = textFontPingFangRegularFont(14);
        label.height = 16;
        label.width = 65;
        label.centerY = self.centerTitleLabel.centerY;;
        label.left = self.leftDotView.right + 15;
        label;
    }));
}
- (UILabel *)leftSubTitleLabel {
    return SW_LAZY(_leftSubTitleLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor999999;
        label.font = textFontPingFangRegularFont(12);
        label.height = 14;
        label.width = self.rightTimeView.left - 12 - self.leftTitleLabel.left;
        label.left = self.leftTitleLabel.left;
        label.top = self.leftTitleLabel.bottom + 8;
        label;
    }));
}
- (void)dealloc {
    
}
@end


@interface IDCMNowTimeExhangeRecordView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong) UIView *blackView;
@property (nonatomic,strong) IDCMTableView *tableView;
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) UIButton *closeBtn;

@property (nonatomic,strong) KVOMutableArray <IDCMNewOrderNoticeAcceptantModel *>*dataArray;

@property (nonatomic,assign) BOOL didPop;

@property (nonatomic, assign) RACDisposable *otcNewestOrderDisposable;
@property (nonatomic, assign) RACDisposable *confirmQuoteOrderDisposable;
@property (nonatomic, assign) RACDisposable *otcOrderStatusChangeDisposable;

@property (assign, nonatomic) SystemSoundID soundID;
@end


@implementation IDCMNowTimeExhangeRecordView

//+ (IDCMNowTimeExhangeRecordView *)share{
//    static id shared = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        shared = [[IDCMNowTimeExhangeRecordView alloc] init];
//    });
//    return shared;
//}


- (instancetype)init{
    if (self = [super init]) {
        [self initConfigure];
        self.backgroundColor = [UIColor clearColor];
//        self.frame = KeyWindow.bounds;
//        [KeyWindow addSubview:self];
//        [KeyWindow bringSubviewToFront:self];
    }
    return self;
}

-(BOOL)isEmpty {
    return self.dataArray.count == 0;
}

- (NSString *)getCountString {
    return [self handleDataArrayCount:self.dataArray];
}

- (NSString *)handleDataArrayCount:(NSArray *)array{
    __block NSInteger count = 0;
    [array enumerateObjectsUsingBlock:^(IDCMNewOrderNoticeAcceptantModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.Status == 1 || obj.Status == 8) {
            count ++;
        }
    }];
    return [NSString stringWithFormat:@"%zd", count];
}

- (void)dealloc
{
    [self.otcNewestOrderDisposable dispose];
    [self.confirmQuoteOrderDisposable dispose];
    [self.otcOrderStatusChangeDisposable dispose];
}

- (void)initConfigure {
    [self configUI];
    @weakify(self);
    self.dataArray = [KVOMutableArray new];
    self.countSignal =
    [[self.dataArray changeSignal] map:^id(RACTuple *value) {
        @strongify(self);
        if (value.count) {
            NSMutableArray *array = (NSMutableArray *)value.first;
            return [self handleDataArrayCount:array];
        }
        return @"0";
    }];
    
    
    //下单推送到承兑商
    self.otcNewestOrderDisposable =  [[[IDCMOTCSignalRTool sharedOTCSignal].otcNewestOrderSubject deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
    
        if (self.dataArray.count >= 5) {
            return;
        }
        IDCMNewOrderNoticeAcceptantModel *model = [IDCMNewOrderNoticeAcceptantModel yy_modelWithJSON:x];
        if (!model) {
            return ;
        }
        if (model.DeadLineSeconds <= 0) {
            return;
        }
        if ([model.Num isEqualToNumber:@(0)]) {  // 推送过来的订单数据，如果数量为0，不处理. by BinBear
            return;
        }
        if(model.UserId == 0){
            return;
        }
        if (model.UserId == [IDCMDataManager sharedDataManager].userID.integerValue){//承兑商不能接受自己的买卖单
            return;
        }
        
        @synchronized(self){
            NSURL *soundURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/otc.mp3", [NSBundle mainBundle].resourcePath]];
            //DisposeSound
            AudioServicesDisposeSystemSoundID(_soundID);
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &_soundID);
            //PlaySound
            AudioServicesPlayAlertSound(_soundID);
            //            AudioServicesPlayAlertSoundWithCompletion(0, nil);
            
            [self.dataArray insertObject:model atIndex:0];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                                  withRowAnimation:UITableViewRowAnimationRight];
            
        }
        
    }];
    //(用户确认报价推送到承兑商)
    self.confirmQuoteOrderDisposable = [[[IDCMOTCSignalRTool sharedOTCSignal].confirmQuoteOrderSubject deliverOnMainThread] subscribeNext:^(NSDictionary *response) {

        @strongify(self);
        @synchronized(self) {
            IDCMPTCConfirmQuoteOrderModel *model = [IDCMPTCConfirmQuoteOrderModel yy_modelWithJSON:response];
            if (!model) {
                return ;
            }
            NSInteger acceptantUserId = model.AcceptantUserId;
            NSInteger orderId = model.OrderId;
            
            NSIndexPath *indexPath;
            BOOL isDelete = NO;
            for (NSUInteger i = 0; i < self.dataArray.count ; i++) {
                IDCMNewOrderNoticeAcceptantModel *model = self.dataArray[i];
                if (orderId == model.OrderID) {
                    indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    if ([[IDCMDataManager sharedDataManager].userID integerValue] == acceptantUserId) {
                        model.didOffer = YES;
                        model.didSelected = YES;
                    }
                    else{
                        isDelete = YES;
                    }
                    break;
                }
            }
            if (indexPath){//如果有ID
                if(isDelete){//选中别人的报价
                    [self removeModel:indexPath];
                }
                else {//选中自己的报价
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                          withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }
    }];
    //订单状态变更通知到承兑商
    self.otcOrderStatusChangeDisposable =  [[[IDCMOTCSignalRTool sharedOTCSignal].otcOrderStatusChangeSubject deliverOnMainThread] subscribeNext:^(NSDictionary *response) {
        
        @strongify(self);
        @synchronized(self) {
            
            if (response &&
                [response isKindOfClass:[NSDictionary class]]) {
                NSString *statusCode = [NSString idcw_stringWithFormat:@"%@",response[@"Status"]];
                
                NSInteger status = [statusCode integerValue];
                if (status != 7 && status != 8 && status != 9  && status != 12) {
                    return ;
                }
                //订单处理完成 ，删除
                NSString *orderIDCode = [NSString idcw_stringWithFormat:@"%@",response[@"OrderID"]];
                NSInteger orderId = [orderIDCode integerValue];
                NSIndexPath *indexPath;
                for (NSUInteger i = 0; i < self.dataArray.count ; i++) {
                    IDCMNewOrderNoticeAcceptantModel *model = self.dataArray[i];
                    if (orderId == model.OrderID) {
                        indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                        break;
                    }
                }
                if (indexPath){//如果有ID
                    [self removeModel:indexPath];
                }
            }
        }
    }];
    
    
    //定时
    [[[IDCMDataManager sharedDataManager].oneSecondSubject deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (self.dataArray.count == 0) {
            return ;
        }
        @synchronized(self) {
            
            NSMutableArray *arr = @[].mutableCopy;
            for (NSUInteger i = 0; i < self.dataArray.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                NowTimeExhangeRecordCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                cell.cellViewModel.DeadLineSeconds -= 1;
                cell.cellViewModel.DeadLineSeconds = MAX(0, cell.cellViewModel.DeadLineSeconds);
                if(cell.cellViewModel.didSelected){//已经选中
                    
                }
                else{//未选中
                    [cell refreshProgress];
//                    if (cell.cellViewModel.didOffer) {//已经报价
//
//                    }
                    if (cell.cellViewModel.DeadLineSeconds <= 0) {
                        [arr addObject: indexPath];
                    }
                }
            }
            if(arr.count > 0){
                NSMutableIndexSet *set = [[NSMutableIndexSet alloc]init];
                for (NSIndexPath *indexPath in arr) {
                    [set addIndex:indexPath.row];
                }
                [self.dataArray removeObjectsAtIndexes:set];
                [self.tableView deleteRowsAtIndexPaths:arr
                                      withRowAnimation:UITableViewRowAnimationLeft];
                if([self isEmpty]){
                    [self.closeBtn.rac_command execute:self.closeBtn];
                }
            }
        }
            
        
    }];
    
    [self fetchHisCallback:nil];
}

- (void)fetchHisCallback:(void(^)(void))callback{
    //请求历史数据
    [IDCMRequestList requestPostAuthNoHUD:GetOtcOfferList_URL params:@{} success:^(NSDictionary *response) {
        NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
        
        if ([status isEqualToString:@"100"]) {
            
        }else{
            if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSArray class]]) {
//                self.dataArray = @[].mutableCopy;
                [self.dataArray removeAllObjects];
                NSArray *datas = [NSArray yy_modelArrayWithClass:[IDCMNewOrderNoticeAcceptantModel class] json:response[@"data"]];
                for (NSInteger i = 0 ; i < datas.count; i ++) {
                    IDCMNewOrderNoticeAcceptantModel *model = datas[i];
                    // 推送过来的订单数据，如果数量为0，不处理. by BinBear
                    if ([model.Num isEqualToNumber:@(0)]) {
                        continue;
                    }
                    //承兑商不能接受自己的买卖单
                    if (model.UserId != 0 && model.UserId == [IDCMDataManager sharedDataManager].userID.integerValue){
                        continue;
                    }
                    //已经完成的干掉
                    NSUInteger status = model.Status;
                    //                    if (status == 7 || status == 8 || status == 9 || status == 12) {
                    //                        continue;
                    //                    }
                    if (status == 2 || status == 4 || status == 5) {
                        continue;
                    }
                    model.didOffer = model.Status == 1;
                    if (model.didOffer) {
                        //过滤 已经报价，但是用户选择了他人的报价
                        if (model.AcceptantId != 0 && model.AcceptantId != [IDCMDataManager sharedDataManager].userID.integerValue) {
                            continue;
                        }
                    }
                    model.didSelected = model.Status == 6;
                    if (!model.didSelected && model.defDeadLineSeconds <= 0) {//用户未选中，且倒计时结束
                        continue;
                    }
                    [self.dataArray addObject:model];
                    if (self.dataArray.count >=5) {
                        break;
                    }
                }
//                if (self.dataArray.count == 0) {
//                    [self dismissWithCompletion:nil];
//                }
                [self.tableView reloadData];
            }
        }
        !callback?:callback();
    } fail:^(NSError *error, NSURLSessionDataTask *task) {
        !callback?:callback();
    }];
    
}


- (void)removeModel:(NSIndexPath *)indexPath{
    if (indexPath==nil) {
        return;
    }
    @synchronized(self) {
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationLeft];
        if([self isEmpty]){
            [self.closeBtn.rac_command execute:self.closeBtn];
        }
    }
}

- (void)configUI {
    [self addSubview:self.blackView];
    [self addSubview:self.tableView];
    [self addSubview:self.tipLabel];
    [self addSubview:self.closeBtn];
    
    self.alpha = 0;
}

- (void)showWithDismissCallback:(void(^)(void))dismissCallback  {
    @weakify(self);
    [self.superview bringSubviewToFront:self];
    CommandInputBlock (^dismiss)(btnAction action) = ^(btnAction action){
        return ^(id input){
            @strongify(self);
            [self dismissWithCompletion:action];
        };
    };
    self.closeBtn.rac_command = RACCommand.emptyCommand(dismiss(dismissCallback));

    self.alpha = 0;
    [self.tableView reloadData];
//    self.tableView.hidden = YES;
//    [[RACScheduler mainThreadScheduler] afterDelay:.03 schedule:^{
//        self.tableView.hidden = NO;
//        [IDCMTableViewAnimationKit showWithAnimationType:1 tableView:self.tableView];
//    }];
    
    [UIView animateWithDuration:0.25
                          delay:.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)dismissWithCompletion:(void(^)(void))completion {
//    [self dismissTableViewWithCompletion:^{
        [UIView animateWithDuration:0.15
                              delay:.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             completion ? completion() : nil;
                         }];
//    }];
}

- (void)dismissTableViewWithCompletion:(void(^)(void))completion {
    NSArray *cells = self.tableView.visibleCells;
    for (int i = 0; i < cells.count; i++) {
        CGFloat totalTime = 0.4;
        UITableViewCell *cell = [cells objectAtIndex:i];
        [UIView animateWithDuration:0.4 delay:i*(totalTime/cells.count) usingSpringWithDamping:0 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            cell.transform = CGAffineTransformMakeTranslation(-SCREEN_WIDTH, 0);
        } completion:^(BOOL finished) {
            
        }];
    }
    [[RACScheduler mainThreadScheduler] afterDelay:.25 schedule:^{
        completion ? completion() : nil;
    }];
}



#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @weakify(self);
    NowTimeExhangeRecordCell *cell = [NowTimeExhangeRecordCell cellWithTableView:tableView
                                                                       indexPath:indexPath
                                                                   cellViewModel:self.dataArray[indexPath.row]];
    cell.nowTimeExhangeRecordCellBlock = ^(UITableViewCell *cell) {
        @strongify(self);
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        IDCMNewOrderNoticeAcceptantModel *model = self.dataArray[indexPath.row];
        //请求历史数据
        NSString *url = [NSString stringWithFormat:@"%@?id=%@",OTCCancelQuoteOrder_URL,@(model.OrderID)];
        [IDCMRequestList requestAuth:url params:nil success:^(NSDictionary *response) {
            NSInteger status = [response[kStatus] integerValue];
            if (status == 1) {
                [self removeModel:indexPath];
            }
            else{
                [IDCMShowMessageView showMessageWithCode:[NSString stringWithFormat:@"%zd",status]];
            }
        } fail:^(NSError *error, NSURLSessionDataTask *task) {
            
        }];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(NowTimeExhangeRecordCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell reloadCellData];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.closeBtn.rac_command execute:self.closeBtn];
    IDCMNewOrderNoticeAcceptantModel *model = self.dataArray[indexPath.row];
    @weakify(self);

    if (model.didSelected) {
        NSDictionary *dict = @{@"orderId" :@(model.OrderID)};
        [IDCMMediatorAction idcm_pushViewControllerWithClassName:@"IDCMOTCExchangeDetailController"
                                               withViewModelName:@"IDCMOTCExchangeDetailViewModel"
                                                      withParams:dict
                                                        animated:YES];
    }
    else{

    [IDCMMediatorAction idcm_pushViewControllerWithClassName:@"IDCMOTCAcceptanceOrderDetailController"
                                           withViewModelName:@"IDCMOTCACceptanceOrederDetailViewModel"
                                                  withParams:@{@"model":self.dataArray[indexPath.row]}
                                                    animated:YES
                                                  completion:^(NSDictionary *para) {
                                                      @strongify(self);
                                                      NSNumber *orderID = para[@"OrderID"];
                                                      for (IDCMNewOrderNoticeAcceptantModel *model in self.dataArray) {
                                                          if (orderID.integerValue == model.OrderID) {
                                                              model.didOffer = YES;
                                                              break;
                                                          }
                                                      }
                                                          [self.tableView reloadData];
                                                      }];
    }

}
- (IDCMTableView *)tableView {
    return SW_LAZY(_tableView, ({
        
        CGFloat rowHeight = 72.0;
        CGFloat tableViewH = rowHeight * 5;
        CGRect rect = CGRectMake(0,
                                 SCREEN_HEIGHT - 49 - kSafeAreaBottom - tableViewH,
                                 SCREEN_HEIGHT,
                                 tableViewH);
        IDCMTableView *tableView = [[IDCMTableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = rowHeight;
        tableView.bounces = NO;
        tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        tableView.backgroundColor = [UIColor clearColor];
        [tableView registerCellWithCellClass:[NowTimeExhangeRecordCell class]];
        tableView.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero];
        tableView;
    }));
}

- (UIView *)blackView {
    return SW_LAZY(_blackView, ({
        
        UIView *view = [[UIView alloc] initWithFrame:KeyWindow.bounds];
        view.backgroundColor = [UIColor colorWithWholeRed:0 green:0 blue:0 alpha:.5];
        view;
    }));
}

- (UILabel *)tipLabel {
    return SW_LAZY(_tipLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorMakeWithHex(@"#FF925E");
        label.font = textFontPingFangRegularFont(12);
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.text = NSLocalizedString(@"3.0_NowTimeExhangeRecordTip", nil);
        label.width = SCREEN_WIDTH - 24;
        label.height = [label.text heightForFont:label.font width:(label.width - 10)];
        label.left = 12;
        label.bottom = self.tableView.top - 5;
        label;
    }));
}

- (UIButton *)closeBtn {
    return SW_LAZY(_closeBtn, ({
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.size = CGSizeMake(38, 38);
        btn.bottom = self.tipLabel.top - 15;
        btn.centerX = self.tipLabel.centerX;
        [btn setBackgroundImage:UIImageMake(@"3.2_Bin_AcceptanceCloseButton") forState:UIControlStateNormal];
        [btn setBackgroundImage:UIImageMake(@"3.2_Bin_AcceptanceCloseButton") forState:UIControlStateHighlighted];
        btn;
    }));
}



@end








