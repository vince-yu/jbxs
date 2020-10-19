//
//  SDRepoViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/2/18.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDRepoViewController.h"
#import "SDRepoListTableView.h"

@interface SDRepoViewController ()
@property (nonatomic ,strong) SDRepoListTableView *repoListTableView;
@end

@implementation SDRepoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择自取地点";
    [self initSubViews];
    [self.repoListTableView refreshAction];
}
- (void)initSubViews{
    [self.view addSubview:self.repoListTableView];
    
    [self.repoListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(kTopHeight);
    }];
}
- (UITableView *)repoListTableView{
    if (!_repoListTableView) {
        _repoListTableView = [[SDRepoListTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        SD_WeakSelf;
        _repoListTableView.selectBlock = ^{
            SD_StrongSelf;
            [self.navigationController popViewControllerAnimated:YES];
        };
    }
    return _repoListTableView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
