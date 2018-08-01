//
//  IDCMHomeChartViewTool.m
//  IDCMWallet
//
//  Created by huangyi on 2018/3/20.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMHomeChartViewTool.h"

@implementation IDCMHomeChartViewTool

+ (NSArray<NSNumber *> *)handleChartViewCoordinateWithValueMax:(double)valueMax
                                                      valueMin:(double)valueMin {

    NSArray   *resultArr = @[];
    valueMax = [self precisionControl:valueMax];
    valueMin = [self precisionControl:valueMin];
    double differ = valueMax - valueMin;
    
    CGFloat  differStep ;
    NSNumber *differOne;
    NSNumber *differTwo;
    NSNumber *differThree;
    NSNumber *differFour;
    NSNumber *differFive;
    
    if (differ == 0) { //相等
        
        differStep = valueMin / 2.0;
        differOne = [self stringFromNumber:0 fractionDigits:2];
        differTwo = [self stringFromNumber:differStep fractionDigits:2];
        differThree = [self stringFromNumber:differStep*2 fractionDigits:2];
        differFour = [self stringFromNumber:differStep*3 fractionDigits:2];
        differFive = [self stringFromNumber:differStep*4 fractionDigits:2];

        resultArr = @[differOne,differTwo,differThree,differFour,differFive];
        
    } else if (differ > 1) { //  差值大于1
        
        NSInteger max,min;
        NSInteger intValueMax = (int)valueMax;
        NSInteger intValueMin = (int)valueMin;
        
        if (intValueMax == intValueMin) { // 整形相等情况
            
            min = 0;
            if (intValueMin <= 1 && intValueMax <= 1) {
                max = 4;
            }else if(intValueMin <= 1 && intValueMax > 1){
                max = intValueMax;
            } else {
                max = intValueMax * 2;
            }
            
        } else {
            
            NSInteger differDigit = [self getDigitWithValue:differ]; // 获取差值有多少位
            NSInteger differPowUnit = pow(10, differDigit);         //差值位数的单位值
            
            //  单位值比例  差值小于四个单位值 比例设为0.5
            double ratio = (differ < differPowUnit * 4) ? (0.5) : (1.0);
            CGFloat ratioValue = differPowUnit * ratio;
            if (ratioValue < 1) {         // 防止小于1传入chartView后小数点被截取掉
                ratioValue = 1;
            }
            
            // 最大值加上单位比例值
            max = (intValueMax < 1) ? (4) : (intValueMax + ratioValue);
            
            // 最小值减去单位比例值
            min = (intValueMin < 1) ? (0) : (intValueMin - ratioValue);
        }
        
        NSInteger step,stepOne,stepTwo,stepThree,stepFour,stepFive;
        NSInteger tempYu = (max - min) % 4;
        step = tempYu ? ((max - min + 4 - tempYu) / 4) : ((max - min) /4 ); // 除法 取余求整数
        
        stepOne = min;
        stepTwo = step+stepOne;
        stepThree = step+stepTwo;
        stepFour = step+stepThree;
        stepFive = stepFour+step;
        resultArr = @[@(stepOne),@(stepTwo),@(stepThree),@(stepFour),@(stepFive)];
        
    } else if (differ <= 1) { // 差值小于1 处理保留多少位相关
        
        differStep = differ / 4.0;
        NSInteger differlocation = [self getDotLocationWithValue:differStep]; // 差值小数点位数单
        NSInteger minLocation = [self getDotLocationWithValue:valueMin];     // 最小值小数点位数单
        NSInteger currentLocation = MAX(differlocation, minLocation);      // 最后保留的位数 取大的那个
        
        CGFloat tempUnit = (1.0 / pow(10, currentLocation)); // 小数点位数单位值
        valueMin -= (tempUnit * 2);
        valueMax += (tempUnit * 2);
        differStep += tempUnit;  // 防止小于单位值的小数位被截取  differStep至少加上一个小数点位数单位值
        
        differlocation = [self getDotLocationWithValue:differStep]; // 为了准确再取一次
        currentLocation = MAX(differlocation, minLocation);
        
        NSDecimalNumberHandler *handle = [NSDecimalNumberHandler
                                          decimalNumberHandlerWithRoundingMode:NSRoundUp
                                          scale:differlocation
                                          raiseOnExactness:NO
                                          raiseOnOverflow:NO
                                          raiseOnUnderflow:NO
                                          raiseOnDivideByZero:NO];
        
        NSDecimalNumber *differvalue = [NSDecimalNumber decimalNumberWithFloat:differStep
                                                                 roundingScale:differlocation
                                                                  roundingMode:NSRoundUp];
        
        NSDecimalNumber *differOne = [NSDecimalNumber decimalNumberWithFloat:valueMin
                                                               roundingScale:currentLocation
                                                                roundingMode:NSRoundDown];
        
        NSDecimalNumber *differTwo = [[differOne decimalNumberByAdding:differvalue] decimalNumberByRoundingAccordingToBehavior:handle];
        NSDecimalNumber *differThree = [[differTwo decimalNumberByAdding:differvalue] decimalNumberByRoundingAccordingToBehavior:handle];
        NSDecimalNumber *differFour = [[differThree decimalNumberByAdding:differvalue] decimalNumberByRoundingAccordingToBehavior:handle];
        NSDecimalNumber *differFive = [[differFour decimalNumberByAdding:differvalue] decimalNumberByRoundingAccordingToBehavior:handle];
        
        resultArr = @[differOne,differTwo,differThree,differFour,differFive];
    }
    
    return resultArr;
}


#pragma mark — 计算一个大于0数的位数
+ (NSInteger)getDigitWithValue:(double)value {
    
    CGFloat tempValue = value;
    for (int i = 0; i < MAXFLOAT; i++) {
        tempValue = tempValue/10;
        if(tempValue <= 1.0){
            return i;
        }
    }
    return 0;
}


#pragma mark — 获取小于0 的位数
+ (NSInteger)getDotLocationWithValue:(CGFloat)value {
    
    NSArray *array = [[NSString stringWithFormat:@"%f", value] componentsSeparatedByString:@"."];
    if (array.count > 1) {
        NSString *minstr = array.lastObject;
        for(int i = 0; i < minstr.length; i++) {
            NSString *temp = [minstr substringWithRange:NSMakeRange(i, 1)];
            if (![temp isEqualToString:@"0"]) {
                return i + 1;
            }
        }
    }
    return 0;
}


+ (double)precisionControl:(double)balance {
    double rounded_up = round(balance * 100000000) / 100000000;
    return rounded_up;
}


+ (NSNumber *)stringFromNumber:(CGFloat)number fractionDigits:(NSUInteger)fractionDigits {
    return [NSDecimalNumber decimalNumberWithFloat:number
                                     roundingScale:fractionDigits
                                      roundingMode:NSRoundPlain];;
}

@end



