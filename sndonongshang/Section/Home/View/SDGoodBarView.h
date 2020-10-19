//
//  SDGoodBarView.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/10.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface SDGoodBarView : UIView
@property (nonatomic ,copy) void (^addToCartBlock)(void);
@property (nonatomic ,copy) void (^buyNowBlock)(void);
@property (nonatomic ,copy) void (^pushToCartVC)(void);
@property (nonatomic ,copy) void (^remindBlock)(void);
@property (nonatomic ,copy) void (^shareBlock)(void);
@property (nonatomic ,assign) SDGoodBarStyle type;
@property (nonatomic ,copy) NSString *remindStr;
@property (nonatomic ,copy) NSString *buyStr;
- (instancetype)initWithFrame:(CGRect)frame type:(SDGoodBarStyle )type;
@end

NS_ASSUME_NONNULL_END
