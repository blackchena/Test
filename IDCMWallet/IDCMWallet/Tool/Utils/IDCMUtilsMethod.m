//
//  IDCMUtilsMethod.m
//  IDCMWallet
//
//  Created by BinBear on 2017/11/18.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMUtilsMethod.h"
#import "IDCMUserStateModel.h"
#import "IDCMBaseViewController.h"


@implementation IDCMUtilsMethod
+ (BOOL)keyedArchiverWithObject:(id)object withKey:(NSString *)key
{
    if (!object) {
        return NO;
    }
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path  = [docPath stringByAppendingPathComponent:key];
    // 归档
   BOOL isSuccess = [NSKeyedArchiver archiveRootObject:object toFile:path];

    return isSuccess;
}
+ (id)getKeyedArchiverWithKey:(NSString *)key
{
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path=[docPath stringByAppendingPathComponent:key];
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

+(BOOL)isValidateUserName:(NSString *)userName
{
    NSString *phoneRegex = @"^[0-9A-Za-z]{4,16}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:userName];
}
+ (BOOL)isValidatePassword:(NSString *)password
{
    NSString *phoneRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:password];
}
//删除小数点后面多余的0
+ (NSString *)changeFloat:(NSString *)stringFloat
{
    NSInteger length = [stringFloat length];
    if ([stringFloat containsString:@"."]) {
        
        for(NSInteger i = length - 1; i >= 0; i--)
        {
            NSString *subString = [stringFloat substringFromIndex:i];
            if(![subString isEqualToString:@"0"])
            {
                if ([subString isEqualToString:@"."]) {
                    
                    return [stringFloat substringToIndex:[stringFloat length] - 1];
                    
                }else{
                    
                    return stringFloat;
                }
            }
            else
            {
                stringFloat = [stringFloat substringToIndex:i];
            }
        }
    }
    return stringFloat;
}
+ (NSString *)precisionControl:(NSNumber *)balance
{
    long double rounded_up = round([balance doubleValue] * 10000000000) / 10000000000;
    NSString *amoutStr = [IDCMUtilsMethod changeFloat:[NSString stringWithFormat:@"%.10Lf",rounded_up]];
    return amoutStr;
}
+ (NSString *)getLocalCurrencyName
{
    NSString *localName = [CommonUtils getStrValueInUDWithKey:LocalCurrencyNameKey];
    if ([localName isNotBlank]) {
        return localName;
    }else{
        return @"USD";
    }
}
+ (NSString*)getPreferredLanguage{
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *preferredLang = [NSString stringWithFormat:@"%@",[languages objectAtIndex:0]]; //系统语言
    NSString *appLanguage = [CommonUtils getStrValueInUDWithKey:LocalLanguageKey]; //应用内语言
    
    if ([appLanguage isNotBlank]) { //有应用内语言
 
        if ([appLanguage isEqualToString:@"zh-Hans"]) {//中文简体
            return @"zh-Hans";
        }else if ([appLanguage isEqualToString:@"zh-Hant"]){//中文繁体
            return @"zh-Hant";
        }else if ([appLanguage isEqualToString:@"ko"]){//韩语
            return @"ko";
        }else if ([appLanguage isEqualToString:@"ja"]){//日文
            return @"ja";
        }else if ([appLanguage isEqualToString:@"vi"]){//越南语
            return @"vi";
        }else if ([appLanguage isEqualToString:@"fr"]){//法语
            return @"fr";
        }else if ([appLanguage isEqualToString:@"nl"]){//荷兰语
            return @"nl";
        }else if([appLanguage isEqualToString:@"es"]){//西班牙语
            return @"es";
        }else{
            return @"en";
        }
    }else{
        
        if ([preferredLang isEqualToString:@"zh-Hans"] || [preferredLang hasPrefix:@"yue-Hans"] || [preferredLang hasPrefix:@"zh-Hans"]) {
            return @"zh-Hans";
        }else if ([preferredLang isEqualToString:@"zh-Hant"] || [preferredLang hasPrefix:@"zh-Hant"] || [preferredLang hasPrefix:@"yue-Hant"] || [preferredLang isEqualToString:@"zh-HK"] || [preferredLang isEqualToString:@"zh-TW"]){
            return @"zh-Hant";
        }else if ([preferredLang containsString:@"ko"]){
            return @"ko";
        }else if ([preferredLang containsString:@"ja"]){
            return @"ja";
        }else if ([preferredLang containsString:@"vi"]){
            return @"vi";
        }else if ([preferredLang containsString:@"fr"]){
            return @"fr";
        }else if ([preferredLang containsString:@"nl"]){
            return @"nl";
        }else if([preferredLang isEqualToString:@"es"]){
            return @"es";
        }else{
            return @"en";
        }
    }
}
+ (NSNumber *)getServiceLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *preferredLang = [NSString stringWithFormat:@"%@",[languages objectAtIndex:0]]; //系统语言
    NSString * appLanguage = [CommonUtils getStrValueInUDWithKey:LocalLanguageKey]; //应用内语言
    
    if ([appLanguage isNotBlank]) { //有应用内语言
        
        if ([appLanguage isEqualToString:@"zh-Hans"]) {//中文简体
            return @(1);
        }else if ([appLanguage isEqualToString:@"zh-Hant"]){//中文繁体
            return @(8);
        }else if ([appLanguage isEqualToString:@"ko"]){//韩语
            return @(4);
        }else if ([appLanguage isEqualToString:@"ja"]){//日文
            return @(2);
        }else if ([appLanguage isEqualToString:@"vi"]){//越南语
            return @(6);
        }else if ([appLanguage isEqualToString:@"fr"]){//法语
            return @(5);
        }else if ([appLanguage isEqualToString:@"nl"]){//荷兰语
            return @(3);
        }else if([appLanguage isEqualToString:@"es"]){//西班牙语
            return @(7);
        }else{ // 英文
            return @(0);
        }
    }else{
        
        if ([preferredLang isEqualToString:@"zh-Hans"] || [preferredLang hasPrefix:@"yue-Hans"] || [preferredLang hasPrefix:@"zh-Hans"]) {
            return @(1);
        }else if ([preferredLang isEqualToString:@"zh-Hant"] || [preferredLang hasPrefix:@"zh-Hant"] || [preferredLang hasPrefix:@"yue-Hant"] || [preferredLang isEqualToString:@"zh-HK"] || [preferredLang isEqualToString:@"zh-TW"]){
            return @(8);
        }else if ([preferredLang containsString:@"ko"]){
            return @(4);
        }else if ([preferredLang containsString:@"ja"]){
            return @(2);
        }else if ([preferredLang containsString:@"vi"]){
            return @(6);
        }else if ([preferredLang containsString:@"fr"]){
            return @(5);
        }else if ([preferredLang containsString:@"nl"]){
            return @(3);
        }else if([preferredLang containsString:@"es"]){
            return @(7);
        }else{
            return @(0);
        }
    }
    
}

+ (NSString*)getH5Language{
    
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *preferredLang = [NSString stringWithFormat:@"%@",[languages objectAtIndex:0]]; //系统语言
    NSString *appLanguage = [CommonUtils getStrValueInUDWithKey:LocalLanguageKey]; //应用内语言
    
    if ([appLanguage isNotBlank]) { //有应用内语言
        
        if ([appLanguage isEqualToString:@"zh-Hans"]) {//中文简体
            return @"zh-CN";
        }else if ([appLanguage isEqualToString:@"zh-Hant"]){//中文繁体
            return @"hk";
        }else if ([appLanguage isEqualToString:@"ko"]){//韩语
            return @"ko";
        }else if ([appLanguage isEqualToString:@"ja"]){//日文
            return @"ja";
        }else if ([appLanguage isEqualToString:@"vi"]){//越南语
            return @"vi";
        }else if ([appLanguage isEqualToString:@"fr"]){//法语
            return @"fr";
        }else if ([appLanguage isEqualToString:@"nl"]){//荷兰语
            return @"nl";
        }else if([appLanguage isEqualToString:@"es"]){//西班牙语
            return @"es";
        }else{
            return @"en";
        }
    }else{
        
        if ([preferredLang isEqualToString:@"zh-Hans"] || [preferredLang hasPrefix:@"yue-Hans"] || [preferredLang hasPrefix:@"zh-Hans"]) {
            return @"zh-CN";
        }else if ([preferredLang isEqualToString:@"zh-Hant"] || [preferredLang hasPrefix:@"zh-Hant"] || [preferredLang hasPrefix:@"yue-Hant"] || [preferredLang isEqualToString:@"zh-HK"] || [preferredLang isEqualToString:@"zh-TW"]){
            return @"hk";
        }else if ([preferredLang containsString:@"ko"]){
            return @"ko";
        }else if ([preferredLang containsString:@"ja"]){
            return @"ja";
        }else if ([preferredLang containsString:@"vi"]){
            return @"vi";
        }else if ([preferredLang containsString:@"fr"]){
            return @"fr";
        }else if ([preferredLang containsString:@"nl"]){
            return @"nl";
        }else if([preferredLang isEqualToString:@"es"]){
            return @"es";
        }else{
            return @"en";
        }
    }
}
+ (NSString *)getPhrasesLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *preferredLang = [NSString stringWithFormat:@"%@",[languages objectAtIndex:0]]; //系统语言
    NSString * appLanguage = [CommonUtils getStrValueInUDWithKey:LocalLanguageKey]; //应用内语言
    if ([appLanguage isNotBlank]) {
        if ([appLanguage isEqualToString:@"zh-Hans"]) {
            return @"ChineseSimplified";
        }else if ([appLanguage isEqualToString:@"zh-Hant"]){
            return @"ChineseSimplified";
        }else if ([appLanguage isEqualToString:@"ja"]){
            return @"Japanese";
        }else if ([appLanguage isEqualToString:@"fr"]){
            return @"French";
        }else if([appLanguage isEqualToString:@"es"]){
            return @"Spanish";
        }else{
            return @"English";
        }
    }else{
        if ([preferredLang isEqualToString:@"zh-Hans"] || [preferredLang hasPrefix:@"yue-Hans"] || [preferredLang hasPrefix:@"zh-Hans"]) {
            return @"ChineseSimplified";
        }else if ([preferredLang isEqualToString:@"zh-Hant"] || [preferredLang hasPrefix:@"zh-Hant"] || [preferredLang hasPrefix:@"yue-Hant"] || [preferredLang isEqualToString:@"zh-HK"] || [preferredLang isEqualToString:@"zh-TW"]){
            return @"ChineseSimplified";
        }else if ([preferredLang containsString:@"ja"]){
            return @"Japanese";
        }else if ([preferredLang containsString:@"fr"]){
            return @"French";
        }else if([preferredLang containsString:@"es"]){
            return @"Spanish";
        }else{
            return @"English";
        }
    }
    
}
+ (NSString *)getLanguagePath
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *preferredLang = [NSString stringWithFormat:@"%@",[languages objectAtIndex:0]]; //系统语言
    NSString * appLanguage = [CommonUtils getStrValueInUDWithKey:LocalLanguageKey]; //应用内语言
    
    NSString * pathStr;
    if ([appLanguage isNotBlank]) { //有应用内语言
        if ([appLanguage isEqualToString:@"zh-Hans"]) {//中文简体
            pathStr = [[NSBundle mainBundle] pathForResource:@"country_cn" ofType:@"json"];
        }else if ([appLanguage isEqualToString:@"zh-Hant"]){ // 中文繁体
            pathStr = [[NSBundle mainBundle] pathForResource:@"country_ft" ofType:@"json"];
        }else if ([appLanguage isEqualToString:@"ko"]){
            pathStr = [[NSBundle mainBundle] pathForResource:@"country_ko" ofType:@"json"];
        }else if ([appLanguage isEqualToString:@"ja"]){
            pathStr = [[NSBundle mainBundle] pathForResource:@"country_ja" ofType:@"json"];
        }else if ([appLanguage isEqualToString:@"vi"]){
            pathStr = [[NSBundle mainBundle] pathForResource:@"country_vi" ofType:@"json"];
        }else if ([appLanguage isEqualToString:@"fr"]){
            pathStr = [[NSBundle mainBundle] pathForResource:@"country_fr" ofType:@"json"];

        }else if ([appLanguage isEqualToString:@"nl"]){
            pathStr = [[NSBundle mainBundle] pathForResource:@"country_nl" ofType:@"json"];
        }else if([appLanguage isEqualToString:@"es"]){
            pathStr = [[NSBundle mainBundle] pathForResource:@"country_es" ofType:@"json"];
        }else{
            pathStr = [[NSBundle mainBundle] pathForResource:@"country_en" ofType:@"json"];
        }

    }else{ //系统语言
        
        if ([preferredLang isEqualToString:@"zh-Hans"] || [preferredLang hasPrefix:@"yue-Hans"] || [preferredLang hasPrefix:@"zh-Hans"]) {
            pathStr = [[NSBundle mainBundle] pathForResource:@"country_cn" ofType:@"json"];
        }else if ([preferredLang isEqualToString:@"zh-Hant"] || [preferredLang hasPrefix:@"zh-Hant"] || [preferredLang hasPrefix:@"yue-Hant"] || [preferredLang isEqualToString:@"zh-HK"] || [preferredLang isEqualToString:@"zh-TW"]){
            pathStr = [[NSBundle mainBundle] pathForResource:@"country_ft" ofType:@"json"];
        }else if ([preferredLang containsString:@"ko"]){
            pathStr = [[NSBundle mainBundle] pathForResource:@"country_ko" ofType:@"json"];
        }else if ([preferredLang containsString:@"ja"]){
            pathStr = [[NSBundle mainBundle] pathForResource:@"country_ja" ofType:@"json"];
        }else if ([preferredLang containsString:@"vi"]){
            pathStr = [[NSBundle mainBundle] pathForResource:@"country_vi" ofType:@"json"];
        }else if ([preferredLang containsString:@"fr"]){
            pathStr = [[NSBundle mainBundle] pathForResource:@"country_fr" ofType:@"json"];
        }else if ([preferredLang containsString:@"nl"]){
            pathStr = [[NSBundle mainBundle] pathForResource:@"country_nl" ofType:@"json"];
        }else if([preferredLang isEqualToString:@"es"]){
            pathStr = [[NSBundle mainBundle] pathForResource:@"country_es" ofType:@"json"];
        }else{
            pathStr = [[NSBundle mainBundle] pathForResource:@"country_en" ofType:@"json"];
        }

    }
    return pathStr;
}
+ (NSString *)stringWithString:(NSDate *)stringDate Format:(NSString *)format locale:(NSLocale *)locale {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    if (locale) [formatter setLocale:locale];
    return [formatter stringFromDate:stringDate];
}

+ (NSString *)addSpaceByString:(NSString *)string separateCount:(NSInteger)separateCount {
    string  = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (separateCount <= 0 ||
        ![string isNotBlank] ||
        [string isKindOfClass:[NSNull class]] ||
        [string isEqualToString:@"null"]  ||
        string.length <= separateCount) {
        return [NSString idcw_stringWithFormat:@"%@", string];
    }
    
    NSInteger row = string.length / separateCount;
    NSMutableArray *array = @[].mutableCopy;
    for (NSInteger i = 0; i< row; i++) {
        NSRange range = NSMakeRange(i *separateCount , separateCount);
        [array addObject:[string substringWithRange:range]];
    }
    NSInteger section = string.length % separateCount;
    if (section > 0) {
        NSRange range = NSMakeRange(string.length - section , section);
        [array addObject:[string substringWithRange:range]];
    }
    return [array componentsJoinedByString:@" "];
}

// 将数字转为每隔3位整数由逗号“,”分隔的字符串
+ (NSString *)separateNumberUseCommaWith:(NSString *)number {

    NSString *replacedStr = [number stringByReplacingOccurrencesOfString:@"," withString:@"."];
    // 分隔符
    NSString *divide = @",";
    
    NSString *integer = @"";
    NSString *radixPoint = @"";
    BOOL contains = NO;
    if ([replacedStr containsString:@"."]) {
        contains = YES;
        // 若传入浮点数，则需要将小数点后的数字分离出来
        NSArray *comArray = [replacedStr componentsSeparatedByString:@"."];
        integer = [comArray firstObject];
        radixPoint = [comArray lastObject];
    } else {
        integer = replacedStr;
    }
    // 将整数按各个字符为一组拆分成数组
    NSMutableArray *integerArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < integer.length; i ++) {
        NSString *subString = [integer substringWithRange:NSMakeRange(i, 1)];
        [integerArray addObject:subString];
    }
    // 将整数数组倒序每隔3个字符添加一个逗号“,”
    NSString *newNumber = @"";
    for (NSInteger i = 0 ; i < integerArray.count ; i ++) {
        NSString *getString = @"";
        NSInteger index = (integerArray.count-1) - i;
        if (integerArray.count > index) {
            getString = [integerArray objectAtIndex:index];
        }
        BOOL result = YES;
        if (index == 0 && integerArray.count%3 == 0) {
            result = NO;
        }
        if ((i+1)%3 == 0 && result) {
            newNumber = [NSString stringWithFormat:@"%@%@%@",divide,getString,newNumber];
        } else {
            newNumber = [NSString stringWithFormat:@"%@%@",getString,newNumber];
        }
    }
    if (contains) {
        newNumber = [NSString stringWithFormat:@"%@.%@",newNumber,radixPoint];
    }
    
    return newNumber;
}
+ (NSString *)encryptStringWithStar:(NSString *)encryptStr andFrontLength:(NSInteger)frontLen andBackLength:(NSInteger)backLen
{
    if (![encryptStr isNotBlank]) {
        return nil;
    }
    NSInteger length = encryptStr.length;
    NSRange frontRange = NSMakeRange(0,frontLen);
    NSString *frontStr = [encryptStr substringWithRange:frontRange];
    NSRange backRange = NSMakeRange(length-backLen,backLen);
    NSString *backStr = [encryptStr substringWithRange:backRange];
    encryptStr = [NSString stringWithFormat:@"%@...%@",frontStr,backStr];
    return encryptStr;
}
+ (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
/** @brief Returns a customized snapshot of a given view. */
+ (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}
+ (NSString *)getStringFrom:(NSNumber *)numberString
{
    
    
    NSString* stringValue = @"0.00";
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.usesSignificantDigits = true;
    formatter.maximumSignificantDigits = 100;
    formatter.groupingSeparator = @"";
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.decimalSeparator = @".";
    stringValue = [formatter stringFromNumber:numberString];
    
    return stringValue;

}

+ (void)checkVersonWithResponse:(NSDictionary *)response withType:(NSString *)type{
    
    NSString *status= [NSString idcw_stringWithFormat:@"%@",response[@"status"]];
    if ([status isEqualToString:@"1"]&& [response[@"data"] isKindOfClass:[NSDictionary class]]) {
        
        if ([response[@"data"][@"isShowUpdate"] isKindOfClass:[NSNumber class]] && [response[@"data"][@"latestVersion"] isKindOfClass:[NSString class]] && [response[@"data"][@"is_enabled"] isKindOfClass:[NSNumber class]] && [response[@"data"][@"updateUrl"] isKindOfClass:[NSString class]]) {
            
            NSString *appVersion = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"latestVersion"]];
            NSString *updateURL = [NSString idcw_stringWithFormat:@"%@",response[@"data"][@"updateUrl"]];
            BOOL isForcedUpdate = [response[@"data"][@"is_enabled"] boolValue];
            BOOL isShowUpdate = [response[@"data"][@"isShowUpdate"] boolValue];
            
            if (![[IDCMUtilsMethod getBundleIdentifier] isEqualToString:IDCWBudidfeKey]) {  // App Store
                
                if (!isShowUpdate && ![IDCMUtilsMethod compareAppVersion:appVersion]) {
                    // 控制App Store版本交易、DApp模块的隐藏
                    [CommonUtils saveBoolValueInUD:YES forKey:ControlHiddenKey];
                }else{
                    // 控制App Store版本交易、DApp模块的开启
                    [CommonUtils saveBoolValueInUD:NO forKey:ControlHiddenKey];
                }
            }
            
            if (isShowUpdate && [IDCMUtilsMethod compareAppVersion:appVersion] && [updateURL isNotBlank]) {  // 有更新
                
                NSString *title = @"";
                NSString *mesaage = @"";
                NSArray *arr = @[];
                if ([type isEqualToString:@"0"]) {
                    title = SWLocaloziString(@"2.0_NewVersion");
                    mesaage = SWLocaloziString(@"2.0_UpdateVersion");
                    arr = isForcedUpdate ? @[SWLocaloziString(@"2.0_Update")] : @[SWLocaloziString(@"2.0_Update"),SWLocaloziString(@"2.0_Cancel")];
                }else{
                    title = [NSString idcw_stringWithFormat:@"%@%@",SWLocaloziString(@"2.1_NewVersionFound"),appVersion];
                    mesaage = nil;
                    arr = isForcedUpdate ? @[SWLocaloziString(@"2.1_UpdateNow")] : @[SWLocaloziString(@"2.1_UpdateNow"),SWLocaloziString(@"2.0_Cancel")];
                }

                [IDCMControllerTool showAlertViewWithTitle:title message:mesaage buttonArray:arr actionBlock:^(NSInteger clickIndex) {
                    
                    if (clickIndex == 0) {
                        if (@available(iOS 10,*)) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateURL] options:@{} completionHandler:^(BOOL success) {
                            }];
                        }else{
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateURL]];
                        }
                    }
                }];
            }else{ // 无更新
                
                if ([type isEqualToString:@"1"]) { // 点击检查更新按钮时，无更新要弹框提示
                    
                    [IDCMControllerTool showAlertViewWithTitle:SWLocaloziString(@"2.1_LatestVersion") message:nil buttonArray:@[SWLocaloziString(@"2.0_Done")] actionBlock:nil];
                }
                
            }
        }
    }
}
// 获取当前控制器
+ (UIViewController *)currentViewController{
    
    UIViewController * currVC = nil;
    UIViewController * Rootvc = [UIApplication sharedApplication].keyWindow.rootViewController ;
    do {
        if ([Rootvc isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)Rootvc;
            UIViewController * v = [nav.viewControllers lastObject];
            currVC = v;
            Rootvc = v.presentedViewController;
            continue;
        }else if([Rootvc isKindOfClass:[UITabBarController class]]){
            UITabBarController * tabVC = (UITabBarController *)Rootvc;
            currVC = tabVC;
            Rootvc = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
            continue;
        }
    } while (Rootvc!=nil);

    return currVC;
}

+ (BOOL)compareAppVersion:(NSString *)appVersion
{
    NSString *app_Version = [CommonUtils getAppVersion];
    if ([appVersion compare:app_Version options:NSNumericSearch] == NSOrderedDescending){
        return YES;
    }else{
        return NO;
    }
}
+ (void)logoutWallet
{
    IDCMUserStateModel *model = [IDCMUtilsMethod getKeyedArchiverWithKey:UserStatusInfokey];
    if ([model.wallet_phrase isEqualToString:@"0"]) { // 未备份助记词
        
        [IDCMControllerTool showAlertViewWithTitle:SWLocaloziString(@"2.2.3_BackupExit") message:nil buttonArray:@[SWLocaloziString(@"2.2.3_IKnow")] actionBlock:nil];
        
    }else{ //已备份助记词
        
        [IDCMControllerTool showAlertViewWithTitle:SWLocaloziString(@"2.2.3_ExitTips") message:nil buttonArray:@[SWLocaloziString(@"2.1_exit"),SWLocaloziString(@"2.0_Cancel")] actionBlock:^(NSInteger clickIndex) {
            
            if (clickIndex == 0) {
                // 退出OTC的SignalR
                [[IDCMOTCSignalRTool sharedOTCSignal] closeSignalR];
                // 清空保存的PIN
                [IDCMUtilsMethod keyedArchiverWithObject:@{}.mutableCopy withKey:FaceIDOrTouchIDKey];
                // 置为非登录
                [CommonUtils saveBoolValueInUD:NO forKey:IsLoginkey];
                // 清空用户信息
                IDCMUserInfoModel *userModel = [[IDCMUserInfoModel alloc] init];
                [IDCMUtilsMethod keyedArchiverWithObject:userModel withKey:UserModelArchiverkey];
                // 清空用户状态信息
                IDCMUserStateModel *statusModel = [[IDCMUserStateModel alloc] init];
                [IDCMUtilsMethod keyedArchiverWithObject:statusModel withKey:UserStatusInfokey];
                [IDCM_APPDelegate setMovieLoginController];
            }
            
        }];
    }
}
+ (NSString *)getTimeWithSeconds:(NSInteger)time{
    if (time <= 0 ) {
        
        return @"00:00";
    }
    time = time * 1000;
    NSInteger minute = (NSInteger) ((time % (1000 * 60 * 60)) / (60 * 1000));
    NSInteger second = (NSInteger) ((time % (1000 * 60)) / 1000);
    NSString *changeMin = @"";
    NSString *changeSec = @"";
    if (minute < 10) {
        changeMin = [NSString idcw_stringWithFormat:@"0%ld",(long)minute];
    }else{
        changeMin = [NSString idcw_stringWithFormat:@"%ld",(long)minute];
    }
    if (second < 10) {
        changeSec = [NSString idcw_stringWithFormat:@"0%ld",(long)second];
    }else{
        changeSec = [NSString idcw_stringWithFormat:@"%ld",(long)second];
    }
    return [NSString idcw_stringWithFormat:@"%@:%@",changeMin,changeSec];

}
+ (NSString *)getAlertMessageWithCode:(NSString *)codeStr{
    //#warning  记得找到相应的语言对应的 plist code码
    NSString * appLanguage  =  [[self class] getPreferredLanguage];
    NSString *pathString ;
    if ([appLanguage isEqualToString:@"zh-Hans"]) {//中文简体
        pathString = [[NSBundle mainBundle] pathForResource:@"code_cn" ofType:@"plist"];
    }else if ([appLanguage isEqualToString:@"zh-Hant"]){//中文繁体
        pathString = [[NSBundle mainBundle] pathForResource:@"code_hant" ofType:@"plist"];
    }else if ([appLanguage isEqualToString:@"ko"]){//韩语
        pathString = [[NSBundle mainBundle] pathForResource:@"code_lo" ofType:@"plist"];
    }else if ([appLanguage isEqualToString:@"ja"]){//日文
        pathString = [[NSBundle mainBundle] pathForResource:@"code_ja" ofType:@"plist"];
    }else if ([appLanguage isEqualToString:@"vi"]){//越南语
        pathString = [[NSBundle mainBundle] pathForResource:@"code_vi" ofType:@"plist"];
    }else if ([appLanguage isEqualToString:@"fr"]){//法语
        pathString = [[NSBundle mainBundle] pathForResource:@"code_fr" ofType:@"plist"];
    }else if ([appLanguage isEqualToString:@"nl"]){//荷兰语
        pathString = [[NSBundle mainBundle] pathForResource:@"code_nl" ofType:@"plist"];
    }else if([appLanguage isEqualToString:@"es"]){//西班牙语
        pathString = [[NSBundle mainBundle] pathForResource:@"code_es" ofType:@"plist"];
    }else{
        pathString = [[NSBundle mainBundle] pathForResource:@"code_en" ofType:@"plist"];
    }
    
    NSDictionary * dict = [[NSDictionary alloc] initWithContentsOfFile:pathString];
    if ([dict[codeStr] isNotBlank]) {
        return dict[codeStr];
    }else{
        return NSLocalizedString(@"3.0_DK_requestError", nil);
        
    }
    
}
+ (NSDecimalNumber *)getStringDecimalNumber:(NSString *)value{
    
    NSDecimalNumber *unit = [NSDecimalNumber decimalNumberWithString:value];
    if([unit isEqualToNumber:NSDecimalNumber.notANumber]){ // 判断NSDecimalNumber 是否为 NaN
        unit = [NSDecimalNumber decimalNumberWithString:@"0"];
    }
    return unit;
}
+ (NSString *)getBundleIdentifier{
    
    NSDictionary* infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleIdentifier = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    return bundleIdentifier;
}
+ (LBXScanViewStyle *)scanStyleWith:(CGFloat)centerPostion andWithBorderColor:(UIColor *)color{
    
    //设置扫码区域参数设置
    
    //创建参数对象
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    //矩形区域中心上移，默认中心点为屏幕中心点
    if (centerPostion > 0) {
        style.centerUpOffset = centerPostion;
    }

    //扫码框周围4个角的类型
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    
    //扫码框周围4个角绘制的线条宽度
    style.photoframeLineW = 5;
    
    //扫码框周围4个角的宽度
    style.photoframeAngleW = 24;
    
    //扫码框周围4个角的高度
    style.photoframeAngleH = 24;
    
    //扫码框内 动画类型 --线条上下移动
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //线条上下移动图片
    style.animationImage = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    
    //矩形框离左边缘及右边缘的距离
    style.xScanRetangleOffset = 20;
    style.whRatio = 1.3;
    
    if (color && [color isKindOfClass:[UIColor class]]) {
        //码框周围4个角的颜色
        style.colorAngle = color;
        //矩形框颜色
        style.colorRetangleLine = color;
    }else{
        //码框周围4个角的颜色
        style.colorAngle = kThemeColor;
        //矩形框颜色
        style.colorRetangleLine = kThemeColor;
    }
    
    return style;
}
+ (NSString *)valueString:(NSString *)string {
    if (string == nil ||
        [string isKindOfClass:[NSNull class]] ||
        ![string isNotBlank]) {
        return @"";
    }
    return string;
}
@end
