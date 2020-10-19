//
//  SDAlterView.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/11.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDAlterView.h"
@interface SDAlterView ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@end

@implementation SDAlterView
- (instancetype)initWithFrame:(CGRect)frame withType:(SDAlterViewStyle )type
{
//    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"SDAlterView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        [self reloadViewWithType:type];
        self.backgroundColor = [UIColor clearColor];
        self.leftBtn.layer.cornerRadius = 20;
        self.rightBtn.layer.cornerRadius = 20;
        self.rightBtn.layer.borderColor = [UIColor colorWithHexString:kSDGreenTextColor].CGColor;
        self.rightBtn.layer.borderWidth = 1.0;
    }
    return self;
}
- (void)reloadViewWithType:(SDAlterViewStyle )type{
    if (type == SDAlterViewStylePaySuccess) {
        [self.iconImageView setImage:[UIImage imageNamed:@"pay_successe"]];
        self.titleLabel.text = @"订单支付成功";
        self.titleLabel.textColor = [UIColor colorWithHexString:kSDGreenTextColor];
        self.describeLabel.text = @"实付：¥46.50";
        [self.leftBtn setTitle:@"查看订单" forState:UIControlStateNormal];
        [self.rightBtn setTitle:@"回到首页" forState:UIControlStateNormal];
    }else if (type == SDAlterViewStylePayFailed){
        [self.iconImageView setImage:[UIImage imageNamed:@"pay_failed"]];
        self.titleLabel.text = @"订单支付失败";
        self.titleLabel.textColor = [UIColor colorWithHexString:@"0xF8615F"];
        self.describeLabel.text = @"实付：¥46.50";
        [self.leftBtn setTitle:@"查看订单" forState:UIControlStateNormal];
        [self.rightBtn setTitle:@"回到首页" forState:UIControlStateNormal];
    }else{
    }
}
- (IBAction)leftBtnAction:(id)sender {
    [self removeFromSuperview];
}
- (IBAction)rightBtnAction:(id)sender {
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(window);
    }];
}
@end

@interface SDGroupBuyAlterView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;
@property (weak, nonatomic) IBOutlet UIImageView *grouperImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation SDGroupBuyAlterView



@end

