//
//  SDJumpManager.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/29.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SDJumpManager : NSObject
+ (instancetype)sharedInstance;

+ (void)jumpUrl:(NSString *)url push:(BOOL )needPush parentsController:(UIViewController *)controller animation:(BOOL )needAnimation;
@end

