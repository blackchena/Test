//
//  IDCMAcceptVariableCell.m
//  IDCMWallet
//
//  Created by wangpu on 2018/4/10.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMAcceptVariableCell.h"
#import "IDCMAcceptVariableModel.h"
@interface IDCMAcceptVariableCell(){
    
    
}

@property (nonatomic,strong) UILabel * coinTypeLabel ;
@property (nonatomic,strong) UILabel * mountLabelMid ;
@property (nonatomic,strong) UILabel * mountLabelLeft ;
@property (nonatomic,strong) UIButton * leftEditBtn ;
@property (nonatomic,strong) UIButton * bottomEditBtn ;
@property (nonatomic,strong) UIButton * bottomDeleteBtn ;
@property (nonatomic,strong) NSArray  * contentTitleArry;

@end

@implementation IDCMAcceptVariableCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        
        [self.contentView addSubview:self.leftEditBtn];
        
         @weakify(self);
        
        [[self.leftEditBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            
            if (self.callBack) {
                self.callBack();
            }
        }];
        
        [[self.bottomDeleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            
            if (self.bottomBtnCallBack) {
                self.bottomBtnCallBack(@"delete");
            }
        }];
        
        [[self.bottomEditBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            
            if (self.bottomBtnCallBack) {
                self.bottomBtnCallBack(@"edit");
            }
        }];
    }
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (self.cellModel.cellSpread) {
        self.bottomEditBtn.frame = CGRectMake(12, self.frame.size.height - 15 -30 ,(SCREEN_WIDTH - 36)/2, 30);
        self.bottomDeleteBtn.frame = CGRectMake(self.bottomEditBtn.frame.origin.x+self.bottomEditBtn.frame.size.width+12, self.frame.size.height - 15 -30 ,(SCREEN_WIDTH - 36)/2, 30);
    }
}
-(void)setCellModel:(IDCMAcceptVariableModel *)cellModel
{
    _cellModel = cellModel;
    
    if (cellModel.cellSpread) {
        
        [self.contentView addSubview:self.bottomEditBtn];
        [self.contentView  addSubview:self.bottomDeleteBtn];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F7FAFE"];
    }
    [self setContentTitleArry:cellModel.titleArr];
}

-(void)setContentTitleArry:(NSArray *)contentTitleArry
{
    _contentTitleArry = contentTitleArry;
    
    __block UIView * lastView = nil;
    
    [contentTitleArry enumerateObjectsUsingBlock:^(NSString * title, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel * label = [[UILabel alloc] init];
        label.text = title;
        label.textColor = [UIColor colorWithHexString:@"#333333"];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = SetFont(@"PingFangSC-Regular", 12);
        
        if (idx  == 0) {
            label.frame = CGRectMake(12, 14, SCREEN_WIDTH * 0.264, 18);
            lastView = label;
            
        }else if (idx == 1){
            
            CGFloat orginalX= lastView.frame.origin.x+lastView.frame.size.width;
            label.frame = CGRectMake(orginalX, 14, SCREEN_WIDTH * 0.41, 18);
            
            lastView = label;
        }else if (idx == 2){
            CGFloat orginalX= lastView.frame.origin.x+lastView.frame.size.width;
            label.frame = CGRectMake(orginalX, 14,0.15 * SCREEN_WIDTH, 18);
            
            lastView = label;
        }
        [self.contentView addSubview:label];
    }];
}

-(UIButton *)leftEditBtn{
    
    if (!_leftEditBtn) {
        _leftEditBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftEditBtn setImage:[UIImage imageNamed:@"editIcon"] forState:UIControlStateNormal];
        _leftEditBtn.frame =CGRectMake(SCREEN_WIDTH-44, 14, 44, 20);
    }
    return _leftEditBtn;
}


-(UIButton *)bottomEditBtn{
    
    if (!_bottomEditBtn) {
        _bottomEditBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomEditBtn setTitleColor:[UIColor colorWithHexString:@"#2968B9"] forState:UIControlStateNormal];
        [_bottomEditBtn setTitle:SWLocaloziString(@"3.0_AcceptantEdit") forState:UIControlStateNormal];
        _bottomEditBtn.layer.borderWidth = 0.5;
        _bottomEditBtn.layer.borderColor = [UIColor colorWithHexString:@"2968B9"].CGColor;
        _bottomEditBtn.layer.cornerRadius = 4;
        _bottomEditBtn.clipsToBounds = YES;
        _bottomEditBtn.titleLabel.font = SetFont(@"PingFangSC-Regular", 12);
        _bottomEditBtn.backgroundColor = [UIColor whiteColor];
    }
    
    return _bottomEditBtn;
}
-(UIButton *)bottomDeleteBtn{
    
    if (!_bottomDeleteBtn) {
        _bottomDeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomDeleteBtn.backgroundColor = [UIColor whiteColor];
        [_bottomDeleteBtn setTitleColor:[UIColor colorWithHexString:@"#2968B9"] forState:UIControlStateNormal];
        [_bottomDeleteBtn setTitle:SWLocaloziString(@"2.1_Delete") forState:UIControlStateNormal];
        _bottomDeleteBtn.titleLabel.font = SetFont(@"PingFangSC-Regular", 12);
        _bottomDeleteBtn.layer.borderWidth = 0.5;
        _bottomDeleteBtn.layer.borderColor = [UIColor colorWithHexString:@"2968B9"].CGColor;
        _bottomDeleteBtn.layer.cornerRadius = 4;
        _bottomDeleteBtn.clipsToBounds = YES;
    }
    return _bottomDeleteBtn;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
