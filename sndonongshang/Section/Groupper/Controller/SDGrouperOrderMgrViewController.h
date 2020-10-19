//
//  SDGrouperOrderMgrViewController.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/7.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDGrouperOrderMgrViewController : UIViewController

+ (instancetype)orderContentType:(SDUserRolerType)rolerType status:(NSString *)status;

@end

NS_ASSUME_NONNULL_END
