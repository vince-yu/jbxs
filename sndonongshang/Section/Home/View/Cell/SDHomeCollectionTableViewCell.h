//
//  SDHomeCollectionTableViewCell.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/9.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HomeMoreBlock)();

NS_ASSUME_NONNULL_BEGIN

@interface SDHomeCollectionTableViewCell : UITableViewCell
@property (nonatomic ,copy) HomeMoreBlock moreBlock;
@end

NS_ASSUME_NONNULL_END
