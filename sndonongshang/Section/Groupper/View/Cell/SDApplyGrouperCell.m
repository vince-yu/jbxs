//
//  SDAppalyGrouperCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/14.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDApplyGrouperCell.h"


@interface SDApplyGrouperCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;


@end

@implementation SDApplyGrouperCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView addSubview:self.chooseAddrBtn];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(SDApplyGroupUIModel *)model{
    _model = model;
    self.contentTextField.text = model.value;
    self.titleLabel.text = model.title;
    self.contentTextField.placeholder = model.placeholder;
    self.contentTextField.enabled = model.canEdit;
    self.lineView.hidden = model.hiddenLine;
    self.chooseAddrBtn.hidden = [model.title isEqualToString:@"选择地址:"] ? NO : YES;
    if (!self.contentTextField.enabled) {
        self.contentTextField.textColor = [UIColor colorWithHexString:kSDGreenTextColor];
    }else{
        self.contentTextField.textColor = [UIColor colorWithHexString:kSDMainTextColor];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.chooseAddrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.and.bottom.mas_equalTo(0);
    }];
}

#pragma mark - lazy
- (SDArrowButton *)chooseAddrBtn {
    if (!_chooseAddrBtn) {
        _chooseAddrBtn = [SDArrowButton buttonWithType:UIButtonTypeCustom];
        [_chooseAddrBtn setTitle:@"选择收货地址" forState:UIControlStateNormal];
        _chooseAddrBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:12];
        [_chooseAddrBtn setTitleColor:[UIColor colorWithHexString:kSDGrayTextColor] forState:UIControlStateNormal];
        _chooseAddrBtn.userInteractionEnabled = NO;
    }
    return _chooseAddrBtn;
}
@end
