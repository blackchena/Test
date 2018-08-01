//
//  RACCommand+Request.h
//  IDCMWallet
//
//  Created by huangyi on 2018/3/21.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>


// 处理执行command的block
typedef void (^requestCommandBlock)(id input, id response,  id<RACSubscriber> subscriber);

// 处理执行command的input来改变请求参数的paramsblock
typedef id (^requestParamsBlock)(id input);

// 处理执行command的input来改变请求Url
typedef id (^requestUrlBlock)(id input);



@interface RACCommand (Request)




/**
 不需要Ticket的post请求(需要hud)
 
 @param url 请求地址
 @param serverName 服务名字
 @param params 参数
 @param handleCommand 自己处理处理信号发送，传入nil 默认处理
 @return Command
 */
+ (instancetype)commandNotAuth:(NSString *)url
                    serverName:(NSString *)serverName
                        params:(requestParamsBlock)params
                 handleCommand:(requestCommandBlock)handleCommand;

+ (instancetype)commandNotAuthWithUrl:(requestUrlBlock)url
                           serverName:(NSString *)serverName
                               params:(requestParamsBlock)params
                        handleCommand:(requestCommandBlock)handleCommand;



/**
 不需要Ticket的post请求(不需要hud)
 
 @param url 请求地址
 @param serverName 服务名字
 @param params 参数
 @param handleCommand 自己处理处理信号发送，传入nil 默认处理
 @return Command
 */
+ (instancetype)commandPostNoHUDAuth:(NSString *)url
                          serverName:(NSString *)serverName
                              params:(requestParamsBlock)params
                       handleCommand:(requestCommandBlock)handleCommand;

+ (instancetype)commandPostNoHUDAuthWithUrl:(requestUrlBlock)url
                                 serverName:(NSString *)serverName
                                     params:(requestParamsBlock)params
                              handleCommand:(requestCommandBlock)handleCommand;




/**
 不需要Ticket的get请求(不需要hud)
 
 @param url 请求地址
 @param serverName 服务名字
 @param params 参数
 @param handleCommand 自己处理处理信号发送，传入nil 默认处理
 @return Command
 */
+ (instancetype)commandGetNotAuth:(NSString *)url
                       serverName:(NSString *)serverName
                           params:(requestParamsBlock)params
                    handleCommand:(requestCommandBlock)handleCommand;


+ (instancetype)commandGetNotAuthWithUrl:(requestUrlBlock)url
                              serverName:(NSString *)serverName
                                  params:(requestParamsBlock)params
                           handleCommand:(requestCommandBlock)handleCommand;



/**
 不需要Ticket的get请求(需要hud)
 
 @param url 请求地址
 @param serverName 服务名字
 @param params 参数
 @param handleCommand 自己处理处理信号发送，传入nil 默认处理
 @return Command
 */
+ (instancetype)commandGetNotAuthHUD:(NSString *)url
                          serverName:(NSString *)serverName
                              params:(requestParamsBlock)params
                       handleCommand:(requestCommandBlock)handleCommand;

+ (instancetype)commandGetNotAuthHUDWithUrl:(requestUrlBlock)url
                                 serverName:(NSString *)serverName
                                     params:(requestParamsBlock)params
                              handleCommand:(requestCommandBlock)handleCommand;




/**
 需要Ticket的post请求(需要hud)
 
 @param url 请求地址
 @param serverName 服务名字
 @param params 参数
 @param handleCommand 自己处理处理信号发送，传入nil 默认处理
 @return Command
 */
+ (instancetype)commandAuth:(NSString *)url
                 serverName:(NSString *)serverName
                     params:(requestParamsBlock)params
              handleCommand:(requestCommandBlock)handleCommand;

+ (instancetype)commandAuthWithUrl:(requestUrlBlock)url
                        serverName:(NSString *)serverName
                            params:(requestParamsBlock)params
                     handleCommand:(requestCommandBlock)handleCommand;



/**
 需要Ticket的post请求(不需要hud)
 
 @param url 请求地址
 @param serverName 服务名字
 @param params 参数
 @param handleCommand 自己处理处理信号发送，传入nil 默认处理
 @return Command
 */
+ (instancetype)commandPostAuthNoHUD:(NSString *)url
                          serverName:(NSString *)serverName
                              params:(requestParamsBlock)params
                       handleCommand:(requestCommandBlock)handleCommand;

+ (instancetype)commandPostAuthNoHUDWithUrl:(requestUrlBlock)url
                                 serverName:(NSString *)serverName
                                     params:(requestParamsBlock)params
                              handleCommand:(requestCommandBlock)handleCommand;



/**
 需要Ticket的get请求(需要hud)
 
 @param url 请求地址
 @param serverName 服务名字
 @param params 参数
 @param handleCommand 自己处理处理信号发送，传入nil 默认处理
 @return Command
 */
+ (instancetype)commandGetAuth:(NSString *)url
                    serverName:(NSString *)serverName
                        params:(requestParamsBlock)params
                 handleCommand:(requestCommandBlock)handleCommand;

+ (instancetype)commandGetAuthWithUrl:(requestUrlBlock)url
                           serverName:(NSString *)serverName
                               params:(requestParamsBlock)params
                        handleCommand:(requestCommandBlock)handleCommand;




/**
 需要Ticket的get请求(不需要hud)
 
 @param url 请求地址
 @param serverName 服务名字
 @param params 参数
 @param handleCommand 自己处理处理信号发送，传入nil 默认处理
 @return Command
 */
+ (instancetype)commandGetNoHUDAuth:(NSString *)url
                         serverName:(NSString *)serverName
                             params:(requestParamsBlock)params
                      handleCommand:(requestCommandBlock)handleCommand;


+ (instancetype)commandGetNoHUDAuthWithUrl:(requestUrlBlock)url
                                serverName:(NSString *)serverName
                                    params:(requestParamsBlock)params
                             handleCommand:(requestCommandBlock)handleCommand;



/**
 需要Ticket的get请求(需要hud，内部不判断status)
 
 @param url 请求地址
 @param serverName 服务名字
 @param params 参数
 @param handleCommand 自己处理处理信号发送，传入nil 默认处理
 @return Command
 */
+ (instancetype)commandGetAuthNotStatus:(NSString *)url
                             serverName:(NSString *)serverName
                                 params:(requestParamsBlock)params
                          handleCommand:(requestCommandBlock)handleCommand;

+ (instancetype)commandGetAuthNotStatusWithUrl:(requestUrlBlock)url
                                    serverName:(NSString *)serverName
                                        params:(requestParamsBlock)params
                                 handleCommand:(requestCommandBlock)handleCommand;





@end












