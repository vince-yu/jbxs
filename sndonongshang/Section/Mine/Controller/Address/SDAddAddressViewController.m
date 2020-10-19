//
//  SDAddAddressViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/9.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDAddAddressViewController.h"
#import "SDAddAddressCell.h"
#import "SDConsigneeCell.h"
#import "SDAddressTypeCell.h"
#import "SDDefaultAddressCell.h"
#import "SDAddAddressModel.h"
#import "SDChooseAddrCell.h"
#import "SDCityListRequest.h"
#import "SDAddAddressRequest.h"
#import "SDDelAddrReqeust.h"
#import "SDUpdateAddrRequest.h"
#import "SDAddressSearchViewController.h"

@interface SDAddAddressViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) UIButton *saveAddressBtn;
@property (nonatomic, strong) UIButton *deleteAddressBtn;
@property (nonatomic, strong) NSArray *cityArr;

@property (nonatomic, weak) UITextField *nameTextField;
@property (nonatomic, weak) UITextField *mobileTextField;
@property (nonatomic, weak) UITextField *addressTextField;
@property (nonatomic, weak) UITextField *houseNumerTextField;
@property (nonatomic, weak) UISwitch *defaultAddrSwitch;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, weak) SDAddressModel *tempAddrModel;
@property (nonatomic, strong) AMapPOI *poi;

@end

@implementation SDAddAddressViewController

static NSString * const cellIDMobile = @"SDAddAddressCellMobile";
static NSString * const cellIDAddress = @"SDChooseAddrCellAddress";
static NSString * const cellIDHouseNumber = @"SDAddAddressCellHouseNumber";
static NSString * const consigneeCellID = @"SDConsigneeCell";
static NSString * const typeCellID = @"SDAddressTypeCell";
static NSString * const defaultCellID = @"SDDefaultAddressCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self getCityList];
    [self initTableView];
    [self setupUserInfo];
}

- (void)initNav {
    if (self.update) {
        self.navigationItem.title = @"编辑收货地址";
    }else {
        self.navigationItem.title = @"新增地址";
    }
}

- (void)initTableView {
    CGRect frame = CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight);
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor colorWithRGB:0xf5f5f7];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    [tableView registerClass:[SDAddAddressCell class] forCellReuseIdentifier:cellIDMobile];
    [tableView registerClass:[SDChooseAddrCell class] forCellReuseIdentifier:cellIDAddress];
    [tableView registerClass:[SDAddAddressCell class] forCellReuseIdentifier:cellIDHouseNumber];
    [tableView registerClass:[SDConsigneeCell class] forCellReuseIdentifier:consigneeCellID];
    [tableView registerClass:[SDAddressTypeCell class] forCellReuseIdentifier:typeCellID];
    [tableView registerClass:[SDDefaultAddressCell class] forCellReuseIdentifier:defaultCellID];
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kTopHeight);
        make.left.and.right.and.bottom.mas_equalTo(0);
    }];
}

- (void)setupUserInfo {
    if (self.addressModel) {
        self.tempAddrModel = self.addressModel;
        [self.tableView reloadData];
    }
}

- (BOOL)checkLegalWithText:(NSString *)text {
    NSString *regex = @"^[\u4e00-\u9fa5_a-zA-Z0-9_]{1,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:text];
}

/** 刷新地址管理页面 */
- (void)refreshAddrMgrWithType:(int)type {
    if (self.block) {
        self.block(self.addressModel, type);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotifiAddressUpdate object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - action
- (void)saveAddressClick {
    [SDStaticsManager umEvent:kaddress_save];
    NSString *name = self.nameTextField.text;
    NSString *mobile = self.mobileTextField.text;
    NSString *address = self.addressTextField.text;
    NSString *houseNumer = self.houseNumerTextField.text;
    if ([name isEmpty]) {
        [SDToastView HUDWithWarnString:@"请填写收货人"];
        return;
    }
    if ([mobile isEmpty]) {
        [SDToastView HUDWithWarnString:@"请填写联系电话"];
        return;
    }
    if (![mobile isPhoneNumber]) {
        [SDToastView HUDWithWarnString:@"请填写正确的联系电话"];
        return;
    }
    
    if (!address || address.length == 0) {
        [SDToastView HUDWithWarnString:@"请选择收货地址"];
        return;
    }
    if ([houseNumer isEmpty]) {
        [SDToastView HUDWithWarnString:@"请填写楼号门牌"];
        return;
    }
    
    BOOL legalName = [self checkLegalWithText:name];
    if (!legalName) {
        [SDToastView HUDWithWarnString:@"收货人请输入20个以下的汉字、数字和英文"];
        return;
    }

    if (houseNumer.length > 30 ) {
        [SDToastView HUDWithWarnString:@"楼号门牌不超过30个字符"];
        return;
    }
    
    self.addressModel.name = name;
    self.addressModel.mobile = mobile;
    self.addressModel.house_number = houseNumer;
    self.addressModel.is_default = self.defaultAddrSwitch.on;

    if (self.isUpdate) {
        [self updateAddrNetwork];
        return;
    }
    [self addAddressNetwork];
}

- (void)deleteAddressClick {
    [self deleteAddrNetWork];
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

- (void)addAddressNetwork {
    SDAddAddressRequest *request = [[SDAddAddressRequest alloc] init];
    request.addressModel = self.addressModel;
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof SDAddAddressRequest * _Nonnull request) {
        [SDToastView HUDWithSuccessString:@"地址已保存"];
        if ([request.addrId isNotEmpty]) {
            self.addressModel.addrId = request.addrId;
            self.addressModel.fullAddr = request.fullAddress;
        }
        [self refreshAddrMgrWithType:SDAddrStatusTypeAdd];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SDToastView HUDWithErrString:@"地址保存失败，请重新设置"];
    }];
}

- (void)updateAddrNetwork {
    SDUpdateAddrRequest *request = [[SDUpdateAddrRequest alloc] init];
    request.addressModel = self.addressModel;
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SDToastView HUDWithSuccessString:@"地址已保存"];
        [self refreshAddrMgrWithType:SDAddrStatusTypeUpdate];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.navigationController popViewControllerAnimated:YES];
        [SDToastView HUDWithErrString:@"地址保存失败，请重新设置"];
    }];
}

- (void)deleteAddrNetWork {
    SDDelAddrReqeust *request = [[SDDelAddrReqeust alloc] init];
    request.addrId = self.addressModel.addrId;
    [SDToastView show];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SDToastView HUDWithSuccessString:@"地址已删除"];
        [self refreshAddrMgrWithType:SDAddrStatusTypeDelete];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [SDToastView HUDWithErrString:@"地址删除失败，请重新设置"];

    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionArr = self.dataArr[section];
    return sectionArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) { // 收货人
        SDConsigneeCell *cell = [tableView dequeueReusableCellWithIdentifier:consigneeCellID];
        SD_WeakSelf
        cell.block = ^(NSString * _Nonnull sex) {
            SD_StrongSelf
            self.addressModel.sex = sex;
        };
        self.nameTextField = cell.contentTextField;
        if (self.tempAddrModel) {
            cell.sex = self.addressModel.sex;
            cell.contentTextField.text = self.addressModel.name;
        }
        return cell;
    }else if (indexPath.section == 1 && indexPath.row == 2) { // 设为默认地址
        SDDefaultAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
        self.defaultAddrSwitch = cell.defaultAddressSwitch;
        if (self.tempAddrModel) {
            cell.defaultAddressSwitch.on = self.tempAddrModel.is_default;
        }
        
        return cell;
    }else if (indexPath.section == 1 && indexPath.row == 3) { // 地址类型
        SDAddressTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:typeCellID];
        SD_WeakSelf
        cell.block = ^(NSString * _Nonnull type) {
            SD_StrongSelf
            self.addressModel.type = type;
        };
        if (self.tempAddrModel) {
            cell.type = self.tempAddrModel.type;
            self.tempAddrModel = nil;
        }
        return cell;
    }else if (indexPath.section == 1 && indexPath.row == 0) { // 收货地址
        SDChooseAddrCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDAddress];
        cell.contentTextField.userInteractionEnabled = NO;
        cell.contentTextField.delegate = self;
        cell.contentTextField.font = [UIFont fontWithName:kSDPFBoldFont size:12];
        cell.contentTextField.textAlignment = NSTextAlignmentRight;
        self.addressTextField = cell.contentTextField;
        if (self.tempAddrModel) {
            cell.contentTextField.text = self.tempAddrModel.sketch;
        }else if ([self.address isNotEmpty]) {
            cell.contentTextField.text = self.address;
        }
        return cell;
    }
    
    SDAddAddressCell *cell;
    if (indexPath.section == 0 && indexPath.row == 1) { // 联系电话
        cell = [tableView dequeueReusableCellWithIdentifier:cellIDMobile];
        cell.contentTextField.keyboardType = UIKeyboardTypePhonePad;
        self.mobileTextField = cell.contentTextField;
        if (self.tempAddrModel) {
            cell.contentTextField.text = self.tempAddrModel.mobile;
        }
    }else if (indexPath.section == 1 && indexPath.row == 1)  { // 楼号门牌
        cell = [tableView dequeueReusableCellWithIdentifier:cellIDHouseNumber];
        self.houseNumerTextField = cell.contentTextField;
        if (self.tempAddrModel) {
            cell.contentTextField.text = self.tempAddrModel.house_number;
        }
    }
    NSArray *sectionArr = self.dataArr[indexPath.section];
    SDAddAddressModel *model = sectionArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        [SDStaticsManager umEvent:kaddress_poi_search];
        SDAddressSearchViewController *vc = [[SDAddressSearchViewController alloc] init];
        vc.province = self.addressModel.province;
        vc.city = self.addressModel.city;
        vc.cityArr = self.cityArr;
        SD_WeakSelf
        vc.block = ^(AMapPOI * _Nonnull poi, NSString * _Nonnull address) {
            SD_StrongSelf
            self.addressModel.province = poi.province;
            self.addressModel.city = poi.city;
            self.addressModel.county = poi.district;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 110;
    }
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return [[UIView alloc] init];
    }
    UIView *footerView = [[UIView alloc] init];
    [footerView addSubview:self.saveAddressBtn];
    self.saveAddressBtn.frame = CGRectMake(15, 25, SCREEN_WIDTH - 15 * 2, 44);
    
    if (self.isUpdate) {
        [footerView addSubview:self.deleteAddressBtn];
        self.deleteAddressBtn.frame = CGRectMake(15, 44 + 10 + 25, SCREEN_WIDTH - 15 * 2, 44);
    }
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0.001;
    }
    if (self.isUpdate) {
        return 25 * 2 + 44 * 2 + 10;
    }
    return 25 * 2 + 44;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.view endEditing:YES];
    
    return NO;
}

#pragma mark - lazy
- (NSArray *)dataArr {
    if(!_dataArr) {
        NSArray *firstArr = @[@{@"title" : @"收 货 人", @"placeholder" : @"请输入收货人姓名"},
                              @{@"title" : @"联系电话", @"placeholder" : @"请输入收货人手机号", @"hiddenBottomLine" : @YES}
                              ];
        NSArray *secondArr = @[@{@"title" : @"收货地址", @"placeholder" : @"请选择您的收货地址"},
                               @{@"title" : @"楼号门牌", @"placeholder" : @"楼号/单元/门牌号"},
                               @{@"title" : @"设为默认地址", @"placeholder" : @""},
                               @{@"title" : @"地址类型", @"placeholder" : @""},
                              ];
//        @{@"title" : @"所在地区", @"placeholder" : @"请选择您的收货城市"}
        NSArray *tempArr = @[firstArr, secondArr];
        _dataArr = [SDAddAddressModel mj_objectArrayWithKeyValuesArray:tempArr];
    }
    return _dataArr;
}

- (UIButton *)saveAddressBtn {
    if (!_saveAddressBtn) {
        _saveAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveAddressBtn setTitle:@"保存地址" forState:UIControlStateNormal];
        [_saveAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveAddressBtn setCornerRadius:22];
        _saveAddressBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        _saveAddressBtn.backgroundColor = [UIColor colorWithHexString:kSDGreenTextColor];
        [_saveAddressBtn addTarget:self action:@selector(saveAddressClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveAddressBtn;
}

- (UIButton *)deleteAddressBtn {
    if (!_deleteAddressBtn) {
        _deleteAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteAddressBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deleteAddressBtn setCornerRadius:22];
        _deleteAddressBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
        _deleteAddressBtn.backgroundColor = [UIColor colorWithHexString:kSDRedTextColor];
        [_deleteAddressBtn addTarget:self action:@selector(deleteAddressClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteAddressBtn;
}

- (SDAddressModel *)addressModel {
    if (!_addressModel) {
        _addressModel = [[SDAddressModel alloc] init];
    }
    return _addressModel;
}

- (NSArray *)cityArr {
    if (!_cityArr) {
        _cityArr = [NSArray array];
    }
    return _cityArr;
}

@end
