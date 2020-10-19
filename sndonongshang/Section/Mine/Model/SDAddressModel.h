//
//  SDAddressModel.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/31.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDAddressModel : NSObject

@property (nonatomic, copy) NSString *addrId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *mobileHide;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *county;
@property (nonatomic, copy) NSString *street;
@property (nonatomic, copy) NSString *fullAddr;
/** 地区简述 */
@property (nonatomic, copy) NSString *sketch;
@property (nonatomic, copy) NSString *house_number;
@property (nonatomic, assign) BOOL is_default;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, assign) NSInteger edit_time;
@property (nonatomic, assign) NSInteger add_time;

/** 纬度 */
@property (nonatomic, copy) NSString *lat;
/** 经度 */
@property (nonatomic, copy) NSString *lng;


/** extra 是否被选中 送货地址 */
@property (nonatomic, assign, getter=isSelected) BOOL selected;





//"_id":"5c4c1b0202dce60bd0002386",                //类型：String  必有字段  备注：无
//"name":"小田田",                //类型：String  必有字段  备注：无
//"sex":"[女士 先生]",                //类型：String  必有字段  备注：性别
//"mobile":"13398208750",                //类型：String  必有字段  备注：手机号
//"city":"成都",                //类型：String  必有字段  备注：城市
//"county":"双流区",                //类型：String  必有字段  备注：区县
//"street":"太平园xx大道",                //类型：String  必有字段  备注：街道
//"house_number":"xx大道",                //类型：String  必有字段  备注：门号
//"is_default":1,                //类型：Number  必有字段  备注：是否为默认地址 0:否 1:是
//"user_id":"5c4c04ac02dce63aac004e76",                //类型：String  必有字段  备注：无
//"edit_time":20190126163202,                //类型：Number  必有字段  备注：无
//"add_time":20190126163202                //类型：Number  必有字段  备注：无
@end

NS_ASSUME_NONNULL_END
