//
//  SDBSRequest.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/5.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"
#import "SDNetConfig.h"
#import "SDLoginViewController.h"

@implementation SDBSRequest
- (NSString*)requestUrl {
//    NSString *pattern = @"";
//    switch ([SDNetConfig sharedInstance].type) {
//        case SeverType_Dev:
//            pattern = @"bsky-app-dev";
//            break;
//        case SeverType_Test:
//            pattern = @"bsky-app-test";
//            break;
//        case SeverType_Release:
//            pattern = @"bsky-app";
//            break;
//        default:
//            break;
//    }
    return [NSString stringWithFormat:@"%@",[self bs_requestUrl]];
}

- (NSString*)bs_requestUrl {
    return nil;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

-(NSTimeInterval)requestTimeoutInterval {
    return 30;
}

- (NSDictionary*)requestHeaderFieldValueDictionary {
    return @{
             @"Content-Type": @"application/json",
             @"headMode": @"",
             @"User-Agent": @"iOS",
             @"Device-Type": @"5",
             @"Authorization": [[NSUserDefaults standardUserDefaults] stringForKey:KToken],
             @"appVersion": [UIApplication sharedApplication].appVersion
             };
}

- (void)requestCompleteFilter {
    _code = -1;
    _msg = @"没有数据";
    if (self.responseObject && [self.responseObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)self.responseObject;
        SNDOLOG(@"网络请求 %@", self);
        SNDOLOG(@"Data: %@", dic);

        _msg = dic[@"msg"];
        _alert = dic[@"alert"];
        if (dic[@"code"]) {
            _code =  ((NSString *)dic[@"code"]).integerValue;
        }
        // 数据解密
        id data = dic[@"data"];
        if (!data || [data isKindOfClass:[NSNull class]]) {
            _ret = [NSDictionary dictionary];
        }
        else if ([data isKindOfClass:[NSString class]])
        {
            // 取消加密
            //            NSString* jsonString = [AES128Helper AES128DecryptCBC:data key:[BSClientManager sharedInstance].cek gIv:[BSClientManager sharedInstance].gIv];
            //            if (!jsonString) {
            //                jsonString = [AES128Helper AES128DecryptText:data key:[BSClientManager sharedInstance].cek];
            //            }
            //            if ([data length] > 0 && jsonString.length <= 0) {
            //                jsonString = data;
            //            }
            //            if (jsonString) {
            //                NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            //                NSError* error = nil;
            //                id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            //                if (obj != nil && error == nil) {
            //                    _ret = obj;
            //                }
            //            }else {
            //                _ret = dic[@"data"];
            //            }
            
            NSData* dd = [data dataUsingEncoding:NSUTF8StringEncoding];
            NSError* error = nil;
            id obj = [NSJSONSerialization JSONObjectWithData:dd options:NSJSONReadingAllowFragments error:&error];
            if (obj != nil && error == nil) {
                _ret = obj;
            }
        }
        else
        {
            _ret = data;
        }
    }
    if (self.code != 200) {
        [self dismissHudAction];
        self.successCompletionBlock = nil;
        
        if ([self.alert isNotEmpty]) {
//            if (self.code != 201) {
            if (!(self.noFaildAlterShow && self.code == 201)) {
                [SDToastView HUDWithErrString:self.alert];
            }
            
//            }
            
            if (self.failureCompletionBlock) {
                self.failureCompletionBlock(self);
            }
            return;
        }
       // 正式上线 > 422 & 请求失败
        if (self.code == 422) {
            SNDOLOG(@"错误码 442 接口 %@", _msg);
            [self dismissHudAction];
        } else if (self.code == 401) { // 可预知的错误提示 ，如保存失败，更新失败
            [self dismissHudAction];
             [SDToastView HUDWithErrString:self.msg];
        }else if (self.code == 400) { // token
            [self dismissHudAction];
            SNDOLOG(@"token 失效");
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:KToken];
            [SDLoginViewController present];
//            SDLoginViewController *loginVc = [[SDLoginViewController alloc] init];
//            SDNavigationViewController *nav = [[SDNavigationViewController alloc] initWithRootViewController:loginVc];
//            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
            [SDToastView HUDWithErrString:@"登录已过期，请重新登录"];
        }else if (self.code >= 450) {
            [self dismissHudAction];
            if (self.code == 450101) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotifiOderWithErrorPrePay object:nil];
            }else{
                [SDToastView HUDWithErrString:@"服务器繁忙"];
                SNDOLOG(@"服务器出现BUG %ld", (long)_code);
            }
            
        }else {
            SNDOLOG(@"msg is....%@ code = %ld",self.msg, (long)self.code);
          [self dismissHudAction];
        }
        
        if (self.failureCompletionBlock) {
            self.failureCompletionBlock(self);
        }
    }else {
        [self dismissHudAction];
    }
}
- (void)dismissHudAction{
    if (!self.nodissMissHud) {
        [SDToastView dismiss];
    }
}
-(void)requestFailedFilter {
    _code = -1;
    _msg = @"没有数据";
    [self dismissHudAction];
    if (self.responseObject && [self.responseObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)self.responseObject;
        _msg = dic[@"msg"];
        if (dic[@"code"]) {
            _code =  ((NSString *)dic[@"code"]).integerValue;
        }
    }else if (self.error) {
        _msg = self.error.localizedDescription;
        _code = self.error.code;
        SNDOLOG(@"网络请求 %@", self);
        SNDOLOG(@"Error %@", self.error);
        if (self.error.code == NSURLErrorTimedOut) {
            [SDToastView HUDWithErrString:@"网络请求超时！"];
            SNDOLOG(@"网络请求超时！%ld", (long)_code);
            return;
        }
        if (self.error.code == NSURLErrorNotConnectedToInternet) {
            [SDToastView HUDWithErrString:@"当前无法访问网络，请检查网络设置!"];
            SNDOLOG(@"当前无法访问网络，请检查网络设置! %ld", (long)_code);
            return;
        }
        if (self.error.code == NSURLErrorCannotConnectToHost) {
            [SDToastView HUDWithErrString:@"未能连接到服务器"];
            SNDOLOG(@"未能连接到服务器 %ld", (long)_code);
            return;
        }
        if (self.error.code == NSURLErrorCancelled) { // task cancel
            [SDToastView HUDWithErrString:@"请求取消!"];
            SNDOLOG(@"请求取消! %ld", (long)_code);
            return;
        }
        if (self.error.code == NSURLErrorBadServerResponse) {
            [SDToastView HUDWithErrString:@"服务器繁忙!"];
            SNDOLOG(@"程序员正在抢修! %ld", (long)_code);
        }
        
        if (self.error.code == 3840) {
            [SDToastView HUDWithErrString:@"数据解析错误!"];
            SNDOLOG(@"数据解析错误! %ld", (long)_code);
        }
    }
}

- (id)requestArgument {
    return nil;
}

-(BOOL)ignoreCache {
    return YES;
}

- (BOOL)statusCodeValidator {
    return YES;
}


@end
