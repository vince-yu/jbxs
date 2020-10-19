//
//  SDGoodDetailCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/10.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGoodDetailCell.h"
@interface SDGoodDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end



@implementation SDGoodDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setDetailDic:(NSDictionary *)detailDic{
    _detailDic = detailDic;
    for (UILabel *label in self.contentView.subviews) {
        if (label != self.titleLabel && [label isKindOfClass:[UILabel class]]) {
            [label removeFromSuperview];
        }
    }
    [self.contentView layoutIfNeeded];
    CGFloat firstOffset = 58;
    CGFloat itemOffset = 15;
    CGFloat itemHeight = 16;
    for (int i = 0 ; i < self.detailDic.count ; i ++) {
        NSString *key = [self.detailDic.allKeys objectAtIndex:i];
        NSString *value = [self.detailDic objectForKey:key];
        if (![key isKindOfClass:[NSString class]] || ![value isKindOfClass:[NSString class]] || !key.length || !value.length) {
            continue;
        }
        UILabel *label = [[UILabel alloc] init];
        
        label.attributedText = [NSString getGoodDetailAtrr:key content:value];
        
        
        [self.contentView addSubview:label];
        
        if (i == self.detailDic.count - 1) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(16);
                make.right.mas_equalTo(-16);
                make.height.mas_equalTo(14);
                make.top.mas_equalTo(firstOffset + i *(itemHeight + itemOffset));
                make.bottom.mas_equalTo(-20);
            }];
        }else{
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(16);
                make.right.mas_equalTo(-16);
                make.height.mas_equalTo(14);
                make.top.mas_equalTo(firstOffset + i *(itemHeight + itemOffset));
            }];
        }
    }
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
