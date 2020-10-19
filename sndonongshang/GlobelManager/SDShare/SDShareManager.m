//
//  ShareManager.m
//  QAQ
//
//  Created by apple on 2017/7/4.
//  Copyright © 2017年 SNDO. All rights reserved.
//

#import "SDShareManager.h"
#import "SDShareView.h"

@implementation SDShareManager

#pragma mark - 登录
+(void)loginWithPlatform:(UMSocialPlatformType)platformType resultBlock:(ThirdLoginResultBlock)loginResultBlock{
    [self getUserInfoForPlatform:platformType resultBlock:(ThirdLoginResultBlock)loginResultBlock];
}

#pragma mark - 登录获取用户信息

+(void)getUserInfoForPlatform:(UMSocialPlatformType)platformType resultBlock:(ThirdLoginResultBlock)loginResultBlock{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        
        // 第三方登录数据(为空表示平台未提供)
        // 授权数据
        SNDOLOG(@" uid: %@", resp.uid);
        SNDOLOG(@" openid: %@", resp.openid);
        SNDOLOG(@" accessToken: %@", resp.accessToken);
        SNDOLOG(@" refreshToken: %@", resp.refreshToken);
        SNDOLOG(@" expiration: %@", resp.expiration);
        // 用户数据
        SNDOLOG(@" name: %@", resp.name);
        SNDOLOG(@" iconurl: %@", resp.iconurl);
        SNDOLOG(@" gender: %@", resp.gender);
        
        // 第三方平台SDK原始数据
        SNDOLOG(@" originalResponse: %@", resp.originalResponse);
        
        if (loginResultBlock) {
            loginResultBlock(resp, error);
        }
    }];
}

#pragma mark -取消授权
+ (void)cancelAuthWithPlatform:(UMSocialPlatformType)platformType resultBlock:(ThirdLoginResultBlock)loginResultBlock{
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:platformType completion:^(id result, NSError *error) {
        UMSocialUserInfoResponse *resp = result;
        if (loginResultBlock) {
            loginResultBlock(resp, error);
        }
    }];
}


#pragma mark - 分享文本
+ (void)shareTextToPlatformType:(UMSocialPlatformType)platformType withMessage:(NSString *)message withShareResultBlock:(ShareResultBlock)shareResultBlock{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = message;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (shareResultBlock) {
            shareResultBlock(data, error);
        }
    }];
}

#pragma mark - 分享图片
+(void)shareImageToPlatformType:(UMSocialPlatformType)platformType thumbImage:(UIImage *)thumbImage sourceImagePath:(NSString *)imageUrlStr withShareResultBlock:(ShareResultBlock)shareResultBlock{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = thumbImage;
    [shareObject setShareImage:imageUrlStr];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (shareResultBlock) {
            shareResultBlock(data, error);
        }
    }];
}

#pragma mark -   分享图文（新浪支持，微信/QQ仅支持图或文本分享）
+(void)shareImageAndTextToPlatformType:(UMSocialPlatformType)platformType withMessage:(NSString *)message thumbImage:(UIImage *)thumbImage sourceImagePath:(NSString *)imageUrlStr withShareResultBlock:(ShareResultBlock)shareResultBlock{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //设置文本
    messageObject.text = message;
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = thumbImage;
    [shareObject setShareImage:imageUrlStr];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (shareResultBlock) {
            shareResultBlock(data, error);
        }
    }];
}


#pragma mark -  分享网页
+(void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType title:(NSString *)title descr:(NSString *)descr thumbImage:(id)thumbImage webpageUrl:(NSString *)webpageUrl withShareResultBlock:(ShareResultBlock)shareResultBlock {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:thumbImage];
    //设置网页地址
    shareObject.webpageUrl = webpageUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (shareResultBlock) {
            shareResultBlock(data, error);
        }
    }];
}

#pragma mark -  分享音乐
+(void)shareMusicToPlatformType:(UMSocialPlatformType)platformType title:(NSString *)title descr:(NSString *)descr thumbImage:(UIImage *)thumbImage musicUrl:(NSString *)musicUrl withShareResultBlock:(ShareResultBlock)shareResultBlock{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建音乐内容对象
    UMShareMusicObject *shareObject = [UMShareMusicObject shareObjectWithTitle:title descr:descr thumImage:thumbImage];
    //设置音乐网页播放地址
    shareObject.musicUrl = musicUrl; // @"http://c.y.qq.com/v8/playsong.html?songid=108782194&source=yqq#wechat_redirect";
    //            shareObject.musicDataUrl = @"这里设置音乐数据流地址（如果有的话，而且也要看所分享的平台支不支持）";
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (shareResultBlock) {
            shareResultBlock(data, error);
        }
    }];
}

#pragma mark -  分享视频
+(void)shareVedioToPlatformType:(UMSocialPlatformType)platformType title:(NSString *)title descr:(NSString *)descr thumbImage:(UIImage *)thumbImage videoUrl:(NSString *)videoUrl withShareResultBlock:(ShareResultBlock)shareResultBlock{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建视频内容对象
    UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:title descr:descr thumImage:thumbImage];
    //设置视频网页播放地址
    shareObject.videoUrl = videoUrl; // @"http://video.sina.com.cn/p/sports/cba/v/2013-10-22/144463050817.html";
    //            shareObject.videoStreamUrl = @"这里设置视频数据流地址（如果有的话，而且也要看所分享的平台支不支持）";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (shareResultBlock) {
            shareResultBlock(data, error);
        }
    }];
}
#pragma mark - 微信会话分享小程序
+ (void)shareMinProgramToPlatformType:(UMSocialPlatformType)platformType title:(NSString *)title descr:(NSString *)descr thumbImage:(UIImage *)thumbImage hdImage:hdImage webUrl:(NSString *)webUrl programId:(NSString *)programId programPath:(NSString *)programPath  withShareResultBlock:(ShareResultBlock)shareResultBlock{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareMiniProgramObject *shareObject = [UMShareMiniProgramObject shareObjectWithTitle:title descr:descr thumImage:thumbImage];
    shareObject.webpageUrl = webUrl;
    shareObject.userName = programId;
    shareObject.path = programPath;
    if ([SDNetConfig sharedInstance].type == SeverType_Release) {
        shareObject.miniProgramType = UShareWXMiniProgramTypeRelease;
    }else{
        shareObject.miniProgramType = UShareWXMiniProgramTypePreview;
    }
    messageObject.shareObject = shareObject;
    if (hdImage) {
        shareObject.hdImageData = [hdImage compressWithMaxLength:128 * 1024];
    }
    
//    shareObject.miniProgramType = UShareWXMiniProgramTypeRelease; // 可选体验版和开发板
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
//                [SDToastView HUDWithString:@"分享成功!"];
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        if (shareResultBlock) {
            shareResultBlock(data,error);
        }
    }];
}
#pragma mark - 分享图片到朋友圈
+(void)shareImageToPlatformTypeShareImage:(UIImage *)shareImage withShareResultBlock:(ShareResultBlock)shareResultBlock{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
//    shareObject.thumbImage = thumbImage;
//    [shareObject setShareImage:imageUrlStr];
    if (shareImage) {
        shareObject.shareImage = [shareImage compressWithMaxLength:128 * 1024];
    }
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (shareResultBlock) {
            shareResultBlock(data, error);
        }
    }];
}
#pragma mark - 使用友盟分享UI
+(void)shareWebPageWithUMUIToPlatformType:(UMSocialPlatformType)platformType title:(NSString *)title descr:(NSString *)descr thumbImage:(id)thumbImage hdImage:(id)hdImage webpageUrl:(NSString *)webpageUrl programId:(NSString *)programId programPath:(NSString *)programPath viewDescr:(NSAttributedString *)str withShareResultBlock:(ShareResultBlock)shareResultBlock type:(SDShareType)shareType goodModel:(SDGoodModel *)goodModel{
    NSString *successStr = @"分享成功";
    NSString *failedStr = @"分享失败，请重新分享";
    [SDShareView showWithWxBlock:^{
        switch (shareType) {
                case SDShareTypeGoodDetailView:
                [SDStaticsManager umEvent:kdetail_share_wx attr:@{@"_id":goodModel.goodId,@"name":goodModel.name,@"type":goodModel.type}];
                break;
                case SDShareTypeLaXingView:
                [SDStaticsManager umEvent:klx_share_wx];
                break;
            default:
                break;
        }
        [SDShareManager shareMinProgramToPlatformType:UMSocialPlatformType_WechatSession title:title descr:descr thumbImage:thumbImage hdImage:hdImage webUrl:webpageUrl programId:programId programPath:programPath withShareResultBlock:^(id data, NSError *error) {
            
            if (shareType == SDShareTypeGoodDetailView) {
                if (error) {
//                    [SDToastView HUDWithString:failedStr];
                    [SDStaticsManager umEvent:kdetail_share_fail attr:@{@"_id":goodModel.goodId,@"name":goodModel.name,@"type":goodModel.type,@"platform":@"WEIXIN"}];
                }else{
//                    [SDToastView HUDWithString:successStr];
                    [SDStaticsManager umEvent:kdetail_share_success attr:@{@"_id":goodModel.goodId,@"name":goodModel.name,@"type":goodModel.type,@"platform":@"WEIXIN"}];
                }
            }
            shareResultBlock(data,error);
        }];
    } wxTimeLineBlock:^(id image){
        switch (shareType) {
                case SDShareTypeGoodDetailView:
                [SDStaticsManager umEvent:kdetail_share_circle attr:@{@"_id":goodModel.goodId,@"name":goodModel.name,@"type":goodModel.type}];
                break;
                case SDShareTypeLaXingView:
                [SDStaticsManager umEvent:klx_share_circle];
                break;
            default:
                break;
        }
        [SDShareManager shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine title:title descr:descr thumbImage:thumbImage webpageUrl:webpageUrl withShareResultBlock:^(id data, NSError *error) {
            if (shareType == SDShareTypeGoodDetailView) {
                if (error) {
//                    [SDToastView HUDWithString:failedStr];
                    [SDStaticsManager umEvent:kdetail_share_fail attr:@{@"_id":goodModel.goodId,@"name":goodModel.name,@"type":goodModel.type,@"platform":@"WEIXIN_CIRCLE"}];
                }else{
//                    [SDToastView HUDWithString:successStr];
                    [SDStaticsManager umEvent:kdetail_share_success attr:@{@"_id":goodModel.goodId,@"name":goodModel.name,@"type":goodModel.type,@"platform":@"WEIXIN_CIRCLE"}];
                }
            }else{
                
            }
            shareResultBlock(data,error);
        }];
    } qqBlock:^{
        switch (shareType) {
                case SDShareTypeGoodDetailView:
                [SDStaticsManager umEvent:kdetail_share_qq attr:@{@"_id":goodModel.goodId,@"name":goodModel.name,@"type":goodModel.type}];
                break;
                case SDShareTypeLaXingView:
                [SDStaticsManager umEvent:klx_share_qq];
                break;
            default:
                break;
        }
        [SDShareManager shareWebPageToPlatformType:UMSocialPlatformType_QQ title:title descr:descr thumbImage:thumbImage webpageUrl:webpageUrl withShareResultBlock:^(id data, NSError *error) {
            NSString *message = nil;
            if (shareType == SDShareTypeGoodDetailView) {
                if (error) {
                    if ([error.userInfo isKindOfClass:[NSDictionary class]]) {
                        NSString *messageStr = [error.userInfo objectForKey:@"message"];
                        if ([messageStr isEqualToString:@"操作取消"]) {
                            message = @"分享已取消";
                        }
                        else{
                            message = failedStr;
                        }
                    }else{
                        message = failedStr;
                    }
                    
                    [SDStaticsManager umEvent:kdetail_share_fail attr:@{@"_id":goodModel.goodId,@"name":goodModel.name,@"type":goodModel.type,@"platform":@"WEIXIN_CIRCLE"}];
                }else{
//                    [SDToastView HUDWithString:successStr];
                    message = successStr;
                    [SDStaticsManager umEvent:kdetail_share_success attr:@{@"_id":goodModel.goodId,@"name":goodModel.name,@"type":goodModel.type,@"platform":@"WEIXIN_CIRCLE"}];
                }
            }else{
                if (error) {
                    if ([error.userInfo isKindOfClass:[NSDictionary class]]) {
                        NSString *messageStr = [error.userInfo objectForKey:@"message"];
                        if ([messageStr isEqualToString:@"操作取消"]) {
                            message = @"分享已取消";
                        }
                        else{
                            message = failedStr;
                        }
                    }else{
                        message = failedStr;
                    }
//                    [SDToastView HUDWithString:failedStr];
                }else{
//                    [SDToastView HUDWithString:successStr];
                    message = successStr;
                }
            }
            if (message.length) {
                [SDToastView HUDWithString:message];
            }
            
            shareResultBlock(data,error);
        }];
    } describe:str type:shareType];
}
@end
