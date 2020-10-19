//
//  SDSearchAddrCell.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/31.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDSearchAddrCell : UITableViewCell

@property (nonatomic, weak) UILabel *addressLabel;
@property (nonatomic, strong) AMapPOI *poiModel;

@end

NS_ASSUME_NONNULL_END
