//
//  IDCMContactController.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/20.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMContactController.h"
#import "IDCMContactViewModel.h"
#import "IDCMContactListModel.h"

@interface IDCMContactController ()
/**
 *  bind ViewModel
 */
@property (strong, nonatomic, readonly) IDCMContactViewModel *viewModel;
/**
 *  tableVIew
 */
@property (strong, nonatomic) IDCMTableView *tableView;
/**
 *  headerView
 */
@property (strong, nonatomic) UIView *headerView;
/**
 *  tipsLabel
 */
@property (strong, nonatomic) UILabel *propertyLabel;
/**
 *  tableViewBindHelper
 */
@property (strong, nonatomic) IDCMTableViewBindHelper *tableViewBindHelper;
@end

@implementation IDCMContactController
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorWhite;
    self.title = NSLocalizedString(@"2.1_About_App", nil);
}

#pragma mark  -- bind
- (void)bindViewModel{
    
    [super bindViewModel];
    

    self.tableViewBindHelper = [IDCMTableViewBindHelper bindingHelperForTableView:self.tableView
                                                                     sourceSignal:RACObserve(self.viewModel, dataArr)
                                                                 selectionCommand:nil
                                                                     templateCell:@"IDCMContactMenueListCell"];
    
    [self.view addSubview:self.propertyLabel];

    [self.viewModel.requestDataCommand execute:nil];

}

#pragma mark - getter
- (IDCMTableView *)tableView{
    
    return SW_LAZY(_tableView, ({
        IDCMTableView *tableView = [[IDCMTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kNavigationBarHeight-kSafeAreaTop) style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = UIColorWhite;
        tableView.scrollEnabled = NO;
        tableView.rowHeight = 40;
        tableView.tableHeaderView =  self.headerView;
        [self.view addSubview:tableView];
        tableView;
    }));
}
- (UIView *)headerView{
    
    return SW_LAZY(_headerView, ({
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
        UIImageView *imageView = [UIImageView createImageViewWithSuperView:view contentMode:UIViewContentModeScaleAspectFit image:[UIImage imageNamed:@"2.1_contact_page_logo_icon"] clipsToBounds:YES];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(view.mas_top).offset(30);
            make.centerX.equalTo(view.mas_centerX);
            make.width.equalTo(@70);
            make.height.equalTo(@90);
        }];
        view;
    }));
}
- (UILabel *)propertyLabel{
    
    return SW_LAZY(_propertyLabel, ({
        UILabel *label = [UILabel createLabelWithTitle:@"©2017-2018 IDCW. All Rights Reserved." titleColor:textColor999999 font:textFontPingFangRegularFont(12) textAlignment:NSTextAlignmentCenter];
        label.frame = CGRectMake(0, SCREEN_HEIGHT-60-kSafeAreaBottom-kNavigationBarHeight-kSafeAreaTop, SCREEN_WIDTH, 25);
        label;
    }));
}

@end
