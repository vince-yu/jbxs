//
//  SDSegmentedControl.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/17.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "HMSegmentedControl.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SDSelectedSegmentIndexBlock)(NSInteger index);

static CGFloat const SegmentedControlH = 51.0;

@interface SDSegmentedControl : HMSegmentedControl

/** SegmentIndex 点击发生变化时调用 */
@property (nonatomic, copy) SDSelectedSegmentIndexBlock block;

@end

NS_ASSUME_NONNULL_END
