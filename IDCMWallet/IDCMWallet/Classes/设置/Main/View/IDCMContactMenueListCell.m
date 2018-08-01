//
//  IDCMContactMenueListCell.m
//  IDCMWallet
//
//  Created by BinBear xu on 2018/1/20.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMContactMenueListCell.h"
#import "IDCMContactListModel.h"

@interface IDCMContactMenueListCell ()
@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *infoLabel;
@property (nonatomic,strong) UIView *line;
@end

@implementation IDCMContactMenueListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.line];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.width.height.equalTo(@17);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(10);
        make.width.lessThanOrEqualTo(@200);
        make.height.greaterThanOrEqualTo(@16);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.width.lessThanOrEqualTo(@200);
        make.height.greaterThanOrEqualTo(@16);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@0.5);
    }];
}

- (void)bindViewModel:(id)viewModel{
    
    IDCMContactListModel *model = viewModel;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:nil options:SDWebImageRefreshCached];
    self.titleLabel.text = model.title;
    self.infoLabel.text = model.content;
    
    // 长按复制
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        
        UILongPressGestureRecognizer *tap = sender;
        if (tap.state == UIGestureRecognizerStateBegan) {
            if (model) {
                if ([model.content isNotBlank]) {
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = model.content;
                    [IDCMShowMessageView showErrorWithMessage:SWLocaloziString(@"2.0_CopySuccess")];
                }
            }
        }
    }];
    longPressGR.minimumPressDuration = 1.0;
    [self addGestureRecognizer:longPressGR];
}

#pragma mark - getter
- (UIView *)line
{
    return SW_LAZY(_line, ({
        UIView *view = [UIView new];
        view.backgroundColor = UIColorFromRGB(0xDDDDDD);
        view;
    }));
}
- (UILabel *)titleLabel
{
    return SW_LAZY(_titleLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangRegularFont(14);
        label.textColor = textColor333333;
        label.textAlignment = NSTextAlignmentLeft;
        label;
    }));
}
- (UILabel *)infoLabel
{
    return SW_LAZY(_infoLabel, ({
        UILabel *label = [UILabel new];
        label.font = textFontPingFangRegularFont(14);
        label.textColor = textColor333333;
        label.textAlignment = NSTextAlignmentRight;
        label;
    }));
}
- (UIImageView *)icon
{
    return SW_LAZY(_icon,({
        UIImageView *icon = [UIImageView new];
        icon.contentMode = UIViewContentModeScaleAspectFit;
        icon.clipsToBounds = YES;
        icon;
    }));
}
@end
