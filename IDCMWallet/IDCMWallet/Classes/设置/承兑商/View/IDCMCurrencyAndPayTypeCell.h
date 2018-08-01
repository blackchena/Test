//
//  IDCMCurrencyAndPayeTypeCell.h
//  IDCMWallet
//
//  Created by wangpu on 2018/4/11.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <UIKit/UIKit.h>


@class IDCMAcceptVariableModel;


typedef void (^CellCallBackBlock) (void);
@interface IDCMCurrencyAndPayTypeCell : UITableViewCell

@property (nonatomic,strong) IDCMAcceptVariableModel * model;

@property (nonatomic,copy) CellCallBackBlock  cellCallBack;

-(void)updateWithModel:(IDCMAcceptVariableModel *) model;
@end
