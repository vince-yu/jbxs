//
//  SDMineServiceView.h
//  sndonongshang
//
//  Created by SNQU on 2019/2/25.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDMineServiceView : UIView

/** 是否是团长 */
@property (nonatomic, assign, getter=isGrouper) BOOL grouper;

- (void)setupGrouperData;

@end

NS_ASSUME_NONNULL_END
