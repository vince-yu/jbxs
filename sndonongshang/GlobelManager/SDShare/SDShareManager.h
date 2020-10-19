//
//  ShareManager.h
//  QAQ
//
//  Created by apple on 2017/7/4.
//  Copyright © 2017年 SNDO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>
#import "SDGoodModel.h"


// 第三方登录回调 block
typedef void(^ThirdLoginResultBlock)(UMSocialUserInfoResponse *userInfoResponse, NSError *error);

// 第三方分享回调
typedef void(^ShareResultBlock)(id data, NSError *error);

@interface SDShareManager : NSObject

+(void)loginWithPlatform:(UMSocialPlatformType)platformType resultBlock:(ThirdLoginResultBlock)loginResultBlock;

//取消授权
+ (void)cancelAuthWithPlatform:(UMSocialPlatformType)platformType resultBlock:(ThirdLoginResultBlock)loginResultBlock;

#pragma mark - 分享文本
+ (void)shareTextToPlatformType:(UMSocialPlatformType)platformType withMessage:(NSString *)message withShareResultBlock:(ShareResultBlock)shareResultBlock;

#pragma mark - 分享图片
+(void)shareImageToPlatformType:(UMSocialPlatformType)platformType thumbImage:(UIImage *)thumbImage sourceImagePath:(NSString *)imageUrlStr withShareResultBlock:(ShareResultBlock)shareResultBlock;

#pragma mark -   分享图文（新浪支持，微信/QQ仅支持图或文本分享）
+(void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType withMessage:(NSString *)message thumbImage:(UIImage *)thumbImage sourceImagePath:(NSString *)imageUrlStr withShareResultBlock:(ShareResultBlock)shareResultBlock;

#pragma mark -  分享网页 thumImage 缩略图（UIImage或者NSData类型，或者image_url）
+(void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType title:(NSString *)title descr:(NSString *)descr thumbImage:(id)thumbImage webpageUrl:(NSString *)webpageUrl withShareResultBlock:(ShareResultBlock)shareResultBlock;

#pragma mark -  分享音乐
+(void)shareMusicToPlatformType:(UMSocialPlatformType)platformType title:(NSString *)title descr:(NSString *)descr thumbImage:(UIImage *)thumbImage musicUrl:(NSString *)musicUrl withShareResultBlock:(ShareResultBlock)shareResultBlock;

#pragma mark -  分享视频
+(void)shareVedioToPlatformType:(UMSocialPlatformType)platformType title:(NSString *)title descr:(NSString *)descr thumbImage:(UIImage *)thumbImage videoUrl:(NSString *)videoUrl withShareResultBlock:(ShareResultBlock)shareResultBlock;
#pragma mark - 小程序分享
+(void)shareWebPageWithUMUIToPlatformType:(UMSocialPlatformType)platformType title:(NSString *)title descr:(NSString *)descr thumbImage:(id)thumbImage hdImage:(id)hdImage webpageUrl:(NSString *)webpageUrl programId:(NSString *)programId programPath:(NSString *)programPath viewDescr:(NSAttributedString *)str withShareResultBlock:(ShareResultBlock)shareResultBlock type:(SDShareType )shareType goodModel:(SDGoodModel *)goodModel;
#pragma mark - 朋友圈图片分享
+(void)shareImageToPlatformTypeShareImage:(UIImage *)shareImage withShareResultBlock:(ShareResultBlock)shareResultBlock;
@end
