//
//  SDHomeCollectionTableViewCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/9.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDHomeCollectionTableViewCell.h"
#import "SDGoodCollectionView.h"

@interface SDHomeCollectionTableViewCell ()
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UIView *titleView;
@property (nonatomic ,strong) UIView *lineView;
@property (nonatomic ,strong) SDGoodCollectionView *collectionView;
@property (nonatomic ,strong) UIButton *moreBtn;
@property (nonatomic ,strong) UIImageView *moreIcon;
@end

@implementation SDHomeCollectionTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}
- (void)initSubViews{
    [self.contentView addSubview:self.titleView];
    [self.contentView addSubview:self.collectionView];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(20);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom).offset(10);
        make.right.mas_equalTo(-20);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(148);
        make.bottom.mas_equalTo(-20);
    }];
    
    [self.titleView addSubview:self.lineView];
    [self.titleView addSubview:self.titleLabel];
    [self.titleView addSubview:self.moreBtn];
    [self.titleView addSubview:self.moreIcon];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(3);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(14);
        make.centerY.equalTo(self.titleView.mas_centerY);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-20);
        make.left.equalTo(self.lineView.mas_right).offset(10);
        make.height.mas_equalTo(148);
        make.centerY.mas_equalTo(self.lineView);
    }];
    [self.moreIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(5);
        make.height.mas_equalTo(9);
        make.centerY.equalTo(self.lineView.mas_centerY);
    }];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moreIcon.mas_left).offset(-6);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(13);
        make.centerY.equalTo(self.lineView.mas_centerY);
    }];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark init view
- (SDGoodCollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //最小行间距(默认为10)
        flowLayout.minimumLineSpacing = 10;
        //最小item间距（默认为10）
        flowLayout.minimumInteritemSpacing = 10;
        //设置senction的内边距
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //设置UICollectionView的滑动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //sectionHeader的大小,如果是竖向滚动，只需设置Y值。如果是横向，只需设置X值。
        flowLayout.headerReferenceSize = CGSizeMake(0,0);
        flowLayout.footerReferenceSize = CGSizeMake(0,0);
        _collectionView = [[SDGoodCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x131413"];
        _titleLabel.font = [UIFont fontWithName:kSDPFBoldFont size:16];
        _titleLabel.text = @"拼团享优惠";
    }
    return _titleLabel;
}
- (UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _titleView;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithRed:22/255.0 green:188/255.0 blue:46/255.0 alpha:1.0];
    }
    return _lineView;
}
- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:[UIColor colorWithHexString:kSDGrayTextColor] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
        _moreBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:13];
    }
    return _moreBtn;
}
- (UIImageView *)moreIcon{
    if (!_moreIcon) {
        _moreIcon = [[UIImageView alloc] init];
        _moreIcon.image = [UIImage imageNamed:@"cart_select_time"];
    }
    return _moreIcon;
}
- (void)moreAction{
    if (self.moreBlock) {
        self.moreBlock();
    }
}
@end
