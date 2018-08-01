//
//  IDCMLocalLanguageController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/1.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMLocalLanguageController.h"
#import "IDCMLocalViewCell.h"
#import "NSBundle+Language.h"

@interface IDCMLocalLanguageController ()<UITableViewDelegate,UITableViewDataSource>

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
 *  本地语言
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

@implementation IDCMLocalLanguageController

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
    self.title = NSLocalizedString(@"2.0_Language", nil);
    
    self.logoArr = @[@"2.0_yingwen",@"2.0_zhongwen",@"2.0_fanti",@"2.0_riwen",@"2.0_hanyu",@"2.0_fayu",@"2.0_xibanya",@"2.0_helanyu",@"2.0_yuenanyu"];
    self.localArr = @[@"en",@"zh-Hans",@"zh-Hant",@"ja",@"ko",@"fr",@"nl",@"es",@"vi"];
    self.titleArr = @[@"English",@"简体中文",@"繁體中文",@"日本語",@"한국어",@"Français",@"Español",@"Nederlands",@"Tiếng Việt"];
    
    @weakify(self);
    [self.localArr enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        if ([[IDCMUtilsMethod getPreferredLanguage] isEqualToString:obj]) {
            self.slectIndex = idx;
        }
    }];
}
#pragma mark - bind
- (void)bindViewModel
{
    [super bindViewModel];

}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
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
    
    // 设置语言
    NSArray *arr = @[@"en",@"zh-Hans",@"zh-Hant",@"ja",@"ko",@"fr",@"es",@"nl",@"vi"];
    [NSBundle setLanguage:arr[indexPath.row]];
    
    [CommonUtils saveStrValueInUD:self.localArr[indexPath.row] forKey:LocalLanguageKey];
    self.slectIndex = indexPath.row;
    [self.tableView reloadData];
    
    [IDCM_APPDelegate setTabBarViewController];
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
