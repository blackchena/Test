//
//  IDCMSelectCountryController.m
//  IDCMExchange
//
//  Created by BinBear on 2017/12/6.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMSelectCountryController.h"
#import "IDCMCountryListModel.h"
#import "IDCMSelectCountryCell.h"
#import "IDCMSearchBar.h"

@interface IDCMSelectCountryController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
/**
 *  自定义nav
 */
@property (strong, nonatomic) UIImageView *navImageView;
/**
 *  标题
 */
@property (strong, nonatomic) UILabel *titlelable;
/**
 *  返回按钮
 */
@property (strong, nonatomic) UIButton *dismissButton;

/**
 *  列表
 */
@property (strong, nonatomic) IDCMTableView *tableView;
/**
 * 搜索
 */
@property (nonatomic, strong) IDCMSearchBar *searchBar;
/**
 * 搜索结果的数组
 */
@property (nonatomic, strong) NSMutableArray *searchArr;
/**
 * 头部
 */
@property (nonatomic, strong) UIView  *headView;

/**
 * 判断是搜索状态还是编辑状态
 */
@property (nonatomic, assign) BOOL isSearch;
/**
 * 记录搜索的关键字
 */
@property (nonatomic, copy) NSString  *searchKeyText;


/**
 *  国家列表
 */
@property (strong, nonatomic) NSMutableDictionary *countryData;
/**
 * 搜索结果的数组
 */
@property (nonatomic, strong) NSMutableArray *keys;
@end

static NSString *identifier = @"IDCMSelectCountryCell";

@implementation IDCMSelectCountryController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configStatusView];
    
    [self requestCountry];
}
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    [self.navImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(kNavigationBarHeight+kSafeAreaTop));
    }];
    [self.titlelable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.navImageView);
        make.bottom.equalTo(self.navImageView.mas_bottom).offset(-15);
        make.height.equalTo(@25);
    }];
    [self.dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.navImageView.mas_left).offset(15);
        make.centerY.equalTo(self.titlelable.mas_centerY);
        make.height.width.equalTo(@40);
    }];

    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.right.equalTo(self.headView);
        make.height.equalTo(@55);
    }];
    
}
#pragma mark - setView
- (void)configStatusView{
    
    self.view.backgroundColor = SetColor(235, 234, 240);
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopDisabled = YES;
    @weakify(self);
    [self.dismissButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:NO];
    }];
}
#pragma mark - NetWork
// 请求国家列表
- (void)requestCountry
{
    @weakify(self);
    NSData * josnData = [NSData dataWithContentsOfFile:[IDCMUtilsMethod getLanguagePath]];
    NSDictionary * response = [NSJSONSerialization JSONObjectWithData:josnData options:NSJSONReadingAllowFragments error:nil];
    [self.countryData removeAllObjects];
    [response[@"Data"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        NSDictionary *data = obj;
        NSString *titleKey = [NSString stringWithFormat:@"%@",data[@"Key"]];
        [self.keys addObject:titleKey];
        NSMutableArray *arr = @[].mutableCopy;
        [data[@"Data"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = obj;
            IDCMCountryListModel *model = [IDCMCountryListModel yy_modelWithDictionary:dic];
            [arr addObject:model];
        }];
        [self.countryData setValue:arr forKey:titleKey];
        [self.tableView reloadData];
    }];

}
#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isSearch) {
        return 1;
    }else{
        return self.keys.count;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isSearch) {

        return self.searchArr.count;
 
    }else{
        NSString *key = self.keys[section];
        
        return [self.countryData[key] count];
    }
 
}
//右侧的索引
- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.keys;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    IDCMSelectCountryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (self.isSearch) {
        IDCMCountryListModel *model = self.searchArr[indexPath.row];
        cell.model = model;
    }else{
        
        NSString *key = self.keys[indexPath.section];
        IDCMCountryListModel *model = self.countryData[key][indexPath.row];
        cell.model = model;
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSearch) {
        IDCMCountryListModel *model = self.searchArr[indexPath.row];
        if ([self.delegate respondsToSelector:@selector(selectCountryController:didAddContact:)]) {
            [self.delegate selectCountryController:self didAddContact:model];
        }
    }else{
        
        NSString *key = self.keys[indexPath.section];
        IDCMCountryListModel *model = self.countryData[key][indexPath.row];
        if ([self.delegate respondsToSelector:@selector(selectCountryController:didAddContact:)]) {
            [self.delegate selectCountryController:self didAddContact:model];
        }
    }
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor = SetColor(235, 234, 240);
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-15, 40)];
    lable.font = SetFont(@"PingFang-SC-Regular", 16);
    lable.textColor = [UIColor grayColor];
    [view addSubview:lable];
    if (self.isSearch) {
        lable.text = NSLocalizedString(@"2.0_SearchResults", nil);
    }else{
        lable.text = self.keys[section];
    }
    return view;
}
#pragma mark - UISearchBarDelegate

-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchText.length > 0) {
        self.isSearch = YES;
        
    }else{
        
        self.isSearch = NO;
        [searchBar resignFirstResponder];
    }
    [self.searchArr removeAllObjects];
    
    @weakify(self);
    
    [self.countryData enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        @strongify(self);
        NSArray *data = obj;
        if ([self.keys[0] isEqualToString:key]) {
            
        }else{
            
            [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                @strongify(self);
                IDCMCountryListModel *model = obj;
                if ([model.Name rangeOfString:searchText].location != NSNotFound) {
                    [self.searchArr addObject:model];
                }
            }];
        }
        
    }];
    
    [self.tableView reloadData];
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.searchBar resignFirstResponder];
}

#pragma mark - getter
- (IDCMTableView *)tableView
{
    return SW_LAZY(_tableView, ({
        
        CGFloat originY;
        if (isiPhoneX) {
            originY = 88;
        }else{
            originY = 64;
        }
        IDCMTableView *tableView = [[IDCMTableView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, SCREEN_HEIGHT  - originY) style:UITableViewStyleGrouped];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 50.0f;
        [tableView registerClass:[IDCMSelectCountryCell class] forCellReuseIdentifier:identifier];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.tableHeaderView = self.headView;
        tableView.tableFooterView = [UIView new];
        tableView.sectionFooterHeight = 0;
        tableView.sectionHeaderHeight = 40.0f;
        tableView.sectionIndexColor = [UIColor grayColor];
        tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        [self.view addSubview:tableView];
        tableView;
    }));
}
- (UIView *)headView
{
    return SW_LAZY(_headView, ({
        CGFloat originY;
        if (isiPhoneX) {
            originY = 88;
        }else{
            originY = 64;
        }
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, 55)];
        view.backgroundColor = SetColor(235, 234, 240);
        view;
    }));
}
- (IDCMSearchBar *)searchBar
{
    return SW_LAZY(_searchBar, ({
        IDCMSearchBar *view = [[IDCMSearchBar alloc] init];
        view.placeholder = NSLocalizedString(@"2.0_Search", nil);
        view.delegate = self;
        UIImage* searchBarBg = [IDCMUtilsMethod GetImageWithColor:SetColor(235, 234, 240) andHeight:32.0f];
        [view setBackgroundImage:searchBarBg];
        [view setBackgroundColor:[UIColor clearColor]];
        [self.headView addSubview:view];
        view;
    }));
}

- (UIImageView *)navImageView
{
    return SW_LAZY(_navImageView, ({
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"2.0_daohangtiaobai"];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.userInteractionEnabled = YES;
        [self.view addSubview:view];
        view;
    }));
}
- (UILabel *)titlelable
{
    return SW_LAZY(_titlelable, ({
        UILabel *view = [UILabel new];
        view.textColor = SetColor(51, 51, 51);
        view.font = SetFont(@"PingFang-SC-Medium", 18);
        view.text = NSLocalizedString(@"2.0_SelectCountryVC", nil);
        view.textAlignment = NSTextAlignmentCenter;
        [self.navImageView addSubview:view];
        view;
    }));
}
- (UIButton *)dismissButton
{
    return SW_LAZY(_dismissButton, ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:UIImageMake(@"2.0_fanhuihei") forState:UIControlStateNormal];
        [button setImage:UIImageMake(@"2.0_fanhuihei") forState:UIControlStateHighlighted];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.navImageView addSubview:button];
        button;
    }));
}
- (NSMutableArray *)searchArr
{
    return SW_LAZY(_searchArr, @[].mutableCopy);
}
- (NSMutableDictionary *)countryData
{
    return SW_LAZY(_countryData, @{}.mutableCopy);
}
- (NSMutableArray *)keys
{
    return SW_LAZY(_keys, @[].mutableCopy);
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

@end
