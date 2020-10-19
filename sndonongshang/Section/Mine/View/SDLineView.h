//
//  SDLineView.h
//  sndonongshang
//
//  Created by SNQU on 2019/6/10.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    SDDashLineTypeHorizontal,
    SDDashLineTypeVertical,
} SDDashLineType;
@interface SDLineView : UIView
- (instancetype )initWithType:(SDDashLineType )type;
@end

NS_ASSUME_NONNULL_END
