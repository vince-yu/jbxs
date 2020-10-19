//
//  SDAmoyMoneyCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/16.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDAmoyMoneyCell.h"

@interface SDAmoyMoneyCell ()

@property (nonatomic, weak) UILabel *dateLabel;
@property (nonatomic, weak) UILabel *amountLabel;
@property (nonatomic, weak) UIView *lineView;

@end

@implementation SDAmoyMoneyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.text = @"2018年10月";
    dateLabel.font = [UIFont fontWithName:kSDPFMediumFont size:16];
    dateLabel.textColor = [UIColor colorWithRGB:0x131413];
    [self.contentView addSubview:dateLabel];
    self.dateLabel = dateLabel;
    
    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.text = @"￥325.24";
    amountLabel.font = [UIFont fontWithName:kSDPFMediumFont size:16];
    amountLabel.textColor = [UIColor colorWithHexString:kSDGreenTextColor];
    [self.contentView addSubview:amountLabel];
    self.amountLabel = amountLabel ;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:kSDSeparateLineClolor];
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.width.mas_lessThanOrEqualTo(@(SCREEN_WIDTH * 0.5));
    }];
}

@end
