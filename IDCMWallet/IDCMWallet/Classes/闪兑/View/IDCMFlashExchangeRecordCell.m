//
//  IDCMFlashRecordCell.m
//  IDCMWallet
//
//  Created by huangyi on 2018/3/14.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMFlashExchangeRecordCell.h"
#import "IDCMFlashExchangeRecordModel.h"


@interface IDCMFlashExchangeRecordCell ()

@property (nonatomic,strong) UIView *customContentView;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *cashOutTitleLabel;
@property (nonatomic,strong) UILabel *cashOutLabel;
@property (nonatomic,strong) UILabel *cashEnterTitleLabel;
@property (nonatomic,strong) UILabel *cashEnterLabel;
@property (nonatomic,strong) UILabel *cashStateTitleLabel;
@property (nonatomic,strong) UILabel *cashStateLabel;
@property (nonatomic,strong) UIView  *bottomLine;

@property (nonatomic,weak) IDCMFlashExchangeRecordModel *cellViewModel;
@end


@implementation IDCMFlashExchangeRecordCell
@dynamic cellViewModel;
- (void)initConfig {
    [super initConfig];
    self.contentView.backgroundColor = viewBackgroundColor;
    self.customSubViewsArray = @[self.customContentView];
}

- (void)reloadCellData {
    self.customContentView.top  = self.indexPath.row ? 0 : 8;
    self.bottomLine.hidden = self.indexPath.row ==
    ([self.viewModel getSectionViewModelAtSection:self.indexPath.row].cellModels.count - 1);
    self.timeLabel.text = self.cellViewModel.customerTime;
    self.cashOutLabel.text = self.cellViewModel.customerCashOut;
    self.cashEnterLabel.text = self.cellViewModel.customerCashEnter;
    self.cashStateLabel.text = self.cellViewModel.customerState;
}

#pragma mark — getters and setters
- (UIView *)customContentView {
    if (!_customContentView){
        _customContentView = [[UIView alloc] init];
        _customContentView.size = CGSizeMake(SCREEN_WIDTH, 114);
        _customContentView.backgroundColor = UIColorWhite;
        
        [_customContentView addSubview:self.timeLabel];
        [_customContentView addSubview:self.cashEnterTitleLabel];
        [_customContentView addSubview:self.cashEnterLabel];
        [_customContentView addSubview:self.cashOutTitleLabel];
        [_customContentView addSubview:self.cashOutLabel];
        [_customContentView addSubview:self.cashStateTitleLabel];
        [_customContentView addSubview:self.cashStateLabel];
        [_customContentView addSubview:self.bottomLine];
    }
    return _customContentView;
}

- (UILabel *)timeLabel {
    return SW_LAZY(_timeLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor666666;
        label.font = textFontPingFangRegularFont(12);
        label.width = SCREEN_WIDTH - 24;
        label.height = 13;
        label.left = 12;
        label.top = 12;
        label;
    }));
}

- (UILabel *)cashOutTitleLabel {
    return SW_LAZY(_cashOutTitleLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor999999;
        label.font = textFontPingFangRegularFont(12);
        label.text = NSLocalizedString(@"3.0_ExchangeOut", nil);
        [label sizeToFit];
        label.left = self.timeLabel.left;
        label.top = self.timeLabel.bottom + 12;
        label;
    }));
}

- (UILabel *)cashOutLabel {
    return SW_LAZY(_cashOutLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor333333;
        label.font = textFontPingFangRegularFont(12);
        label.textAlignment = NSTextAlignmentRight;
        label.width = SCREEN_WIDTH - self.cashOutTitleLabel.right - 10 - 12;
        label.height = self.cashOutTitleLabel.height;
        label.left = self.cashOutTitleLabel.right + 10;
        label.centerY = self.cashOutTitleLabel.centerY;
        label;
    }));
}

- (UILabel *)cashEnterTitleLabel {
    return SW_LAZY(_cashEnterTitleLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor999999;
        label.font = textFontPingFangRegularFont(12);
        label.text = NSLocalizedString(@"3.0_ExchangeEnter", nil);;
        [label sizeToFit];
        label.top = self.cashOutTitleLabel.bottom + 8;
        label.left = self.cashOutTitleLabel.left;
        label;
    }));
}

- (UILabel *)cashEnterLabel {
    return SW_LAZY(_cashEnterLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor333333;
        label.font = textFontPingFangRegularFont(12);
        label.textAlignment = NSTextAlignmentRight;
        label.width = self.cashOutLabel.width;
        label.height = self.cashEnterTitleLabel.height;
        label.centerY = self.cashEnterTitleLabel.centerY;
        label.left = self.cashOutLabel.left;
        label;
    }));
}

- (UILabel *)cashStateTitleLabel {
    return SW_LAZY(_cashStateTitleLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor999999;
        label.font = textFontPingFangRegularFont(12);
        label.text = NSLocalizedString(@"3.0_ExchangeEnterState", nil);;
        [label sizeToFit];
        label.left = self.timeLabel.left;
        label.top = self.cashEnterTitleLabel.bottom + 8;
        label;
    }));
}

- (UILabel *)cashStateLabel {
    return SW_LAZY(_cashStateLabel, ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = textColor333333;
        label.font = textFontPingFangRegularFont(12);
        label.textAlignment = NSTextAlignmentRight;
        label.height = self.cashStateTitleLabel.height;
        label.width = SCREEN_WIDTH - self.cashStateTitleLabel.right - 10 - 12;
        label.centerY = self.cashStateTitleLabel.centerY;
        label.left = self.cashStateTitleLabel.right + 10;
        label;
    }));
}

- (UIView *)bottomLine {
    return SW_LAZY(_bottomLine, ({
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
        line.height = .5;
        line.left = self.timeLabel.left;
        line.width = SCREEN_WIDTH - line.left;
        line.bottom = 114.0f;
        line;
    }));
}

@end



