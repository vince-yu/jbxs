//
//  SDPopView.h
//  sndonongshang
//
//  Created by SNQU on 2019/2/1.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^popCancelBlock)(void);
typedef void(^popConfirmBlock)(void);

@interface SDPopView : UIView

+ (instancetype)showPopViewWithContent:(NSString *)content noTap:(BOOL )noTap confirmBlock:(popConfirmBlock)confirmBlock cancelBlock:(popCancelBlock)cancelBlock;
@property (nonatomic, assign) BOOL noTap;
@property (nonatomic, weak) UIButton *confirmBtn;
@property (nonatomic, weak) UIButton *cancelBtn;

- (void)showSelf;
- (void)hideSelf;
@end

NS_ASSUME_NONNULL_END
