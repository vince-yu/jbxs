//
//  SDHomeHeaderTableViewCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/8.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDHomeHeaderTableViewCell.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "SDHomeDataManager.h"
#import "SDHomeBannerModel.h"
#import "SDHomeCategroyModel.h"
#import <iCarousel/iCarousel.h>
#import "SDSpecialBanner.h"

static CGFloat const itemHeight = 85;
static CGFloat const itemWith = 40;


@interface SDHomeHeaderTableViewCell ()<SDCycleScrollViewDelegate,iCarouselDelegate,iCarouselDataSource,SDSpecialBannerDelegate>
@property (nonatomic ,strong) SDCycleScrollView *srollerView;
@property (nonatomic ,strong) UIView *categoryView;
@property (nonatomic ,strong) iCarousel *icarousel;
@property (nonatomic ,strong) SDSpecialBanner *bannerView;
@property (nonatomic ,strong) UIImageView *imageViewBanner;
@end

@implementation SDHomeHeaderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
//    [self.contentView addSubview:self.srollerView];
//    [self.contentView addSubview:self.categoryView];
    [self.contentView addSubview:self.bannerView];
//    self.srollerView.hidden = YES;
    self.contentView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:247/255.0 alpha:1];
    
//    [self.srollerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.mas_equalTo(10);
//        make.right.mas_equalTo(-10);
//        make.width.mas_equalTo(SCREEN_WIDTH - 20);
//        make.height.mas_equalTo(self.srollerView.mas_width).multipliedBy(9/25.0);
//    }];
    [self.bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(self.bannerView.mas_width).multipliedBy(9/25.0);
        make.bottom.mas_equalTo(-10);
    }];
    
//    [self.categoryView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.bannerView.mas_bottom).offset(10);
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
////        make.height.mas_equalTo(itemHeight);
//        make.bottom.mas_equalTo(0);
//
//    }];
    
}
- (void)reloadCategory{
    NSArray *imageUrls = [SDHomeDataManager sharedInstance].bannerArray;
    SDHomeBannerModel *model = imageUrls.firstObject;
    NSString *imageUrl = model.picUrl;
    if (imageUrl) {
        _imageViewBanner = [[UIImageView alloc] init];
        [SDToastView show];
        SD_WeakSelf;
        [_imageViewBanner sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [SDToastView dismiss];
            SD_StrongSelf;
            if (image) {
                CGFloat bili = image.size.height / image.size.width;
                [self reloadBanner:bili];
            }else{
                [self reloadBanner:0.435];
            }
        }];
    }else{
        [self reloadBanner:0];
    }

}
- (void)reloadBanner:(CGFloat )bili{
    self.bannerView.bili = bili;
    NSArray *imageUrls = [SDHomeDataManager sharedInstance].bannerArray;
    //    imageUrls = nil;
    if (!imageUrls.count) {
        [self.bannerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(self.bannerView.mas_width).multipliedBy(0/4.0);
            make.bottom.mas_equalTo(-10);
        }];
    }else{
        [self.bannerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(self.bannerView.mas_width).multipliedBy(bili);
            make.bottom.mas_equalTo(-10);
        }];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (SDHomeBannerModel *model in imageUrls) {
            if (model.picUrl.length) {
                [array addObject:model.picUrl];
            }
        }
        //        self.srollerView.imageURLStringsGroup = array;
        self.bannerView.imageArray = array;
    }
}
- (void)initCateGoryViewWithDataArray:(NSArray *)dataArray{
    for (UIView *view in self.categoryView.subviews) {
        [view removeFromSuperview];
    }
    if (!dataArray.count) {
        [self.bannerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(self.bannerView.mas_width).multipliedBy(9/25.0);
            make.bottom.equalTo(self.contentView).offset(0);
        }];
        return;
    }
    NSInteger maxCount = 5;
    NSInteger count = dataArray.count;
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
            make.top.equalTo(self.bannerView.mas_bottom).offset(10);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(height);
            make.bottom.mas_equalTo(0).priorityHigh();
            
        }];
    }else{
        CGFloat height = itemHeight;
        [self.categoryView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bannerView.mas_bottom).offset(10);
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
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma fuction
- (void)setModel:(id )model{
    
}
#pragma mark initSubviews
- (SDCycleScrollView *)srollerView{
    if (!_srollerView) {
        _srollerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"head_placeholder"]];
        _srollerView.infiniteLoop = YES;
        _srollerView.autoScroll = YES;
        _srollerView.autoScrollTimeInterval = 3;
//        _srollerView.hidesForSinglePage = YES;
        _srollerView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
//        _srollerView.pageDotImage = [UIImage imageNamed:@"main_normal_dot"];
//        _srollerView.currentPageDotImage = [UIImage imageNamed:@"main_selected_dot"];
        _srollerView.pageControlBottomOffset = 10.0f;
        _srollerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _srollerView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        _srollerView.backgroundColor = [UIColor clearColor];
        _srollerView.clickItemOperationBlock = ^(NSInteger currentIndex) {
            [SDHomeDataManager clickBannerTojump:currentIndex];
        };
        
       
    }
    return _srollerView;
}
- (SDSpecialBanner *)bannerView{
    if (!_bannerView) {
        _bannerView = [[SDSpecialBanner alloc] initWithFrame:CGRectZero withImageArray:nil];
        _bannerView.delegate = self;
    }
    return _bannerView;
}
- (iCarousel *)icarousel{
    if (!_icarousel) {
        _icarousel = [[iCarousel alloc] init];
        _icarousel.type = iCarouselTypeLinear;
        _icarousel.pagingEnabled = YES;
    }
    return _icarousel;
}
- (UIView *)categoryView{
    if (!_categoryView) {
        _categoryView = [[UIView alloc] init];
        _categoryView.backgroundColor = [UIColor whiteColor];
    }
    return _categoryView;
}
#pragma mark Banner Delegate
- (void)selectIndex:(NSInteger)index{
    [SDHomeDataManager clickBannerTojump:index];
}
@end
