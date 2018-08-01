//
//  BetaNaoTextField.m
//  BWWalkthroughExample
//
//  Created by mukesh mandora on 24/07/15.
//  Copyright (c) 2015 Yari D'areglia. All rights reserved.
//

#import "BetaNaoTextField.h"

@interface BetaNaoTextField (){
    //    UILabel *self.self.placeholder;
    CGFloat inset;
  
    CAShapeLayer *leftLayer;
    CGPoint textFieldInset,placeholderInset;
    BOOL isNotBlank,isNotFirst;
}

@property (nonatomic) CGFloat placeholderHeight;


@end
@implementation BetaNaoTextField
@synthesize placeHolderLabel;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    if (!isNotBlank) {
        [self addPlaceHolderLabel];
    }
    
    
    UIBezierPath *leftPath = [UIBezierPath bezierPath];
    // Set the starting point of the shape.
    [leftPath moveToPoint:CGPointMake(0,self.bounds.size.height)];
    // Draw the lines.
    [leftPath addLineToPoint:CGPointMake(0,self.bounds.size.height)];
    [leftPath addLineToPoint:CGPointMake(self.bounds.size.width,self.bounds.size.height)];
    
    leftLayer.path = leftPath.CGPath;
    leftLayer.fillColor = nil;
    leftLayer.borderWidth = 3.0f;
    leftLayer.lineCap = kCALineCapRound;
    leftLayer.lineJoin = kCALineJoinRound;
    //    leftLayer.frame=CGRectMake(0, 50, 200, 1);
    leftLayer.borderColor=[UIColor blackColor].CGColor;
    [self.layer addSublayer:leftLayer];
    

}

- (instancetype)init
{
    self.delegate = self;
    if (self = [super init]) {
        self.placeHolderLabel = [[UILabel alloc] init];
        self.placeHolderLabel.text = @"Add comment here";
        self.placeHolderLabel.textColor = SetColor(207, 215, 222);
        self.placeHolderLabel.backgroundColor=[UIColor clearColor];
        self.placeHolderLabel.font =  SetFont(@"PingFang-SC-Regular", 17);;
        self.placeHolderLabel.textAlignment = NSTextAlignmentCenter;
        
        
        placeholderInset = CGPointMake(6, 6);
        textFieldInset = CGPointMake(6, 6);
        
        leftLayer = [CAShapeLayer layer];
        leftLayer.strokeColor = SetColor(160, 165, 171).CGColor;
        
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    self.delegate = self;
    if (self) {
        self.placeHolderLabel = [[UILabel alloc] init];
        self.placeHolderLabel.text = @"Add comment here";
        self.placeHolderLabel.textColor = SetColor(207, 215, 222);
        self.placeHolderLabel.backgroundColor=[UIColor clearColor];
        self.placeHolderLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0];
        self.placeHolderLabel.textAlignment = NSTextAlignmentCenter;
       
        
        placeholderInset = CGPointMake(6, 6);
        textFieldInset = CGPointMake(6, 6);
        
        leftLayer = [CAShapeLayer layer];
        
        self.backgroundColor=[UIColor clearColor];

    }
    
    return self;
}



-(void)animateCureve{
    
    
    
    CABasicAnimation *pathAppear = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAppear.duration = 1.0;
    pathAppear.fromValue = (__bridge id)leftLayer.path;
    pathAppear.toValue   = (__bridge id)[self wavePath].CGPath;
    
    [leftLayer addAnimation:pathAppear forKey:@"make the path appear"];
    
}
- (UIBezierPath *)wavePath {
    //set start and end accordingly
    
    UIBezierPath *startPath = [UIBezierPath bezierPath];
    
    [startPath moveToPoint:CGPointMake(0, self.bounds.size.height)];
    //    [startPath addQuadCurveToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height/2) controlPoint:CGPointMake(self.bounds.size.width/2,10)];
    
    [startPath addCurveToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height) controlPoint1:CGPointMake(20, self.bounds.size.height+0)  controlPoint2:CGPointMake(self.bounds.size.width/2, 20) ];
    [startPath moveToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
    [startPath addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
    
    return startPath;
}

-(void)setPlaceholderHeight:(CGFloat)placeholderHeight{
    
}

-(CGFloat)placeholderHeight{
    
    
    
    UIFont *fontOfText=[UIFont fontWithName:@"HelveticaNeue" size:self.font.pointSize*0.7];
    return placeholderInset.y+fontOfText.lineHeight;
}
- (void)addPlaceHolderLabel
{
    
     self.placeHolderLabel.frame = CGRectMake(0, self.bounds.size.height-35, self.bounds.size.width, 25);
//    [self addSubview:self.placeHolderLabel];
    
}

-(void)setBorderLayer{
    
}


//-(CGRect)textRectForBounds:(CGRect)bounds{
//    return CGRectOffset(self.bounds, 0, self.bounds.size.height/2-textFieldInset.y);
//}
//
//-(CGRect)editingRectForBounds:(CGRect)bounds{
//    return [self textRectForBounds:bounds];
//}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if ([textField.text isEqual:@""]) {
        isNotBlank = NO;
        [self animateCureve];
        [UIView animateWithDuration:0.5 delay:0.2 options:0 animations:^{
            self.placeHolderLabel.frame = CGRectMake(0, 25, self.bounds.size.width, 25);
            
            leftLayer.strokeColor = SetColor(41, 104, 185).CGColor;
        } completion:^(BOOL finished) {
            self.placeHolderLabel.textColor = SetColor(51, 51, 51);
        }];
    }else{
        isNotBlank = YES;
        leftLayer.strokeColor = SetColor(41, 104, 185).CGColor;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if([textField.text isEqual:@""]){
          [UIView animateWithDuration:0.5 animations:^{
            
              self.placeHolderLabel.frame=CGRectMake(0, self.bounds.size.height-35, self.bounds.size.width, 25);
              self.placeHolderLabel.textColor = SetColor(207, 215, 222);
              leftLayer.strokeColor = SetColor(160, 165, 171).CGColor;
        }];
    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqual: @" "]) {
        return NO;
    }
    return YES;
}
@end

