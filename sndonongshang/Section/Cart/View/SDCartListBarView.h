//
//  SDCartListBarView.h
//  sndonongshang
//
//  Created by SNQU on 2019/1/11.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CartPayBlock )(void);
typedef void(^CartAllChooseBlock )(BOOL selected);
typedef void(^CartShowFreightBlock )(BOOL hidden);


@interface SDCartListBarView : UIView
@property (nonatomic ,copy) CartPayBlock payBlock;
@property (nonatomic ,copy) CartAllChooseBlock chooseBlock;
@property (nonatomic ,copy) CartShowFreightBlock showFreightBlock;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@end

NS_ASSUME_NONNULL_END
