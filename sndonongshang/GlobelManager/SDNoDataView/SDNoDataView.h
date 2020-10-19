//
//  SDNoDataView.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/13.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^loadClickBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface SDNoDataView : UIImageView

+ (instancetype)noDataViewWithTips:(NSString *)tips loadClickBlock:(loadClickBlock)block;

@property (nonatomic, assign) BOOL loadFail;


@end

NS_ASSUME_NONNULL_END
