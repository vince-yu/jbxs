//
//  SDChooseCityPopView.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ChooseCityBlock)(NSString *province, NSString *city);

@interface SDChooseCityPopView : UIView

+ (instancetype)showPopViewWithCitys:(NSArray *)cityArr confirmBlock:(ChooseCityBlock)block;

@end

NS_ASSUME_NONNULL_END
