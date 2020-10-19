//
//  SDSystemRuleCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/26.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDSystemRuleCell.h"

@interface SDSystemRuleCell ()
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ruleImageView;

@end

@implementation SDSystemRuleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.describeLabel addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight withRadii:CGSizeMake(10, 10) viewRect:CGRectMake(0,0,SCREEN_WIDTH - 32, 20)];
}
- (void)setRuleArray:(NSArray *)ruleArray{
    _ruleArray = ruleArray;
    if (_ruleArray.count) {
        self.ruleImageView.hidden = NO;
        self.ruleImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.ruleImageView.backgroundColor = [UIColor colorWithRed:244/ 255.0 green:245 / 255.0 blue:244/ 255.0 alpha:1];
        NSURL *url = [NSURL URLWithString:ruleArray.firstObject];
//        url = [NSURL URLWithString:@"http"];
        [self.ruleImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"head_placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                self.ruleImageView.contentMode = UIViewContentModeScaleToFill;
                self.ruleImageView.backgroundColor = [UIColor clearColor];
                CGFloat height = image.size.height * SCREEN_WIDTH / image.size.width;
                [self.ruleImageView layoutIfNeeded];
                [self.ruleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(height);
                }];
            }
        }];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
