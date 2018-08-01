//
//  IDCMAcceptVariableCell.h
//  IDCMWallet
//
//  Created by wangpu on 2018/4/10.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IDCMAcceptVariableModel;

typedef void (^CellEditBlock)(void);
typedef void (^CellBottomBtnBlock)(NSString * type);

@interface IDCMAcceptVariableCell : UITableViewCell
@property (nonatomic,copy) CellEditBlock  callBack;
@property (nonatomic,copy) CellBottomBtnBlock  bottomBtnCallBack;
@property (nonatomic,strong) IDCMAcceptVariableModel * cellModel;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
