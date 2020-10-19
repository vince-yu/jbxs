//
//  NSObject+SystemInfo.m
//  socialDemo
//
//  Created by 陈欢 on 13-12-30.
//  Copyright (c) 2013年 陈欢. All rights reserved.
//

#import "NSObject+SystemInfo.h"
#import <objc/runtime.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CommonCrypto/CommonDigest.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#import <mach/mach.h>
#import <CoreTelephony/CTCarrier.h>
#import <sys/utsname.h>

@implementation NSObject (SystemInfo)

- (NSMutableArray *)attributeList {
	static NSMutableDictionary *classDictionary = nil;
	if (classDictionary == nil) {
		classDictionary = [[NSMutableDictionary alloc] init];
	}

	NSString *className = NSStringFromClass(self.class);

	NSMutableArray *propertyList = [classDictionary objectForKey:className];

	if (propertyList != nil) {
		return propertyList;
	}

	propertyList = [[NSMutableArray alloc] init];

	id theClass = object_getClass(self);
	[self getPropertyList:theClass forList:&propertyList];

	[classDictionary setObject:propertyList forKey:className];
#if !__has_feature(objc_arc)
	[propertyList release];
#endif
	return propertyList;
}
- (NSMutableDictionary *)getAttribitDic{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (NSString *attri in [self attributeList]) {
        id object = [self valueForKey:attri];
        if (object) {
            if ([object isKindOfClass:[NSObject class]]) {
                [dic setObject:object forKey:attri];
            }else{
                
            }
        
        }
    }
    return dic;
}
- (void)getPropertyList:(id)theClass forList:(NSMutableArray **)propertyList {
	id superClass = class_getSuperclass(theClass);
	unsigned int count, i;
	objc_property_t *properties = class_copyPropertyList(theClass, &count);
	for (i = 0; i < count; i++) {
		objc_property_t property = properties[i];
		NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property)
		                                                  encoding:NSUTF8StringEncoding];
		if (propertyName != nil) {
			[*propertyList addObject: propertyName];
#if !__has_feature(objc_arc)
			[propertyName release];
#endif
			propertyName = nil;
		}
	}
	free(properties);

	if (superClass != [NSObject class]) {
		[self getPropertyList:superClass forList:propertyList];
	}
}
- (NSMutableArray *)getProperties
{
    // 获取当前类的所有属性
    unsigned int count;// 记录属性个数
    
    objc_property_t *properties = class_copyPropertyList(self.class, &count);
    // 遍历
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        
        // An opaque type that represents an Objective-C declared property.
        // objc_property_t 属性类型
        objc_property_t property = properties[i];
        // 获取属性的名称 C语言字符串
        const char *cName = property_getName(property);
        // 转换为Objective C 字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [mArray addObject:name];
    }
    return mArray;
}

- (NSString *)version {
	NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
	return version;
}

/*设备相关*/
- (float)deviceSystemVersion {
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
	return version;
}

- (NSString *)deviceModel {
	NSString *model = [[UIDevice currentDevice] model];
	model = [model stringByReplacingOccurrencesOfString:@" " withString:@"_"];
	return model;
}

- (NSString *)deviceName {
	NSString *name = [[UIDevice currentDevice] name];
	return name;
}

- (BOOL)deviceIsPad {
	return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
}

- (BOOL)deviceIsPhone {
	return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
}
/*md5 加密*/
- (NSString *)md5 {
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
	return [data md5];
}

- (NSString *)appleLanguages {
	return [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
}

- (void)observeNotificaiton:(NSString *)name {
	[self observeNotificaiton:name selector:@selector(handleNotification:)];
}

- (void)observeNotificaiton:(NSString *)name selector:(SEL)selector {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
	                                         selector:selector
	                                             name:name
	                                           object:nil];
}

- (void)unobserveNotification:(NSString *)name {
	[[NSNotificationCenter defaultCenter] removeObserver:self
	                                                name:name
	                                              object:nil];
}

- (void)unobserveAllNotification {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)postNotification:(NSString *)name {
	[self postNotification:name object:nil];
}

- (void)postNotification:(NSString *)name object:(id)object {
	[[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
}

- (void)postNotification:(NSString *)name userInfo:(NSDictionary *)userInfo {
	[self postNotification:name object:nil userInfo:userInfo];
}

- (void)postNotification:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo {
	[[NSNotificationCenter defaultCenter] postNotificationName:name
	                                                    object:object
	                                                  userInfo:userInfo];
}

- (void)postNotification:(NSString *)name withObject:(id)object {
	if (object == nil) {
		object = @"";
	}
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:object forKey:kNotificationObject];
	[[NSNotificationCenter defaultCenter] postNotificationName:name
	                                                    object:nil
	                                                  userInfo:userInfo];
}

- (void)handleNotification:(NSNotification *)noti {
	if ([self respondsToSelector:@selector(handleNotification:object:userInfo:)]) {
		[self handleNotification:noti.name object:noti.object userInfo:noti.userInfo];
	}
}

- (void)handleNotification:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo {
}

- (BOOL)isString {
	if ([self isKindOfClass:[NSString class]]) {
		return YES;
	}
	return NO;
}
- (BOOL)isEmptyString {
    if (self != nil && [self isString] && [((NSString *)self) length] > 0) {
        return NO;
    }
    return YES;
}
- (BOOL)isNotEmptyString {
    if (self != nil && [self isString] && [((NSString *)self) length] > 0) {
        NSString *str = (NSString *)self;
        NSRange range1 = [str rangeOfString:@"null"];//判断字符串是否包含
        NSRange range2 = [str rangeOfString:@"Null"];//判断字符串是否包含
        NSRange range3 = [str rangeOfString:@"NULL"];//判断字符串是否包含
        if (range1.length == 0 && range2.length == 0 && range3.length == 0) {
            return YES;
        }
        return NO;
    }
    return NO;
}

- (BOOL)isArray {
	if ([self isKindOfClass:[NSArray class]]) {
		return YES;
	}
	return NO;
}

- (BOOL)isEmptyArray {
	if (self != nil && [self isArray] && [(NSArray *)self count] > 0) {
		return NO;
	}
	return YES;
}

- (BOOL)isNotEmptyArray {
	if (self != nil && [self isArray] && [(NSArray *)self count] > 0) {
		return YES;
	}
	return NO;
}

- (BOOL)isDictionary {
	if ([self isKindOfClass:[NSDictionary class]]) {
		return YES;
	}
	return NO;
}
- (BOOL)isEmptyDictionary {
    if (self != nil && [self isDictionary] && [((NSDictionary *)self).allKeys count] > 0) {
        return NO;
    }
    return YES;
}

- (BOOL)isNotEmptyDictionary {
	if ([self isDictionary]) {
		NSDictionary *tempDict = (NSDictionary *)self;
		if ([tempDict allKeys].count > 0) {
			return YES;
		}
	}
	return NO;
}

- (BOOL)openURL:(NSURL *)url {
	return [[UIApplication sharedApplication] openURL:url];
}

- (void)sendMail:(NSString *)mail {
	NSString *url = [NSString stringWithFormat:@"mailto://%@", mail];
	[self openURL:[NSURL URLWithString:url]];
}

- (void)sendSMS:(NSString *)number {
	NSString *url = [NSString stringWithFormat:@"sms://%@", number];
	[self openURL:[NSURL URLWithString:url]];
}

- (void)callNumber:(NSString *)number {
	NSString *url = [NSString stringWithFormat:@"tel://%@", number];
	[self openURL:[NSURL URLWithString:url]];
}

- (NSString *)applicationDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	basePath = [basePath stringByReplacingOccurrencesOfString:@"/Documents" withString:@""];
	return basePath;
}

- (NSString *)applicationDocumentsDirectory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	return basePath;
}

/*保存在本地数据*/
- (void)setNsuserDefault:(id)object forKey:(NSString *)key {
	NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
	[user setObject:object forKey:key];
	[user synchronize];
}

/*获取文件夹路径*/
- (UIImage *)imagePath:(NSString *)directory file:(NSString *)hash {
	NSString *imagePath = [self getFilePath:directory file:hash];
	NSFileManager *fm = [NSFileManager defaultManager];
	if ([fm fileExistsAtPath:imagePath]) {
		UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
		return image;
	}
	return nil;
}

- (NSString *)getFilePath:(NSString *)directory file:(NSString *)hash {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [paths objectAtIndex:0];
	NSString *imagePath = [documentDirectory stringByAppendingPathComponent:directory];
	imagePath = [imagePath stringByAppendingPathComponent:hash];
	return imagePath;
}

- (uint64_t)getFreeDiskspace {
	uint64_t totalSpace = 0;
	uint64_t totalFreeSpace = 0;
	NSError *error = nil;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error:&error];

	if (dictionary) {
		NSNumber *fileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemSize];
		NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
		totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
		totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
	}
	else {
	}

	return totalFreeSpace;
}

- (uint64_t)getTotalDiskspace {
	uint64_t totalSpace = 0;
	uint64_t totalFreeSpace = 0;
	NSError *error = nil;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error:&error];

	if (dictionary) {
		NSNumber *fileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemSize];
		NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
		totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
		totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
	}
	else {
	}

	return totalSpace;
}

- (NSString *)networkInfo {
	CTTelephonyNetworkInfo *telephonyInfo = [CTTelephonyNetworkInfo new];
	return telephonyInfo.currentRadioAccessTechnology;
}

- (long long int)getNowTime {
	NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
	long long int date = (long long int)time;
	return date;
}

- (NSString *)getDevieceDPI {
	//屏幕尺寸

	CGRect rect = [[UIScreen mainScreen] bounds];

	CGSize size = rect.size;

	CGFloat width = size.width;

	CGFloat height = size.height;


	//分辨率

	CGFloat scale_screen = [UIScreen mainScreen].scale;

	NSString *dpi = [NSString stringWithFormat:@"%0.0fx%0.0f", width * scale_screen, height * scale_screen];
	return dpi;
}

- (CGFloat)getDevieceW_Hbili {
	CGRect rect = [[UIScreen mainScreen] bounds];

	CGSize size = rect.size;

	CGFloat width = size.width;

	CGFloat height = size.height;

	return width / height;
}

- (CGSize)getDevieceSize {
	CGRect rect = [[UIScreen mainScreen] bounds];

	CGSize size = rect.size;

	return size;
}

- (NSString *)replaceNullData:(NSString *)nullData {
	if ([[self converString:nullData]isEqualToString:@"空"]) {
		return @"";
	}
	else {
		return nullData;
	}
	return @"";
}

- (NSString *)converString:(NSObject *)obj {
	NSString *str = (NSString *)obj;

	if ([[obj class] isSubclassOfClass:[NSNumber class]]) {
		str = [obj description];
	}
	else if ([[obj class] isSubclassOfClass:[NSNull  class]]
	         || (obj == nil)
	         || ([[obj class] isSubclassOfClass:[NSString class]] && ([(NSString *)obj isEqualToString:@"(null)"]  || [(NSString *)obj isEqualToString:@""]))
	         ) {
		str = @"空";
	}
	return str.description;
}

//sha1加密方式
- (NSString *)getSha1String:(NSString *)srcString {
	const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
	NSData *data = [NSData dataWithBytes:cstr length:srcString.length];

	uint8_t digest[CC_SHA1_DIGEST_LENGTH];

	CC_SHA1(data.bytes, (unsigned int)data.length, digest);

	NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

	for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
		[result appendFormat:@"%02x", digest[i]];
	}

	NSString *upperString = [[NSString alloc]initWithString:result];

	upperString = [upperString uppercaseString];

	return upperString;
}

- (NSString *)timeToTranslate:(NSString *)timestring {
    
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:timestring.doubleValue];

	//实例化一个NSDateFormatter对象
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	//设定时间格式,这里可以设置成自己需要的格式
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[NSLocale currentLocale]];

	NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];

	return currentDateStr;
}

- (NSString *)timeToTranslateToHours:(float)time {
	NSString *string = [NSString stringWithFormat:@"%li天%02li时%02li分%02li秒",
	                    lround(floor(time / (24 * 3600.))),
	                    lround(floor(time / 3600.)) % 24,
	                    lround(floor(time / 60.)) % 60,
	                    lround(floor(time / 1.)) % 60];
	return string;
}

+ (NSString *)getIdentifier {
	NSString *bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
	return bundleId;
}

+ (NSString *)getShortVersion {
	NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
	return version;
}

+ (NSString *)getSystemName {
	NSString *deviceName = [UIDevice currentDevice].systemName;
	return deviceName;
}

+ (NSString *)getSystemModel {
	NSString *modelName = [UIDevice currentDevice].model;
	return modelName;
}

+ (NSString *)getUDID {
	NSString *uuid = [UIDevice currentDevice].identifierForVendor.UUIDString.uppercaseString;
	return uuid;
}
+ (NSString *)getISP{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    return carrier.carrierName;
}
//获得设备型号
+ (NSString *)getCurrentDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo); // 获取系统设备信息
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    NSDictionary *dict = @{
                           // iPhone
                           @"iPhone5,3" : @"iPhone 5c",
                           @"iPhone5,4" : @"iPhone 5c",
                           @"iPhone6,1" : @"iPhone 5s",
                           @"iPhone6,2" : @"iPhone 5s",
                           @"iPhone7,1" : @"iPhone 6 Plus",
                           @"iPhone7,2" : @"iPhone 6",
                           @"iPhone8,1" : @"iPhone 6s",
                           @"iPhone8,2" : @"iPhone 6s Plus",
                           @"iPhone8,4" : @"iPhone SE",
                           @"iPhone9,1" : @"iPhone 7",
                           @"iPhone9,2" : @"iPhone 7 Plus",
                           @"iPhone10,1" : @"iPhone 8",
                           @"iPhone10,4" : @"iPhone 8",
                           @"iPhone10,2" : @"iPhone 8 Plus",
                           @"iPhone10,5" : @"iPhone 8 Plus",
                           @"iPhone10,3" : @"iPhone X",
                           @"iPhone10,6" : @"iPhone X",
                           @"iPhone11,2" : @"iPhone XS",
                           @"iPhone11,4" : @"iPhone XS Max",
                           @"iPhone11,6" : @"iPhone XS Max",
                           @"iPhone11,8" : @"iPhone XR",
                           @"i386" : @"iPhone Simulator",
                           @"x86_64" : @"iPhone Simulator",
                           // iPad
                           @"iPad4,1" : @"iPad Air",
                           @"iPad4,2" : @"iPad Air",
                           @"iPad4,3" : @"iPad Air",
                           @"iPad5,3" : @"iPad Air 2",
                           @"iPad5,4" : @"iPad Air 2",
                           @"iPad6,7" : @"iPad Pro 12.9",
                           @"iPad6,8" : @"iPad Pro 12.9",
                           @"iPad6,3" : @"iPad Pro 9.7",
                           @"iPad6,4" : @"iPad Pro 9.7",
                           @"iPad6,11" : @"iPad 5",
                           @"iPad6,12" : @"iPad 5",
                           @"iPad7,1" : @"iPad Pro 12.9 inch 2nd gen",
                           @"iPad7,2" : @"iPad Pro 12.9 inch 2nd gen",
                           @"iPad7,3" : @"iPad Pro 10.5",
                           @"iPad7,4" : @"iPad Pro 10.5",
                           @"iPad7,5" : @"iPad 6",
                           @"iPad7,6" : @"iPad 6",
                           // iPad mini
                           @"iPad2,5" : @"iPad mini",
                           @"iPad2,6" : @"iPad mini",
                           @"iPad2,7" : @"iPad mini",
                           @"iPad4,4" : @"iPad mini 2",
                           @"iPad4,5" : @"iPad mini 2",
                           @"iPad4,6" : @"iPad mini 2",
                           @"iPad4,7" : @"iPad mini 3",
                           @"iPad4,8" : @"iPad mini 3",
                           @"iPad4,9" : @"iPad mini 3",
                           @"iPad5,1" : @"iPad mini 4",
                           @"iPad5,2" : @"iPad mini 4",
                           // Apple Watch
                           @"Watch1,1" : @"Apple Watch",
                           @"Watch1,2" : @"Apple Watch",
                           @"Watch2,6" : @"Apple Watch Series 1",
                           @"Watch2,7" : @"Apple Watch Series 1",
                           @"Watch2,3" : @"Apple Watch Series 2",
                           @"Watch2,4" : @"Apple Watch Series 2",
                           @"Watch3,1" : @"Apple Watch Series 3",
                           @"Watch3,2" : @"Apple Watch Series 3",
                           @"Watch3,3" : @"Apple Watch Series 3",
                           @"Watch3,4" : @"Apple Watch Series 3",
                           @"Watch4,1" : @"Apple Watch Series 4",
                           @"Watch4,2" : @"Apple Watch Series 4",
                           @"Watch4,3" : @"Apple Watch Series 4",
                           @"Watch4,4" : @"Apple Watch Series 4"
                           };
    NSString *name = dict[platform];
    
    return name ? name : platform;
}
+ (NSString *)getOS{
    
    return [UIDevice currentDevice].systemVersion;
}
//12.2后无效
+(NSString *)getNetWorkStates{
    UIApplication *app = [UIApplication sharedApplication];
    id statusBar = [app valueForKeyPath:@"statusBar"];
    NSString * network = nil;
    
    if ([SDAppManager isLiuHaiScreen]) {
        //        刘海屏
        id statusBarView = [statusBar valueForKeyPath:@"statusBar"];
        UIView *foregroundView = [statusBarView valueForKeyPath:@"foregroundView"];
        NSArray *subviews = [[foregroundView subviews][2] subviews];
        
        if (subviews.count == 0) {
            //            iOS 12
            id currentData = [statusBarView valueForKeyPath:@"currentData"];
            id wifiEntry = [currentData valueForKey:@"wifiEntry"];
            if ([[wifiEntry valueForKey:@"_enabled"] boolValue]) {
                network = @"无服务";
            }else {
                //                卡1:
                id cellularEntry = [currentData valueForKey:@"cellularEntry"];
                //                卡2:
                id secondaryCellularEntry = [currentData valueForKey:@"secondaryCellularEntry"];
                
                if (([[cellularEntry valueForKey:@"_enabled"] boolValue]|[[secondaryCellularEntry valueForKey:@"_enabled"] boolValue]) == NO) {
                    //                    无卡情况
                    network = 0;
                }else {
                    //                    判断卡1还是卡2
                    BOOL isCardOne = [[cellularEntry valueForKey:@"_enabled"] boolValue];
                    int networkType = isCardOne ? [[cellularEntry valueForKey:@"type"] intValue] : [[secondaryCellularEntry valueForKey:@"type"] intValue];
                    switch (networkType) {
                        case 0://无服务
                            network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"NONE"];
                            break;
                        case 3:
                            network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"2G/E"];
                            break;
                        case 4:
                            network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"3G"];
                            break;
                        case 5:
                            network = [NSString stringWithFormat:@"%@-%@", isCardOne ? @"Card 1" : @"Card 2", @"4G"];
                            break;
                        default:
                            break;
                    }
                    
                }
            }
            
        }else {
            
            for (id subview in subviews) {
                if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarWifiSignalView")]) {
                    network = @"NO DISPLAY";
                }else if ([subview isKindOfClass:NSClassFromString(@"_UIStatusBarStringView")]) {
                    //非wifi情况下的信号还有待真机验证 need to do
                    //                    network = [subview valueForKeyPath:@"originalText"];
                }
            }
        }
        
    }else {
        //        非刘海屏
        UIView *foregroundView = [statusBar valueForKeyPath:@"foregroundView"];
        NSArray *subviews = [foregroundView subviews];
        
        for (id subview in subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
                int networkType = [[subview valueForKeyPath:@"dataNetworkType"] intValue];
                switch (networkType) {
                    case 0:
                        network = @"NONE";
                        break;
                    case 1:
                        network = @"2G";
                        break;
                    case 2:
                        network = @"3G";
                        break;
                    case 3:
                        network = @"4G";
                        break;
                    case 5:
                        network = @"WIFI";
                        break;
                    default:
                        break;
                }
            }
        }
    }
    
    return network;
}
@end
