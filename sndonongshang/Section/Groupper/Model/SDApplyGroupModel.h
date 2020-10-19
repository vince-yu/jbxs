//
//  SDApplyGroupModel.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/14.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDApplyGroupModel : NSObject
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *telephone;
@property (nonatomic ,copy) NSString *address;
@property (nonatomic ,copy) NSString *city;
@end

NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN

@interface SDApplyGroupUIModel : NSObject
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *code;
@property (nonatomic ,copy) NSString *placeholder;
@property (nonatomic ,copy) NSString *value;
@property (nonatomic ,assign) BOOL canEdit;
@property (nonatomic ,assign) BOOL hiddenLine;
@end

NS_ASSUME_NONNULL_END
