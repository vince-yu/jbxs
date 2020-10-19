//
//  SDLogisticsModel.h
//  sndonongshang
//
//  Created by SNQU on 2019/6/6.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SDLogisticsStatusStart = 0,
    SDLogisticsStatusProcess = 1,
    SDLogisticsStatusFinal = 2,
} SDLogisticsStatus;

NS_ASSUME_NONNULL_BEGIN

@interface SDLogisticsListModel : NSObject
@property (nonatomic ,copy) NSArray *list;
@property (nonatomic, copy) NSString *expressNo;
@property (nonatomic, copy) NSString *expressCom;
@end

@interface SDLogisticsModel : NSObject
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic ,assign) SDLogisticsStatus status;

@end

NS_ASSUME_NONNULL_END
