//
//  SDCityListRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"
#import "SDCityModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDCityListRequest : SDBSRequest

@property (nonatomic, strong) NSArray *cityList;
@property (nonatomic, strong) NSArray *provincesList;
@end

NS_ASSUME_NONNULL_END
