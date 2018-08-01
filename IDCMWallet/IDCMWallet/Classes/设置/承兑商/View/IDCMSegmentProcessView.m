//
//  IDCMSegment.m
//  IDCMWallet
//
//  Created by wangpu on 2018/4/10.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMSegmentProcessView.h"

#define DONECOLOR     [UIColor colorWithHexString:@"#2E406B"]
#define UNDONECOLOR   [UIColor colorWithHexString:@"#999FA5"]
#define NUMFont       SetFont(@"PingFangSC-Regular", 11)
#define TITLEFont     SetFont(@"PingFangSC-Regular", 12)

@interface IDCMSegmentProcessView ()
{
    
}

@property (nonatomic, strong) UIView *lineUndo;
@property (nonatomic, strong) UIView *lineDone;
@property (nonatomic, strong) NSMutableArray< UILabel *> *cricleMarks;//圆环labels
@property (nonatomic, strong) NSMutableArray <UILabel *> *titleLabels;//下面标题

@end

@implementation IDCMSegmentProcessView

- (instancetype)initWithFrame:(CGRect)frame titles:( NSArray *) titles{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _titles = titles;
        _stepIndex = 0;
        
        [self initUIView];
    }
    return self;
}

-(void)initUIView{
    
    [self addSubview:self.lineUndo];
    [self addSubview:self.lineDone];
    for (int i=0; i<self.titles.count;i++)
    {
        NSString * title = self.titles[i];
        UILabel *lbl = [[UILabel alloc]init];
        lbl.text = title;
        lbl.numberOfLines = 0;
        lbl.textColor = UNDONECOLOR;
        lbl.font = TITLEFont;
        lbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lbl];
        [self.titleLabels addObject:lbl];
        
        UILabel *circle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
        circle.backgroundColor = UNDONECOLOR;
        circle.text = [NSString stringWithFormat:@"%d",i+1];
        circle.textAlignment = NSTextAlignmentCenter;
        circle.layer.cornerRadius = 16.f / 2;
        circle.clipsToBounds = YES;
        circle.textColor = [UIColor whiteColor];
        circle.font = NUMFont;
        [self addSubview:circle];
        [self.cricleMarks addObject:circle];
    }

}

//
- (void)layoutSubviews{
    
      NSInteger perWidth = self.frame.size.width / self.titles.count;
      self.lineUndo.frame = CGRectMake(perWidth/2.0, 17, self.frame.size.width - perWidth,2);
      self.lineUndo.center = CGPointMake(self.frame.size.width / 2, 17.5);
      CGFloat startX = self.lineUndo.frame.origin.x;
    
        for (int i = 0; i < self.titles.count; i++)
        {
            UILabel *circle = [self.cricleMarks objectAtIndex:i];
            
            if (circle != nil)
            {
                circle.center = CGPointMake(i * perWidth + startX, self.lineUndo.center.y);
            }
            
            UILabel *lbl = [self.titleLabels objectAtIndex:i];
            
            if (lbl != nil)
            {
                NSString * str =  self.titles[i];
                CGRect textRect = [str boundingRectWithSize:CGSizeMake(self.frame.size.width / _titles.count, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:TITLEFont} context:nil];
                lbl.frame = CGRectMake(perWidth * i, 32, self.frame.size.width / _titles.count, textRect.size.height);
            }
        }
}

- (void)setStepIndex:(NSInteger)stepIndex
{
    if (stepIndex >= 0 && stepIndex < self.titles.count)
    {
        _stepIndex = stepIndex;
        
        CGFloat perWidth = self.frame.size.width / self.titles.count;
        
        self.lineDone.frame = CGRectMake(perWidth/2.0, 17, perWidth * stepIndex,2);
        for (int i = 0; i < self.titles.count; i++)
        {
            UILabel *circle = [self.cricleMarks objectAtIndex:i];
            if (circle != nil)
            {
                if (i <= stepIndex)
                {
                    circle.backgroundColor = DONECOLOR;
                }
                else
                {
                    circle.backgroundColor = UNDONECOLOR;
                }
            }
            
            UILabel *lbl = [self.titleLabels objectAtIndex:i];
            if (lbl != nil)
            {
                if (i <= stepIndex)
                {
                    lbl.textColor = DONECOLOR;
                }
                else
                {
                    lbl.textColor = UNDONECOLOR;
                }
            }
        }
    }
}

- (void)setStepIndex:(NSInteger)stepIndex animation:(BOOL)animation
{
    if (stepIndex >= 0 && stepIndex < self.titles.count)
    {
        if (animation)
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.stepIndex = stepIndex;
            }];
        }
        else
        {
            self.stepIndex = stepIndex;
        }
    }
}

#pragma mark - Getter

- (NSMutableArray *)cricleMarks
{
    if (!_cricleMarks)
    {
        _cricleMarks = [[NSMutableArray alloc] init];;
    }
    return _cricleMarks;
}

- (NSMutableArray *)titleLabels
{
    if (!_titleLabels)
    {
        _titleLabels = [[NSMutableArray alloc] init];
    }
    return _titleLabels;
}

-(UIView *)lineUndo{
    
    if (!_lineUndo) {
        _lineUndo = [[UIView alloc]init];
        _lineUndo.backgroundColor = UNDONECOLOR;
    }
    return _lineUndo;
}

-(UIView *)lineDone{
    
    if (!_lineDone) {
        _lineDone = [[UIView alloc]init];
        _lineDone.backgroundColor = DONECOLOR;
    }
    return _lineDone;
}

@end
