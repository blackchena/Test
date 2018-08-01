//
//  IDCMLocalCurrencyController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/1.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMLocalCurrencyController.h"

#import "IDCMLocalViewCell.h"
#import "IDCMUserInfoModel.h"

@interface IDCMLocalCurrencyController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMLocalCurrencyViewModel *viewModel;

/**
 *  列表
 */
@property (strong, nonatomic) IDCMTableView *tableView;
/**
 *  图标
 */
@property (strong, nonatomic) NSArray *logoArr;
/**
 *  标题
 */
@property (strong, nonatomic) NSArray *titleArr;
/**
 *  本地货币
 */
@property (strong, nonatomic) NSArray *localArr;
/**
 *  选中的
 */
@property (assign, nonatomic) NSUInteger slectIndex;
/**
 *  选中的
 */
@property (assign, nonatomic) NSUInteger tempIndex;
@end

@implementation IDCMLocalCurrencyController
@dynamic viewModel;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBaseData];
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(12);
    }];
}
- (void)configBaseData
{
    self.view.backgroundColor = viewBackgroundColor;
    self.title = NSLocalizedString(@"2.0_SetCurency", nil);
    
    self.logoArr = @[@"2.0_meiyuan",@"2.0_ouyuan",@"2.0_renminbi",@"2.0_gangbi",@"2.0_riyuan",@"2.0_hanyuan",@"2.0_yingbang",@"2.0_yuenandun"];
    self.titleArr = @[NSLocalizedString(@"2.0_meiyuan", nil),NSLocalizedString(@"2.0_ouyuan", nil),NSLocalizedString(@"2.0_renminbi", nil),NSLocalizedString(@"2.0_gangbi", nil),NSLocalizedString(@"2.0_riyuan", nil),NSLocalizedString(@"2.0_hangyuan", nil),NSLocalizedString(@"2.0_yingbang", nil),NSLocalizedString(@"2.0_yuenandun", nil)];
    self.localArr = @[@"USD",@"EUR",@"CNY",@"HKD",@"JPY",@"KRW",@"GBP",@"VND"];
    

}
#pragma mark - bind
- (void)bindViewModel
{
    [super bindViewModel];
    
    @weakify(self);

    
    // 设置货币
    [[[self.viewModel.setLocalCurrencyCommand.executionSignals switchToLatest]
      deliverOnMainThread]
     subscribeNext:^(NSDictionary *response) {
         @strongify(self);
         NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
         if ([status isEqualToString:@"1"] && ![response[@"data"] isKindOfClass:[NSNull class]] && response[@"data"] != nil) {
             
             self.slectIndex = self.tempIndex;
             [self.tableView reloadData];
             [CommonUtils saveStrValueInUD:self.localArr[self.slectIndex] forKey:LocalCurrencyNameKey];
             [IDCM_APPDelegate setTabBarViewController];
         }else{
             [IDCMShowMessageView showErrorWithMessage:NSLocalizedString(@"2.0_SetCurrencyFail", nil)];
         }
         
     }];
    
    // 获取设置后的货币
    [[[self.viewModel.requestDataCommand.executionSignals switchToLatest]
       deliverOnMainThread]
      subscribeNext:^(NSDictionary *response) {
          @strongify(self);
          NSString *status= [NSString stringWithFormat:@"%@",response[@"status"]];
          if ([status isEqualToString:@"1"] && [response[@"data"] isKindOfClass:[NSArray class]]) {
              NSString __block *currencyName = @"";
              [response[@"data"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                  if ([obj[@"option"] integerValue] == 1) {
                      currencyName = obj[@"name"];
                  }
              }];
              
              [self.localArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                  if ([currencyName isEqualToString:obj]) {
                      self.slectIndex = idx;
                  }
              }];
              
              [self.tableView reloadData];
              
          }
      }];
    
    [self.viewModel.requestDataCommand execute:nil];
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IDCMLocalViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IDCMLocalViewCell"];
    
    cell.localLogo.image = [UIImage imageNamed:self.logoArr[indexPath.row]];
    cell.contentLabel.text = self.titleArr[indexPath.row];
    
    if (self.slectIndex == indexPath.row) {
        cell.selectLogo.image = [UIImage imageNamed:@"2.0_xuanzhong"];
    }else{
        cell.selectLogo.image = [UIImage imageNamed:@"2.0_weixuanzhong"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.tempIndex = indexPath.row;
    [self.viewModel.setLocalCurrencyCommand execute:self.localArr[indexPath.row]];
    
}
#pragma mark - getter
- (IDCMTableView *)tableView
{
    return SW_LAZY(_tableView, ({
        
        IDCMTableView *view = [[IDCMTableView alloc] init];
        view.backgroundColor = viewBackgroundColor;
        view.delegate = self;
        view.dataSource = self;
        view.rowHeight = 46.0f;
        view.separatorStyle = UITableViewCellSeparatorStyleNone;
        view.tableFooterView =[[UIView alloc]initWithFrame:CGRectZero];
        [view registerNib:[UINib nibWithNibName:@"IDCMLocalViewCell" bundle:nil] forCellReuseIdentifier:@"IDCMLocalViewCell"];
        [self.view addSubview:view];
        view;
    }));
}

@end
