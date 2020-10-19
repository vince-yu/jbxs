//
//  SDCartRepoListModel.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/31.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDCartRopoLocationModel : NSObject
@property (nonatomic ,copy) NSString *address;
@property (nonatomic ,copy) NSString *type;
@end


@interface SDCartRepoListModel : NSObject
@property (nonatomic ,copy) NSString *repoId;
@property (nonatomic ,copy) NSString *province;
@property (nonatomic ,copy) NSString *city;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *county;
@property (nonatomic ,strong) SDCartRopoLocationModel *location;
@property (nonatomic ,copy) NSString *address;
@property (nonatomic ,copy) NSString *phone;
@property (nonatomic ,copy) NSString *selected;
@property (nonatomic ,copy) NSString *distance;
@property (nonatomic ,copy) NSString *range;
@property (nonatomic ,copy) NSString *user;
@end

NS_ASSUME_NONNULL_END
