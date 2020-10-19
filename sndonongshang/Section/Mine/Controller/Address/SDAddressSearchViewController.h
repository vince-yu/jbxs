//
//  SDAddressSearchViewController.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/31.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBaseViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ChooseAddrBlock)(AMapPOI *poi, NSString *address);

@interface SDAddressSearchViewController : SDBaseViewController

@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, strong) NSArray *cityArr;
@property (nonatomic, copy) ChooseAddrBlock block;

@end

NS_ASSUME_NONNULL_END
