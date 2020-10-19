//
//  SDGroupDetailHeaderView.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/12.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDOrderDetailModel;
NS_ASSUME_NONNULL_BEGIN

@interface SDGroupDetailHeaderView : UIView

@property (nonatomic, strong) SDOrderDetailModel *detailModel;
@property (nonatomic ,assign) SDUserRolerType rolerType;
+ (instancetype)headerView:(SDOrderDetailModel *)detailModel rolerType:(SDUserRolerType )rolerType;
- (void)updateStatusLabelText:(NSString *)status;
@end

NS_ASSUME_NONNULL_END
