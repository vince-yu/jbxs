//
//  SDShareVeiw.h
//  sndonongshang
//
//  Created by SNQU on 2019/2/26.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^wxBlock)(void);
typedef void(^wxTimeLineBlock)(id _Nullable image);
typedef void(^qqBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface SDShareView : UIView
+ (void)showWithWxBlock:(wxBlock )wxBlock wxTimeLineBlock:(wxTimeLineBlock )wxTimeLineBlock qqBlock:(qqBlock )qqblock describe:(NSAttributedString *)str type:(SDShareType )type;
@end

NS_ASSUME_NONNULL_END
