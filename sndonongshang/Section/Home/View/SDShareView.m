//
//  SDShareVeiw.m
//  sndonongshang
//
//  Created by SNQU on 2019/2/26.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDShareView.h"
#import "SDShareManager.h"
#import "SDShareSaveView.h"
#import "SDHomeDataManager.h"
#import "SDGoodDetailModel.h"
#import "SDQRRequest.h"

@interface SDShareView ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic ,copy) wxBlock wxBlock;
@property (nonatomic ,copy) wxTimeLineBlock wxTimeLineBlock;
@property (nonatomic ,copy) qqBlock qqBlock;
@property (weak, nonatomic) IBOutlet UILabel *decrebLabel;
@property (nonatomic ,assign) SDShareType type;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@end

@implementation SDShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib{
    [super awakeFromNib];
    [self layoutIfNeeded];
    self.bottomViewHeight.constant = kBottomSafeHeight + 50;
}
- (IBAction)closeAction:(id)sender {
    switch (self.type) {
            case SDShareTypeLaXingView:
            [SDStaticsManager umEvent:klx_share_cancel];
            break;
            case SDShareTypeGoodDetailView:
            
            break;
        default:
            break;
    }
    SD_WeakSelf;
    [UIView animateWithDuration:0.40 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        SD_StrongSelf
        self.bgView.alpha = 0;
        self.contentView.frame = CGRectMake(0, SCREEN_HEIGHT,SCREEN_WIDTH, self.contentView.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (IBAction)wxShare:(id)sender {
    if (self.wxBlock) {
        self.wxBlock();
        [self removeFromSuperview];
    }
     [self removeFromSuperview];
}
- (IBAction)qqShare:(id)sender {
    if (self.qqBlock) {
        self.qqBlock();
       
    }
    [self removeFromSuperview];
}
- (IBAction)wxTimeLineShare:(id)sender {
    if (self.wxTimeLineBlock) {
        if (self.type == SDShareTypeGoodDetailView) {
            [self wxTimeLineViewAppear];
        }else{
            self.wxTimeLineBlock(nil);
        }
        
        [self removeFromSuperview];
    }
}
+ (void)showWithWxBlock:(wxBlock )wxBlock wxTimeLineBlock:(wxTimeLineBlock )wxTimeLineBlock qqBlock:(qqBlock )qqblock describe:(NSAttributedString *)str type:(SDShareType)type{
    SDShareView *share = [[NSBundle mainBundle] loadNibNamed:@"SDShareView" owner:nil options:nil].firstObject;
    share.wxBlock = wxBlock;
    share.qqBlock = qqblock;
    share.wxTimeLineBlock = wxTimeLineBlock;
    if ([SDUserModel sharedInstance].role == SDUserRolerTypeNormal) {
        str = nil;
    }
    if ([str isKindOfClass:[NSAttributedString class]] && str.length) {
        share.decrebLabel.attributedText = str;
    }
    
    share.type = type;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:share];
    [share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(window);
    }];
    [share showAnimation];
}
- (void)layoutSubviews{
    
}
- (void)showAnimation{
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 0.25; // 动画持续时间
    animation.repeatCount = 1; // 不重复
    animation.timingFunction =
    [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionDefault];
    CGFloat describleHeight = 0.0;
    if (self.decrebLabel.attributedText.length) {
        describleHeight = [self.decrebLabel.attributedText.string sizeWithFont:[UIFont fontWithName:kSDPFRegularFont size:12] maxSize:CGSizeMake(SCREEN_WIDTH - 40, 100)].height;
    }
    CGFloat contentHeight = 280 + kBottomSafeHeight + describleHeight;
    
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT + contentHeight / 2.0)]; // 起始点
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH / 2.0,SCREEN_HEIGHT - contentHeight / 2.0)]; // 终了点
    [self.contentView.layer addAnimation:animation forKey:@"move-layer"];
}
- (void)wxTimeLineViewAppear{
    [SDToastView show];
    [SDHomeDataManager getWXQR:^(id  _Nonnull mdoel) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [SDToastView dismiss];
            SDShareSaveView *shareView = [[SDShareSaveView alloc] init];
            SDGoodDetailModel *detailModel = [SDHomeDataManager sharedInstance].detailModel;
            detailModel.miniQRImage = mdoel;
            shareView.model = detailModel;
            SD_WeakSelf;
        
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window addSubview:shareView];
            [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.left.bottom.equalTo(window);
            }];
        });
        
    } ailedBlock:^(id model){
        
    }];
}
@end
