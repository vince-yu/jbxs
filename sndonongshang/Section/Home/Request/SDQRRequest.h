//
//  SDQRRequest.h
//  sndonongshang
//
//  Created by SNQU on 2019/5/28.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBSRequest.h"


@interface SDQRRequest : SDBSRequest
@property (nonatomic, assign) CGFloat width;
@property (nonatomic ,strong) UIImage *QRImage;
@end

