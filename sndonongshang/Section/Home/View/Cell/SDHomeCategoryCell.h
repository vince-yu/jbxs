//
//  SDHomeCategoryCell.h
//  sndonongshang
//
//  Created by SNQU on 2019/4/18.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CategoryBlock)(id model);

@interface SDHomeCategoryCell : UITableViewCell
@property (nonatomic ,copy) CategoryBlock clickCategoryBlock;
- (void)initCateGoryViewWithDataArray:(NSArray *)dataArray;
@end

NS_ASSUME_NONNULL_END
