//
//  SDShareSaveView.h
//  sndonongshang
//
//  Created by SNQU on 2019/5/28.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDGoodDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDShareSaveView : UIView
@property (nonatomic ,strong) SDGoodDetailModel *model;
@property (nonatomic ,copy) void(^wxTimeLineShareBlck)(id image);
@end

NS_ASSUME_NONNULL_END
