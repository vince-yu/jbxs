//
//  SDSearchAddrCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/31.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDSearchAddrCell.h"

@interface SDSearchAddrCell ()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIView *lineView;

@end

@implementation SDSearchAddrCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor colorWithRGB:0x131413];
    titleLabel.text = @"天府新谷";
    titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:16];
    self.titleLabel = titleLabel;
    [self.contentView addSubview:titleLabel];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.textColor = [UIColor colorWithRGB:0x848488];
    addressLabel.text = @"天府新谷";
    addressLabel.font = [UIFont fontWithName:kSDPFMediumFont size:12];
    self.addressLabel = addressLabel;
    [self.contentView addSubview:addressLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:kSDSeparateLineClolor];
    self.lineView = lineView;
    [self.contentView addSubview:lineView];
}

- (void)setPoiModel:(AMapPOI *)poiModel {
    _poiModel = poiModel;
    self.titleLabel.text = _poiModel.name;
    NSString *address = [NSString stringWithFormat:@"%@%@%@%@%@",_poiModel.province, _poiModel.city, _poiModel.district, _poiModel.address, _poiModel.name];
    self.addressLabel.text = address;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(16);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(10);
        make.height.mas_equalTo(12);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.titleLabel);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

@end
