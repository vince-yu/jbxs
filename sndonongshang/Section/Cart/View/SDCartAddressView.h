//
//  SDCartAddressView.h
//  sndonongshang
//
//  Created by SNQU on 2019/2/18.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDCartAddressView : UIView
@property (nonatomic ,copy) void(^newAddressBlock)(void);
@property (nonatomic ,copy) void(^repolistBlock)(void);
- (void)updateAddressType:(SDCartOrderType )type;
@end

NS_ASSUME_NONNULL_END
