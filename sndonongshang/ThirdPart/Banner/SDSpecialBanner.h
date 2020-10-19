//
//  SDSpecialBanner.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/26.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iCarousel/iCarousel.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SDSpecialBannerDelegate <NSObject>

- (void)selectIndex:(NSInteger )index;

@end

@interface SDSpecialBanner : UIView
- (instancetype)initWithFrame:(CGRect)frame withImageArray:(NSArray *)array;
@property (nonatomic ,weak) id <SDSpecialBannerDelegate> delegate;
@property (nonatomic ,strong) NSArray *imageArray;
@property (nonatomic ,assign) CGFloat bili;
@end

NS_ASSUME_NONNULL_END
