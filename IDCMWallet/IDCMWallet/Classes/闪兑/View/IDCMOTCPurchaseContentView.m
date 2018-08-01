

//
//  IDCMOTCPurchaseContentView.m
//  IDCMWallet
//
//  Created by mac on 2018/5/6.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMOTCPurchaseContentView.h"
#import "UILabel+CreateLabel.h"
@implementation IDCMOTCPurchaseContentView
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
      
        
        
        
    }
    return self;
}
-(UILabel*)LeftLabel{
    return SW_LAZY(_LeftLabel, ({
        UILabel * label = [UILabel createLabelWithTitle:@"" titleColor:[UIColor colorWithHexString:@"#666666"] font:textFontPingFangRegularFont(12.0f) textAlignment:NSTextAlignmentLeft];
        label;
    }));
}
-(UIView *)rightContentView{
    
    return SW_LAZY(_rightContentView, ({
        UIView * view = [UIView new];
        
        
        view;
    }));
}
@end
