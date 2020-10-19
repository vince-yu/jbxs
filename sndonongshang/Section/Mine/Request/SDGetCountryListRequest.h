//
//  SDGetCountryListRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/28.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"
#import "SDCountryModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SDGetCountryListRequest : SDBSRequest

@property (nonatomic, strong) NSArray *countryArr;

@end

NS_ASSUME_NONNULL_END
