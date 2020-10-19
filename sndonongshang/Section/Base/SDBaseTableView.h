//
//  SDBaseTableView.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDBaseTableView : UITableView
@property (nonatomic ,assign)CGFloat sectionHeaderHeight;
@property (nonatomic ,assign) BOOL refresTime;
@property (nonatomic ,strong) NSMutableDictionary *cellHightDict;
- (void)addMJRefresh;
- (void)addMJMoreFoot;
- (void)refreshAction;
- (void)loadMoreAction;
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
