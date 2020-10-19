//
//  SDGoodHeadCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/10.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGoodHeadCell.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "SDGoodDetailHeadView.h"

@interface SDGoodHeadCell ()<SDCycleScrollViewDelegate>
@property (nonatomic ,strong) SDCycleScrollView *srollerView;
@property (nonatomic ,strong) SDGoodDetailHeadView *detailView;
@property (nonatomic ,strong) UIView *noteView;
@property (nonatomic ,strong) UILabel *noteLabel;
@end

@implementation SDGoodHeadCell

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
    [self.contentView addSubview:self.srollerView];
    [self.contentView addSubview:self.detailView];
    self.contentView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:247/255.0 alpha:1];
    
    [self.srollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(self.srollerView.mas_width).multipliedBy(3.0/4);
    }];
    
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.srollerView.mas_bottom).offset(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(138);
        make.bottom.mas_equalTo(0);
        
    }];
    [self.srollerView addSubview:self.noteView];
    [self.srollerView addSubview:self.noteLabel];
    [self.noteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(18);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-10);
    }];
    [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(25);
        make.height.mas_equalTo(18);
        make.center.equalTo(self.noteView);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (SDCycleScrollView *)srollerView{
    if (!_srollerView) {
        _srollerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"head_placeholder"]];
        _srollerView.infiniteLoop = YES;
        _srollerView.autoScroll = YES;
        _srollerView.autoScrollTimeInterval = 3;
        _srollerView.hidesForSinglePage = YES;
        _srollerView.showPageControl = NO;
        _srollerView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        _srollerView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:247/255.0 alpha:1];
    }
    return _srollerView;
}
- (UIView *)detailView{
    if (!_detailView) {
        _detailView = [[[NSBundle mainBundle] loadNibNamed:@"SDGoodDetailHeadView" owner:nil options:nil] firstObject];
    }
    return _detailView;
}
- (void)setType:(SDGoodDetailType)type{
    _type = type;
    _detailView.type = _type;
    [_detailView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(125);
    }];
}
- (void)setDetailModel:(SDGoodDetailModel *)detailModel{
    _detailModel = detailModel;
    [self layoutIfNeeded];
    _detailView.detailModel = _detailModel;
    [self.detailView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.detailView.height + 20);
    }];
    _srollerView.imageURLStringsGroup = _detailModel.banner;
    if (self.detailModel.banner.count) {
        self.noteView.hidden = NO;
        self.noteLabel.text = [NSString stringWithFormat:@"%d/%ld",1,self.detailModel.banner.count];
    }else{
        self.noteView.hidden = YES;
    }
    
}
- (UIView *)noteView{
    if (!_noteView) {
        _noteView = [[UIView alloc] init];
        _noteView.layer.cornerRadius = 9.0;
        _noteView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
    }
    return _noteView;
}
- (UILabel *)noteLabel{
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.textColor = [UIColor whiteColor];
        _noteLabel.font = [UIFont fontWithName:kSDPFMediumFont size:11];
        _noteLabel.textAlignment = NSTextAlignmentCenter;
        //        _noteLabel.text = @"2/5";
    }
    return _noteLabel;
}
#pragma mark CycleViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    self.noteLabel.text = [NSString stringWithFormat:@"%ld/%ld",index + 1,self.detailModel.banner.count];
//    [self.noteLabel sizeToFit];
}
@end
