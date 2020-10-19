//
//  SDGoodCollectionView.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/9.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectGodBlock)();

@interface SDGoodCollectionView : UICollectionView
@property (nonatomic ,strong) NSArray *dataArray;
@property (nonatomic ,copy)SelectGodBlock selectBlock;
@end

NS_ASSUME_NONNULL_END
