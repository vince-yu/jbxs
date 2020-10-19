//
//  SDNetConfig.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/5.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDNetConfig.h"
#import "YTKNetwork.h"

@implementation SDNetConfig
+ (instancetype)sharedInstance {
    static SDNetConfig *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (void)setType:(SeverType)type
{
    _type = type;
    YTKNetworkAgent *agent = [YTKNetworkAgent sharedAgent];
    [agent setValue:[NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json",@"text/html",@"text/css",@"image/jpeg",@"image/png", nil] forKeyPath:@"jsonResponseSerializer.acceptableContentTypes"];
    
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    switch (type) {
        case SeverType_Dev:
            config.baseUrl = KSeverDevURL;
            self.htmlUrl = KH5ServerDevURL;
            break;
        case SeverType_Test:
            config.baseUrl = KServerTestURL;
            self.htmlUrl = KH5ServerTestURL;
            break;
        case SeverType_Release:
            config.baseUrl = KServerReleaseURL;
            self.htmlUrl = KH5ServerReleaseURL;
            break;
        default:
            break;
    }
    //    AFHTTPSessionManager *manager = [agent valueForKey:@"_manager"];
    //    manager.securityPolicy.allowInvalidCertificates = YES;
    //    manager.securityPolicy.validatesDomainName = NO;
    //    __block AFHTTPSessionManager *blockManager = manager;
    //    [manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession *session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing *_credential) {
    //        SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
    //        /**
    //                  *  导入多张CA证书
    //                  */
    //        NSString *cerPath = [[NSBundle mainBundle]pathForResource:@"bskyHttps" ofType:@"cer"];//自签名证书
    //        NSData* caCert = [NSData dataWithContentsOfFile:cerPath];
    //        NSSet *cerArray = [NSSet setWithObjects:caCert, nil];
    //        blockManager.securityPolicy.pinnedCertificates = cerArray;
    //        SecCertificateRef caRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)caCert);
    //        NSCAssert(caRef != nil, @"caRef is nil");
    //        NSArray *caArray = @[(__bridge id)(caRef)];
    //        NSCAssert(caArray != nil, @"caArray is nil");
    //        OSStatus status = SecTrustSetAnchorCertificates(serverTrust, (__bridge CFArrayRef)caArray);
    //        SecTrustSetAnchorCertificatesOnly(serverTrust,NO);
    //        NSCAssert(errSecSuccess == status, @"SecTrustSetAnchorCertificates failed");
    //        NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    //        __autoreleasing NSURLCredential *credential = nil;
    //        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
    //            if ([blockManager.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
    //                credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    //                if (credential) {
    //                    disposition = NSURLSessionAuthChallengeUseCredential;
    //                }else
    //                {
    //                    disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    //                }
    //            }
    //            else
    //            {
    //                disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
    //            }
    //        }
    //        else
    //        {
    //            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    //        }
    //        return disposition;
    //    }];
}

- (NSString *)baseUrl {
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    return config.baseUrl;
}

@end
