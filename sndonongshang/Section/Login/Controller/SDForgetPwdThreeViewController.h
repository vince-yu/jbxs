//
//  SDForgetPwdThreeViewController.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBaseLoginViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDForgetPwdThreeViewController : SDBaseLoginViewController

@property (nonatomic, copy) NSString *smsCode;
@property (nonatomic, assign, getter=isChangePwd) BOOL changePwd;

@end

NS_ASSUME_NONNULL_END
