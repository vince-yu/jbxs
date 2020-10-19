//
//  SDDetailTableView.m
//  sndonongshang
//
//  Created by SNQU on 2019/3/26.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDDetailTableView.h"
#import "SDNomalTiltleCell.h"
#import "SDSystemTitleCell.h"
#import "SDDiscountTitleCell.h"
#import "SDSecondKillTitleCell.h"
#import "SDBannerCell.h"
#import "SDSystemHeadCell.h"

@interface SDDetailTableView ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic ,assign) SDGoodDetailType detailType;
@property (nonatomic, strong) UIImageView *emptyView;
@property (nonatomic, strong) UIButton *loadBtn;
@property (nonatomic, strong) UIImageView *emptyIv;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic ,strong) NSMutableArray *imageViewArray;

@end

@implementation SDDetailTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
        self.backgroundColor = [UIColor colorWithRGB:0xf7f7f7];
        UINib *nib1 = [UINib nibWithNibName:@"SDSystemTitleCell" bundle: [NSBundle mainBundle]];
        [self registerNib:nib1 forCellReuseIdentifier:[SDSystemTitleCell cellIdentifier]];
        UINib *nib6 = [UINib nibWithNibName:@"SDBannerCell" bundle: [NSBundle mainBundle]];
        [self registerNib:nib6 forCellReuseIdentifier:[SDBannerCell cellIdentifier]];
    }
    return self;
}

- (void)refreshAction {
    [self refreshActionWithHiddenToast:NO];
}

#pragma mark - DZNEmptyDataSetSource tableView
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -20;
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    if (!_emptyView) {
    [self.emptyView addSubview:self.emptyIv];
    [self.emptyView addSubview:self.tipsLabel];
        [self.emptyView addSubview:self.loadBtn];
    }
    CGFloat x = (SCREEN_WIDTH - 120) * 0.5;
    if (self.isLoadFail) {
    self.loadBtn.hidden = NO;
    self.tipsLabel.text = @"加载失败";
    self.emptyIv.image = [UIImage imageNamed:@"load_fail"];
    self.emptyView.frame = CGRectMake(x, 0, 120, 120 + 14 + 35 + 27);
    }else {
        if (self.detailModel.code == 201) {
            self.tipsLabel.text = @"该商品已下架";
        }else{
            self.tipsLabel.text = @"暂无数据";
        }
        
        self.loadBtn.hidden = YES;
        
        self.emptyIv.image = [UIImage imageNamed:@"cart_no_good"];
        self.emptyView.frame = CGRectMake(x, 0, 120, 120);
    }
    self.emptyIv.frame = CGRectMake(x , 0, 120, 120);
    self.tipsLabel.frame = CGRectMake(x , CGRectGetMaxY(self.emptyIv.frame), 200, 14);
    self.tipsLabel.center = self.emptyIv.center;
    self.tipsLabel.y = CGRectGetMaxY(self.emptyIv.frame);
    self.loadBtn.frame = CGRectMake((SCREEN_WIDTH - 75) * 0.5, CGRectGetMaxY(self.emptyIv.frame) + 30, 75, 27);
    self.emptyView.superview.userInteractionEnabled = YES;
    
    return self.emptyView;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self emptyDataClick];
}
- (void)emptyDataClick {
    [self.mj_header beginRefreshing];
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (UIButton *)loadBtn{
    if (!_loadBtn) {
        _loadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loadBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        [_loadBtn setTitleColor:[UIColor colorWithHexString:@"0x131413"] forState:UIControlStateNormal];
        _loadBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:13];
        _loadBtn.layer.borderWidth = 0.5;
        _loadBtn.layer.cornerRadius = 13.5;
        _loadBtn.layer.borderColor = [UIColor colorWithHexString:kSDGreenTextColor].CGColor;
        _loadBtn.backgroundColor = [UIColor colorWithHexString:@"0xF5F6F5"];
        [_loadBtn addTarget:self action:@selector(emptyDataClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loadBtn;
}

- (UIImageView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[UIImageView alloc] init];
        _emptyView.image = [UIImage cp_imageWithColor:[UIColor colorWithRGB:0xf7f7f7] size:CGSizeMake(SCREEN_WIDTH, 120 + 14 + 35 + 27)];
    }
    return _emptyView;
}

- (UIImageView *)emptyIv {
    if (!_emptyIv) {
        _emptyIv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cart_no_good"]];
    }
    return _emptyIv;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = @"加载失败";
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        _tipsLabel.textColor = [UIColor colorWithHexString:kSDSecondaryTextColor];
    }
    return _tipsLabel;
}
#pragma suprer params
- (BOOL)refresTime{
    return YES;
}
#pragma mark 首次进入先加载图片再刷新UI
- (void)loadImages{
    [self.imageViewArray removeAllObjects];
    if (!self.detailModel.detail.count) {
        return;
    }
    [SDToastView show];
    for (int i = 0 ; i < self.detailModel.detail.count ; i ++) {
        NSString *str = [self.detailModel.detail objectAtIndex:i];
        UIImage *img = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:str];
        if (img) {
            if (i == self.detailModel.detail.count - 1) {
                [SDToastView dismiss];
            }
        }else{
            
            UIImageView *imageView = [[UIImageView alloc] init];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                NSInteger count = [self.detailModel.detail indexOfObject:[imageURL absoluteString]];
                if (count == self.detailModel.detail.count - 1) {
                    [SDToastView dismiss];
                    [self reloadData];
                }
            }];
//            i ++;
            [self.imageViewArray addObject:imageView];
        }
    }
}
- (NSMutableArray *)imageViewArray{
    if (!_imageViewArray) {
        _imageViewArray = [[NSMutableArray alloc] init];
    }
    return _imageViewArray;
}

#pragma mark TableViewDelegate 集成
- (UITableViewCell *)handleTitleCellWithIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (self.detailModel.type.integerValue == SDGoodTypeNamoal) {
        
        SDNomalTiltleCell *titleCell = [self dequeueReusableCellWithIdentifier:[SDNomalTiltleCell cellIdentifier] forIndexPath:indexPath];
        titleCell.detailModel = self.detailModel;
        cell = titleCell;
        
    }else if (self.detailModel.type.integerValue == SDGoodTypeGroup){
        SDSystemTitleCell *titleCell = [self dequeueReusableCellWithIdentifier:[SDSystemTitleCell cellIdentifier] forIndexPath:indexPath];
        titleCell.detailModel = self.detailModel;
        cell = titleCell;
    }else if (self.detailModel.type.integerValue == SDGoodTypeSecondkill){
        if (self.detailModel.soldOut) {
            SDSystemTitleCell *titleCell = [self dequeueReusableCellWithIdentifier:[SDSystemTitleCell cellIdentifier] forIndexPath:indexPath];
            titleCell.detailModel = self.detailModel;
            cell = titleCell;
        }else{
            SDSecondKillTitleCell* headCell = [self dequeueReusableCellWithIdentifier:[SDSecondKillTitleCell cellIdentifier] forIndexPath:indexPath];
            headCell.detailModel = self.detailModel;
            SD_WeakSelf;
            headCell.timerBlock = ^{
                SD_StrongSelf;
                [self refreshAction];
            };
            cell = headCell;
        }
        
    }else if (self.detailModel.type.integerValue == SDGoodTypeDiscount){
        SDDiscountTitleCell* headCell = [self dequeueReusableCellWithIdentifier:[SDDiscountTitleCell cellIdentifier] forIndexPath:indexPath];
        headCell.detailModel = self.detailModel;
        cell = headCell;
    }
    return cell;
}
- (UITableViewCell *)handleBannerCellWithIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (!self.detailModel.soldOut && self.detailModel.type.integerValue == SDGoodTypeGroup){
        SDSystemHeadCell* headCell = [self dequeueReusableCellWithIdentifier:[SDSystemHeadCell cellIdentifier] forIndexPath:indexPath];
        headCell.detailModel = self.detailModel;
        SD_WeakSelf;
        headCell.reloadBlock = ^{
            SD_StrongSelf;
            [self refreshAction];
        };
        cell = headCell;
    }else{
        SDBannerCell* headCell = [self dequeueReusableCellWithIdentifier:[SDBannerCell cellIdentifier] forIndexPath:indexPath];
        headCell.detailModel = self.detailModel;
        cell = headCell;
    }
    return cell;
}
@end
