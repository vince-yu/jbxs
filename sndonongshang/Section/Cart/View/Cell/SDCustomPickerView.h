//
//  SDCustomPickerView.h
//  sndonongshang
//
//  Created by SNQU on 2019/2/19.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDCustomPickerView : UIView

@property (nonatomic ,copy) void (^selectedIndex)(NSInteger index);

- (void)setItems:(NSArray *)items title:(NSString *)title defaultStr:(NSString *)defaultStr;

- (void)show;
@end

NS_ASSUME_NONNULL_END
