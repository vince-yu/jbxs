
//
//  SDAddressCityCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/30.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDAddressCityCell.h"

@interface SDAddressCityCell ()

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UIImageView *hookIv;



@end

@implementation SDAddressCityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = [UIColor colorWithRGB:0x131413];
    nameLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
    self.nameLabel = nameLabel;
    [self.contentView addSubview:nameLabel];
    
    UIImageView *hookIv = [[UIImageView alloc] init];
    hookIv.image = [UIImage imageNamed:@"pay_method_selected"];
    self.hookIv = hookIv;
    [self.contentView addSubview:hookIv];
}


- (void)setModel:(SDCityModel *)model {
    _model = model;
    self.nameLabel.text = _model.name;
    if (_model.isChoose) {
        self.hookIv.hidden = NO;
        self.nameLabel.textColor = [UIColor colorWithHexString:kSDGreenTextColor];
    }else {
        self.hookIv.hidden = YES;
        self.nameLabel.textColor = [UIColor colorWithRGB:0x131413];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.hookIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18, 12));
        make.left.mas_equalTo(self.nameLabel.mas_right).mas_equalTo(24);
        make.centerY.mas_equalTo(self.contentView);
    }];
}

@end
