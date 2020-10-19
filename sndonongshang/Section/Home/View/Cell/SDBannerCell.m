//
//  SDBannerCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/5.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDBannerCell.h"
#import <SDCycleScrollView/SDCycleScrollView.h>

@interface SDBannerCell ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (nonatomic ,strong) SDCycleScrollView *srollerView;
@property (nonatomic ,strong) UIView *noteView;
@property (nonatomic ,strong) UILabel *noteLabel;
@end


@implementation SDBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.bannerView addSubview:self.srollerView];
    [self.srollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.bannerView);
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
- (void)setDetailModel:(SDGoodDetailModel *)detailModel{
    _detailModel = detailModel;
    _srollerView.imageURLStringsGroup = _detailModel.banner;
    if (self.detailModel.banner.count) {
        self.noteView.hidden = NO;
        self.noteLabel.text = [NSString stringWithFormat:@"%d/%ld",1,self.detailModel.banner.count];
    }else{
        self.noteView.hidden = YES;
    }
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
