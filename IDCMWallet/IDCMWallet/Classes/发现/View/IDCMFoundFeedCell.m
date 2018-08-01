//
//  IDCMFoundFeedCell.m
//  IDCMWallet
//
//  Created by BinBear on 2018/5/22.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMFoundFeedCell.h"
#import "IDCMFoundDappModel.h"


@interface IDCMFoundFeedCell ()
/**
 *  背景view
 */
@property (strong, nonatomic) UIImageView *bgView;
/**
 *  标题
 */
@property (strong, nonatomic) UILabel *titleLabel;
/**
 *  collectionView
 */
@property (strong, nonatomic) UICollectionView *collectionView;
/**
 *  BindHelper
 */
@property (strong, nonatomic) IDCMCollectionViewBindHelper *collectionViewBindHelper;
/**
 *  数据源
 */
@property (strong, nonatomic) NSArray *data;
/**
 *  dapp授权command
 */
@property (strong, nonatomic) RACCommand *dappAuthorizationCommand;
/**
 *  dapp是否授权command
 */
@property (strong, nonatomic) RACCommand *dappReadCommand;
/**
 *  dapp的model
 */
@property (strong, nonatomic) IDCMDappModel *dappModel;
@end

@implementation IDCMFoundFeedCell

#pragma mark - Life Cycle
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initUI];
        [self bindData];
    }
    return self;
}


#pragma mark - Public Methods


#pragma mark - Privater Methods
- (void)initUI{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.collectionView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(12, 12, 12, 12));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.bgView.mas_top).offset(10);
        make.height.equalTo(@25);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(14);
        make.height.greaterThanOrEqualTo(@103);
        make.left.equalTo(self.bgView.mas_left).offset(14);
        make.right.equalTo(self.bgView.mas_right).offset(-14);
    }];
}
- (void)bindData{
    
    
    @weakify(self);
    // dapp是否授权
    self.dappReadCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        @strongify(self);
        IDCMDappModel *model = input;
        self.dappModel = model;
        NSString *isReadURL = [NSString idcw_stringWithFormat:@"%@?dappId=%@",DappIsRead_URL,model.ID];
        return [RACSignal signalGetAuth:isReadURL serverName:nil params:nil handleSignal:nil];
    }];
    
    // Dapp授权
    self.dappAuthorizationCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        NSString *authorizationURL = [NSString idcw_stringWithFormat:@"%@?dappId=%@",MarkDappAsRead_URL,self.dappModel.ID];
        return [RACSignal signalGetNoHUDAuth:authorizationURL serverName:nil params:nil handleSignal:nil];
    }];
    
    // 监听是否授权Command
    [[self.dappReadCommand.executionSignals.switchToLatest deliverOnMainThread]
     subscribeNext:^(id  _Nullable value) {
         @strongify(self);
         NSString *status = [NSString idcw_stringWithFormat:@"%@",value[@"status"]];
         if ([status isEqualToString:@"1"] && [value[@"data"] isKindOfClass:[NSNumber class]]) {
             if ([value[@"data"] boolValue]) { // 已授权
                 [self pushDappGame];
             }else{ // 未授权
                 
                 NSAttributedString *attr =
                 [[NSAttributedString alloc] initWithString:SWLocaloziString(@"3.0_Bin_Authorization")
                                                 attributes:@{
                                                              NSFontAttributeName : textFontPingFangMediumFont(16),
                                                              NSForegroundColorAttributeName : textColor333333
                                                              }];
                 NSString *subTitle = [NSString idcw_stringWithFormat:@"%@ %@",self.dappModel.DappName,SWLocaloziString(@"3.0_Bin_ApplyID")];
                 [IDCMCenterTipView showWithConfigure:^(IDCMCenterTipViewConfigure *configure) {
                     @strongify(self);
                     configure
                     .topTitle(attr)
                     .subTitle(subTitle)
                     .image(RACTuplePack(self.dappModel.LogoUrl, @(CGSizeMake(60, 60))))
                     .getBtnsConfig.firstObject.btnTitle(SWLocaloziString(@"3.0_Bin_Refused"));
                     
                     configure.getBtnsConfig.lastObject.btnTitle(SWLocaloziString(@"3.0_Bin_Allow")).btnCallback(^{
                         @strongify(self);
                         [self.dappAuthorizationCommand execute:nil];
                     });
                 }];
             }
         }else{  // 请求失败
             [IDCMShowMessageView showMessageWithCode:status];
         }
     }];
    // 监听授权Command
    [[self.dappAuthorizationCommand.executionSignals.switchToLatest deliverOnMainThread]
     subscribeNext:^(id  _Nullable value) {
         @strongify(self);
         NSString *status = [NSString idcw_stringWithFormat:@"%@",value[@"status"]];
         if ([status isEqualToString:@"1"] && [value[@"data"] isKindOfClass:[NSNumber class]]) {
             if ([value[@"data"] boolValue]) { // 授权成功
                 
                 [self pushDappGame];
                 
             }else{ // 授权失败
                 [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"3.0_Bin_AuthorizationFail")];
             }
         }else{  // 授权失败
             [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"3.0_Bin_AuthorizationFail")];
         }
     }];
    
    
    self.collectionViewBindHelper = [IDCMCollectionViewBindHelper bindingHelperForCollectionView:self.collectionView
                                                                                    sourceSignal:RACObserve(self, data)
                                                                                selectionCommand:self.dappReadCommand
                                                                                    templateCell:@"IDCMFoundDAPPItemCell"];
}
- (void)pushDappGame{
    
    NSString *url = @"";
    if ([self.dappModel.Url isNotBlank]) {
        IDCMUserInfoModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserModelArchiverkey];
        url = [NSString idcw_stringWithFormat:@"%@?openid=%@",self.dappModel.Url,[model.guid base64EncodedString]];
    }

    [IDCMMediatorAction idcm_pushViewControllerWithClassName:@"IDCMDappViewController"
                                           withViewModelName:@"IDCMDappViewModel"
                                                  withParams:@{@"requestURL":url}
                                                    animated:YES];
}
#pragma mark - Action
- (void)bindViewModel:(id)viewModel{
    
    IDCMFoundDappModel *model = viewModel;
    NSMutableArray *arr = @[].mutableCopy;
    [model.DappList enumerateObjectsUsingBlock:^(IDCMDappModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObject:obj];
    }];
    self.data = [NSArray arrayWithArray:arr];
    self.titleLabel.text  = model.ModuleName;
}

#pragma mark - Getter & Setter
- (UILabel *)titleLabel
{
    return SW_LAZY(_titleLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangMediumFont(16);
        label.textColor = UIColorMake(46, 64, 107);
        label.textAlignment = NSTextAlignmentCenter;
        label;
    }));
}
- (UIImageView *)bgView
{
    return SW_LAZY(_bgView,({
        UIImageView *view = [UIImageView new];
        view.image = UIImageMake(@"3.0_Found_BG");
        view.userInteractionEnabled = YES;
        view.clipsToBounds = YES;
        view;
    }));
}
- (UICollectionView *)collectionView{
    return SW_LAZY(_collectionView, ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(70, 103);
        layout.minimumLineSpacing = (SCREEN_WIDTH-332)/3;
        UICollectionView *view = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        view.pagingEnabled = YES;
        view.showsHorizontalScrollIndicator = NO;
        view.showsVerticalScrollIndicator = NO;
        view.backgroundColor = [UIColor clearColor];
        view;
    }));
}
@end
