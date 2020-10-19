//
//  SDRecruitViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/14.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDRecruitViewController.h"
#import "SDApplyViewController.h"

@interface SDRecruitViewController ()
@property (nonatomic ,strong) UIButton *applyBtn;
@property (nonatomic ,strong) UIImageView *bgImageView;
@end

@implementation SDRecruitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubView];
}
- (void)initSubView{
    
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.applyBtn];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    [self.applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(-40);
    }];
    
    self.applyRole = SDApplyRoleGrouper;
    if (self.applyRole == SDApplyRoleTaoke) {
        self.title = @"淘客招募令";
        self.bgImageView.image = [UIImage imageNamed:@""];
        [self.applyBtn setTitle:@"我要成为淘客" forState:UIControlStateNormal];
    }else{
        self.title = @"团长招募令";
        self.bgImageView.image = [UIImage imageNamed:@""];
        [self.applyBtn setTitle:@"我要成为团长" forState:UIControlStateNormal];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        
    }
    return _bgImageView;
}
- (UIButton *)applyBtn{
    if (!_applyBtn) {
        _applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_applyBtn addTarget:self action:@selector(applyAction) forControlEvents:UIControlEventTouchUpInside];
        [_applyBtn setTitleColor:[UIColor colorWithHexString:@"0x1D1B1B"] forState:UIControlStateNormal];
        _applyBtn.titleLabel.font = [UIFont fontWithName:kSDPFRegularFont size:21];
    }
    return _applyBtn;
}
- (void)applyAction{
    if (self.applyRole == SDApplyRoleTaoke) {
        
    }else{
        SDApplyViewController *applyVC = [[SDApplyViewController alloc] init];
        [self.navigationController pushViewController:applyVC animated:YES];
    }
}
@end
