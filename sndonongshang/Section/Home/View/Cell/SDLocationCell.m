//
//  SDLocationCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/9.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDLocationCell.h"

@interface SDLocationCell ()

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *locationBtn;

@end

@implementation SDLocationCell

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
    
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locationBtn.titleLabel.font =[UIFont fontWithName:kSDPFBoldFont size:16];
    [locationBtn setTitle:@"重新定位" forState:UIControlStateNormal];
    [locationBtn setTitleColor:[UIColor colorWithHexString:kSDGreenTextColor] forState:UIControlStateNormal];
    self.locationBtn = locationBtn;
    [self.contentView addSubview:locationBtn];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(self.contentView.mas_height);
        make.width.mas_equalTo(self.contentView);
    }];
    
    [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.top.mas_equalTo(0);
        make.height.mas_equalTo(self.contentView);
        make.width.mas_equalTo(94);
    }];
}

@end
