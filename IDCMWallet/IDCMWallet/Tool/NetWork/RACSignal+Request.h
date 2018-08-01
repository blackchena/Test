//
//  RACSignal+Request.h
//  IDCMWallet
//
//  Created by huangyi on 2018/3/21.
//  Copyright © 2018年 BinBear. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>



typedef void (^requestSignalBlock)(id response, id<RACSubscriber> subscriber);




@interface RACSignal (Request)


/**
 不需要Ticket的post请求(需要hud)
 
 @param url 请求地址
 @param serverName 服务名字
 @param params 参数
 @param handleSignal  自己处理处理信号发送，传入nil 默认处理
 @return Signal
 */
+ (instancetype)signalNotAuth:(NSString *)url
                   serverName:(NSString *)serverName
                       params:(id)params
                 handleSignal:(requestSignalBlock)handleSignal;




/**
 不需要Ticket的post请求(不需要hud)
 
 @param url 请求地址
 @param serverName 服务名字
 @param params 参数
 @param handleSignal  自己处理处理信号发送，传入nil 默认处理
 @return Signal
 */
+ (instancetype)signalPostNoHUDAuth:(NSString *)url
                         serverName:(NSString *)serverName
                             params:(id)params
                       handleSignal:(requestSignalBlock)handleSignal;





/**
 不需要Ticket的get请求(不需要hud)
 
 @param url 请求地址
 @param serverName 服务名字
 @param params 参数
 @param handleSignal  自己处理处理信号发送，传入nil 默认处理
 @return Signal
 */
+ (instancetype)signalGetNotAuth:(NSString *)url
                      serverName:(NSString *)serverName
                          params:(id)params
                    handleSignal:(requestSignalBlock)handleSignal;






/**
 不需要Ticket的get请求(需要hud)
 
 @param url 请求地址
 @param serverName 服务名字
 @param params 参数
 @param handleSignal  自己处理处理信号发送，传入nil 默认处理
 @return Signal
 */
+ (instancetype)signalGetNotAuthHUD:(NSString *)url
                         serverName:(NSString *)serverName
                             params:(id)params
                       handleSignal:(requestSignalBlock)handleSignal;






/**
 需要Ticket的post请求(需要hud)
 
 @param url 请求地址
 @param serverName 服务名字
 @param params 参数
 @param handleSignal  自己处理处理信号发送，传入nil 默认处理
 @return Signal
 */
+ (instancetype)signalAuth:(NSString *)url
                serverName:(NSString *)serverName
                    params:(id)params
              handleSignal:(requestSignalBlock)handleSignal;







/**
 需要Ticket的post请求(不需要hud)
 
 @param url 请求地址
 @param serverName 服务名字
 @param params 参数
 @param handleSignal  自己处理处理信号发送，传入nil 默认处理
 @return Signal
 */
+ (instancetype)signalPostAuthNoHUD:(NSString *)url
                         serverName:(NSString *)serverName
                             params:(id)params
                       handleSignal:(requestSignalBlock)handleSignal;






/**
 需要Ticket的get请求(需要hud)
 
 @param url 请求地址
 @param serverName 服务名字
 @param params 参数
 @param handleSignal  自己处理处理信号发送，传入nil 默认处理
 @return Signal
 */
+ (instancetype)signalGetAuth:(NSString *)url
                   serverName:(NSString *)serverName
                       params:(id)params
                 handleSignal:(requestSignalBlock)handleSignal;






/**
 需要Ticket的get请求(不需要hud)
 
 @param url 请求地址
 @param serverName 服务名字
 @param params 参数
 @param handleSignal  自己处理处理信号发送，传入nil 默认处理
 @return Signal
 */
+ (instancetype)signalGetNoHUDAuth:(NSString *)url
                        serverName:(NSString *)serverName
                            params:(id)params
                      handleSignal:(requestSignalBlock)handleSignal;







/**
 需要Ticket的get请求(需要hud，内部不判断status)
 
 @param url 请求地址
 @param serverName 服务名字
 @param params 参数
 @param handleSignal  自己处理处理信号发送，传入nil 默认处理
 @return Signal
 */
+ (instancetype)signalGetAuthNotStatus:(NSString *)url
                            serverName:(NSString *)serverName
                                params:(id)params
                          handleSignal:(requestSignalBlock)handleSignal;






@end









