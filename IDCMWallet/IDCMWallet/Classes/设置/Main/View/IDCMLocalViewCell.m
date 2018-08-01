//
//  IDCMLocalViewCell.m
//  IDCMWallet
//
//  Created by BinBear on 2018/1/1.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMLocalViewCell.h"


@interface IDCMLocalViewCell ()

@property (weak, nonatomic) IBOutlet UIView *line;

@end

@implementation IDCMLocalViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentLabel.textColor = SetColor(51, 51, 51);
    self.line.backgroundColor = SetColor(244, 244, 244);
}


@end
