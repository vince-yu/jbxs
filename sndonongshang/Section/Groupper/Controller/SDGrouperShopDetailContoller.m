//
//  SDGrouperShopDetailContollerViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/16.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDGrouperShopDetailContoller.h"
#import "CATPlaceHolderTextView.h"

@interface SDGrouperShopDetailContoller ()<UITextViewDelegate>
@property (nonatomic ,strong) CATPlaceHolderTextView *textView;
@end

@implementation SDGrouperShopDetailContoller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubView];
}
- (void)initSubView{
    self.title = @"店铺介绍";
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.mas_equalTo(kTopHeight);
    }];
}
- (UITextView *)textView{
    if (!_textView) {
        _textView = [[CATPlaceHolderTextView alloc] init];
        _textView.textColor = [UIColor colorWithHexString:kSDMainTextColor];
        _textView.placeholder = @"填写您的店铺介绍，让更多小伙伴认识～";
        _textView.font = [UIFont fontWithName:kSDPFRegularFont size:15];
        _textView.backgroundColor = [UIColor clearColor];
    }
    return _textView;
}
@end
