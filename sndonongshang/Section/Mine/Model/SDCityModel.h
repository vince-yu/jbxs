//
//  SDCityModel.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDCityModel : SDBSRequest

@property (nonatomic, copy) NSString *areaId;
@property (nonatomic, assign) int level;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int pid;
@property (nonatomic, strong) NSArray *citys;

/** 额外 是否被选中 */
@property (nonatomic, assign, getter=isChoose) BOOL choose;


@end

NS_ASSUME_NONNULL_END
