//
//  SDGroupDetailFooterView.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/12.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDOrderDetailModel;
NS_ASSUME_NONNULL_BEGIN

@interface SDGroupDetailFooterView : UIView

@property (nonatomic, strong) SDOrderDetailModel *detailModel;

+ (instancetype)footerView:(SDOrderDetailModel *)detailModel;

@end

NS_ASSUME_NONNULL_END
