//
//  SDWeChatPayModel.h
//  sndonongshang
//
//  Created by SNQU on 2019/2/18.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDWeChatPayModel : NSObject
//"appid":"wx51216334fb7469b6",                //类型：String  必有字段  备注：微信应用id
//"partnerid":"1523246401",                //类型：String  必有字段  备注：商户id
//"prepayid":"wx201410272009395522657a690389285100",                //类型：String  必有字段  备注：预支付id
//"packageStr":"Sign=WXPay",                //类型：String  必有字段  备注：包含预支付信息
//"timestamp":"mock",                //类型：String  必有字段  备注：时间戳
//"noncestr":"6d101220ec7a348f106a73d2d379bbd0",                //类型：String  必有字段  备注：随机串 slat
//"sign":"D79E03726F1E0ADE4C2BBA287013F461"                //类型：String  必有字段  备注：签名串
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *partnerId;
@property (nonatomic, copy) NSString *prepayId;
@property (nonatomic, copy) NSString *package;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, copy) NSString *noncestr;
@property (nonatomic, copy) NSString *sign;
@end

NS_ASSUME_NONNULL_END
