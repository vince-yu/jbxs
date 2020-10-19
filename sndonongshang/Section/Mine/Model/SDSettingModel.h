//
//  SDSettingModel.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/12.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDSettingModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *avatorUrl;
@property (nonatomic, assign, getter=isHiddenArrow) BOOL hiddenArrow;
@property (nonatomic, assign, getter=isValueChoose) BOOL valueChoose;
@property (nonatomic, assign, getter=isHiddenLine) BOOL hiddenLine;
@property (nonatomic, assign, getter=isShowAvator) BOOL showAvator;


@end

NS_ASSUME_NONNULL_END
