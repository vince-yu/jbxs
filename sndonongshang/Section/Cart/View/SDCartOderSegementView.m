//
//  SDCartOderSegementView.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/11.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDCartOderSegementView.h"
#import "SDCartDataManager.h"

@interface SDCartOderSegementView ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *selectedRight;
@property (weak, nonatomic) IBOutlet UIImageView *selectedLeft;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;
@property (nonatomic ,strong) UILabel *namelLable;
@end

@implementation SDCartOderSegementView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.selectedLeft.hidden = NO;
    self.selectedRight.hidden = YES;
//    self.backgroundColor = [UIColor clearColor];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bgView addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(5, 5) viewRect:CGRectMake(0, 0, SCREEN_WIDTH - 30, 45)];
    [self addRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight withRadii:CGSizeMake(5, 5) viewRect:CGRectMake(0, 0, SCREEN_WIDTH - 20, 50)];
//    UIImage *bgImage = self.bgImageView.image;
//    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 0, 10)];
//    self.bgImageView.image = bgImage;
    
    [self addSubview:self.namelLable];
    [self.namelLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.equalTo(self);
    }];
    self.bgImageView.hidden = YES;
    self.namelLable.hidden = YES;
}
- (void)setType:(SDCartOrderType)type{
    if (type == SDCartOrderTypeDeliveryOnly) {
        self.bgView.hidden = YES;
        self.rightBtn.hidden = YES;
        self.leftBtn.enabled = NO;
        self.tagImageView.hidden = YES;
        self.namelLable.hidden = NO;
        self.leftBtn.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.namelLable.text = @"送货上门";
    }
    if (type == SDCartOrderTypeSelfTakeOnly || type == SDCartOrderTypeHeader ) {
        self.bgView.hidden = YES;
        self.rightBtn.hidden = YES;
        self.leftBtn.enabled = NO;
        self.tagImageView.hidden = YES;
        self.namelLable.hidden = NO;
        self.leftBtn.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.namelLable.text = @"到店自取";
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)leftClick:(id)sender {
    [SDStaticsManager umEvent:kpurchase_todoor];
    SDCartOrderType type = [SDCartDataManager sharedInstance].prepayModel.type;
    if (type == SDCartOrderTypeDelivery) {
        return;
    }
    SD_WeakSelf;
    [SDCartDataManager sharedInstance].prepayModel.type = SDCartOrderTypeDelivery;
    [self refreshOrder:^{
        SD_StrongSelf;
        [self leftClickSuccess];
    }faied:^(id model){
        SD_StrongSelf;
        [SDCartDataManager sharedInstance].prepayModel.type = SDCartOrderTypeSelfTake;
        [SDCartDataManager handlePayOrderRequestFailed:model viewController:self.viewController refreshBlock:^{
            [self leftClickWithNoFialeMsg];
        }];
    }];;
}
- (IBAction)leftClickWithNoFialeMsg{
    [SDStaticsManager umEvent:kpurchase_todoor];
    SDCartOrderType type = [SDCartDataManager sharedInstance].prepayModel.type;
    if (type == SDCartOrderTypeDelivery) {
        return;
    }
    SD_WeakSelf;
    [SDCartDataManager sharedInstance].prepayModel.type = SDCartOrderTypeDelivery;
    [self refreshOrder:^{
        SD_StrongSelf;
        [self leftClickSuccess];
    }faied:^(id model){
        SD_StrongSelf;
        [SDCartDataManager sharedInstance].prepayModel.type = SDCartOrderTypeSelfTake;
        [SDCartDataManager handlePayOrderRequestFailedRepeat:model viewController:self.viewController refreshBlock:^{
            [self leftClickWithNoFialeMsg];
        }];
    }];;
}
- (IBAction)rightClickWithNoFialeMsg{
    [SDStaticsManager umEvent:kpurchase_tostore];
    SDCartOrderType type = [SDCartDataManager sharedInstance].prepayModel.type;
    if (type == SDCartOrderTypeSelfTake) {
        return;
    }
    SD_WeakSelf;
    [SDCartDataManager sharedInstance].prepayModel.type = SDCartOrderTypeSelfTake;
    [self refreshOrder:^{
        SD_StrongSelf;
        [self rightClickSuccess];
    }faied:^(id model){
        SD_StrongSelf;
        [SDCartDataManager sharedInstance].prepayModel.type = SDCartOrderTypeDelivery;
        [SDCartDataManager handlePayOrderRequestFailedRepeat:model viewController:self.viewController refreshBlock:^{
            [self rightClickWithNoFialeMsg];
        }];
        
    }];
    
}
- (IBAction)rightClick:(id)sender {
    [SDStaticsManager umEvent:kpurchase_tostore];
    SDCartOrderType type = [SDCartDataManager sharedInstance].prepayModel.type;
    if (type == SDCartOrderTypeSelfTake) {
        return;
    }
    SD_WeakSelf;
    [SDCartDataManager sharedInstance].prepayModel.type = SDCartOrderTypeSelfTake;
    [self refreshOrder:^{
        SD_StrongSelf;
        [self rightClickSuccess];
    }faied:^(id model){
        SD_StrongSelf;
        [SDCartDataManager sharedInstance].prepayModel.type = SDCartOrderTypeDelivery;
        [SDCartDataManager handlePayOrderRequestFailed:model viewController:self.viewController refreshBlock:^{
            [self rightClickWithNoFialeMsg];
        }];
        
    }];
    
}
- (void)rightClickSuccess{
    self.selectedLeft.hidden = YES;
    self.selectedRight.hidden = NO;
    [self.rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (self.rightBlock) {
        self.rightBlock();
    }
}
- (void)leftClickSuccess{
    self.selectedLeft.hidden = NO;
    self.selectedRight.hidden = YES;
    [self.leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (self.leftBlock) {
        self.leftBlock();
    }
}
- (void)refreshOrder:( void (^)(void))completeBlock faied:(void (^)(id model))failedBlock{
    SDCartOrderType type = [SDCartDataManager sharedInstance].prepayModel.type;
    SD_WeakSelf;
    [SDCartDataManager prepayNomalOrderWithOrderRequestModel:[SDCartDataManager sharedInstance].prepayModel isCartTO:NO completeBlock: ^(id model){
        SD_StrongSelf;
        if (completeBlock) {
            completeBlock();
        }
    } failedBlock:^(id model){
        if (failedBlock) {
            failedBlock(model);
        }
    }];
}
- (UILabel *)namelLable{
    if (!_namelLable) {
        _namelLable = [UILabel new];
        _namelLable.font = [UIFont fontWithName:kSDPFBoldFont size:16];
        _namelLable.textColor = [UIColor colorWithHexString:kSDGreenTextColor];
    }
    return _namelLable;
}
@end
