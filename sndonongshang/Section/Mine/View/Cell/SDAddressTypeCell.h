//
//  SDAddressTypeCell.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/9.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^addrTypeBlock)(NSString *type);

@interface SDAddressTypeCell : UITableViewCell

/** 选中地址类型 */
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) addrTypeBlock block;


@end

NS_ASSUME_NONNULL_END
