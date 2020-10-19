//
//  SDCartOderSegementView.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/11.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CartOrderSegLeftBlock)(void);
typedef void(^CartOrderSegRightBlock)(void);

@interface SDCartOderSegementView : UIView
@property (nonatomic ,assign) SDCartOrderType type;
@property (nonatomic ,copy) CartOrderSegLeftBlock leftBlock;
@property (nonatomic ,copy) CartOrderSegRightBlock rightBlock;
@property (nonatomic ,copy) void (^failedRefreshBlock)(id model);
@end

NS_ASSUME_NONNULL_END
