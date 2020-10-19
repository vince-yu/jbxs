//
//  SDMyEquityCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/15.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDMyEquityCell.h"

@interface SDMyEquityCell ()

@property (nonatomic, weak) UIImageView *avatarIV;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) YYLabel *proportionLabel;
@property (nonatomic, weak) YYLabel *incomeLabel;
@property (nonatomic, weak) UIView *lineView;



@end

@implementation SDMyEquityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    UIImageView *avatarIv = [[UIImageView alloc] init];
    avatarIv.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:avatarIv];
    self.avatarIV = avatarIv;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"用户8975757用户8975757用户8975757用户8975757";
    nameLabel.font = [UIFont fontWithName:kSDPFRegularFont size:12];
    if (iPhone5 || iPhone4) {
        nameLabel.font = [UIFont fontWithName:kSDPFRegularFont size:10];
    }
    nameLabel.textColor = [UIColor colorWithHexString:kSDSecondaryTextColor];
    self.nameLabel = nameLabel;
    [self.contentView addSubview:nameLabel];
    
    YYLabel *proportionLabel = [[YYLabel alloc] init];
    NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:@"佣金比例：7%"];
    text1.yy_font = [UIFont fontWithName:kSDPFRegularFont size:12];
    if (iPhone5 || iPhone4) {
        text1.yy_font = [UIFont fontWithName:kSDPFRegularFont size:10];
    }
    text1.yy_color = [UIColor colorWithHexString:kSDGreenTextColor];
    [text1 yy_setColor:[UIColor colorWithRGB:0x33333] range:NSMakeRange(0, 5)];
    proportionLabel.attributedText = text1;
    self.proportionLabel = proportionLabel;
    [self.contentView addSubview:proportionLabel];
    
    YYLabel *incomeLabel = [[YYLabel alloc] init];
    incomeLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    NSMutableAttributedString *text2 = [[NSMutableAttributedString alloc] initWithString:@"佣金收入：￥220000"];
    text2.yy_font = [UIFont fontWithName:kSDPFRegularFont size:12];
    if (iPhone5 || iPhone4) {
        text2.yy_font = [UIFont fontWithName:kSDPFRegularFont size:10];
    }
    text2.yy_color = [UIColor colorWithHexString:kSDGreenTextColor];
    text2.yy_lineBreakMode = NSLineBreakByTruncatingMiddle;
    [text2 yy_setColor:[UIColor colorWithRGB:0x33333] range:NSMakeRange(0, 5)];
    incomeLabel.attributedText = text2;
    self.incomeLabel = incomeLabel;
    [self.contentView addSubview:incomeLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:kSDSeparateLineClolor];
    self.lineView = lineView;
    [self.contentView addSubview:lineView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.avatarIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarIV.mas_right).mas_equalTo(13);
        make.centerY.mas_equalTo(self.contentView);
        make.width.mas_lessThanOrEqualTo(@80);
    }];
    
    if (iPhone5 || iPhone4) {
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.avatarIV.mas_right).mas_equalTo(13);
            make.centerY.mas_equalTo(self.contentView);
            make.width.mas_lessThanOrEqualTo(@80);
        }];
        
        [self.incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.right.mas_equalTo(-10);
            make.width.mas_lessThanOrEqualTo(@100);
        }];
        
        [self.proportionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.incomeLabel.mas_left).mas_equalTo(-10);
        }];
    }else {
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.avatarIV.mas_right).mas_equalTo(13);
            make.centerY.mas_equalTo(self.contentView);
            make.width.mas_lessThanOrEqualTo(@100);
        }];
        
        [self.incomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.right.mas_equalTo(-15);
            make.width.mas_lessThanOrEqualTo(@120);
        }];
        
        [self.proportionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.incomeLabel.mas_left).mas_equalTo(-20);
        }];
    }
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.right.and.bottom.mas_equalTo(0);
        make.left.mas_equalTo(self.avatarIV);
    }];
}

@end
