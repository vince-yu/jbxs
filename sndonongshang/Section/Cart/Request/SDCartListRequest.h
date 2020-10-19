//
//  SDCartListRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"
#import "SDCartListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDCartListRequest : SDBSRequest
@property (nonatomic ,strong) SDCartListModel *cartModel;
@end

NS_ASSUME_NONNULL_END
