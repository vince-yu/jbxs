//
//  SDGoodRecommedCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/4.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGoodRecommedCell.h"
#import "SDGoodCollectionView.h"

@interface SDGoodRecommedCell ()
@property (nonatomic ,strong) SDGoodCollectionView *collectionView;


@property (nonatomic ,strong) UIView *lineView;
@property (nonatomic ,strong) UILabel *recommendLabel;
@end

@implementation SDGoodRecommedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.recommendLabel];
    [self.contentView addSubview:self.collectionView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(26);
        make.width.mas_equalTo(4);
        make.height.mas_equalTo(15);
    }];
    
    [self.recommendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right).offset(7);
        make.centerY.equalTo(self.lineView);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(60);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(100);
    }];
    
}
- (SDGoodCollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 20;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[SDGoodCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:kSDGreenTextColor];
    }
    return _lineView;
}
- (UILabel *)recommendLabel{
    if (!_recommendLabel) {
        _recommendLabel = [[UILabel alloc] init];
        _recommendLabel.font = [UIFont fontWithName:kSDPFMediumFont size:15];
        _recommendLabel.textColor = [UIColor colorWithHexString:@"0x131413"];
        _recommendLabel.text = @"为你推荐";
    }
    return _recommendLabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    self.collectionView.dataArray = _dataArray;
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.collectionView.height);
    }];
}
@end
