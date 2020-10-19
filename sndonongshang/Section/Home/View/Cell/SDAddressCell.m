//
//  SDAddressCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/9.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDAddressCell.h"

@interface SDAddressCell ()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIView *lineView;

@end

@implementation SDAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"天府新谷10号楼";
    titleLabel.textColor = [UIColor colorWithHexString:kSDMainTextColor];
    titleLabel.font = [UIFont fontWithName:kSDPFBoldFont size:16];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:kSDSeparateLineClolor];
    self.lineView = lineView;
    [self.contentView addSubview:lineView];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(self.contentView.mas_height);
        make.width.mas_equalTo(self.contentView);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(0);
    }];
}

@end
