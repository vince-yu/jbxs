//
//  SDPayResultViewController.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/26.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBaseGreenViewController.h"
#import "SDCartOderModel.h"

typedef enum : NSUInteger {
    SDPayResultTypeSuccess = 0,
    SDPayResultTypeFailed,
} SDPayResultType;

NS_ASSUME_NONNULL_BEGIN

@interface SDPayResultViewController : SDBaseGreenViewController
- (instancetype)initWithType:(SDPayResultType )type;

@property (nonatomic, strong) SDCartOderModel *orderModel;

@end

NS_ASSUME_NONNULL_END
