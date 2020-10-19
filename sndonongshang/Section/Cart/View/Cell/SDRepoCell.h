//
//  SDRepoCell.h
//  sndonongshang
//
//  Created by SNQU on 2019/2/18.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCartRepoListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDRepoCell : UITableViewCell
@property (nonatomic ,strong) SDCartRepoListModel *repoModel;
@end

NS_ASSUME_NONNULL_END
