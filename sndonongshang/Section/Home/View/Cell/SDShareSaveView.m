//
//  SDShareSaveView.m
//  sndonongshang
//
//  Created by SNQU on 2019/5/28.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDShareSaveView.h"
#import "SDShareManager.h"
#import "SDStaticsManager.h"

@interface  SDShareSaveView ()
@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,strong) UIView *contentView;
@property (nonatomic ,strong) UIView *saveView;
@property (nonatomic ,strong) UIView *bottomView;
@property (nonatomic ,strong) UIView *topView;

@property (nonatomic ,strong) UIImageView *cancelImageView;
@property (nonatomic ,strong) UIButton *cancelBtn;

@property (nonatomic ,strong) UIImageView *goodImageView;
@property (nonatomic ,strong) UILabel *tilteLabel;
@property (nonatomic ,strong) UILabel *soldLabel;
@property (nonatomic ,strong) UIView *tagView;
@property (nonatomic ,strong) UIImageView *miniImageView;
@property (nonatomic ,strong) UILabel *priceLabel;
@property (nonatomic ,strong) UILabel *miniLabel;
@property (nonatomic ,strong) UIImageView *saveImageView;
@property (nonatomic ,strong) UILabel *saveDesLabel;

@property (nonatomic ,strong) UIButton *saveBtn;
@property (nonatomic ,strong) UILabel *saveLabel;

@end

@implementation SDShareSaveView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
}
- (void)initSubViews{
    [self addSubview:self.bgView];
    [self addSubview:self.contentView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_greaterThanOrEqualTo(557);
    }];
    
    [self.contentView addSubview:self.topView];
    [self.contentView addSubview:self.bottomView];
    [self.contentView addSubview:self.saveView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(30);
    }];
    [self.saveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(10);
        make.left.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.bottom.equalTo(self.bottomView.mas_top).offset(-20);
        make.height.mas_greaterThanOrEqualTo(400);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(90 + kBottomSafeHeight);
    }];
    [self initTopView];
    [self initSaveView];
    [self initBottomView];
}
- (void)initTopView{
    [self.topView addSubview:self.cancelBtn];
    [self.cancelBtn addSubview:self.cancelImageView];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.topView);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(45);
    }];
    
    [self.cancelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.cancelBtn);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(16);
        make.bottom.mas_equalTo(0);
    }];
    
}
- (void)initBottomView{
    [self.bottomView addSubview:self.saveBtn];
    [self.bottomView addSubview:self.saveLabel];
    
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView);
        make.left.equalTo(self.bottomView).offset(15);
        make.right.equalTo(self.bottomView).offset(-15);
        make.height.mas_equalTo(50);
    }];
    
    [self.saveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.right.left.equalTo(self.saveBtn);
        make.height.mas_equalTo(12);
    }];
}
- (void)initSaveView{
    [self.saveView addSubview:self.saveImageView];
    [self.saveView addSubview:self.saveDesLabel];
    [self.saveView addSubview:self.goodImageView];
    [self.saveView addSubview:self.tilteLabel];
    [self.saveView addSubview:self.soldLabel];
    [self.saveView addSubview:self.priceLabel];
    [self.saveView addSubview:self.miniLabel];
    [self.saveView addSubview:self.miniImageView];
    [self.saveView addSubview:self.tagView];
    
    [self.saveImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.centerX.equalTo(self.saveView);
        make.width.mas_equalTo(86.5);
        make.height.mas_equalTo(26);
    }];
    
    [self.saveDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.saveImageView.mas_bottom).offset(10);
        make.centerX.equalTo(self.saveImageView);
        make.height.mas_equalTo(12);
    }];
    
    [self.goodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(SCREEN_WIDTH - 90);
        make.top.equalTo(self.saveDesLabel.mas_bottom).offset(15);
        make.height.equalTo(self.goodImageView.mas_width).multipliedBy(3.0/4);
    }];
    [self.miniImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.equalTo(self.goodImageView.mas_bottom).offset(10);
        make.width.mas_equalTo(95);
        make.height.mas_equalTo(95);
    }];
    [self.tilteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodImageView);
        make.right.equalTo(self.miniImageView.mas_left).offset(-10);
        make.height.mas_greaterThanOrEqualTo(17);
        make.top.equalTo(self.goodImageView.mas_bottom).offset(15);
    }];
    [self.soldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tilteLabel.mas_bottom).offset(12);
        make.left.equalTo(self.tilteLabel.mas_left);
        make.height.mas_equalTo(11);
        make.right.equalTo(self.miniImageView.mas_left).offset(-15);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.soldLabel.mas_left);
        make.right.equalTo(self.miniLabel.mas_left);
        make.top.equalTo(self.tagView.mas_bottom).offset(15);
        make.height.mas_equalTo(19);
        make.bottom.equalTo(self.saveView.mas_bottom).offset(-22);
    }];
    [self.miniLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.miniImageView.mas_centerX);
        make.top.equalTo(self.miniImageView.mas_bottom).offset(5);
        make.height.mas_equalTo(12);
    }];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.soldLabel.mas_bottom).offset(15);
        make.left.equalTo(self.priceLabel.mas_left);
        make.right.equalTo(self.priceLabel.mas_right);
        make.height.mas_equalTo(14);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setModel:(SDGoodDetailModel *)model{
    _model = model;
    [self.goodImageView sd_setImageWithURL:[NSURL URLWithString:self.model.banner.firstObject]];
    self.miniLabel.text = @"长按小程序码去购买";
    self.miniImageView.image = self.model.miniQRImage;
    self.tilteLabel.text = self.model.name;
    self.soldLabel.text = [NSString stringWithFormat:@"已售%@%@",self.model.sold,self.model.spec];
    if (self.model.priceActive.length) {
        self.priceLabel.attributedText = [NSString getAttributeStringPrice:[self.model.priceActive priceStr] priceFontSize:18 withOldPrice:[self.model.price priceStr]  oldPriceSize:12 unit:self.model.spec];
    }else{
        if (self.model.price.length) {
            self.priceLabel.attributedText = [NSString getAttributeStringPrice:[self.model.price priceStr] priceFontSize:18 withOldPrice:@"" oldPriceSize:12 unit:self.model.spec];
        }else{
            self.priceLabel.attributedText = [[NSAttributedString alloc] initWithString:@""];
        }
    }
    [self.tagView addTagWithArray:self.model.tags discount:self.model.discount];
}
#pragma mark lazy init
- (UIView *)bgView{
    if(!_bgView){
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
    }
    return _bgView;
}
- (UIView *)contentView{
    if(!_contentView){
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}
- (UIView *)topView{
    if(!_topView){
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}
- (UIView *)saveView{
    if(!_saveView){
        _saveView = [[UIView alloc] init];
        _saveView.backgroundColor = [UIColor whiteColor];
//        _saveView.clipsToBounds = YES;
        _saveView.layer.cornerRadius = 10.0;
        _saveView.layer.shadowColor = [UIColor blackColor].CGColor;
        _saveView.layer.shadowRadius = 3.0;
        _saveView.layer.shadowOpacity = 0.2;
        _saveView.layer.shadowOffset = CGSizeMake(0,0);
//        _saveView.backgroundColor = [UIColor redColor];
    }
    return _saveView;
}
- (UIView *)bottomView{
    if(!_bottomView){
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.backgroundColor = [UIColor clearColor];
    }
    return _cancelBtn;
}
- (UIImageView *)cancelImageView{
    if (!_cancelImageView) {
        _cancelImageView = [[UIImageView alloc] init];
        _cancelImageView.image = [UIImage imageNamed:@"cart_orderlist_close"];
    }
    return _cancelImageView;
}
- (UIImageView *)miniImageView{
    if (!_miniImageView) {
        _miniImageView = [[UIImageView alloc] init];
    }
    return _miniImageView;
}
- (UIImageView *)goodImageView{
    if (!_goodImageView) {
        _goodImageView = [[UIImageView alloc] init];
    }
    return _goodImageView;
}
- (UILabel *)tilteLabel{
    if (!_tilteLabel) {
        _tilteLabel = [[UILabel alloc] init];
        _tilteLabel.font = [UIFont fontWithName:kSDPFMediumFont size:16];
        _tilteLabel.textColor = [UIColor colorWithHexString:@"0x131413"];
        _tilteLabel.numberOfLines = 2;
    }
    return _tilteLabel;
}
- (UILabel *)soldLabel{
    if (!_soldLabel) {
        _soldLabel = [[UILabel alloc] init];
        _soldLabel.font = [UIFont fontWithName:kSDPFMediumFont size:11];
        _soldLabel.textColor = [UIColor colorWithHexString:@"0x848487"];
    }
    return _soldLabel;
}
- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
    }
    return _priceLabel;
}
- (UILabel *)miniLabel{
    if (!_miniLabel) {
        _miniLabel = [[UILabel alloc] init];
        _miniLabel.font = [UIFont fontWithName:kSDPFRegularFont size:12];
        _miniLabel.textColor = [UIColor colorWithHexString:@"0x131413"];
    }
    return _miniLabel;
}
- (UILabel *)saveLabel{
    if (!_saveLabel) {
        _saveLabel = [[UILabel alloc] init];
        _saveLabel.font = [UIFont fontWithName:kSDPFRegularFont size:12];
        _saveLabel.textColor = [UIColor colorWithHexString:@"0x131413"];
    }
    return _saveLabel;
}
- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        _saveBtn.backgroundColor = [UIColor clearColor];
        [_saveBtn setTitle:@"分享" forState:UIControlStateNormal];
        _saveBtn.backgroundColor = [UIColor colorWithHexString:kSDGreenTextColor];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveBtn.layer.cornerRadius = 25;
    }
    return _saveBtn;
}
- (UIView *)tagView{
    if (!_tagView) {
        _tagView = [[UIView alloc] init];
        _tagView.backgroundColor = [UIColor whiteColor];
    }
    return _tagView;
}
- (UIImageView *)saveImageView{
    if (!_saveImageView) {
        _saveImageView = [[UIImageView alloc] init];
        _saveImageView.image = [UIImage imageNamed:@"good_share_title"];
    }
    return _saveImageView;
}
- (UILabel *)saveDesLabel{
    if (!_saveDesLabel) {
        _saveDesLabel = [[UILabel alloc] init];
        _saveDesLabel.font = [UIFont fontWithName:kSDPFMediumFont size:12];
        _saveDesLabel.textColor = [UIColor colorWithHexString:@"0x9D9E9D"];
        _saveDesLabel.text = @"- 1元水果每天享 -";
    }
    return _saveDesLabel;
}
#pragma mark Action
- (void)saveAction{
    UIImage *image = [self getImageFromView:self.saveView];
    
    [SDStaticsManager umEvent:kdetail_share_circle attr:@{@"_id":self.model.goodId,@"name":self.model.name,@"type":self.model.type}];
    
    [SDShareManager shareImageToPlatformTypeShareImage:image withShareResultBlock:^(id data, NSError *error) {
            if (error) {
                //                    [SDToastView HUDWithString:failedStr];
                [SDStaticsManager umEvent:kdetail_share_fail attr:@{@"_id":self.model.goodId,@"name":self.model.name,@"type":self.model.type,@"platform":@"WEIXIN_CIRCLE"}];
                [SDToastView HUDWithString:@"分享成功"];
            }else{
                //                    [SDToastView HUDWithString:successStr];
                [SDStaticsManager umEvent:kdetail_share_success attr:@{@"_id":self.model.goodId,@"name":self.model.name,@"type":self.model.type,@"platform":@"WEIXIN_CIRCLE"}];
                [SDToastView HUDWithString:@"分享失败，请重新分享"];
            }
    }];
    [self removeFromSuperview];
}
- (void)cancelAction{
    [self removeFromSuperview];
}
// 对指定视图进行截图
//获取截图
-(UIImage *)getImageFromView:(UIView *)orgView{
    CGSize s = orgView.bounds.size;
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    
    [orgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}
@end
