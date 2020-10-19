//
//  SDOrderDetailFooterView.h
//  sndonongshang
//
//  Created by SNQU on 2019/2/26.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDOrderDetailModel;
NS_ASSUME_NONNULL_BEGIN

@interface SDOrderDetailFooterView : UIView

@property (nonatomic, strong) SDOrderDetailModel *detailModel;

+ (instancetype)footerView:(SDOrderDetailModel *)detailModel;

@end

NS_ASSUME_NONNULL_END
