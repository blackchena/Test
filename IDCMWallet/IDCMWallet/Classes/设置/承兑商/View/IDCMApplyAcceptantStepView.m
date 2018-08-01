//
//  IDCMApplyAcceptantStepOneView.m
//  IDCMWallet
//
//  Created by wangpu on 2018/4/13.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMApplyAcceptantStepView.h"

#import "IDCMAcceptVariableModel.h"
#import "IDCMAcceptVariableCell.h"
#import "IDCMAcceptantSectionHeadView.h"
#import "IDCMCurrencyAndPayTypeCell.h"

@interface IDCMApplyAcceptantStepView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * mainTableView;
@property (nonatomic,strong) UIButton * bottomNextBtn ;
@property (nonatomic,strong) IDCMAcceptVariableModel * currentSpreadCellModel;
@property (nonatomic,strong) NSIndexPath * currentSpreadCellIndex;
@property (nonatomic,assign) BOOL nextStepEnable;
@end

@implementation IDCMApplyAcceptantStepView


+ (instancetype)applyAcceptantStepViewWithFrame:(CGRect)frame type:(NSInteger) type  subTitles:(NSArray *)subTitles

                                 completeSignal:(RACSubject *)nextSignal{
    IDCMApplyAcceptantStepView * stepView = [[IDCMApplyAcceptantStepView alloc] initWithFrame:frame];
    stepView.type = type;
    stepView.sectionHeaderSubTitles = subTitles;
    stepView.nextSignal = nextSignal;
    [stepView configView];
    return stepView;
}

-(void)configView{
   
    [self setSignals];
    [self initUIView];
    [self setConstrains];
}

-(void)initUIView{
    
    [self addSubview:self.mainTableView];
    self.mainTableView.tableFooterView = [self footView];
    UIView * headerView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12)];
    headerView.backgroundColor = [UIColor clearColor];
    self.mainTableView.tableHeaderView = headerView;
}

-(void)setConstrains{
    
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

-(void)setSignals{
    
     @weakify(self);
    if (self.nextSignal) {
        [[self.bottomNextBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            
            [self.nextSignal sendNext:nil];
        }];
    }
    self.deleteSubject  = [RACSubject subject];
    self.editSubject  = [RACSubject subject];
    self.sectionHeaderSubject = [RACSubject subject];
}
-(void)reloadView{
    
    if (self.sectionOneArray.count>0  && self.sectionTwoArray.count >0) {
        [self setNextStepEnable:YES];
    }else{
        [self setNextStepEnable:NO];
    }
    
    self.currentSpreadCellIndex = nil;
    [self.mainTableView reloadData];
}

#pragma mark - TableViweDelegate
#pragma mark - tabelViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    if (section == 0) {
        return self.sectionOneArray.count;
    }else{
        return self.sectionTwoArray.count;
    }
    return 0;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        IDCMAcceptVariableModel * model =self.sectionOneArray[indexPath.row];
        if (model.cellSpread) {
            return 90;
        }
    }else if(indexPath.section == 1){
        
        if (self.type == 2) {
            IDCMAcceptVariableModel * model =self.sectionTwoArray[indexPath.row];
            if (model.cellSpread) {
                return 90;
            }
        }
    }
    return  46;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell = nil;
    @weakify(self);
    
    if (self.type == 2) {
        NSString *identifier = @"IDCMAcceptVariableCell";
        IDCMAcceptVariableCell *tableViewcell = [[IDCMAcceptVariableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        tableViewcell.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        IDCMAcceptVariableModel * model  = nil;
        if (indexPath.section ==0) {
            model = self.sectionOneArray[indexPath.row];
        }else{
             model = self.sectionTwoArray[indexPath.row];
        }
        tableViewcell.cellModel = model ;
        //
        tableViewcell.callBack = ^{
            
            @strongify(self);
            [self refreshCells:model indexPath:indexPath];
        };
        //
        tableViewcell.bottomBtnCallBack = ^(NSString *type) {
            @strongify(self);
            if ([type isEqualToString:@"delete"]) {
                [self.deleteSubject  sendNext:model];
            }else{
                [self.editSubject  sendNext:model];
            }
        };
        cell =tableViewcell;
        
    }else if(self.type  == 1){
        
        if (indexPath.section == 0) {
            NSString *identifier = @"IDCMAcceptVariableCell";
            IDCMAcceptVariableCell *tableViewcell = [[IDCMAcceptVariableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            IDCMAcceptVariableModel * model = self.sectionOneArray[indexPath.row];
            tableViewcell.cellModel = model;
            tableViewcell.callBack = ^{
                @strongify(self);
                [self refreshCells:model indexPath:indexPath];
            };
            tableViewcell.bottomBtnCallBack = ^(NSString *type) {
                @strongify(self);
                if ([type isEqualToString:@"delete"]) {
                    [self.deleteSubject  sendNext:model];
                }else{
                    [self.editSubject  sendNext:model];
                }
            };
            cell = tableViewcell;
        }else{
            
            NSString *identifier = @"IDCMCurrencyAndPayTypeCell";
            IDCMCurrencyAndPayTypeCell *tableViewcell = [[IDCMCurrencyAndPayTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            IDCMAcceptVariableModel * model = self.sectionTwoArray[indexPath.row];
            [tableViewcell updateWithModel:model];
            
            tableViewcell.cellCallBack = ^{
                @strongify(self);
                [self.deleteSubject  sendNext:model];
            };
            cell = tableViewcell;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    return cell;
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    @weakify(self);
    IDCMAcceptantSectionHeadView * sectionHeaderView = nil;
    if (section == 0) {
        
        sectionHeaderView = [[IDCMAcceptantSectionHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) titles:self.sectionHeaderTitles.firstObject callBack:^(NSInteger section) {
                @strongify(self);
                [self.sectionHeaderSubject sendNext:@{@"section":@"0",@"direction":[NSNumber numberWithInteger:self.type]}];
            }];
        if (self.sectionOneArray.count == 0) {
            [sectionHeaderView setSubTitle:self.sectionHeaderSubTitles.firstObject];
        }else{
            [sectionHeaderView setSubTitle:nil];
        }
        
    }else{
        
        sectionHeaderView = [[IDCMAcceptantSectionHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) titles:self.sectionHeaderTitles.lastObject callBack:^(NSInteger section) {
                @strongify(self);
                [self.sectionHeaderSubject sendNext:@{@"section":@"1",@"direction":[NSNumber numberWithInteger:self.type]}];
        }];
        if (self.sectionTwoArray.count == 0) {
            [sectionHeaderView setSubTitle:self.sectionHeaderSubTitles.lastObject];
        }else{
            [sectionHeaderView setSubTitle:nil];
        }
    }
    sectionHeaderView.sectionIndex = section;
    
    return sectionHeaderView;
}

//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        NSArray  * titles = self.sectionHeaderTitles.firstObject;
        CGRect textRectFirst = [titles[1] boundingRectWithSize:CGSizeMake(0.264 * SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:SetFont(@"PingFangSC-Regular", 12)} context:nil];
        CGRect textRectSecond = [titles[2] boundingRectWithSize:CGSizeMake(0.41 * SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:SetFont(@"PingFangSC-Regular", 12)} context:nil];
        CGRect textRectThird = [titles.lastObject boundingRectWithSize:CGSizeMake(0.15 * SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:SetFont(@"PingFangSC-Regular", 12)} context:nil];
        CGFloat differ = MAX(MAX(textRectFirst.size.height, textRectSecond.size.height), textRectThird.size.height) - 17 ;
        CGFloat height = 68 + differ ;
        if (self.sectionOneArray.count == 0) {
            height =  115 + differ ;
        }
        return  height;
    }else{
        NSArray  * titles = self.sectionHeaderTitles.lastObject;
        
        CGRect textRectTitle = [titles.firstObject boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:SetFont(@"PingFangSC-Regular", 14)} context:nil];
        CGFloat  titleDiffer =textRectTitle.size.height - 20;
        CGRect textRectFirst = [titles[1] boundingRectWithSize:CGSizeMake(0.264 * SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:SetFont(@"PingFangSC-Regular", 12)} context:nil];
        CGRect textRectSecond = [titles.lastObject boundingRectWithSize:CGSizeMake(0.41 * SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:SetFont(@"PingFangSC-Regular", 12)} context:nil];
        CGFloat  differ  = MAX(textRectFirst.size.height, textRectSecond.size.height) + titleDiffer -17;
        CGFloat  height = 68 + differ;
        if (self.sectionTwoArray.count == 0) {
            height =  115 + differ;
        }
        return height;
    }
}
//
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * sectionFooterView = nil;
    
    if (section == 0) {
    
        sectionFooterView = [UIView new];
        sectionFooterView.backgroundColor = viewBackgroundColor;
    }else if(section == 1){
      
       sectionFooterView = [self footView];
    }
    
    return sectionFooterView;
}
//
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = 0.0;
    
    if (section ==0 ) {
        height = 12.0;
    }else{
        if (self.nextSignal) {
            height = 80;
        }else{
            
            height = 0.1;
        }
    }
    return height;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,12,0,0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0,12,0,0)];
    }
}
-(void)refreshCells :(IDCMAcceptVariableModel *) model indexPath :(NSIndexPath *) indexPath{
    
    if (self.currentSpreadCellModel) {
        if (self.currentSpreadCellModel == model) {
            model.cellSpread = !self.currentSpreadCellModel.cellSpread;
        }else{
            self.currentSpreadCellModel.cellSpread = NO;
            model.cellSpread = YES;
            self.currentSpreadCellModel = model;
        }
    }else{
        self.currentSpreadCellModel = model;
        model.cellSpread = YES;
    }
    
    [self.mainTableView beginUpdates];
    if (self.currentSpreadCellIndex != nil && self.currentSpreadCellIndex != indexPath) {
        [self.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.currentSpreadCellIndex,nil] withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
    [self.mainTableView endUpdates];

    self.currentSpreadCellIndex = indexPath;
    self.mainTableView.userInteractionEnabled = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.mainTableView reloadData];
        self.mainTableView.userInteractionEnabled = YES;
    });
}

#pragma mark - 请求数据

#pragma mark - 懒加载

-(UITableView *)mainTableView{
    return SW_LAZY(_mainTableView, ({
        IDCMTableView *tableView = [[IDCMTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = viewBackgroundColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.showsVerticalScrollIndicator = NO;
        [tableView registerCellWithCellClass:[IDCMAcceptVariableCell class]];
        [tableView registerCellWithCellClass:[IDCMCurrencyAndPayTypeCell class]];
        tableView;
    }));
}


-(UIView *)footView{
    
    if (self.nextSignal) {
        UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        
        footView.backgroundColor = [UIColor clearColor];
        [footView addSubview:self.bottomNextBtn];
        
        [self.bottomNextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(footView).offset(20);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 24, 40));
            make.bottom.equalTo(footView).offset(-20);
            make.centerX.equalTo(footView);
        }];
        return footView;
    }

    return nil;
}

-(UIButton *)bottomNextBtn{
    
    
    if (!_bottomNextBtn) {
        _bottomNextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomNextBtn setTitle:NSLocalizedString(@"2.0_NextStep_Next", nil) forState:UIControlStateNormal];
        _bottomNextBtn.titleLabel.alpha = 0.5;
        _bottomNextBtn.layer.cornerRadius = 5;
        _bottomNextBtn.clipsToBounds = YES;
        _bottomNextBtn.backgroundColor = [UIColor colorWithHexString:@"#999FA5"];
    }
    return _bottomNextBtn;
}
-(void)setNextStepEnable:(BOOL)nextStepEnable{
    
    if (nextStepEnable) {
        _bottomNextBtn.titleLabel.alpha = 1;
        _bottomNextBtn.backgroundColor = [UIColor colorWithHexString:@"#2E406B"];
    }else{
        _bottomNextBtn.titleLabel.alpha = 0.5;
        _bottomNextBtn.backgroundColor = [UIColor colorWithHexString:@"#999FA5"];
    }
}
-(void)setSectionOneArray:(NSMutableArray<IDCMAcceptVariableModel *> *)sectionOneArray{
    
    _sectionOneArray = sectionOneArray;
}
-(void)setSectionTwoArray:(NSMutableArray<IDCMAcceptVariableModel *> *)sectionTwoArray{
    
    _sectionTwoArray = sectionTwoArray;
}
@end
