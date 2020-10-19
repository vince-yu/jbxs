//
//  SDSystemHeadCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/26.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDSystemHeadCell.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "SDSystemProgressView.h"

@interface SDSystemHeadCell ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *pictureVIew;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *greenBgImage;
@property (nonatomic ,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic ,strong) UIView *noteView;
@property (nonatomic ,strong) UILabel *noteLabel;
@property (nonatomic ,strong) SDSystemProgressView *timerView;
@end

@implementation SDSystemHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.greenBgImage.image = [UIImage cp_imageByCommonGreenWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
    self.contentView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    self.progressView.layer.cornerRadius = 7.5;
    [self.pictureVIew addSubview:self.cycleScrollView];
    [self.pictureVIew addSubview:self.noteView];
    [self.pictureVIew addSubview:self.noteLabel];
    
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.pictureVIew);
    }];
    
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
    
    
    [self.progressView addSubview:self.timerView];
    [self.timerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(SCREEN_WIDTH - 20);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-20);
    }];
    
}
- (void)setDetailModel:(SDGoodDetailModel *)detailModel{
    _detailModel = detailModel;
    self.cycleScrollView.imageURLStringsGroup = _detailModel.banner;
    self.timerView.detailModel = detailModel;
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
- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"head_placeholder"]];
        _cycleScrollView.infiniteLoop = YES;
        _cycleScrollView.autoScroll = YES;
        _cycleScrollView.autoScrollTimeInterval = 2.5;
        _cycleScrollView.hidesForSinglePage = YES;
//        _cycleScrollView.pageDotImage = [UIImage imageNamed:@"main_normal_dot"];
//        _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"main_selected_dot"];
        _cycleScrollView.showPageControl = NO;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        _cycleScrollView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:247/255.0 alpha:1];
//        _cycleScrollView.backgroundColor = [UIColor blueColor];
    }
    return _cycleScrollView;
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
- (SDSystemProgressView *)timerView{
    if (!_timerView) {
        _timerView = [[SDSystemProgressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 125)];
        SD_WeakSelf;
        _timerView.timeChangeEndBlock = ^{
            SD_StrongSelf;
            if (self.reloadBlock) {
                self.reloadBlock();
            }
        };
    }
    return _timerView;
}
#pragma mark CycleViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    self.noteLabel.text = [NSString stringWithFormat:@"%ld/%ld",index + 1,self.detailModel.banner.count];
}
@end
