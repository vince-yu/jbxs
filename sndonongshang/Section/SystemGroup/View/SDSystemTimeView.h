//
//  SDSystemTimeView.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/26.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SDSystemTimeViewDelegate<NSObject>

- (void)startTimeToEndTime;

@end

@interface SDSystemTimeView : UIView
@property (nonatomic ,assign) BOOL isBegin;
@property (nonatomic ,assign) BOOL isEnded;
@property (nonatomic ,weak) id<SDSystemTimeViewDelegate> delegate;
- (void)setStartTime:(NSString *)startTime endTime:(NSString *)endTime;
- (void)fire;
- (void)cancel;
@end

NS_ASSUME_NONNULL_END
