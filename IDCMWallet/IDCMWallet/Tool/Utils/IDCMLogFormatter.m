//
//  IDCMLogFormatter.m
//  IDCMExchange
//
//  Created by 数维科技 on 2018/4/17.
//  Copyright © 2018年 IDC. All rights reserved.
//

#import "IDCMLogFormatter.h"

@interface IDCMLogFormatter()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end
@implementation IDCMLogFormatter

-(instancetype)init {
    if (self = [super init]) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4]; // 10.4+ style
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSSZ"];
    }
    return self;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel;
    switch (logMessage->_flag) {
        case DDLogFlagError    : logLevel = @"E"; break;
        case DDLogFlagWarning  : logLevel = @"W"; break;
        case DDLogFlagInfo     : logLevel = @"I"; break;
        case DDLogFlagDebug    : logLevel = @"D"; break;
        case DDLogFlagVerbose  : logLevel = @"V"; break;
    }
    NSString *dateAndTime = [_dateFormatter stringFromDate:(logMessage->_timestamp)];
    
    return [NSString stringWithFormat:@"%@[%@:%@:%zd]:%@",dateAndTime,logLevel,logMessage.fileName,logMessage.line,logMessage.message];
}
@end
