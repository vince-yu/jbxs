//
//  SDGrouperHeadView.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/14.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGrouperHeadView.h"

@interface SDGrouperHeadView ()
@property (weak, nonatomic) IBOutlet UIImageView *alterImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopDescribeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nikeNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@end

@implementation SDGrouperHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)editAction:(id)sender {
    if (self.editBlock) {
        self.editBlock();
    }
}

@end
