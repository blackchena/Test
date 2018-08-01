//
//  IDCMOTCChatCell.m
//  IDCMWallet
//
//  Created by 数维科技 on 2018/5/4.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMOTCChatCell.h"
#import <UIView+FDCollapsibleConstraints.h>
#import "NSDate+Time.h"

//@implementation IDCMOTCChatModel
//
//@end

@interface IDCMOTCChatCell()
@property (strong, nonatomic) NSLayoutConstraint *leftLayoutConstraint;
@property (strong, nonatomic) NSLayoutConstraint *rightLayoutConstraint;

@end

@implementation IDCMOTCChatCell

- (NSLayoutConstraint * )leftLayoutConstraint {
    return SW_LAZY(_leftLayoutConstraint , ({
        NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self.conView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual  toItem:self.leftHead attribute:NSLayoutAttributeRight multiplier:1 constant:8];
        layout.identifier = @"LeftID";
        layout;
    }));
}

- (NSLayoutConstraint * )rightLayoutConstraint {
    return SW_LAZY(_rightLayoutConstraint , ({
        NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self.conView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual  toItem:self.rightHead attribute:NSLayoutAttributeLeft multiplier:1 constant:-8];
        layout.identifier = @"RightID";
        layout;
    }));
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    
    
    self.topLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.topLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1/1.0];
 
    self.conLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    self.conLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];

    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.conView.layer.cornerRadius = 6;
    self.conView.layer.masksToBounds = YES;
    
    self.conImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.conImageView.userInteractionEnabled = YES;
    @weakify(self);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self);
        !self.chatTapImageView ?:self.chatTapImageView(self.conImageView.image);
    }];
    [self.conImageView addGestureRecognizer:tap];
    [[self.retryButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        !self.chatTapRetryButton ?:self.chatTapRetryButton(self.indexPath);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(IDCMOTCChatModel *)model {
    _model = model;
    
    self.topLabel.fd_collapsed = !model.showTime;
    if (model.showTime) {
        self.topLabel.text = [NSDate dateToString:@"yyyy-MM-dd HH:mm" byDate:[NSDate dateWithTimeIntervalSince1970:model.TimeStamp/1000]];
    }
    else{
        self.topLabel.text = nil;
    }
    
    for (NSLayoutConstraint *con in self.conImageView.constraints) {
        if ([con.identifier isEqualToString:@"ConImageViewLayoutConstraint"]){
            [self.conImageView removeConstraint:con];
        }
        if ([con.identifier isEqualToString:@"ConImageViewHeightLayoutConstraint"]){
            [self.conImageView removeConstraint:con];
        }
    }
    self.conLabel.text = nil;
    self.conImageView.image = nil;
    if ([model j_isText]) {
        self.conLabel.text = model.Message;
    }
    else{
        if ([model.FileUrl isKindOfClass:[NSString class]] && model.FileUrl.length > 0){
            NSString *imgStr = model.FileUrl;
            if([imgStr hasPrefix:@"http"]) {
                @weakify(self);
                UIImage *img = [[SDImageCache sharedImageCache] imageFromCacheForKey:imgStr];
                if (img) {
                    self.conImageView.image = img;
                }
                else{
                    [self.conImageView sd_setImageWithURL:[NSURL URLWithString:imgStr] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                        @strongify(self);
                        for (NSLayoutConstraint *con in self.conImageView.constraints) {
                            if ([con.identifier isEqualToString:@"ConImageViewLayoutConstraint"]){
                                [self.conImageView removeConstraint:con];
                            }
                            if ([con.identifier isEqualToString:@"ConImageViewHeightLayoutConstraint"]){
                                [self.conImageView removeConstraint:con];
                            }
                        }
                        CGFloat fee = self.conImageView.image.size.width/self.conImageView.image.size.height;
                        NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self.conImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual  toItem:self.conImageView attribute:NSLayoutAttributeHeight multiplier:fee constant:0];
                        layout.identifier = @"ConImageViewLayoutConstraint";
                        [self.conImageView addConstraint:layout];
                        
                        [self.tableView beginUpdates];
                        [self.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                        [self.tableView endUpdates];
                        
                    }];
                }
            }
            else {
                self.conImageView.image = [UIImage imageNamed:imgStr];
            }
        }
        else if([model.FileUrl isKindOfClass:[UIImage class]]) {
            UIImage *img = (UIImage *)model.FileUrl;
            self.conImageView.image = img;
        }
        CGFloat fee;
        if(self.conImageView.image != nil) {
            fee = self.conImageView.image.size.width/self.conImageView.image.size.height;
        }
        else{
            fee = 9/16;
            NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self.conImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual  toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:200];
            layout.identifier = @"ConImageViewHeightLayoutConstraint";
            [self.conImageView addConstraint:layout];
        }
        NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:self.conImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual  toItem:self.conImageView attribute:NSLayoutAttributeHeight multiplier:fee constant:0];
        layout.identifier = @"ConImageViewLayoutConstraint";
        [self.conImageView addConstraint:layout];
    }
    

    BOOL isSend = [model j_send];
    self.conViewRight.active = NO;
    for (NSLayoutConstraint *con in self.contentView.constraints) {
        if ([con.identifier isEqualToString:@"LeftID"]){
            [self.contentView removeConstraint:con];
        }
        else if ([con.identifier isEqualToString:@"RightID"]){
            [self.contentView removeConstraint:con];
        }
    }
    
    if(isSend){
        [self.contentView addConstraint:self.rightLayoutConstraint];
        
        self.retryButton.hidden = !model.sendFail;
        self.leftHead.image = nil;
        self.rightHead.image = [UIImage imageNamed:@"3.2_chat_我-icon"];
        self.conView.backgroundColor = [UIColor colorWithHexString:@"#3C9BFF"];
        self.conLabel.textColor = [UIColor whiteColor];

    }
    else {
        [self.contentView addConstraint:self.leftLayoutConstraint];
        
        self.retryButton.hidden = YES;
        self.leftHead.image = [UIImage imageNamed:model.ChatObjectCategory == 0 ? @"3.2_chat_客服-icon" :@"3.2_chat_对方-icon"];
        self.rightHead.image = nil;
        self.conView.backgroundColor = [UIColor whiteColor];
        self.conLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    }
    [self.contentView setNeedsUpdateConstraints];
}

@end
