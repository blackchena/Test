//
//  IDCMSettingMemorizingWordsViewModel.m
//  IDCMWallet
//
//  Created by huangyi on 2018/4/1.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import "IDCMSettingMemorizingWordsViewModel.h"

@implementation IDCMSettingMemorizingWordsViewModel

- (void)initialize {
    
    RACSignal *enbeldSignal = [[RACSignal
                               combineLatest:@[ RACObserve(self, oneText),
                                                RACObserve(self, twoText),
                                                RACObserve(self, threeText),
                                                RACObserve(self, fourText) ,
                                                RACObserve(self, fiveText),
                                                RACObserve(self, sixText),
                                                RACObserve(self, sevenText),
                                                RACObserve(self, eightText),
                                                RACObserve(self, nineText),
                                                RACObserve(self, tenText),
                                                RACObserve(self, elevenText),
                                                RACObserve(self, twelveText)]
                                       reduce:^(NSString *one,
                                                NSString *two,
                                                NSString *three,
                                                NSString *four,
                                                NSString *five,
                                                NSString *six,
                                                NSString *seven,
                                                NSString *eight,
                                                NSString *nine,
                                                NSString *ten,
                                                NSString *eleven,
                                                NSString *twelve) {
                                           
                                           
                                       return @(one.length > 0 &&
                                                two.length > 0 &&
                                                three.length > 0 &&
                                                four.length > 0 &&
                                                five.length > 0 &&
                                                six.length > 0 &&
                                                seven.length > 0 &&
                                                eight.length > 0 &&
                                                nine.length > 0 &&
                                                ten.length > 0 &&
                                                eleven.length > 0 &&
                                                twelve.length > 0);
                               }]
                              distinctUntilChanged];
    
    
    @weakify(self);
    self.sureCommand = [[RACCommand alloc] initWithEnabled:enbeldSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        self.endEditingCallback ? self.endEditingCallback() : nil;
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            @strongify(self);
            NSMutableArray *wordArr = @[].mutableCopy;
            NSDictionary *dic1 = @{@"serial_number":@(1),@"phrase":[self.oneText lowercaseString]};
            [wordArr addObject:dic1];
            NSDictionary *dic2 = @{@"serial_number":@(2),@"phrase":[self.twoText lowercaseString]};
            [wordArr addObject:dic2];
            NSDictionary *dic3 = @{@"serial_number":@(3),@"phrase":[self.threeText lowercaseString]};
            [wordArr addObject:dic3];
            NSDictionary *dic4 = @{@"serial_number":@(4),@"phrase":[self.fourText lowercaseString]};
            [wordArr addObject:dic4];
            NSDictionary *dic5 = @{@"serial_number":@(5),@"phrase":[self.fiveText lowercaseString]};
            [wordArr addObject:dic5];
            NSDictionary *dic6 = @{@"serial_number":@(6),@"phrase":[self.sixText lowercaseString]};
            [wordArr addObject:dic6];
            NSDictionary *dic7 = @{@"serial_number":@(7),@"phrase":[self.sevenText lowercaseString]};
            [wordArr addObject:dic7];
            NSDictionary *dic8 = @{@"serial_number":@(8),@"phrase":[self.eightText lowercaseString]};
            [wordArr addObject:dic8];
            NSDictionary *dic9 = @{@"serial_number":@(9),@"phrase":[self.nineText lowercaseString]};
            [wordArr addObject:dic9];
            NSDictionary *dic10 = @{@"serial_number":@(10),@"phrase":[self.tenText lowercaseString]};
            [wordArr addObject:dic10];
            NSDictionary *dic11 = @{@"serial_number":@(11),@"phrase":[self.elevenText lowercaseString]};
            [wordArr addObject:dic11];
            NSDictionary *dic12 = @{@"serial_number":@(12),@"phrase":[self.twelveText lowercaseString]};
            [wordArr addObject:dic12];
            
            IDCMURLSessionTask *task = [IDCMRequestList requestNotAuth:GetUserByPhrase_URL
                                                                params:wordArr
                                                               success:^(NSDictionary *response) {
                [subscriber sendNext:response];
                [subscriber sendCompleted];
            } fail:^(NSError *error, NSURLSessionDataTask *task) {
                [subscriber sendError:error];
            }];
            return [RACDisposable disposableWithBlock:^{
                [task cancel];
            }];
        }];
    }];
    self.sureCommand.allowsConcurrentExecution = YES;
    
    
    // 仅供开发调试使用（debug）
    self.testCommand = [RACCommand commandNotAuth:GetUserByPhrase_URL serverName:nil params:^id(id input) {
        @strongify(self);
        return [self getwordPara:[input integerValue]];
    } handleCommand:nil];
}

// 仅供开发调试使用（debug）
- (NSMutableArray *)getwordPara:(NSInteger)idx{
    
    NSMutableArray *wordArr = @[].mutableCopy;
    NSArray *word = @[];
    switch (idx) {
        case 0: // BinBear
        {
            word = @[@"egg",@"sudden",@"advance",@"apple",@"salmon",@"mad",@"crowd",@"ginger",@"essence",@"fork",@"public",@"funny"];
        }
            break;
        case 1: // DK
        {
            word = @[@"great",@"truck",@"achieve",@"output",@"slim",@"reward",@"sheriff",@"frog",@"coin",@"olympic",@"brown",@"cover"];
        }
            break;
        case 2: // HY
        {
            word = @[@"grace",@"coyote",@"rifle",@"royal",@"east",@"fantasy",@"consider",@"public",@"sauce",@"armed",@"aspect",@"elder"];
        }
            break;
        case 3: // fisker
        {
            word = @[@"badge",@"gadget",@"idle",@"over",@"anxiety",@"glass",@"target",@"index",@"cute",@"general",@"guess",@"prosper"];
        }
            break;
        case 4: // zjw
        {
            word = @[@"else",@"final",@"captain",@"improve",@"nurse",@"fever",@"chaos",@"welcome",@"now",@"sunny",@"tongue",@"angry"];
        }
            break;
        case 5: // wp
        {
            word = @[@"crisp",@"lawn",@"obey",@"tennis",@"live",@"voice",@"uncle",@"about",@"patch",@"breeze",@"cake",@"tornado"];
        }
            break;
        case 6: // test1
        {
            word = @[@"van",@"version",@"this",@"thank",@"nose",@"okay",@"guide",@"pink",@"owner",@"demand",@"correct",@"dutch"];
        }
            break;
        case 7: // test4
        {
            word = @[@"bridge",@"toast",@"argue",@"save",@"soup",@"cannon",@"ring",@"during",@"vivid",@"office",@"case",@"chronic"];
        }
            break;
        case 8: // test6
        {
            word = @[@"sudden",@"naive",@"swap",@"throw",@"risk",@"grant",@"deal",@"sun",@"matter",@"advice",@"prosper",@"genius"];
        }
            break;
        case 9: // test7
        {
            word = @[@"doctor",@"offer",@"able",@"cheap",@"exact",@"detect",@"say",@"oven",@"boy",@"comfort",@"spread",@"tape"];
        }
            break;
        case 10: // test8
        {
            word = @[@"senior",@"east",@"shock",@"gauge",@"melody",@"tiny",@"come",@"arrive",@"grace",@"hire",@"lumber",@"trim"];
        }
            break;
        default: // test10
        {
            word = @[@"scene",@"learn",@"bubble",@"salad",@"tongue",@"item",@"destroy",@"quit",@"bounce",@"moral",@"mixed",@"position"];
        }
            break;
    }
    NSDictionary *dic1 = @{@"serial_number":@(1),@"phrase":word[0]};
    [wordArr addObject:dic1];
    NSDictionary *dic2 = @{@"serial_number":@(2),@"phrase":word[1]};
    [wordArr addObject:dic2];
    NSDictionary *dic3 = @{@"serial_number":@(3),@"phrase":word[2]};
    [wordArr addObject:dic3];
    NSDictionary *dic4 = @{@"serial_number":@(4),@"phrase":word[3]};
    [wordArr addObject:dic4];
    NSDictionary *dic5 = @{@"serial_number":@(5),@"phrase":word[4]};
    [wordArr addObject:dic5];
    NSDictionary *dic6 = @{@"serial_number":@(6),@"phrase":word[5]};
    [wordArr addObject:dic6];
    NSDictionary *dic7 = @{@"serial_number":@(7),@"phrase":word[6]};
    [wordArr addObject:dic7];
    NSDictionary *dic8 = @{@"serial_number":@(8),@"phrase":word[7]};
    [wordArr addObject:dic8];
    NSDictionary *dic9 = @{@"serial_number":@(9),@"phrase":word[8]};
    [wordArr addObject:dic9];
    NSDictionary *dic10 = @{@"serial_number":@(10),@"phrase":word[9]};
    [wordArr addObject:dic10];
    NSDictionary *dic11 = @{@"serial_number":@(11),@"phrase":word[10]};
    [wordArr addObject:dic11];
    NSDictionary *dic12 = @{@"serial_number":@(12),@"phrase":word[11]};
    [wordArr addObject:dic12];
    return wordArr;
}
@end








