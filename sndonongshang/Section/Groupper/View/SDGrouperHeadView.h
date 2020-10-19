//
//  SDGrouperHeadView.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/14.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SDGrouperEditBlock)(void);

@interface SDGrouperHeadView : UIView
@property (nonatomic ,copy) SDGrouperEditBlock editBlock;
@end

NS_ASSUME_NONNULL_END
