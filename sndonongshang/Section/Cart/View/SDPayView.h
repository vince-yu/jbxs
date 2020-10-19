//
//  SDPayView.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/11.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    SDPayTitleStyleMethod,
    SDPayTitleStyleSurePay,
} SDPayTitleStyle;

typedef void(^SDPayBlock)(void);
typedef void(^SDBackPayBlock)(void);

@interface SDPayTitleView : UIView
@property (nonatomic ,strong) UIButton *closeBtn;
@property (nonatomic ,strong) UIButton *backBtn;
- (instancetype)initWithFrame:(CGRect)frame type:(SDPayTitleStyle )type;
@end
@interface SDPayView : UIView
@property (nonatomic ,copy) SDPayBlock payBlock;
- (instancetype)initWithFrame:(CGRect)frame payAction:(SDPayBlock )block backAction:(SDBackPayBlock )backBlock;
- (void)show;
@end
@interface SDPayContentView : UIView
@property (nonatomic ,copy) SDPayBlock payBlock;
@property (nonatomic ,copy) SDBackPayBlock backBlock;
- (instancetype)initWithFrame:(CGRect)frame type:(SDPayTitleStyle )type;
@end
NS_ASSUME_NONNULL_END
