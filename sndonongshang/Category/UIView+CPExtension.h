//
//  UIView+Extension.h
//  CPPlyaer
//
//  Created by SNQU on 2018/12/6.
//  Copyright © 2018 CPCoder. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CPExtension)

@property (assign, nonatomic) CGFloat cp_x;
@property (assign, nonatomic) CGFloat cp_y;
@property (assign, nonatomic) CGFloat cp_w;
@property (assign, nonatomic) CGFloat cp_h;
@property (assign, nonatomic) CGSize cp_size;
@property (assign, nonatomic) CGPoint cp_origin;
    
@end

NS_ASSUME_NONNULL_END
