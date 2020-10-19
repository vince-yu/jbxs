//
//  SDRepoListTableView.h
//  sndonongshang
//
//  Created by SNQU on 2019/2/18.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBaseTableView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SDRepoSelectBlock)(void);

@interface SDRepoListTableView : SDBaseTableView
@property (nonatomic ,copy) SDRepoSelectBlock selectBlock;
@end

NS_ASSUME_NONNULL_END
