//
//  IDCMOTCChooseTypeView.h
//  IDCMWallet
//
//  Created by wangpu on 2018/5/11.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "IDCMChooseBTypeBaseView.h"

@interface IDCMOTCChooseTypeView : IDCMChooseBTypeBaseView


@property (nonatomic,copy) NSString *   modelType;

-(instancetype) initWithFrame:(CGRect)frame bTypes:(NSArray *)types title:(NSString *)title withModelType:(NSString *) type;


@end

