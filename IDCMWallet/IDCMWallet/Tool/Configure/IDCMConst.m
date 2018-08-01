//
//  IDCMConst.m
//  IDCMWallet
//
//  Created by BinBear on 2017/11/16.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import "IDCMConst.h"

/********** Project Key ***********/
// 用户状态model归档key
NSString *const  UserStatusInfokey = @"UserStatusInfokey";
// 首页banner数据key
NSString *const  IsLoginkey = @"IsLoginkey";
// 用户信息归档key
NSString *const  UserModelArchiverkey = @"UserModel.data";
// 指纹密码key
NSString *const  FingerprintPWKey = @"FingerprintPWKey";
// 本地货币名称key
NSString *const  LocalCurrencyNameKey = @"LocalCurrencyNameKey";
// 本地语言key
NSString *const  LocalLanguageKey = @"LocalLanguageKey";
// FaceID或TouchID key
NSString *const  FaceIDOrTouchIDKey = @"FaceIDOrTouchIDKey";
// 解锁 key
NSString *const  UnlockKey = @"UnlockKey";
// 移除弹框 key
NSString *const  RemoveAlertKey = @"RemoveAlerViewNotification";
// Debug模式下设置服务器地址key
NSString *const  DebugSetServerAddKey = @"DebugSetServerAddKey";
// 使用AES加密PIN的key
NSString *const  AESLockPINKey = @"IDCW-AES-PIN-key";
// 企业分发budID的key
NSString *const  IDCWBudidfeKey = @"com.IDCG.IDCWallet";
// 控制是否隐藏交易/DApp模块的key
NSString *const  ControlHiddenKey = @"ControlHiddenKey";




/********** 第三方平台Key ***********/
// 企业分发Bugly的key
NSString *const  IDCWEnterpriseBuglyKey = @"1fec21e831";
// AppStore的Bugly的key
NSString *const  IDCWAppStoreBuglyKey = @"6de43d9795";
// 企业分发友盟的key
NSString *const  IDCWEnterpriseUmengKey = @"5b2ba2de8f4a9d7fe5000058";
// AppStore的友盟的key
NSString *const  IDCWAppStoreUmengKey = @"5b2ba2de8f4a9d7fe5000058";
// 企业分发新浪微博分享的App key & App Secret
NSString *const  IDCWEnterpriseSinaShareKey = @"465191353";
NSString *const  IDCWEnterpriseSinaShareSecret = @"d81d7f134ecc9fa3fb4bdc3855a716e5";
// AppStore新浪微博分享的App key & App Secret
NSString *const  IDCWAppStoreSinaShareKey = @"3567692559";
NSString *const  IDCWAppStoreSinaShareSecret = @"ac81da7aed0661ce6be8badc2c20de19";
// 企业分发Twitter分享的App key & App Secret
NSString *const  IDCWEnterpriseTwitterShareKey = @"UK3APmVl9nRjM9OhSQHVQnek9";
NSString *const  IDCWEnterpriseTwitterShareSecret = @"tAK4WjUXXnFkioCuLwwUyxKEimOFHVqaotKsROvfrPjt7VyylU";
// AppStoreTwitter分享的App key & App Secret
NSString *const  IDCWAppStoreTwitterShareKey = @"bdHt4VPqkW8gwzl8NOPN2WAIq";
NSString *const  IDCWAppStoreTwitterShareSecret = @"ppteVI4jKZe8qLhAXGRDBELR0GRbU0gwNOy8v3QAuTPOBgfoPr";
// 企业分发微信分享的App key & App Secret
NSString *const  IDCWEnterpriseWeChatShareKey = @"wxe0369537665a2416";
NSString *const  IDCWEnterpriseWeChatShareSecret = @"4aca80403e06db880968862f412da427";
// AppStore微信分享的App key & App Secret
NSString *const  IDCWAppStoreWeChatShareKey = @"wxbebcba3ae543417b";
NSString *const  IDCWAppStoreWeChatShareSecret = @"2501ef09306e7f081c86f23dbb84141f";
// 企业分发QQ分享的App key & App Secret
NSString *const  IDCWEnterpriseQQShareKey = @"1106987332";
// AppStoreQQ分享的App key & App Secret
NSString *const  IDCWAppStoreQQShareKey = @"1106987354";
// 企业分发FaceBook分享的App key & App Secret
NSString *const  IDCWEnterpriseFaceBookShareKey = @"392702877907471";
NSString *const  IDCWEnterpriseFaceBookShareSecret = @"307fc5435471a5af2c558ce100f297cd";
// AppStoreFaceBook分享的App key & App Secret
NSString *const  IDCWAppStoreFaceBookShareKey = @"229787877850964";
NSString *const  IDCWAppStoreFaceBookShareSecret = @"4c03f6fa3ab4e7567ff136f23a7dc5b3";



/********** 网络请求地址 ***********/
// 请求返回基本参数
NSString *const  kStatus = @"status";
NSString *const  kData = @"data";


// 交易服务 key
NSString *const  ExchangeServerName = @"ExchangeServerName";
// 维护服务 key
NSString *const  MaintenanceServerName = @"MaintenanceServerName";


// 生产环境
NSString *const  IDCMURL = @"https://api.idcw.io";
NSString *const  ExchangeServerName_URL = @"https://api.idcw.io";
NSString *const  MaintenanceServerName_URL = @"https://maintain.idcw.io:8208";

// 灰度发布环境
NSString *const  IDCMURL_Gray = @"https://api.idcw.io:8204";
NSString *const  ExchangeServerName_URL_Gray = @"https://api.idcw.io:8204";
NSString *const  MaintenanceServerName_URL_Gray = @"http://192.168.1.88:8208";

// 预发布环境
NSString *const  IDCMURL_Pre = @"https://preapi.idcw.io";
NSString *const  ExchangeServerName_URL_Pre = @"https://preapi.idcw.io";
NSString *const  MaintenanceServerName_URL_Pre = @"http://premaintain.idcw.io:8208";

// 测试环境
NSString *const  IDCMURL_Test = @"http://192.168.1.35:8203";
NSString *const  ExchangeServerName_URL_Test = @"http://192.168.1.35:8203";
NSString *const  MaintenanceServerName_URL_Test = @"http://192.168.1.88:8208";

// 开发环境
NSString *const  IDCMURL_Dev = @"http://192.168.1.88:8203";
NSString *const  ExchangeServerName_URL_Dev = @"http://192.168.1.88:8203";
NSString *const  MaintenanceServerName_URL_Dev = @"http://192.168.1.88:8208";

// 测试环境的外网映射
NSString *const  IDCMURL_Mapping = @"http://183.62.193.179:8203";
NSString *const  ExchangeServerName_URL_Mapping = @"http://183.62.193.179:8203";
NSString *const  MaintenanceServerName_URL_Mapping = @"http://premaintain.idcw.io:8208";


// Web环境
NSString *const  IDCMWebURL = @"https://www.idcw.io"; // 生产环境
NSString *const  IDCMWebURL_Test = @"http://192.168.1.35:81"; // 测试环境
NSString *const  IDCMWebURL_Pre = @"http://prewww.idcw.io"; // 预发布环境





/********** APP接口 ***********/
//登陆
NSString *const Login_URL = @"/api/Account/login";
//注册（新版注册）
NSString *const Register_URL = @"/api/Account/register_new";
//退出
NSString *const Exit_URL = @"/api/Account/exit";
//我的余额 && 账户余额
NSString *const GetMyBalance_URL = @"/api/Wallet/GetMyBalance";
//用户信息状态
NSString *const GetSetingsState_URL = @"/api/SecuritySettings/GetSetingsState";
//获取二维码
NSString *const GetQrCode2_URL = @"http://www.idcw.io/api/Tools/GetIOSQrCode?txt=";
//获取账户地址
NSString *const GetAccountAddress_URL = @"/api/Wallet/GetAccountAddress";
//发送
NSString *const SendFrom_URL = @"/api/Wallet/SendFrom";
//发送邮箱验证码
NSString *const SendMail_URL = @"/api/Tools/SendMail";
//发送短信验证码
NSString *const SendSMS_URL = @"/api/Tools/SendSMS";
//校验地址是否合法
NSString *const ValidAddress_URL = @"/api/Wallet/ValidAddress";
//获得钱包入账出账记录
NSString *const GetWalletHistories_URL = @"/api/Wallet/GetWalletHistories";
//用户名校验
NSString *const ValidUserInfo_URL = @"/api/Account/validUserInfo";
//获得随机12条短语
NSString *const GetRandomList_URL = @"/api/SecuritySettings/GetRandomList";
//保存助记词
NSString *const SavePhrases_URL = @"/api/SecuritySettings/SavePhrases";
//检查用户助记词
NSString *const CheckUserPhrase_URL = @"/api/SecuritySettings/CheckUserPhrase";
//根据币种获取我的钱包
NSString *const GetWalletByCurrency_URL = @"/api/Wallet/GetWalletByCurrency";
//修改用戶信息
NSString *const ModifyUserInfo_URL = @"/api/Account/ModifyUserInfo";
//创建一个新的地址
NSString *const GetNewAddress_URL = @"/api/Wallet/GetNewAddress";
//请求钱包
NSString *const ReceivedWalletOpt_URL = @"/api/Wallet/ReceivedWalletOpt";
//忘记密码
NSString *const ResetPwdByConfirmCode_URL = @"/api/SecuritySettings/ResetPwdByConfirmCode";
//获取7天金额数据（2.0）
NSString *const GetHistoryAmount_URL = @"/api/Wallet/GetHistoryAmount";
//获取钱包列表（2.0）
NSString *const GetWalletList_URL = @"/api/Wallet/GetWalletList";
//设置币种是否显示（2.0）
NSString *const SetCurrencyIsShow_URL = @"/api/Wallet/SetCurrencyIsShow";
//根据交易号拿到交易记录（2.0）
NSString *const GetTxByTxId_URL = @"/api/Wallet/GetTxByTxId";
//根据助记词查找（2.0）
NSString *const GetUserByPhrase_URL = @"/api/SecuritySettings/GetUserInfoByPhrase";
//找回我的钱包（2.0）
NSString *const FindMyWallet_URL = @"/api/SecuritySettings/FindMyWallet";
//设置支付密码（2.0）
NSString *const SetPayPasssword_URL = @"/api/SecuritySettings/SetPayPasssword";
//重置支付密码（2.0）
NSString *const RestPayPassword_URL = @"/api/SecuritySettings/RestPayPassword";
//重置登录密码（2.0）
NSString *const ResetPassword_URL = @"/api/SecuritySettings/ResetPassword";
//获取本地货币（2.0）
NSString *const GetLoaclCurrency_URL = @"/api/Tools/GetLoaclCurrency";
//检查原始密码（2.0）
NSString *const CheckOriginalPwd_URL = @"/api/SecuritySettings/CheckOriginalPwd";
//验证码校验（2.0）
NSString *const CheckVerifyCode_URL = @"/api/Tools/CheckVerifyCode";
//获取货币对应的金额（2.0）
NSString *const GetBalanceByCoin_URL = @"/api/Wallet/GetBalanceByCoin";
//获取推荐费用（2.0）
NSString *const GetRecommendedFee_URL = @"/api/Wallet/GetRecommendedFee";
//获取更新信息（2.0）
NSString *const CheckVersion_URL = @"/api/Tools/CheckVersion";
//获取活动信息（2.0）
NSString *const GetNewMessage_URL = @"/api/Message/GetNewMessage";
//确认已读（2.0）
NSString *const ConfirmRead_URL = @"/api/Message/ConfirmRead";
//领币（2.0）
NSString *const GetCoin_URL = @"/api/Message/GetCoin";
//获取用户所有币种（2.1）
NSString *const GetUserCurrency_URL = @"/api/Wallet/GetUserCurrency";
//获取用户所有币种 用于ios appstore过审使用
NSString *const GetUserCurrencyForApp_URL = @"/api/Wallet/GetUserCurrencyForApp";
//获取用户所有币种（3.0）
NSString *const GetUserAllCurrency_URL = @"/api/Wallet/GetAllCurrency";
//获取推荐费用（2.1）
NSString *const RecommendedFeeList_URL = @"/api/Wallet/RecommendedFeeList";
//校验提交发送的虚拟币表单（2.1）
NSString *const ValidSendFrom_URL = @"/api/Wallet/ValidSendFrom";
//修改交易描述（2.1）
NSString *const ModifyTradeDescription_URL = @"/api/Wallet/ModifyTradeDescription";
//获取最新消息 新版本（2.1）
NSString *const GetNewMessage_New_URL = @"/api/Message/GetNewMessage_New";
//获取消息列表（2.1）
NSString *const GetMessageList_URL = @"/api/Message/GetMessageList";
//删除消息（2.1）
NSString *const MessageBatchSetting_URL = @"/api/Message/MessageBatchSetting";
//用户反馈（2.1）
NSString *const FeedBack_URL = @"/api/Tools/FeedBack";
//版本库列表（2.1）
NSString *const GetVersionList_URL = @"/api/Tools/GetVersionList";
//获取走势图配置（2.1）
NSString *const GetConfig_URL = @"/api/TrendChart/GetConfig";
//设置走势图配置（2.1）
NSString *const SettingConfig_URL = @"/api/TrendChart/SettingConfig";
//获取走势图数据（2.1）
NSString *const GetTrendChartData_URL = @"/api/TrendChart/GetTrendChartData";
//切割地址 (2.2.1）
NSString *const ValidComplicatedAddressAsync_URL = @"/api/Wallet/ValidComplicatedAddressAsync";
//PC授权登录 (2.2.3）
NSString *const QrCodeAuthorized_URL = @"/api/AuthorizedLogin/QrCodeAuthorized";
//新版检查PIN (2.2.3）
NSString *const CheckOriginalPwd_New_URL = @"/api/SecuritySettings/CheckOriginalPwd_New";
//关于我们
NSString *const GetAboutUs_URL = @"/api/Tools/GetAboutUs";
//获取币种精度
NSString *const GetCurrencyAccuracy_URL = @"/api/Tools/GetCurrencyAccuracy";


/********** 第三方支付接口 ***********/
//第三方支付
NSString *const SecurityPaySendFrom_URL = @"/api/SecurityPay/SecurityPaySendFrom";
//获取客户信息
NSString *const GetCustomerInfo_URL = @"/api/SecurityPay/GetCustomerInfo";


/********** 闪兑接口 ***********/
// 闪兑列表
NSString *const ExchangeGetExchangeDataList_URL = @"/api/Exchange/GetExchangeDataList";
// 闪兑详情
NSString *const ExchangeGetExchangeDetail_URL = @"/api/Exchange/GetExchangeDetail";
// 闪兑详情编辑描述
NSString *const ExchangeEditComment_URL = @"/api/Exchange/EditComment";
// 兑币 币列表
NSString *const ExchangeGetCoinList_URL = @"/api/Exchange/GetCoinList";
NSString *const ExchangeGetNewCoinList_NewURL = @"/api/Exchange/GetNewCoinList";
// 兑币汇率
NSString *const ExchangeGetCoinRate_URL = @"/api/Exchange/GetCoinRate";
// 兑换
NSString *const ExchangeExchangeIn_URL = @"/api/Exchange/ExchangeIn";
// 获取可兑余额
NSString *const ExchangeGetBalance_URL = @"/api/Exchange/GetBalanceByCoin";

/********** 承兑商接口 ***********/
//获取承兑商开通状态
NSString *const OTCAcceptant_URL = @"/api/OtcAcceptant/GetAcceptantInfo";
//获取承兑买币信息
NSString *const OTCAcceptantGetExchangeBuyList_URL = @"/api/OtcAcceptant/GetExchangeBuyList";
//获取承兑币种列表
NSString *const OTCAcceptantGetOtcCoinList_URL = @"/api/OtcAcceptant/GetOtcCoinList";
//获取承兑商卖币信息
NSString *const OTCAcceptantGetExchangeSellList_URL = @"/api/OtcAcceptant/GetExchangeSellList";
//添加或编辑币种及限额
NSString *const OTCAcceptantExchangeCoinChange_URL = @"/api/OtcAcceptant/ExchangeCoinChange";
//删除币种及限额
NSString *const OTCAcceptantExchangeCoinRemove_URL = @"/api/OtcAcceptant/ExchangeCoinRemove";
//获取法币及支付方式列表
NSString *const OTCAcceptantGetExchangePayModeList_URL = @"/api/OtcAcceptant/GetExchangePayModeList";
//添加法币及支付方式
NSString *const OTCAcceptantExchangePayModeAdd_URL = @"/api/OtcAcceptant/ExchangePayModeAdd";
//移除法币及支付方式
NSString *const OTCAcceptantExchangePayModeRemove_URL = @"/api/OtcAcceptant/ExchangePayModeRemove";
//获取法币币种列表
NSString *const OTCAcceptantGetOtcLocalCurrencyList_URL = @"/api/OtcAcceptant/GetOtcLocalCurrencyList";
//添加或编辑币种及资金量
NSString *const OTCAcceptantExchangeLocalCurrencyChange_URL = @"/api/OtcAcceptant/ExchangeLocalCurrencyChange";
//移除币种及资金量
NSString *const OTCAcceptantExchangeLocalCurrencyRemove_URL = @"/api/OtcAcceptant/ExchangeLocalCurrencyRemove";
//保证金交易规则及系统钱包地址
NSString *const OTCAcceptantGetAcceptantSettingList_URL = @"/api/OtcAcceptant/GetAcceptantSettingListe";
//充值保证金
NSString *const OTCAcceptantRecharge_URL = @"/api/OtcAcceptant/Recharge";
//校验能否提取保证金
NSString *const OTCAcceptantCheckWithdraw_URL = @"/api/OtcAcceptant/CheckWithdraw";
//保证金管理列表
NSString *const OTCAcceptantGetDepositList_URL = @"/api/OtcAcceptant/GetDepositList";
//设置扣款顺序
NSString *const OTCAcceptantSetPaySequence_URL = @"/api/OtcAcceptant/SetPaySequence";
//
NSString *const OTCAcceptantGetDepositWastebookList_URL = @"/api/OtcAcceptant/GetDepositWastebookList";
//提取保证金
NSString *const OTCAcceptantPickUpBalance_URL = @"/api/OtcAcceptant/Withdraw";
//获取当前保证金币种和余额
NSString *const OTCAcceptantWithdrawCoinList_URL = @"/api/OtcAcceptant/GetWithdrawCoinList";
//设置当前步骤
NSString *const OTCAcceptantSetCurrentStep_URL = @"/api/OtcAcceptant/SetCurrentStep";
//获取获取保证金币种
NSString *const OTCMarginCoinList_URL = @"/api/OtcAcceptant/GetOtcMarginCoinList";


/********** OTC接口 ***********/
// 获取Signalr地址
NSString *const GetSignalrUrl_URL = @"/api/OtcChat/GetSignalrUrl";
// 上传聊天图片
NSString *const UploadFile_URL = @"/api/OtcChat/UploadFile";
//获取OTC记录列表
NSString *const GetOtcOrders_URL = @"/api/OtcTrade/GetOtcOrders";
//获取OTC订单详情
NSString *const GetOtcOrder_URL = @"/api/OtcTrade/GetOtcOrder";
//获取订单详情列表
NSString *const GetOtcOrderList_URL = @"/api/OtcTrade/GetOtcOrders";
//获取OTC交易相关设置
NSString *const GetOtcSettingInfo_URL = @"/api/OtcTradeSetting/GetOtcTradeSetting";
//获取OTC配置信息
NSString *const GetOTCBaseSet_URL = @"/api/OtcSysSetting/GetOtcSetting";
//发送订单
NSString *const GetOtcSendOrder_URL = @"/api/OtcTrade/SendOrder";
//支付方式管理
NSString *const PaymentModeManagement_URL = @"/api/Payment/GetPaymentModeManagement";
//添加或编辑支付方式
NSString *const PaymentModeChange_URL = @"/api/Payment/PaymentModeChange";
//删除支付方式
NSString *const PaymentModeRemove_URL = @"/api/Payment/PaymentModeRemove";
//获取支付方式列表
NSString *const PaymentModeList_URL = @"/api/Payment/GetPaymentModeList";
//检测pin
NSString *const PaymentCheckPIN_URL = @"/api/Payment/CheckPIN";
//排序
NSString *const SortPayment_URL = @"/api/Payment/SortPayment";
// 获取OTC交易聊天记录
NSString *const GetChatHistory_URL = @"/api/OtcChat/GetChatHistory";
//撤销订单
NSString *const CancelOrder_URL = @"/api/OtcTrade/CancelOrder";
//设置已转账
NSString *const OTCSetTransfer_URL = @"/api/OtcTrade/SetTransfer";
//确认已经到账
NSString *const OTCConfirmArrived_URL = @"/api/OtcTrade/ConfirmArrived";
//设置延时处理
NSString *const OTCSetDelayConfirm_URL = @"/api/OtcTrade/SetDelayConfirm";
//申请申诉
NSString *const OTCApplyAppeal_URL = @"/api/OtcTrade/ApplyAppeal";
//同意退币
NSString *const OTCAgreeRefund_URL = @"/api/OtcTrade/AgreeRefund";
// 取消申报订单
NSString *const OTCCancelQuoteOrder_URL = @"/api/OtcOfferOrder/CancelQuoteOrder";
//获取用户推送下单到承兑商历史
NSString *const GetOtcOfferList_URL = @"/api/OtcOfferOrder/GetOtcOfferList";
//承兑商报价
NSString *const QuotePrice_URL = @"/api/OtcOfferOrder/QuotePrice";
//选择确认的报价单
NSString *const ConfirmOfferOrder_URL = @"/api/OtcTrade/ConfirmOfferOrder";
// 上传支付凭证
NSString *const OTCUploadPayCertificate_URL = @"/api/Appeal/UploadPayCertificate";
// 买家设置申述中
NSString *const OTCSetAppealing_URL = @"/api/OtcTrade/SetAppealing";
// 买卖规则
NSString *const TradingRules_URL = @"/static/mobile/tradingRules/gzsm.html";
// 承兑商规则
NSString *const AcceptanceRules_URL = @"/static/mobile/tradingRules/index.html";


/********** 发现页面(DAPP)接口 ***********/
// 发现
NSString *const FoundShow_URL = @"/api/Discover/ShowAsync";
// 判断Dapp是否授权
NSString *const DappIsRead_URL = @"/api/Discover/DappIsRead";
// 授权Dapp
NSString *const MarkDappAsRead_URL = @"/api/Discover/MarkDappAsRead";



/********** 我的页面接口 ***********/
// 获取邀请链配置
NSString *const GetInviteConfig_URL = @"/api/Tools/GetInviteConfig";



/********** 维护接口 ***********/
// 检查维护接口
NSString *const CheckServerMaintenance_URL = @"/api/Tools/CheckServerMaintenance";







