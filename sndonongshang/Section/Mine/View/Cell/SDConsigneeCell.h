//
//  SDConsigneeCell.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/9.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^chooseSexBlock)(NSString *sex);

@interface SDConsigneeCell : UITableViewCell

@property (nonatomic, weak) UITextField *contentTextField;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) chooseSexBlock block;

@end

NS_ASSUME_NONNULL_END
