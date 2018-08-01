//
//  IDCMOTCWorkStationTopView.h
//  IDCMWallet
//
//  Created by 数维科技 on 2018/5/6.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IDCMOTCWorkStationTopView : UIView
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (strong, nonatomic) UIView *line;

@end
