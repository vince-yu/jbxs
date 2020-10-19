//
//  SDCartOrderListView.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/11.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SDCartOrderListViewTypeNomal,
    SDCartOrderListViewTypeDelete,
} SDCartOrderListViewType;

@interface SDCartOrderListView : UIView
- (instancetype)initWithFrame:(CGRect)frame type:(SDCartOrderListViewType )type;
@property (nonatomic ,assign) SDCartOrderListViewType type;
- (void)show;
@end

NS_ASSUME_NONNULL_END
