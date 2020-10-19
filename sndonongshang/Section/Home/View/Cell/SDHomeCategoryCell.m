//
//  SDHomeCategoryCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/4/18.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDHomeCategoryCell.h"
#import "SDHomeCategroyModel.h"
#import "SDHomeDataManager.h"

@interface SDHomeCategoryCell ()
@property (nonatomic ,strong) UIView *categoryView;
@end

static CGFloat const itemHeight = 85;
static CGFloat const itemWith = 40;

@implementation SDHomeCategoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.categoryView];
    }
    return self;
}
- (void)initCateGoryViewWithDataArray:(NSArray *)dataArray{
    for (UIView *view in self.categoryView.subviews) {
        [view removeFromSuperview];
    }
//    if (!dataArray.count) {
//        [self.bannerView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.mas_equalTo(10);
//            make.right.mas_equalTo(-10);
//            make.width.mas_equalTo(SCREEN_WIDTH);
//            make.height.mas_equalTo(self.bannerView.mas_width).multipliedBy(9/25.0);
//            make.bottom.equalTo(self.contentView).offset(0);
//        }];
//        return;
//    }
    NSInteger maxCount = 5;
    NSInteger count = dataArray.count;
    if (count == 0) {
        return;
    }
    switch (count) {
        case 6:
            maxCount = 3;
            break;
        case 8:
            maxCount = 4;
            break;
        case 7:
            maxCount = 4;
            break;
        default:
            break;
    }
    
    if (count < maxCount) {
        maxCount = count;
    }
    CGFloat interval = (SCREEN_WIDTH - 40 ) / maxCount;
    if (count > maxCount) {
        CGFloat height = itemHeight * 2;
        [self.categoryView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(height);
            make.bottom.mas_equalTo(0).priorityHigh();
            
        }];
    }else{
        CGFloat height = itemHeight;
        [self.categoryView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(height);
            make.bottom.mas_equalTo(0).priorityHigh();
            
        }];
    }
    
    //    if (!count) {
    //        return;
    //    }
    for (NSInteger i = 0 ; i < count ; i ++) {
        if (i >= maxCount * 2) {
            return;
        }
        SDHomeCategroyModel *model = [dataArray objectAtIndex:i];
        UIButton *itemView = [UIButton buttonWithType:UIButtonTypeCustom];
        [itemView addTarget:self action:@selector(categoryClick:) forControlEvents:UIControlEventTouchUpInside];
        itemView.tag = 12000 + i;
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"list_placeholder"]];
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = [UIColor colorWithHexString:@"0x848487"];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont fontWithName:kSDPFMediumFont size:12];
        nameLabel.text = model.name;
        [nameLabel sizeToFit];
        
        [self.categoryView addSubview:itemView];
        [itemView addSubview:imageView];
        [itemView addSubview:nameLabel];
        
        if (i >= maxCount && i < maxCount * 2) {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(20 + (i - maxCount)*interval + (interval - itemWith) / 2.0);
                make.top.bottom.mas_equalTo(itemHeight);
                make.height.mas_equalTo(itemHeight);
                make.width.mas_equalTo(itemWith);
            }];
        }else if (i < maxCount){
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(20 + i*interval + (interval - itemWith) / 2.0);
                make.top.bottom.mas_equalTo(0);
                make.height.mas_equalTo(itemHeight);
                make.width.mas_equalTo(itemWith);
            }];
        }else{
            
        }
        
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(14);
            make.centerX.equalTo(itemView.mas_centerX);
        }];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.width.mas_equalTo(60);
            make.height.mas_equalTo(12);
            make.top.equalTo(imageView.mas_bottom).offset(9);
            make.centerX.equalTo(itemView.mas_centerX);
        }];
        
        
    }
    
}
- (UIView *)categoryView{
    if (!_categoryView) {
        _categoryView = [[UIView alloc] init];
    }
    return _categoryView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)categoryClick:(UIButton *)btn{
    if (self.clickCategoryBlock) {
        NSArray *array = [SDHomeDataManager sharedInstance].categoryArray;
        self.clickCategoryBlock(array[btn.tag - 12000]);
    }
}
@end
