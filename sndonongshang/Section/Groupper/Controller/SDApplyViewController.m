//
//  SDApplyViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/14.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDApplyViewController.h"
#import "SDApplyGrouperCell.h"
#import "SDApplyGroupModel.h"
#import "SDAddressSearchViewController.h"
#import "SDCityListRequest.h"
#import "SDAddressModel.h"
#import "SDApplyRegimentRequest.h"

@interface SDApplyViewController ()<UITableViewDelegate ,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *contentTableView;
@property (nonatomic ,strong) UIButton *submitBtn;
@property (nonatomic ,strong) NSArray *dataArray;
@property (nonatomic ,strong) NSArray *cityArr;
@property (nonatomic, strong) SDAddressModel *addressModel;
@property (nonatomic, copy) NSString *address;

@end

@implementation SDApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCityList];
    [self initSubview];
}
- (void)initSubview{
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xF5F5F7"];
    self.title = @"申请团长";
    [self.view addSubview:self.contentTableView];
    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self.view);
    }];
}
- (UITableView *)contentTableView{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        _contentTableView.backgroundColor = [UIColor clearColor];
        _contentTableView.backgroundView = nil;
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UINib *nib = [UINib nibWithNibName:@"SDApplyGrouperCell" bundle: [NSBundle mainBundle]];
        [self.contentTableView registerNib:nib forCellReuseIdentifier:[SDApplyGrouperCell cellIdentifier]];
    }
    return _contentTableView;
}
- (UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
        _submitBtn.layer.cornerRadius = 22;
        [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        _submitBtn.backgroundColor = [UIColor colorWithHexString:kSDGreenTextColor];
        _submitBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:16];
        [_submitBtn setTitleColor:[UIColor colorWithHexString:@"0xFFFFFF"] forState:UIControlStateNormal];
    }
    return _submitBtn;
}
- (NSArray *)dataArray{
    if (!_dataArray) {
        NSArray *array = @[@{@"title":@"真实姓名:",@"placeholder":@"请输入真实姓名",@"value":@"",@"code":@"name",@"canEdit":@1},
                           @{@"title":@"联系电话:",@"placeholder":@"请输入手机号",@"value":@"",@"code":@"telephone",@"canEdit":@1},
                           @{@"title":@"选择地址:",@"placeholder":@"",@"value":@"",@"code":@"address",@"canEdit":@0},
                           @{@"title":@"楼号门牌:",@"placeholder":@"楼号/单元/门牌号",@"value":@"",@"code":@"houseNumber",@"canEdit":@1},
                           @{@"title":@"小区名称:",@"placeholder":@"请输入所在小区名称",@"value":@"",@"code":@"community",@"canEdit":@1, @"hiddenLine" : @YES}];
        _dataArray = [SDApplyGroupUIModel mj_objectArrayWithKeyValuesArray:array];
    }
    return _dataArray;
}
- (void)submitAction{
    [self.view endEditing:YES];
    NSString *name = nil;
    NSString *mobile = nil;
    NSString *community = nil;
    NSString *houseNumer = nil;

    for (int i =0; i < self.dataArray.count; i++) {
        SDApplyGroupUIModel *model = self.dataArray[i];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        SDApplyGrouperCell *cell = [self.contentTableView cellForRowAtIndexPath:indexPath];
        NSString *text = cell.contentTextField.text;
        if ([model.code isEqualToString:@"name"]) {
            name = text;
        }else if ([model.code isEqualToString:@"telephone"]) {
            mobile = text;
        }else if ([model.code isEqualToString:@"houseNumber"]) {
            houseNumer = text;
        }else if ([model.code isEqualToString:@"community"]) {
            community = text;
        }
    }
    if (!name || [name isEmpty]) {
        [SDToastView HUDWithWarnString:@"真实姓名不能为空"];
        return;
    }
    if (!mobile || [mobile isEmpty]) {
        [SDToastView HUDWithWarnString:@"联系电话不能为空"];
        return;
    }
    if (![mobile isPhoneNumber]) {
        [SDToastView HUDWithWarnString:@"请输入11位手机号"];
        return;
    }
    
    if (!self.address || !self.addressModel ) {
        [SDToastView HUDWithWarnString:@"收货地址不能为空"];
        return;
    }
    
    if (!houseNumer || [houseNumer isEmpty]) {
        [SDToastView HUDWithWarnString:@"楼号门牌不能为空"];
        return;
    }
    
    if (!community || [community isEmpty]) {
        [SDToastView HUDWithWarnString:@"小区名称不能为空"];
        return;
    }

    BOOL legalName = [self checkLegalWithText:name];
    if (!legalName) {
        [SDToastView HUDWithWarnString:@"真实姓名请输入20个以下的汉字、数字和英文"];
        return;
    }
    BOOL legalHouseNumer = [self checkLegalWithText:houseNumer];
    if (!legalHouseNumer) {
        [SDToastView HUDWithWarnString:@"楼号门牌请输入20个以下的汉字、数字和英文"];
        return;
    }
    
    BOOL legalCommunity = [self checkLegalWithText:community];
    if (!legalCommunity) {
        [SDToastView HUDWithWarnString:@"小区名称请输入20个以下的汉字、数字和英文"];
        return;
    }
    
    
    
    [SDStaticsManager umEvent:kcommander_info_submit];
    SDApplyRegimentRequest *request = [[SDApplyRegimentRequest alloc] init];
    request.realName = name;
    request.mobile = mobile;
    request.community = community;
    request.houseNumber = houseNumer;
    request.lat = self.addressModel.lat;
    request.lng = self.addressModel.lng;
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *tipsStr = @"提交成功\n我们会在两个工作日内联系你";
        [SDPopView showPopViewWithContent:tipsStr noTap:NO confirmBlock:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        } cancelBlock:^{
            
        }];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

- (BOOL)checkLegalWithText:(NSString *)text {
    NSString *regex = @"^[\u4e00-\u9fa5_a-zA-Z0-9_]{1,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:text];
}


#pragma mark - network
- (void)getCityList {
    SDCityListRequest *request = [[SDCityListRequest alloc] init];
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof SDCityListRequest * _Nonnull request) {
        self.cityArr = request.cityList;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}

#pragma mark Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SDApplyGrouperCell *cell = [tableView dequeueReusableCellWithIdentifier:[SDApplyGrouperCell cellIdentifier] forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = [self.dataArray objectAtIndex:indexPath.row];
    if (indexPath.row == 2 && [self.address isNotEmpty]) {
        [cell.chooseAddrBtn setTitle:self.address forState:UIControlStateNormal];
    }
    return cell;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 84;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArray count];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 84)];
    view.backgroundColor = [UIColor clearColor];
    [view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(44);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(0);
    }];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        [SDStaticsManager umEvent:kcommander_address];
        SDAddressSearchViewController *vc = [[SDAddressSearchViewController alloc] init];
        vc.cityArr = self.cityArr;
        SD_WeakSelf
        vc.block = ^(AMapPOI * _Nonnull poi, NSString * _Nonnull address) {
            SD_StrongSelf
            if (!self.addressModel) {
                self.addressModel = [[SDAddressModel alloc] init];
            }
            self.addressModel.province = poi.province;
            self.addressModel.city = poi.city;
            self.addressModel.street = poi.address;
            self.addressModel.sketch = poi.name;
            self.addressModel.lat = [NSString stringWithFormat:@"%f", poi.location.latitude];
            self.addressModel.lng = [NSString stringWithFormat:@"%f", poi.location.longitude];
            self.address = poi.name;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - lazy
- (NSArray *)cityArr {
    if (!_cityArr) {
        _cityArr = [NSArray array];
    }
    return _cityArr;
}


@end
