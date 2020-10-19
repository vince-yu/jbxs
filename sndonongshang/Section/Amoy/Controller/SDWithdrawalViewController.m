//
//  SDWithdrawalViewController.m
//  sndonongshang
//
//  Created by SNQU on 2019/1/15.
//  Copyright © 2019 SNQU. All rights reserved.
//

#import "SDWithdrawalViewController.h"
#import "SDBrokerageDataManager.h"

@interface SDWithdrawalViewController () <UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UITextField *amountTextField;
@property (nonatomic, weak) UIButton *submitBtn;
@property (nonatomic, assign) BOOL isHaveDian;
@property (nonatomic, assign) BOOL isFirstZero;
@end

@implementation SDWithdrawalViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self initSubView];
}

- (void)initNav {
    self.navigationItem.title = @"提现";
    UIImage *leftImage = [[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(closeBtnClick)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)initSubView {
    self.view.backgroundColor = [UIColor colorWithRGB:0xf5f5f7];
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGRect frame = CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.backgroundColor = [UIColor colorWithRGB:0xf5f5f7];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
//    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(SCREEN_WIDTH);
//        make.left.and.bottom.mas_equalTo(0);
//        make.top.mas_equalTo(kTopHeight);
//    }];
    
    [self initTopView];
    [self initMiddleView];
    [self initBottomView];
}

- (void)initTopView {
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:topView];
    
    UIImageView *wechatIv = [[UIImageView alloc] init];
    wechatIv.image = [UIImage imageNamed:@"mine_wechat"];
    [topView addSubview:wechatIv];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"微信账号";
    titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:16];
    titleLabel.textColor = [UIColor colorWithRGB:0x31302E];
    [topView addSubview:titleLabel];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = [SDUserModel sharedInstance].nickname;
    nameLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
    nameLabel.textColor = [UIColor colorWithHexString:kSDGrayTextColor];
    [topView addSubview:nameLabel];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(80);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.left.mas_equalTo(0);
    }];
    
    [wechatIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(49, 49));
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(topView);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(wechatIv.mas_right).mas_equalTo(27);
        make.top.mas_equalTo(wechatIv).mas_equalTo(6);
        make.height.mas_equalTo(14);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel);
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_equalTo(10);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(15);
    }];
}

- (void)initMiddleView {
    UIView *middleView = [[UIView alloc] init];
    middleView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:middleView];
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.height.mas_equalTo(123);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.left.mas_equalTo(0);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"提现金额";
    titleLabel.textColor = [UIColor colorWithHexString:kSDSecondaryTextColor];
    titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:14];
    [middleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(14);
    }];
    
    UILabel *signLabel = [[UILabel alloc] init];
    signLabel.text = @"￥";
    signLabel.font = [UIFont fontWithName:kSDPFBoldFont size:25];
    signLabel.textColor = [UIColor colorWithRGB:0x131413];
    [middleView addSubview:signLabel];
    [signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_equalTo(10);
    }];
    
    UITextField *amountTextField = [[UITextField alloc] init];
    self.amountTextField = amountTextField;
    self.amountTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.amountTextField.delegate = self;
    self.amountTextField.font = [UIFont fontWithName:kSDPFBoldFont size:25];
    self.amountTextField.textColor = [UIColor colorWithRGB:0x131413];
    [self.amountTextField addTarget:self action:@selector(textLengthChange:) forControlEvents:UIControlEventEditingChanged];
    [middleView addSubview:amountTextField];
    [amountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(signLabel);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:kSDSeparateLineClolor];
    [middleView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(signLabel.mas_bottom).mas_equalTo(10);
        make.height.mas_equalTo(0.5);
    }];
    
//    UIButton *allWithdrawButton = [[UIButton alloc] init];
//    [allWithdrawButton setTitle:@"全部提现" forState:UIControlStateNormal];
//    [allWithdrawButton setTitleColor:[UIColor colorWithHexString:kSDGreenTextColor] forState:UIControlStateNormal];
//    allWithdrawButton.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:12];
//    [allWithdrawButton addTarget:self action:@selector(allWithdrawBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [middleView addSubview:allWithdrawButton];
//    [allWithdrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(40);
//        make.width.mas_equalTo(78);
//        make.bottom.and.right.mas_equalTo(0);
//    }];
    
    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.text = [NSString stringWithFormat:@"可提现金额%@元", [[SDBrokerageDataManager sharedInstance].brokerageModel.brokerage priceStr]];
    amountLabel.font = [UIFont fontWithName:kSDPFMediumFont size:12];
    amountLabel.textColor = [UIColor colorWithHexString:kSDGrayTextColor];
    [middleView addSubview:amountLabel];
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(15);
//        make.right.mas_equalTo(allWithdrawButton.mas_left);
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(0);
    }];
    
}

- (void)initBottomView {
    UIButton *submitBtn = [[UIButton alloc] init];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont fontWithName:kSDPFMediumFont size:16];
    submitBtn.backgroundColor = [UIColor colorWithHexString:kSDGrayTextColor];
    submitBtn.layer.masksToBounds = YES;
    submitBtn.layer.cornerRadius = 22.5;
    submitBtn.userInteractionEnabled = NO;
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.submitBtn = submitBtn;
    [self.scrollView addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(249);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(SCREEN_WIDTH - 15 * 2);
        make.height.mas_equalTo(45);
    }];
    
    NSString *tipsStr =  @"注意：\n1.最低提现金额为100元。 \n2.申请成功后会有2-3天审核时间。 \n3.申请审核通过后，会在2-7个工作日内到你的账户。\n4.为保障账户安全每天只能提现两次，每次最高500元。";
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:tipsStr];
    text.yy_color = [UIColor colorWithHexString:kSDSecondaryTextColor];
    text.yy_font = [UIFont fontWithName:kSDPFMediumFont size:12];
    text.yy_backgroundColor = [UIColor redColor];
    if (iPhone5 || iPhone4) {
        text.yy_font = [UIFont fontWithName:kSDPFMediumFont size:11];
    }
    text.yy_lineSpacing = 12;
    YYTextLinePositionSimpleModifier *modifier = [YYTextLinePositionSimpleModifier new];
    modifier.fixedLineHeight = 12;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(SCREEN_WIDTH - 20 * 2, 150);
//    container.linePositionModifier = modifier;
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:text];
    YYLabel *tipsLabel = [[YYLabel alloc] init];
    tipsLabel.numberOfLines = 0;
//    tipsLabel.attributedText = text;
//    tipsLabel.linePositionModifier = modifier;
    tipsLabel.size = layout.textBoundingSize;
    tipsLabel.textLayout = layout;
    [self.scrollView addSubview:tipsLabel];
   
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(submitBtn.mas_bottom).mas_equalTo(30);
        make.width.mas_equalTo(SCREEN_WIDTH - 20 * 2);
        make.height.mas_equalTo(150);
    }];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(tipsLabel.frame) + 100);
}

- (BOOL)onlyInputTheNumber:(NSString*)string{
    NSString *numString =@"[0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numString];
    BOOL inputString = [predicate evaluateWithObject:string];
    return inputString;
}
#pragma mark - aciton
- (void)allWithdrawBtnClick {
    NSString *brokerage = [SDBrokerageDataManager sharedInstance].brokerageModel.brokerage;
    if ([brokerage floatValue] > 500) {
        self.amountTextField.text = @"500.00";
    }else {
        self.amountTextField.text = [[SDBrokerageDataManager sharedInstance].brokerageModel.brokerage priceStr];
    }
    [self textLengthChange:self.amountTextField];
}

- (void)submitBtnClick {
    [SDStaticsManager umEvent:kwithdrawal_submit];
    NSString *amount = self.amountTextField.text;
    if ([amount isEmpty]) {
        return;
    }
    
    [SDBrokerageDataManager applyWithdrawWithAmount:amount completeBlock:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failedBlock:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];

}

- (void)closeBtnClick {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.amountTextField) {
        
        if ([textField.text rangeOfString:@"."].location==NSNotFound) {
            _isHaveDian = NO;
        }
        if ([textField.text rangeOfString:@"0"].location==NSNotFound) {
            _isFirstZero = NO;
        }
        
        if ([string length]>0)
        {
            unichar single=[string characterAtIndex:0];//当前输入的字符
            if ((single >='0' && single<='9') || single=='.')//数据格式正确
            {
                
                if([textField.text length]==0){
                    if(single == '.'){
                        //首字母不能为小数点
                        return NO;
                    }
                    if (single == '0') {
                        _isFirstZero = YES;
                        return YES;
                    }
                }
                
                if (single=='.'){
                    if(!_isHaveDian)//text中还没有小数点
                    {
                        _isHaveDian=YES;
                        return YES;
                    }else{
                        return NO;
                    }
                }else if(single=='0'){
                    if ((_isFirstZero&&_isHaveDian)||(!_isFirstZero&&_isHaveDian)) {
                        //首位有0有.（0.01）或首位没0有.（10200.00）可输入两位数的0
                        if([textField.text isEqualToString:@"0.0"]){
                            return NO;
                        }
                        NSRange ran=[textField.text rangeOfString:@"."];
                        int tt=(int)(range.location-ran.location);
                        if (tt <= 2){
                            return YES;
                        }else{
                            return NO;
                        }
                    }else if (_isFirstZero&&!_isHaveDian){
                        //首位有0没.不能再输入0
                        return NO;
                    }else{
                        return YES;
                    }
                }else{
                    if (_isHaveDian){
                        //存在小数点，保留两位小数
                        NSRange ran=[textField.text rangeOfString:@"."];
                        int tt= (int)(range.location-ran.location);
                        if (tt <= 2){
                            return YES;
                        }else{
                            return NO;
                        }
                    }else if(_isFirstZero&&!_isHaveDian){
                        //首位有0没点
                        return NO;
                    }else{
                        return YES;
                    }
                }
            }else{
                //输入的数据格式不正确
                return NO;
            }
        }else{
            return YES;
        }
    }
    return YES;
}

- (void)textLengthChange:(UITextField *)textField{
    if (!textField) return;
    NSString *brokerage = [SDBrokerageDataManager sharedInstance].brokerageModel.brokerage;
    CGFloat maxAmount = [brokerage floatValue];
    if (maxAmount > 500) {
        maxAmount = 500;
    }
    CGFloat mixAmount = 100;
    CGFloat amount = [textField.text floatValue];
    UITextRange *selectedRange = [textField markedTextRange];
    NSInteger markedTextLength = [textField offsetFromPosition:selectedRange.start toPosition:selectedRange.end];
    if (markedTextLength == 0) {
        if (amount > maxAmount || amount < mixAmount) {
            self.submitBtn.backgroundColor =  [UIColor colorWithHexString:kSDGrayTextColor];
            self.submitBtn.userInteractionEnabled = NO;
            if (amount > maxAmount) {
                if (maxAmount < mixAmount) {
                    textField.text = brokerage;
                    self.submitBtn.backgroundColor =  [UIColor colorWithHexString:kSDGrayTextColor];
                    self.submitBtn.userInteractionEnabled = NO;
                    return;
                }
                textField.text = brokerage;
                if ([brokerage floatValue] > 500) {
                    textField.text = @"500.00";
                }
                self.submitBtn.backgroundColor =  [UIColor colorWithHexString:kSDGreenTextColor];
                self.submitBtn.userInteractionEnabled = YES;
            }
        }else {
            self.submitBtn.backgroundColor =  [UIColor colorWithHexString:kSDGreenTextColor];
            self.submitBtn.userInteractionEnabled = YES;
        }
    }
    
}

#pragma mark - lazy


@end
