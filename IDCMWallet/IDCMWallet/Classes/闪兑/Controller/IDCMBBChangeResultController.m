//
//  IDCMBBChangeResultController.m
//  IDCMWallet
//
//  Created by wangpu on 2018/3/16.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMBBChangeResultController.h"

@interface IDCMBBChangeResultController ()

@end

@implementation IDCMBBChangeResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"3.0_ExchangeResult", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setUpUI{
    
    UIScrollView * backScrollView = [[UIScrollView alloc] init];
    backScrollView.backgroundColor = [UIColor whiteColor];
    backScrollView.alwaysBounceVertical = YES;
    backScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:backScrollView];
    
    [backScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView * contentView = [UIView new];
    [backScrollView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(backScrollView);
        make.width.mas_equalTo(self.view.frame.size.width);
    }];
    
    UIImageView * resultImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3.0_suceess"]];
    
    resultImageView.contentMode = UIViewContentModeScaleToFill;
    [contentView addSubview:resultImageView];
    
    [resultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(30);
        make.centerX.equalTo(contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    UILabel * resultWordLabel = [[UILabel alloc] init];
    resultWordLabel.textAlignment = NSTextAlignmentCenter;
    resultWordLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    resultWordLabel.font = SetFont(@"PingFangSC-Regular", 16);
    
    resultWordLabel.text =  NSLocalizedString(@"3.0_ExchangeSucess", nil);
    [contentView addSubview:resultWordLabel];
    
    [resultWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView.mas_centerX);
        make.height.mas_equalTo(22);
        make.width.mas_equalTo(200);
        make.top.equalTo(resultImageView.mas_bottom).offset(12);
        
    }];
    
    UIView * logView = [UIView new];
    [contentView addSubview:logView];
    
    [logView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(resultWordLabel.mas_bottom).offset(30);
        make.height.mas_equalTo(60);
        make.left.equalTo(contentView.mas_left);
        make.right.equalTo(contentView.mas_right);
    }];
    
    UIImageView * midExchangeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"3.0_bbExchange"]];
    midExchangeImageView.contentMode = UIViewContentModeScaleToFill;
    [logView addSubview:midExchangeImageView];
    
    [midExchangeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(logView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(logView.mas_centerY);
    }];
    
    UIImageView * leftIconImageView = [[UIImageView alloc] init];
    [leftIconImageView sd_setImageWithURL:self.infoDict[@"leftLogo"] placeholderImage:nil options:SDWebImageRefreshCached];
    leftIconImageView.contentMode = UIViewContentModeScaleToFill;
    [logView addSubview:leftIconImageView];
    
    [leftIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(midExchangeImageView.mas_left).offset(-40);
        make.top.equalTo(logView.mas_top);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    
    UIImageView * rightIconImageView = [[UIImageView alloc] init];
    [rightIconImageView sd_setImageWithURL:self.infoDict[@"rightLogo"] placeholderImage:nil options:SDWebImageRefreshCached];
    rightIconImageView.contentMode = UIViewContentModeScaleToFill;
    [logView addSubview:rightIconImageView];
    
    [rightIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(midExchangeImageView.mas_right).offset(40);
        make.top.equalTo(logView.mas_top);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
  
    UILabel * leftTitleLabel = [[UILabel alloc] init];
    leftTitleLabel.textAlignment = NSTextAlignmentCenter;
    leftTitleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    leftTitleLabel.font = SetFont(@"PingFangSC-Regular", 16);
    
    leftTitleLabel.text = self.infoDict[@"leftText"];
    [logView addSubview:leftTitleLabel];
    
    [leftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftIconImageView.mas_centerX);
        make.top.equalTo(leftIconImageView.mas_bottom).offset(2);
        make.bottom.equalTo(logView.mas_bottom);
    }];
    
    UILabel * rightTitleLabel = [[UILabel alloc] init];
    rightTitleLabel.textAlignment = NSTextAlignmentCenter;
    rightTitleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    rightTitleLabel.font = SetFont(@"PingFangSC-Regular", 16);
    
    rightTitleLabel.text = self.infoDict[@"rightText"];
    [logView addSubview:rightTitleLabel];
    
    [rightTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightIconImageView.mas_centerX);
        make.top.equalTo(rightIconImageView.mas_bottom).offset(2);
        make.bottom.equalTo(logView.mas_bottom);
    }];
    
    UIView * detailView = [UIView new];
    [contentView addSubview:detailView];
    
    [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(72);
        make.left.equalTo(contentView.mas_left);
        make.right.equalTo(contentView.mas_right);
        make.top.equalTo(logView.mas_bottom).offset(12);
    }];
    
    UILabel * duiChuLabel = [UILabel new];
    duiChuLabel.text = NSLocalizedString(@"3.0_ExchangeOut", nil);
    duiChuLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    
    duiChuLabel.font = SetFont(@"PingFangSC-Regular", 14);
    [detailView addSubview:duiChuLabel];
    
    [duiChuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailView.mas_top);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(20);
    }];
    
    UILabel * mountOut = [UILabel new];
    mountOut.text = self.infoDict[@"exchangeOut"];
    mountOut.textColor = [UIColor colorWithHexString:@"#333333"];
    mountOut.textAlignment = NSTextAlignmentRight;
    mountOut.font = SetFont(@"PingFangSC-Regular", 14);
    [detailView addSubview:mountOut];
    
    [mountOut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailView.mas_top);
        make.left.mas_equalTo(duiChuLabel.mas_right);
        make.height.mas_equalTo(20);
        make.right.equalTo(detailView.mas_right).offset(-12);
    }];
    
    UILabel * Line1= [UILabel new];
    Line1.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    [detailView addSubview:Line1];
    
    [Line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(duiChuLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(duiChuLabel.mas_left);
        make.height.mas_equalTo(1);
        make.right.equalTo(mountOut.mas_right);
    }];
    
    UILabel * duiRuLabel = [UILabel new];
    duiRuLabel.text = NSLocalizedString(@"3.0_ExchangeIn", nil);
    duiRuLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    
    duiRuLabel.font = SetFont(@"PingFangSC-Regular", 14);
    [detailView addSubview:duiRuLabel];
    
    [duiRuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Line1.mas_bottom).offset(10);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(20);
    }];
    
    UILabel * mountIn = [UILabel new];
    mountIn.text = self.infoDict[@"exchangeIn"];
    mountIn.textColor = [UIColor colorWithHexString:@"#333333"];
    mountIn.textAlignment = NSTextAlignmentRight;
    mountIn.font = SetFont(@"PingFangSC-Regular", 14);
    [detailView addSubview:mountIn];
    
    [mountIn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(duiRuLabel.mas_centerY);
        make.left.mas_equalTo(duiRuLabel.mas_right);
        make.height.mas_equalTo(20);
        make.right.equalTo(detailView.mas_right).offset(-12);
    }];
    
    UILabel * Line2= [UILabel new];
    Line2.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
    [detailView addSubview:Line2];
    
    [Line2 mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.mas_equalTo(duiChuLabel.mas_left);
        make.height.mas_equalTo(1);
        make.right.equalTo(mountOut.mas_right);
        make.bottom.equalTo(detailView.mas_bottom);
    }];
    
    UILabel * tipsLabel = [UILabel new];
    tipsLabel.numberOfLines = 0;
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = [UIColor colorWithHexString:@"#333333" ];
    tipsLabel.font = SetFont(@"PingFangSC-Regular", 14);
    tipsLabel.text  = NSLocalizedString(@"3.0_ExchangeTips", nil);
    [contentView addSubview:tipsLabel];
    
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(contentView.mas_left);
        make.right.mas_equalTo(contentView.mas_right);
        make.top.equalTo(detailView.mas_bottom).offset(20);
    }];
    
    
    UIButton * dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    
    dismissBtn.backgroundColor = [UIColor colorWithHexString:@"#2E406B"];
    dismissBtn.layer.cornerRadius = 5;
    dismissBtn.clipsToBounds = YES;
    [dismissBtn setTitle:NSLocalizedString(@"3.0_IKnow", nil) forState:UIControlStateNormal];
    [contentView addSubview:dismissBtn];
    
    [dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsLabel.mas_bottom).offset(20);
        make.height.mas_equalTo(40);
        make.right.equalTo(contentView.mas_right).offset(-12);
        make.left.equalTo(contentView.mas_left).offset(12);
        make.bottom.mas_equalTo (contentView.mas_bottom);
    }];
}

-(void)dismiss:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end





