//
//  SDOderSelfTakeCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/6.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDOderSelfTakeCell.h"
#import "SDCartDataManager.h"

@interface SDOderSelfTakeCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *personLabel;
@property (weak, nonatomic) IBOutlet UILabel *teLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneLabel;

@end

@implementation SDOderSelfTakeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.backgroundView = nil;
    self.contentView.backgroundColor  = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 10;
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-10);
    }];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"手机号码 *"];
    [str addAttributes:@{NSFontAttributeName: [UIFont fontWithName:kSDPFMediumFont size: 16], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"0x131413"]} range:NSMakeRange(0, 4)];
    [str addAttributes:@{NSFontAttributeName: [UIFont fontWithName:kSDPFMediumFont size: 12], NSForegroundColorAttributeName: [UIColor colorWithHexString:@"0xF8665A"]} range:NSMakeRange(4, 2)];
    self.teLabel.attributedText = str;
    self.nameLabel.delegate = self;
    self.phoneLabel.delegate = self;
    self.phoneLabel.keyboardType = UIKeyboardTypeNumberPad;
    
//    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:kOderSelfTakePerson];
//    NSString *mobil = [[NSUserDefaults standardUserDefaults] objectForKey:kOderSelfTakePhone];
//
//    if (name.length) {
//        self.nameLabel.text = name;
//        [SDCartDataManager sharedInstance].prepayModel.receiver = name;
//    }
//    if (mobil.length) {
//        self.phoneLabel.text = mobil;
//        [SDCartDataManager sharedInstance].prepayModel.mobile = mobil;
//    }
//    [SDCartDataManager checkPrePayData];
    [self.nameLabel addTarget:self action:@selector(textLengthChange:) forControlEvents:UIControlEventEditingChanged];
}
- (void)setOrderModel:(SDCartOderModel *)orderModel{
    if ([SDCartDataManager sharedInstance].prepayModel.receiver != nil && [SDCartDataManager sharedInstance].prepayModel.mobile != nil) {
//        self.phoneLabel.text = [SDUserModel sharedInstance].mobile;
//        [SDCartDataManager sharedInstance].prepayModel.mobile = [SDUserModel sharedInstance].mobile;
//        [SDCartDataManager checkPrePayData];
        return;
    }
    _orderModel = orderModel;
    NSString *name = _orderModel.receiver;
    NSString *mobil = _orderModel.lastReceiverMobile;

    if (name.length) {
        self.nameLabel.text = name;
        [SDCartDataManager sharedInstance].prepayModel.receiver = name;
    }
    if (mobil.length) {
        self.phoneLabel.text = mobil;
        [SDCartDataManager sharedInstance].prepayModel.mobile = mobil;
    }else{
        self.phoneLabel.text = [SDUserModel sharedInstance].mobile;
        [SDCartDataManager sharedInstance].prepayModel.mobile = [SDUserModel sharedInstance].mobile;
    }
    [SDCartDataManager checkPrePayData];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isEqual:self.nameLabel]) {
        NSInteger length = [textField.text getLengthWithChinese];
        if ((length > 20) || (length > 0 && [textField.text hasIllegalCharacter])) {
            [SDToastView HUDWithString:@"提货人姓名填写错误，请输入20个以下的汉字、数字和英文"];
        }
        [SDCartDataManager sharedInstance].prepayModel.receiver = textField.text;
    }else{
        if (![textField.text isPhoneNumber]) {
            [SDToastView HUDWithString:@"请输入11位手机号码"];
        }
        [SDCartDataManager sharedInstance].prepayModel.mobile = textField.text;
        
    
    }
    [SDCartDataManager checkPrePayData];
}
- (BOOL )textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL )textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}
- (void)textLengthChange:(UITextField *)textField{
    if (!textField) return;
    
    NSUInteger maxLength = 20;
    NSString *contentText = textField.text;
    UITextRange *selectedRange = [textField markedTextRange];
    NSInteger markedTextLength = [textField offsetFromPosition:selectedRange.start toPosition:selectedRange.end];
    if (markedTextLength == 0) {
//        NSInteger length = [contentText getLengthWithChinese];
        NSInteger length = contentText.length;
        if (length > maxLength || (length > 0 && [textField.text hasIllegalCharacter])){
            [SDToastView HUDWithString:@"提货人姓名填写错误，请输入20个以下的汉字、数字和英文"];
            NSRange needRange = NSMakeRange(0, length > maxLength ? maxLength : length);
            textField.text = [contentText substringWithRange:needRange];
        }
        [SDCartDataManager sharedInstance].prepayModel.receiver = textField.text;
        [SDCartDataManager checkPrePayData];
    }
}

@end
    
