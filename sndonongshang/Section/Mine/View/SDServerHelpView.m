//
//  SDServerHelpView.m
//  sndonongshang
//
//  Created by SNQU on 2019/5/29.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDServerHelpView.h"

@interface SDServerHelpView ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *callABtn;
@property (weak, nonatomic) IBOutlet UIButton *cyBtn;

@end

@implementation SDServerHelpView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.contentView.clipsToBounds = YES;
    self.contentView.layer.cornerRadius = 10.0;
    self.cyBtn.layer.cornerRadius = 18.0;
    self.callABtn.layer.cornerRadius = 18.0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.bgView addGestureRecognizer:tap];
    self.bgView.userInteractionEnabled = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)copyActin:(id)sender {
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    
    pastboard.string = @"jbxs001";
    [SDToastView HUDWithString:@"微信复制成功，快去添加好友吧～"];
}
- (IBAction)callAction:(id)sender {
    [SDStaticsManager umEvent:kme_service];
    [SDToastView show];
    NSString *telephoneNumber = @"4009697709";
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",telephoneNumber];
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:str];
    if (@available(iOS 11.0, *)) {
        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
            [SDToastView dismiss];
        }];
    } else {
        [application openURL:URL];
        [SDToastView dismiss];
    }
}
+ (void)show{
    SDServerHelpView *helpView = [[[NSBundle mainBundle] loadNibNamed:@"SDServerHelpView" owner:nil options:nil] firstObject];
    
    [[UIApplication sharedApplication].keyWindow addSubview:helpView];
    [helpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(@0);
    }];
}
- (void)tapAction{
    [self removeFromSuperview];
}
@end
