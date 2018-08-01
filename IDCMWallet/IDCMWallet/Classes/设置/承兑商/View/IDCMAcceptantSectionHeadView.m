//
//  IDCMAcceptantSectionHeadView.m
//  IDCMWallet
//
//  Created by wangpu on 2018/4/10.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptantSectionHeadView.h"
@interface IDCMAcceptantSectionHeadView ()

@property (nonatomic,strong) UIButton * rightAddBtn;
@property (nonatomic,strong) UILabel * subTitleLabel;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UILabel * subTitleLabelFirst;
@property (nonatomic,strong) UILabel * subTitleLabelSecond;
@property (nonatomic,strong) UILabel * subTitleLabelThird;
@property (nonatomic,strong) UIView *  lineView;
@end
@implementation IDCMAcceptantSectionHeadView

-(instancetype) initWithFrame:(CGRect)frame titles:(NSArray *)titles  callBack:(SectionHeaderCallBackBlock) block{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _subTitles = titles;
        _sectionCallBackBlock = block;
        [self initUIView];
    }
    return self;
}

-(void)initUIView{
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(12);
        make.left.right.equalTo(self);
        
    }];
    [self addSubview:self.rightAddBtn];
    
    [self.rightAddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(44, 32));
    }];
    
    CGFloat perWidth = self.frame.size.width;
    [_subTitles enumerateObjectsUsingBlock:^(NSString * title, NSUInteger idx, BOOL * _Nonnull stop) {
   
        if (idx != 0) {
            UILabel * label = [UILabel new];
            label.textAlignment = NSTextAlignmentLeft;
            label.text = title;
            label.numberOfLines = 0;
            label.font = SetFont(@"PingFangSC-Regular", 12);
            label.textColor = [UIColor colorWithHexString:@"#666666"];
            [self addSubview:label];
            if (idx == 1) {
                self.subTitleLabelFirst = label;
                [self.subTitleLabelFirst mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.mas_left).offset(12);
                    make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
                    make.width.mas_equalTo(0.264 * perWidth);
                    
                }];
            }else if (idx == 2){
                self.subTitleLabelSecond = label;
                [self.subTitleLabelSecond mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.subTitleLabelFirst.mas_right);
                    make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
                    make.width.mas_equalTo(0.41 * perWidth);
                }];

            }else if (idx == 3){
                
                self.subTitleLabelThird = label;
                [self.subTitleLabelThird mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.subTitleLabelSecond.mas_right);
                    make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
                    make.width.mas_equalTo(0.15 * perWidth);
                }];
            }
        }
    }];
        [self addSubview:self.lineView];
}

-(void)setSubTitle:(NSString *)subTitle{
    _subTitle = subTitle;
    if (subTitle) {
        self.subTitleLabel.text =subTitle;
        [self addSubview:self.subTitleLabel];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-15);
            make.centerX.equalTo(self);
            make.width.mas_equalTo(SCREEN_WIDTH);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-46);
            make.height.mas_equalTo(0.5);
        }];

    }else{
        [self.subTitleLabel removeFromSuperview];

        [self.lineView removeFromSuperview];
    }
}

-(UIButton *)rightAddBtn{
    
    if (!_rightAddBtn) {
        _rightAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightAddBtn setImage:[UIImage imageNamed:@"addIcon"] forState:UIControlStateNormal];
         @weakify(self);
        [[_rightAddBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            
            @strongify(self);
            if (self.sectionCallBackBlock) {
                self.sectionCallBackBlock(self.sectionIndex);
            }
        }];
    }
    return _rightAddBtn;
}

-(UILabel *)subTitleLabel{
    
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _subTitleLabel.font = SetFont(@"PingFangSC-Regular", 12);
    }
    return _subTitleLabel;
}
-(UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.numberOfLines = 0;
        _titleLabel.font =SetFont(@"PingFangSC-Regular", 14);
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.text = self.subTitles.firstObject;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
-(UIView *)lineView{
    
    if (!_lineView) {
        _lineView =[[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    }
    return _lineView;
}
@end
