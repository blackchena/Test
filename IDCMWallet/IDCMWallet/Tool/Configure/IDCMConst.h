//
//  IDCMConst.h
//  IDCMWallet
//
//  Created by BinBear on 2017/11/16.
//  Copyright © 2017年 BinBear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/********** Project Key ***********/
// 用户状态model归档key
FOUNDATION_EXTERN NSString *const UserStatusInfokey;
// 是否登录key
FOUNDATION_EXTERN NSString *const IsLoginkey;
// 用户信息归档key
FOUNDATION_EXTERN NSString *const UserModelArchiverkey;
// 指纹密码key
FOUNDATION_EXTERN NSString *const FingerprintPWKey;
// 本地货币名称key
FOUNDATION_EXTERN NSString *const LocalCurrencyNameKey;
// 本地语言key
FOUNDATION_EXTERN NSString *const LocalLanguageKey;
// FaceID或TouchID key
FOUNDATION_EXTERN NSString *const FaceIDOrTouchIDKey;
// 解锁 key
FOUNDATION_EXTERN NSString *const UnlockKey;
// 移除弹框 key
FOUNDATION_EXTERN NSString *const RemoveAlertKey;
// Debug模式下设置服务器地址key
FOUNDATION_EXTERN NSString *const DebugSetServerAddKey;
// 使用AES加密PIN的key
FOUNDATION_EXTERN NSString *const AESLockPINKey;
// 企业分发budID的key
FOUNDATION_EXTERN NSString *const IDCWBudidfeKey;
// 控制是否隐藏交易/DApp模块的key
FOUNDATION_EXTERN NSString *const ControlHiddenKey;




/********** 第三方平台Key ***********/
// 企业分发Bugly的key
FOUNDATION_EXTERN NSString *const IDCWEnterpriseBuglyKey;
// AppStore的Bugly的key
FOUNDATION_EXTERN NSString *const IDCWAppStoreBuglyKey;
// 企业分发友盟的key
FOUNDATION_EXTERN NSString *const IDCWEnterpriseUmengKey;
// AppStore的友盟的key
FOUNDATION_EXTERN NSString *const IDCWAppStoreUmengKey;
// 企业分发新浪微博分享的App key & App Secret
FOUNDATION_EXTERN NSString *const IDCWEnterpriseSinaShareKey;
FOUNDATION_EXTERN NSString *const IDCWEnterpriseSinaShareSecret;
// AppStore新浪微博分享的App key & App Secret
FOUNDATION_EXTERN NSString *const IDCWAppStoreSinaShareKey;
FOUNDATION_EXTERN NSString *const IDCWAppStoreSinaShareSecret;
// 企业分发Twitter分享的App key & App Secret
FOUNDATION_EXTERN NSString *const IDCWEnterpriseTwitterShareKey;
FOUNDATION_EXTERN NSString *const IDCWEnterpriseTwitterShareSecret;
// AppStoreTwitter分享的App key & App Secret
FOUNDATION_EXTERN NSString *const IDCWAppStoreTwitterShareKey;
FOUNDATION_EXTERN NSString *const IDCWAppStoreTwitterShareSecret;
// 企业分发微信分享的App key & App Secret
FOUNDATION_EXTERN NSString *const IDCWEnterpriseWeChatShareKey;
FOUNDATION_EXTERN NSString *const IDCWEnterpriseWeChatShareSecret;
// AppStore微信分享的App key & App Secret
FOUNDATION_EXTERN NSString *const IDCWAppStoreWeChatShareKey;
FOUNDATION_EXTERN NSString *const IDCWAppStoreWeChatShareSecret;
// 企业分发QQ的App key & App Secret
FOUNDATION_EXTERN NSString *const IDCWEnterpriseQQShareKey;
// AppStoreQQ的App key & App Secret
FOUNDATION_EXTERN NSString *const IDCWAppStoreQQShareKey;
// 企业分发FaceBook分享的App key & App Secret
FOUNDATION_EXTERN NSString *const IDCWEnterpriseFaceBookShareKey;
FOUNDATION_EXTERN NSString *const IDCWEnterpriseFaceBookShareSecret;
// AppStoreFaceBook分享的App key & App Secret
FOUNDATION_EXTERN NSString *const IDCWAppStoreFaceBookShareKey;
FOUNDATION_EXTERN NSString *const IDCWAppStoreFaceBookShareSecret;




/********** 网络请求地址 ***********/
FOUNDATION_EXTERN NSString *const kStatus;
FOUNDATION_EXTERN NSString *const kData;

// 主服务地址
FOUNDATION_EXTERN NSString *const IDCMURL;
FOUNDATION_EXTERN NSString *const IDCMURL_Pre;
FOUNDATION_EXTERN NSString *const IDCMURL_Test;
FOUNDATION_EXTERN NSString *const IDCMURL_Dev;
FOUNDATION_EXTERN NSString *const IDCMURL_Gray;
FOUNDATION_EXTERN NSString *const IDCMURL_Mapping;

// 交易服务
FOUNDATION_EXTERN NSString *const ExchangeServerName;
FOUNDATION_EXTERN NSString *const ExchangeServerName_URL;
FOUNDATION_EXTERN NSString *const ExchangeServerName_URL_Pre;
FOUNDATION_EXTERN NSString *const ExchangeServerName_URL_Test;
FOUNDATION_EXTERN NSString *const ExchangeServerName_URL_Dev;
FOUNDATION_EXTERN NSString *const ExchangeServerName_URL_Gray;
FOUNDATION_EXTERN NSString *const ExchangeServerName_URL_Mapping;

// 维护服务
FOUNDATION_EXTERN NSString *const MaintenanceServerName;
FOUNDATION_EXTERN NSString *const MaintenanceServerName_URL;
FOUNDATION_EXTERN NSString *const MaintenanceServerName_URL_Pre;
FOUNDATION_EXTERN NSString *const MaintenanceServerName_URL_Test;
FOUNDATION_EXTERN NSString *const MaintenanceServerName_URL_Dev;
FOUNDATION_EXTERN NSString *const MaintenanceServerName_URL_Gray;
FOUNDATION_EXTERN NSString *const MaintenanceServerName_URL_Mapping;

// Web服务地址
FOUNDATION_EXTERN NSString *const IDCMWebURL;
FOUNDATION_EXTERN NSString *const IDCMWebURL_Test;
FOUNDATION_EXTERN NSString *const IDCMWebURL_Pre;


/********** APP接口 **********/
//登陆
FOUNDATION_EXTERN NSString *const Login_URL;
//注册
FOUNDATION_EXTERN NSString *const Register_URL;
//退出
FOUNDATION_EXTERN NSString *const Exit_URL;
//获取用户状态
FOUNDATION_EXTERN NSString *const GetSetingsState_URL;
//我的余额 && 账户余额
FOUNDATION_EXTERN NSString *const GetMyBalance_URL;
//获取二维码
FOUNDATION_EXTERN NSString *const GetQrCode2_URL;
//获取账户地址
FOUNDATION_EXTERN NSString *const GetAccountAddress_URL;
//发送
FOUNDATION_EXTERN NSString *const SendFrom_URL;
//发送邮箱验证码
FOUNDATION_EXTERN NSString *const SendMail_URL;
//发送短信验证码
FOUNDATION_EXTERN NSString *const SendSMS_URL;
//校验地址是否合法
FOUNDATION_EXTERN NSString *const ValidAddress_URL;
//获得钱包入账出账记录
FOUNDATION_EXTERN NSString *const GetWalletHistories_URL;
//用户名校验
FOUNDATION_EXTERN NSString *const ValidUserInfo_URL;
//获得随机12条短语
FOUNDATION_EXTERN NSString *const GetRandomList_URL;
//保存助记词
FOUNDATION_EXTERN NSString *const SavePhrases_URL;
//检查用户助记词
FOUNDATION_EXTERN NSString *const CheckUserPhrase_URL;
//根据币种获取我的钱包
FOUNDATION_EXTERN NSString *const GetWalletByCurrency_URL;
//修改用戶信息
FOUNDATION_EXTERN NSString *const ModifyUserInfo_URL;
//创建一个新的地址
FOUNDATION_EXTERN NSString *const GetNewAddress_URL;
//请求钱包
FOUNDATION_EXTERN NSString *const ReceivedWalletOpt_URL;
//忘记密码
FOUNDATION_EXTERN NSString *const ResetPwdByConfirmCode_URL;
//获取7天金额数据（2.0）
FOUNDATION_EXTERN NSString *const GetHistoryAmount_URL;
//获取钱包列表（2.0）
FOUNDATION_EXTERN NSString *const GetWalletList_URL;
//设置币种是否显示（2.0）
FOUNDATION_EXTERN NSString *const SetCurrencyIsShow_URL;
//根据交易号拿到交易记录（2.0）
FOUNDATION_EXTERN NSString *const GetTxByTxId_URL;
//根据助记词查找（2.0）
FOUNDATION_EXTERN NSString *const GetUserByPhrase_URL;
//找回我的钱包（2.0）
FOUNDATION_EXTERN NSString *const FindMyWallet_URL;
//设置支付密码（2.0）
FOUNDATION_EXTERN NSString *const SetPayPasssword_URL;
//重置支付密码（2.0）
FOUNDATION_EXTERN NSString *const RestPayPassword_URL;
//重置登录密码（2.0）
FOUNDATION_EXTERN NSString *const ResetPassword_URL;
//获取本地货币（2.0）
FOUNDATION_EXTERN NSString *const GetLoaclCurrency_URL;
//检查原始密码（2.0）
FOUNDATION_EXTERN NSString *const CheckOriginalPwd_URL;
//验证码校验（2.0）
FOUNDATION_EXTERN NSString *const CheckVerifyCode_URL;
//获取货币对应的金额（2.0）
FOUNDATION_EXTERN NSString *const GetBalanceByCoin_URL;
//获取推荐费用（2.0）
FOUNDATION_EXTERN NSString *const GetRecommendedFee_URL;
//获取更新信息（2.0）
FOUNDATION_EXTERN NSString *const CheckVersion_URL;
//获取活动信息（2.0）
FOUNDATION_EXTERN NSString *const GetNewMessage_URL;
//确认已读（2.0）
FOUNDATION_EXTERN NSString *const ConfirmRead_URL;
//领币（2.0）
FOUNDATION_EXTERN NSString *const GetCoin_URL;
//获取用户所有币种（2.1）
FOUNDATION_EXTERN NSString *const GetUserCurrency_URL;
//获取用户所有币种 用于ios appstore过审使用
FOUNDATION_EXTERN NSString *const GetUserCurrencyForApp_URL;
//获取用户所有币种（3.0）
FOUNDATION_EXTERN NSString *const GetUserAllCurrency_URL;
//获取推荐费用（2.1）
FOUNDATION_EXTERN NSString *const RecommendedFeeList_URL;
//校验提交发送的虚拟币表单（2.1）
FOUNDATION_EXTERN NSString *const ValidSendFrom_URL;
//修改交易描述（2.1））
FOUNDATION_EXTERN NSString *const ModifyTradeDescription_URL;
//获取最新消息 新版本（2.1）
FOUNDATION_EXTERN NSString *const GetNewMessage_New_URL;
//获取消息列表（2.1）
FOUNDATION_EXTERN NSString *const GetMessageList_URL;
//删除消息（2.1）
FOUNDATION_EXTERN NSString *const MessageBatchSetting_URL;
//用户反馈（2.1）
FOUNDATION_EXTERN NSString *const FeedBack_URL;
//版本库列表（2.1）
FOUNDATION_EXTERN NSString *const GetVersionList_URL;
//获取走势图配置（2.1）
FOUNDATION_EXTERN NSString *const GetConfig_URL;
//设置走势图配置（2.1）
FOUNDATION_EXTERN NSString *const SettingConfig_URL;
//获取走势图数据（2.1）
FOUNDATION_EXTERN NSString *const GetTrendChartData_URL;
//切割地址 (2.2.1）
FOUNDATION_EXTERN NSString *const ValidComplicatedAddressAsync_URL;
//PC授权登录 (2.2.3）
FOUNDATION_EXTERN NSString *const QrCodeAuthorized_URL;
//新版检查PIN (2.2.3）
FOUNDATION_EXTERN NSString *const CheckOriginalPwd_New_URL;
//关于我们
FOUNDATION_EXTERN NSString *const GetAboutUs_URL;
//获取币种精度
FOUNDATION_EXTERN NSString *const GetCurrencyAccuracy_URL;

/********** 第三方支付接口 ***********/
//第三方支付
FOUNDATION_EXTERN NSString *const SecurityPaySendFrom_URL;
//获取客户信息
FOUNDATION_EXTERN NSString *const GetCustomerInfo_URL;


/********** 闪兑接口 ***********/

// 闪兑列表
FOUNDATION_EXTERN NSString *const ExchangeGetExchangeDataList_URL;
// 闪兑详情
FOUNDATION_EXTERN NSString *const ExchangeGetExchangeDetail_URL;
// 闪兑详情编辑描述
FOUNDATION_EXTERN NSString *const ExchangeEditComment_URL;
// 兑币 币列表
FOUNDATION_EXTERN NSString *const ExchangeGetCoinList_URL;
// 兑币 币列表
FOUNDATION_EXTERN NSString *const ExchangeGetNewCoinList_NewURL;
// 兑币汇率
FOUNDATION_EXTERN NSString *const ExchangeGetCoinRate_URL;
// 兑换
FOUNDATION_EXTERN NSString *const ExchangeExchangeIn_URL;
// 获取可兑余额
FOUNDATION_EXTERN NSString *const ExchangeGetBalance_URL;



/********** OTC接口 ***********/
// 获取Signalr地址
FOUNDATION_EXTERN NSString *const GetSignalrUrl_URL;
// 上传聊天图片
FOUNDATION_EXTERN NSString *const UploadFile_URL;
//获取OTC记录列表
FOUNDATION_EXTERN NSString *const GetOtcOrders_URL;
//获取OTC订单详情
FOUNDATION_EXTERN NSString *const GetOtcOrder_URL;
//获取OTC订单详情列表
FOUNDATION_EXTERN NSString *const GetOtcOrderList_URL;
//获取OTC交易相关设置
FOUNDATION_EXTERN NSString *const GetOtcSettingInfo_URL;
//获取OTC配置信息
FOUNDATION_EXTERN NSString *const GetOTCBaseSet_URL;
//发送订单
FOUNDATION_EXTERN NSString *const GetOtcSendOrder_URL;
// 获取OTC交易聊天记录
FOUNDATION_EXTERN NSString *const GetChatHistory_URL;
//撤销订单
FOUNDATION_EXTERN NSString *const CancelOrder_URL;
//设置已转账
FOUNDATION_EXTERN NSString *const OTCSetTransfer_URL;
//确认已经到账
FOUNDATION_EXTERN NSString *const OTCConfirmArrived_URL;
//设置延时处理
FOUNDATION_EXTERN NSString *const OTCSetDelayConfirm_URL;
//申请申诉
FOUNDATION_EXTERN NSString *const OTCApplyAppeal_URL;
//同意退币
FOUNDATION_EXTERN NSString *const OTCAgreeRefund_URL;
// 详情取消订单
FOUNDATION_EXTERN NSString *const OTCCancelQuoteOrder_URL;
//获取用户推送下单到承兑商历史
FOUNDATION_EXTERN NSString *const GetOtcOfferList_URL;
//承兑商报价
FOUNDATION_EXTERN NSString *const QuotePrice_URL;
//选择确认的报价单
FOUNDATION_EXTERN NSString *const ConfirmOfferOrder_URL;
// 上传支付凭证
FOUNDATION_EXTERN NSString *const OTCUploadPayCertificate_URL;
// 买家设置申述中
FOUNDATION_EXTERN NSString *const OTCSetAppealing_URL;
// 买卖规则
FOUNDATION_EXTERN NSString *const TradingRules_URL;
// 承兑商规则
FOUNDATION_EXTERN NSString *const AcceptanceRules_URL;



/********** 承兑商接口 ***********/
// 获取承兑商状态信息
FOUNDATION_EXTERN NSString *const OTCAcceptant_URL;
//获取承兑买币信息
FOUNDATION_EXTERN NSString *const OTCAcceptantGetExchangeBuyList_URL;
//获取承兑币种列表
FOUNDATION_EXTERN NSString *const OTCAcceptantGetOtcCoinList_URL;
//获取承兑商卖币信息
FOUNDATION_EXTERN NSString *const OTCAcceptantGetExchangeSellList_URL;
//添加或编辑币种及限额
FOUNDATION_EXTERN NSString *const OTCAcceptantExchangeCoinChange_URL;
//删除币种及限额
FOUNDATION_EXTERN NSString *const OTCAcceptantExchangeCoinRemove_URL;
//获取法币及支付方式列表
FOUNDATION_EXTERN NSString *const OTCAcceptantGetExchangePayModeList_URL;
//添加法币及支付方式
FOUNDATION_EXTERN NSString *const OTCAcceptantExchangePayModeAdd_URL;
//移除法币及支付方式
FOUNDATION_EXTERN NSString *const OTCAcceptantExchangePayModeRemove_URL;
//获取法币币种列表
FOUNDATION_EXTERN NSString *const OTCAcceptantGetOtcLocalCurrencyList_URL;
//添加或编辑币种及资金量
FOUNDATION_EXTERN NSString *const OTCAcceptantExchangeLocalCurrencyChange_URL;
//移除币种及资金量
FOUNDATION_EXTERN NSString *const OTCAcceptantExchangeLocalCurrencyRemove_URL;
//保证金交易规则及系统钱包地址
FOUNDATION_EXTERN NSString *const OTCAcceptantGetAcceptantSettingList_URL;
//充值保证金
FOUNDATION_EXTERN NSString *const OTCAcceptantRecharge_URL;
//校验能否提取保证金
FOUNDATION_EXTERN NSString *const OTCAcceptantCheckWithdraw_URL;
//保证金管理列表
FOUNDATION_EXTERN NSString *const OTCAcceptantGetDepositList_URL;
//设置扣款顺序
FOUNDATION_EXTERN NSString *const OTCAcceptantSetPaySequence_URL;
//
FOUNDATION_EXTERN NSString *const OTCAcceptantGetDepositWastebookList_URL;
//提取保证金
FOUNDATION_EXTERN NSString *const OTCAcceptantPickUpBalance_URL;
//获取当前保证金币种和余额
FOUNDATION_EXTERN NSString *const OTCAcceptantWithdrawCoinList_URL;
//设置当前步骤
FOUNDATION_EXTERN NSString *const OTCAcceptantSetCurrentStep_URL;
//获取获取保证金币种
FOUNDATION_EXTERN NSString *const OTCMarginCoinList_URL;

/********** 支付方式管理 ***********/
//支付方式管理
FOUNDATION_EXTERN NSString *const PaymentModeManagement_URL;
//添加或编辑支付方式
FOUNDATION_EXTERN NSString *const PaymentModeChange_URL;
//删除支付方式
FOUNDATION_EXTERN NSString *const PaymentModeRemove_URL;
//获取支付方式列表
FOUNDATION_EXTERN NSString *const PaymentModeList_URL;
//检测pin
FOUNDATION_EXTERN NSString *const PaymentCheckPIN_URL;
//排序
FOUNDATION_EXTERN NSString *const SortPayment_URL;


/********** 发现页面(DAPP)接口 **********/
// 发现
FOUNDATION_EXTERN NSString *const FoundShow_URL;
// 判断Dapp是否授权
FOUNDATION_EXTERN NSString *const DappIsRead_URL;
// 授权Dapp
FOUNDATION_EXTERN NSString *const MarkDappAsRead_URL;


/********** 我的页面接口 **********/
// 获取邀请链配置
FOUNDATION_EXTERN NSString *const GetInviteConfig_URL;


/********** 维护接口 **********/
// 检查维护接口
FOUNDATION_EXTERN NSString *const CheckServerMaintenance_URL;










