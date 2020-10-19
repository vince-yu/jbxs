//
//  SDCartOrderBarView.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/11.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SDOrderSubmitBlock)();

@interface SDCartOrderBarView : UIView
@property (nonatomic ,strong) SDOrderSubmitBlock submitBlock;
- (void)updateTotalPrice;
@end

NS_ASSUME_NONNULL_END
