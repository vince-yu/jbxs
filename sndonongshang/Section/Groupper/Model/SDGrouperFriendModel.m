//
//  SDGrouperFriendModel.m
//  sndonongshang
//
//  Created by SNQU on 2019/6/5.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGrouperFriendModel.h"

@implementation SDGrouperFriendListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"list":@"SDGrouperFriendModel"};
}

@end

@implementation SDGrouperFriendModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"friendId":@"_id"};
}
@end
