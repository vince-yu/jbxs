//
//  SDGoodPictureCell.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/10.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGoodPictureCell.h"

@interface SDGoodPictureCell ()
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

@end

@implementation SDGoodPictureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews{
//    [self.picImageView sizeToFit];
}
- (void)setImageUrl:(NSString *)imageUrl{
    UIImage *imagePlace = [UIImage imageNamed:@"detail_placeholder"];
//    CGFloat height = image.size.height * image.size.width / SCREEN_WIDTH;
//    self.picImageView.contentMode = UIViewContentModeScaleToFill;
//    [self.picImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(height);
//    }];
    NSURL *imageurl = [NSURL URLWithString:imageUrl];
    UIImage *img = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
    if (img) {

        CGFloat height = img.size.height * SCREEN_WIDTH / img.size.width;
        [self.picImageView setImage:img];
        [self.picImageView layoutIfNeeded];
        [self.picImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];

    }else{
        SD_WeakSelf;
//        self.picImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.picImageView sd_setImageWithURL:imageurl placeholderImage:imagePlace completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            SD_StrongSelf;
            NSLog(@"width is.....%f, height is .....%f",image.size.width,image.size.height);
            if (image) {
                CGFloat height = image.size.height * SCREEN_WIDTH / image.size.width;
                [self.picImageView layoutIfNeeded];
                [self.picImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(height);
                }];
            }
            
        }];
    }
//    imageurl = nil;
    
}
@end
