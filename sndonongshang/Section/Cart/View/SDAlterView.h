//
//  SDAlterView.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/11.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SDAlterViewStylePaySuccess = 0,
    SDAlterViewStylePayFailed,
    SDAlterViewStyleGroupBuy,
} SDAlterViewStyle;

@interface SDAlterView : UIView
- (instancetype)initWithFrame:(CGRect)frame withType:(SDAlterViewStyle )type;
- (void)show;
@end

@interface SDGroupBuyAlterView : UIView

@end

NS_ASSUME_NONNULL_END
