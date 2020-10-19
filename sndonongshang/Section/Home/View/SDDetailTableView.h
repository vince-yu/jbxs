//
//  SDDetailTableView.h
//  sndonongshang
//
//  Created by SNQU on 2019/3/26.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBaseTableView.h"
#import "SDGoodDetailModel.h"
#import "SDCartCalculateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDDetailTableView : SDBaseTableView
@property (nonatomic ,strong) NSString *status;
@property (nonatomic, assign, getter=isLoadFail) BOOL loadFail;
@property (nonatomic ,strong) SDGoodDetailModel *detailModel;
@property (nonatomic ,copy) void(^hiddeBarBlock)(BOOL hidden);
@property (nonatomic ,copy) void(^updateBlock)(NSString *status,BOOL isBegin);
@property (nonatomic ,copy) void(^CartCalculateBlock)(SDGoodDetailModel *detailModel);
- (void)loadImages;

- (void)refreshActionWithHiddenToast:(BOOL)hidden;



- (UITableViewCell *)handleTitleCellWithIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)handleBannerCellWithIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
