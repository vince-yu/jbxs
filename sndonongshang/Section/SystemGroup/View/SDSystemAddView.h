//
//  SDSystemAddView.h
//  sndonongshang
//
//  Created by SNQU on 2019/2/15.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDGoodModel.h"
#import "SDGoodDetailModel.h"
#import "SDCartCalculateRequest.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDSystemAddView : UIView
@property (nonatomic ,strong)  SDGoodDetailModel *detailModel;
@property (nonatomic, strong) SDCartCalculateModel *moreModel;
@property (nonatomic ,copy) void(^pushToOderBlock)(NSUInteger num);
@property (nonatomic ,copy) void(^updateDetailModelBlock)(SDCartCalculateModel *moreModel);

- (void)showAnimation;
- (void)getGoodCalculateData;
@end

NS_ASSUME_NONNULL_END
