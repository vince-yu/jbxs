//
//  SDCartOrderBarView.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/11.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCartOrderBarView.h"
#import "SDCartDataManager.h"

@interface SDCartOrderBarView ()
@property (weak, nonatomic) IBOutlet UILabel *saveLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIView *submitBg;

@end

@implementation SDCartOrderBarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSubmitBtnStatus:) name:kNotifiOderRepayCheck object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (IBAction)submitAction:(UIButton *)sender {
    [SDStaticsManager umEvent:kpurchase_order_btn];
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    if (self.submitBlock) {
        self.submitBlock();
    }
}
- (void)updateTotalPrice{
    SDCartOderModel *order = [SDCartDataManager sharedInstance].preOrderModel;
    if (order.amount.length) {
        self.priceLabel.text = [order.amount priceStr];
    }else{
        self.priceLabel.text = order.totalPrice.length ? [order.totalPrice priceStr]: @"0";
    }
    
    
    if (order.reducePrice.length && order.reducePrice.floatValue > 0) {
        self.saveLabel.hidden = NO;
        self.saveLabel.text = [NSString stringWithFormat:@"已优惠￥ %@",[[SDCartDataManager sharedInstance].preOrderModel.reducePrice priceStr]];
    }else{
        self.saveLabel.hidden = YES;
    }
    
}
- (void)updateSubmitBtnStatus:(NSNotification *)note{
    id object = [note object];
    BOOL status = [object boolValue];
    if (!status) {
        self.submitBtn.enabled = NO;
        self.submitBg.backgroundColor = [UIColor colorWithHexString:@"0xededed"];
    }else{
        self.submitBtn.enabled = YES;
        self.submitBg.backgroundColor = [UIColor colorWithHexString:kSDGreenTextColor];
    }
}
@end
