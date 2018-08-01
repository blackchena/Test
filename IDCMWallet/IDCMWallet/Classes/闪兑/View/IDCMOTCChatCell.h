//
//  IDCMOTCChatCell.h
//  IDCMWallet
//
//  Created by 数维科技 on 2018/5/4.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCMOTCChatModel.h"

//@interface IDCMOTCChatCellModel : NSObject
//
//@property (nonatomic, assign) BOOL send;
//
//@property (nonatomic, strong) NSString *headImg;
//@property (nonatomic, strong) id conImg;
//@property (nonatomic, strong) NSString *content;
//
//@end
typedef void(^ChatTapImageView)(UIImage *img);
typedef void(^ChatTapRetryButton)(NSIndexPath *indexPath);

@interface IDCMOTCChatCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@property (weak, nonatomic) IBOutlet UIImageView *leftHead;
@property (weak, nonatomic) IBOutlet UIButton *retryButton;

@property (weak, nonatomic) IBOutlet UIView *conView;
@property (weak, nonatomic) IBOutlet UILabel *conLabel;
@property (weak, nonatomic) IBOutlet UIImageView *conImageView;

@property (weak, nonatomic) IBOutlet UIImageView *rightHead;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *conViewRight;



@property (nonatomic, strong) IDCMOTCChatModel *model;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) ChatTapImageView chatTapImageView;
@property (nonatomic, copy) ChatTapRetryButton chatTapRetryButton;
@end
