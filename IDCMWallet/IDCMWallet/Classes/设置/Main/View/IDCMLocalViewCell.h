//
//  IDCMLocalViewCell.h
//  IDCMWallet
//
//  Created by BinBear on 2018/1/1.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMLocalViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *localLogo;
@property (weak, nonatomic) IBOutlet UIImageView *selectLogo;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@end
