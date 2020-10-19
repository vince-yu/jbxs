//
//  SDAppalyGrouperCell.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/14.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDApplyGroupModel.h"
#import "SDArrowButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDApplyGrouperCell : UITableViewCell

@property (nonatomic ,strong) SDApplyGroupUIModel *model;
@property (strong, nonatomic) SDArrowButton *chooseAddrBtn;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;

@end

NS_ASSUME_NONNULL_END
