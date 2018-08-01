//
//  IDCMOTCExchangeRecordCell.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/5.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMOTCExchangeRecordCell.h"
#import "IDCMOTCExchangeRecordModel.h"


@interface IDCMOTCExchangeRecordCell ()
@property (nonatomic,strong) UIView *customContentView;
@property (nonatomic,strong) UIImageView *leftIconImageView;
@property (nonatomic,strong) UILabel *leftTitleLabel;
@property (nonatomic,strong) UILabel *leftSubTitleLabel;
@property (nonatomic,strong) UILabel *rightTitleLabel;
@property (nonatomic,strong) UILabel *rightSubTitleLabel;
@property (nonatomic,strong) UIView *bottomLineView;
@property (nonatomic,assign) NSInteger numberOfRows;
@property (nonatomic,weak) IDCMOTCExchangeRecordModel *cellViewModel;
@end


@implementation IDCMOTCExchangeRecordCell
@dynamic cellViewModel,viewModel;
- (void)initConfig {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = viewBackgroundColor;
    self.customSubViewsArray = @[self.customContentView];
}

- (void)reloadCellData {
    self.bottomLineView.hidden = self.indexPath.row ==
    ([self.viewModel getSectionViewModelAtSection:self.indexPath.section].cellModels.count - 1);
    self.customContentView.top  = self.indexPath.row ? 0 : 8;
    self.leftIconImageView.image = [UIImage imageNamed:self.cellViewModel.customerLeftImageName];
    self.leftTitleLabel.text =self.cellViewModel.customerUserName;
    self.leftSubTitleLabel.text = self.cellViewModel.customerTime;
    self.rightTitleLabel.text = self.cellViewModel.customerCountCurrey;
    self.rightSubTitleLabel.text = self.cellViewModel.customerStatus;
    if (self.cellViewModel.Direction == 1) {
        self.rightTitleLabel.textColor = UIColorMake(255, 100, 72);
    }else{
        self.rightTitleLabel.textColor = UIColorMake(31, 199, 58);
    }
}

#pragma mark — getters
- (UIView *)customContentView {
    if (!_customContentView){
        _customContentView = [[UIView alloc] init];
        _customContentView.size = CGSizeMake(SCREEN_WIDTH, 64);
        _customContentView.backgroundColor = UIColorWhite;
        
        [_customContentView addSubview:self.leftIconImageView];
        [_customContentView addSubview:self.leftTitleLabel];
        [_customContentView addSubview:self.leftSubTitleLabel];
        [_customContentView addSubview:self.rightTitleLabel];
        [_customContentView addSubview:self.rightSubTitleLabel];
        [_customContentView addSubview:self.bottomLineView];
    }
    return _customContentView;
}

- (UIImageView *)leftIconImageView {
    return SW_LAZY(_leftIconImageView, ({
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(12, 15, 34, 34);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        imageView;
    }));
}

- (UILabel *)leftTitleLabel {
    return SW_LAZY(_leftTitleLabel , ({
        
        UILabel *label = [[UILabel alloc] init];
        label.font = textFontPingFangRegularFont(14);
        label.textColor = textColor333333;
        label.height = 20;
        label.width = (SCREEN_WIDTH - (self.leftIconImageView.right + 10 + 12)) / 2;
        label.left = self.leftIconImageView.right + 10;
        label.top = 12;
        label;
    }));
}

- (UILabel *)leftSubTitleLabel {
    return SW_LAZY(_leftSubTitleLabel , ({
        
        UILabel *label = [[UILabel alloc] init];
        label.font = textFontPingFangRegularFont(12);
        label.textColor = textColor999999;
        label.height = 17;
        label.width = self.leftTitleLabel.width;
        label.left = self.leftTitleLabel.left;
        label.top = self.leftTitleLabel.bottom + 4;
        label;
    }));
}

- (UILabel *)rightTitleLabel {
    return SW_LAZY(_rightTitleLabel , ({
        
        UILabel *label = [[UILabel alloc] init];
        label.font = textFontPingFangRegularFont(14);
        label.textAlignment = NSTextAlignmentRight;
        label.height = 20;
        label.width = self.leftTitleLabel.width;
        label.right = _customContentView.width - 12;
        label.centerY = self.leftTitleLabel.centerY;
        label;
    }));
}

- (UILabel *)rightSubTitleLabel {
    return SW_LAZY(_rightSubTitleLabel , ({
        
        UILabel *label = [[UILabel alloc] init];
        label.font = textFontPingFangRegularFont(12);
        label.textColor = [UIColor colorWithHexString:@"#2968B9"];
        label.textAlignment = NSTextAlignmentRight;
        label.height = 17;
        label.width = self.rightTitleLabel.width;
        label.right = self.rightTitleLabel.right;
        label.centerY = self.leftSubTitleLabel.centerY;
        label;
    }));
}

- (UIView *)bottomLineView {
    return SW_LAZY(_bottomLineView, ({
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
        line.height = .5;
        line.left = self.leftIconImageView.left;
        line.width = SCREEN_WIDTH - line.left;
        line.bottom = _customContentView.bottom;
        line;
    }));
}

@end






