//
//  BTNewAddRecordViewController.m
//  BT
//
//  Created by admin on 2018/5/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTNewAddRecordViewController.h"
#import "HSDatePickerVC.h"
#import "CurrentcyModel.h"
#import "LYLOptionPicker.h"
#import "LYLDatePicker.h"
#import "AddBookKeepingRequest.h"
#import "UpdateBookKeepingRequest.h"
#import "BTRecordModel.h"
#import "AddRecordNavView.h"
#import "JJSSQCell.h"

#import "MenuHrizontal.h"
#import "BTShowLoading.h"

@interface BTNewAddRecordViewController ()<UITextFieldDelegate,UITextViewDelegate,HSDatePickerVCDelegate,UITableViewDelegate,UITableViewDataSource,MenuHrizontalDelegate>{
    
    NSString *_jydStr;
    NSString *_rqStr;
    NSString *_priceStr;
    NSString *_numberStr;
    NSString *_priceTypeStr;
    NSString *_beizhuStr;
    NSString *_jysStr;
    NSString *_walletStr;
    NSString *_exchangeCodeStr;
    BOOL      _isMROrMC;
    BOOL      _isJYDOrBZ;
    BOOL      _isJYSOrQB;
}

@property (weak, nonatomic) IBOutlet UILabel *bzL;
@property (weak, nonatomic) IBOutlet BTButton *mairuBtn;
@property (weak, nonatomic) IBOutlet BTButton *maichuBtn;
@property (weak, nonatomic) IBOutlet BTTextField *numberTF;
@property (weak, nonatomic) IBOutlet BTTextField *priceTF;
@property (weak, nonatomic) IBOutlet BTButton *priceTypeBtn;
@property (weak, nonatomic) IBOutlet BTButton *priceTypeBtn2;
@property (weak, nonatomic) IBOutlet BTButton *jysBtn;
@property (weak, nonatomic) IBOutlet BTButton *walletBtn;
@property (weak, nonatomic) IBOutlet BTLabel *jysOrWalletL;
@property (weak, nonatomic) IBOutlet BTButton *Btn1;
@property (weak, nonatomic) IBOutlet BTButton *Btn2;
@property (weak, nonatomic) IBOutlet BTLabel *timeL;
@property (weak, nonatomic) IBOutlet BTLabel *timeTypeL;
@property (weak, nonatomic) IBOutlet BTButton *jysOrQBBtn;
@property (weak, nonatomic) IBOutlet BTLabel *placeL;
@property (weak, nonatomic) IBOutlet UITextView *bzTV;
@property (weak, nonatomic) IBOutlet UIButton *bzBtn;
@property (weak, nonatomic) IBOutlet UIButton *downBtn1;
@property (weak, nonatomic) IBOutlet UIButton *downBtn2;

@property (nonatomic, strong) MenuHrizontal *menuBtn;
@property (strong, nonatomic) IBOutlet UIView *mScrollView;


@property (nonatomic, assign) NSString *bzStr;
@property (nonatomic, assign) BOOL isHaveDian;
@property (nonatomic, assign) BOOL isFirstZero;
@property (nonatomic, strong) BTRecordModel *editModel;
@property (nonatomic,strong)  AddRecordNavView *navView;
@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) BOOL isShouquandaoru;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollTopContraint;
@property (nonatomic, strong) NSDictionary *params;


@end

@implementation BTNewAddRecordViewController
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSNotification_chooseJYDSuccess
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSNotification_ChooseJYS
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSNotification_PasteSuccess
                                                  object:nil];
}
+ (id)createWithParams:(NSDictionary *)params{
    BTNewAddRecordViewController *vc = [[BTNewAddRecordViewController alloc] init];
    vc.params = params;
    vc.bzStr     = [params objectForKey:@"kind"];
    vc.editModel = [params objectForKey:@"model"];
    
    if([[params objectForKey:@"isShouquandaoru"] boolValue]){
        vc.isShouquandaoru = YES;
    }
    
    return vc;
}
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.mTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self.downBtn1 setImage:[UIImage imageNamed:@"Shape"] forState:UIControlStateNormal];
     [self.downBtn2 setImage:[UIImage imageNamed:@"Shape"] forState:UIControlStateNormal];
    _rqStr        = @"";
    _priceStr     = @"";
    _numberStr    = @"";
    _beizhuStr    = @"";
    _jysStr       = @"";
    _walletStr    = @"";
    _jydStr       = @"CNY";
    _priceTypeStr = [APPLanguageService wyhSearchContentWith:@"danjia"];
    _isMROrMC     = YES;
    _isJYSOrQB    = YES;
    _isJYDOrBZ    = YES;
    _exchangeCodeStr = @"";
    _priceTF.delegate = self;
    _numberTF.delegate = self;
    _bzTV.delegate = self;
    self.title = [APPLanguageService wyhSearchContentWith:@"tianjiajilu"];
    ViewBorderRadius(self.mairuBtn, 14, 0.5, [UIColor colorWithHexString:@"108ee9"]);
    self.mairuBtn.backgroundColor = [UIColor colorWithHexString:@"108ee9"];
    ViewBorderRadius(self.maichuBtn, 14, 0.5, [UIColor colorWithHexString:@"151419"]);
    self.maichuBtn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.jysOrQBBtn.localTitle = @"jiaoyisuobeizhu";
    
    [self.dataArray addObjectsFromArray:@[@"币安 binance",@"火币pro huobi.pro",@"OKEx okex"]];
    [self loadEditUI];
    [self addNavigationItemWithTitles:@[[APPLanguageService wyhSearchContentWith:@"sava"]] isLeft:NO target:self action:@selector(saveBtnClick:) tags:@[@(123)] whereVC:@"保存"];
    //获取通知中心单例对象
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNSNotificationChooseJYDSuccess:) name:NSNotification_chooseJYDSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseJYS:) name:NSNotification_ChooseJYS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pasteSuccess:) name:NSNotification_PasteSuccess object:nil];
    //self.navigationItem.titleView = self.navView;
    
    self.mScrollView.backgroundColor = isNightMode?ViewContentBgColor:CWhiteColor;
   
    
    //授权导入
    if (self.isShouquandaoru) {
        [self.view addSubview:self.mTableView];
        [self.mTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        self.mTableView.hidden = NO;
        [self.view bringSubviewToFront:self.mTableView];
        [AnalysisService alaysisMY_Asset_Authorization_import];
        self.navigationItem.rightBarButtonItem = nil;
        self.title = [APPLanguageService wyhSearchContentWith:@"shouquandaoru"];
    }else{
        if(SAFESTRING([self.params objectForKey:@"isDetail"]).length){
            //添加头部切换menu
            [self.view addSubview:self.menuBtn];
            [self.menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self.view);
                make.height.mas_equalTo(36.0f);
            }];
            self.mTableView.hidden = YES;
            _menuBtn.lineBtnArr =@[@{@"name": [APPLanguageService wyhSearchContentWith:@"mairu"]},@{@"name":[APPLanguageService wyhSearchContentWith:@"maichu"]}];
            [_menuBtn clickButtonAtIndex:0];
            
        }else{
            //添加头部切换menu
            [self.view addSubview:self.menuBtn];
            [self.menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self.view);
                make.height.mas_equalTo(36.0f);
            }];
            [self.view addSubview:self.mTableView];
            self.mTableView.hidden = YES;
            _menuBtn.lineBtnArr =@[@{@"name": [APPLanguageService wyhSearchContentWith:@"mairu"]},@{@"name":[APPLanguageService wyhSearchContentWith:@"maichu"]},@{@"name": [APPLanguageService wyhSearchContentWith:@"shouquandaoru"]}];
            [_menuBtn clickButtonAtIndex:0];
        }
    }
}

-(void)loadEditUI {
    
    if (self.editModel) {
        
        //编辑的时候隐藏 头部，不允许修改买入 卖出
        self.menuBtn.hidden = YES;
        self.scrollTopContraint.constant = 0.0;
        
        NSLog(@"%@",self.editModel.kind);
        NSArray *a = [self.editModel.kind componentsSeparatedByString:@"/"];
        _bzStr    = a[0];
        _jydStr   = a[1];
        if (ISStringEqualToString(_jydStr, @"CNY")||ISStringEqualToString(_jydStr, @"USD")) {
            _isJYDOrBZ = YES;
        } else {
            _isJYDOrBZ = NO;
        }
        [self.priceTypeBtn setTitle:_jydStr forState:UIControlStateNormal];
        if([SAFESTRING(self.editModel.buy) isEqualToString:@"1"]){//买入
            ViewBorderRadius(self.mairuBtn, 14, 0.5, [UIColor colorWithHexString:@"108ee9"]);
            self.mairuBtn.backgroundColor = [UIColor colorWithHexString:@"108ee9"];
            ViewBorderRadius(self.maichuBtn, 14, 0.5, [UIColor colorWithHexString:@"151419"]);
            self.maichuBtn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
            [self.maichuBtn setTitleColor:CFontColor8 forState:UIControlStateNormal];
            [self.mairuBtn setTitleColor:CWhiteColor forState:UIControlStateNormal];
            _isMROrMC                = YES;
            self.timeTypeL.localText = @"mairushijian";
            self.mairuBtn.enabled    = NO;
            self.maichuBtn.enabled   = NO;
        }else {//卖出
            ViewBorderRadius(self.maichuBtn, 14, 0.5, [UIColor colorWithHexString:@"108ee9"]);
            self.maichuBtn.backgroundColor = [UIColor colorWithHexString:@"108ee9"];
            ViewBorderRadius(self.mairuBtn, 14, 0.5, [UIColor colorWithHexString:@"151419"]);
            self.mairuBtn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
            [self.mairuBtn setTitleColor:CFontColor8 forState:UIControlStateNormal];
            [self.maichuBtn setTitleColor:CWhiteColor forState:UIControlStateNormal];
            _isMROrMC                = NO;
            self.timeTypeL.localText = @"maichushijian";
            self.mairuBtn.enabled    = NO;
            self.maichuBtn.enabled   = NO;
        }
        
        _numberStr     = [[DigitalHelper shareInstance] isp6DataWithDouble:self.editModel.count];
        _numberTF.text = [[DigitalHelper shareInstance] isp6DataWithDouble:self.editModel.count];;
        //单价
        _priceStr      = [[DigitalHelper shareInstance] isp8DataWithDouble:self.editModel.unitPrice];
        _isHaveDian    = YES;
        _priceTF.text  = [[DigitalHelper shareInstance] isp8DataWithDouble:self.editModel.unitPrice];
        
        _rqStr = self.editModel.recordDate;
        _timeL.text = self.editModel.recordDate;
        [self changeUIKitCollor];
        if (self.editModel.dealSource == 2) {//钱包
            
            _isJYSOrQB = NO;
            _walletStr    = self.editModel.dealSourceInfo;
            [self.Btn1 setImage:IMAGE_NAMED(@"choose") forState:UIControlStateNormal];
            [self.Btn2 setImage:IMAGE_NAMED(@"choose copy") forState:UIControlStateNormal];
            if (ISNSStringValid(_walletStr)) {
                
                //[self.jysOrQBBtn setTitle:_walletStr forState:UIControlStateNormal];
                self.jysOrQBBtn.localTitle = @"qianbaobeizhu";
                self.jysOrWalletL.text = _walletStr;
            } else {
                
                self.jysOrQBBtn.localTitle = @"qianbaobeizhu";
                self.jysOrWalletL.text = [APPLanguageService wyhSearchContentWith:@"qingxuanze"];
            }
            
        } else {
            
            _isJYSOrQB = YES;
            _jysStr    = self.editModel.dealSourceInfo;
            _exchangeCodeStr = self.editModel.dealSourceExchangeCode;
            [self.Btn1 setImage:IMAGE_NAMED(@"choose copy") forState:UIControlStateNormal];
            [self.Btn2 setImage:IMAGE_NAMED(@"choose") forState:UIControlStateNormal];
            if (ISNSStringValid(_jysStr)) {
                
                //[self.jysOrQBBtn setTitle:_jysStr forState:UIControlStateNormal];
                self.jysOrQBBtn.localTitle = @"jiaoyisuobeizhu";
                self.jysOrWalletL.text = _walletStr;
                
            } else {
                
                self.jysOrQBBtn.localTitle = @"jiaoyisuobeizhu";
                self.jysOrWalletL.text = [APPLanguageService wyhSearchContentWith:@"qingxuanze"];
            }
        }
        
        if (ISNSStringValid(SAFESTRING(self.editModel.note))) {
            
            _beizhuStr    = self.editModel.note;
            _bzTV.text    = self.editModel.note;
            self.placeL.hidden = YES;
        }
    }else{
        NSDate *date = [NSDate date];
        NSString *dateFormatter = @"yyyy-MM-dd HH:mm";
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:dateFormatter];
        NSString *dateStr = [formatter stringFromDate:date];
        _timeL.text = dateStr;
        _rqStr = dateStr;
        self.timeL.textColor = ISNSStringValid(_rqStr) ? FirstColor : ThirdColor;
    }
    if (ISNSStringValid(_bzStr)) {//从详情过来
        
        self.bzL.text = _bzStr;
        self.bzBtn.enabled = NO;
    }
    [self changeUIKitCollor];
}
//选择币种
- (IBAction)chooseBZbTN:(UIButton *)sender {
    
        NSDictionary *dic =@{@"title":@"添加收益"};
        [BTCMInstance presentViewControllerWithName:@"historySearch" andParams:dic animated:NO];
}
//买入
- (IBAction)mairuBtnClick:(BTButton *)sender {
    
    ViewBorderRadius(self.mairuBtn, 14, 0.5, [UIColor colorWithHexString:@"108ee9"]);
    self.mairuBtn.backgroundColor = [UIColor colorWithHexString:@"108ee9"];
    ViewBorderRadius(self.maichuBtn, 14, 0.5, [UIColor colorWithHexString:@"151419"]);
    self.maichuBtn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.maichuBtn setTitleColor:CFontColor8 forState:UIControlStateNormal];
    [self.mairuBtn setTitleColor:CWhiteColor forState:UIControlStateNormal];
    _isMROrMC        = YES;
    self.timeTypeL.localText = @"mairushijian";
    
}
//卖出
- (IBAction)maichuBtnClick:(BTButton *)sender {
    
    ViewBorderRadius(self.maichuBtn, 14, 0.5, [UIColor colorWithHexString:@"108ee9"]);
    self.maichuBtn.backgroundColor = [UIColor colorWithHexString:@"108ee9"];
    ViewBorderRadius(self.mairuBtn, 14, 0.5, [UIColor colorWithHexString:@"151419"]);
    self.mairuBtn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [self.mairuBtn setTitleColor:CFontColor8 forState:UIControlStateNormal];
    [self.maichuBtn setTitleColor:CWhiteColor forState:UIControlStateNormal];
    _isMROrMC        = NO;
    self.timeTypeL.localText = @"maichushijian";
}
//选择用什么买入或卖出
- (IBAction)priceBtnClick1:(BTButton *)sender {
    
    [self resignFirstResponderUI];
    [LYLOptionPicker showOptionPickerInView:[[[UIApplication sharedApplication] delegate] window] dataSource:@[@[@"CNY",@"USD",@"BTC",@"ETH",@"USDT"]] determineChoose:^(NSArray *indexes, NSArray *selectedItems) {
        
        NSLog(@"%@,%@",indexes[0],selectedItems[0]);
        _jydStr = selectedItems[0];
        if (ISStringEqualToString(_jydStr, @"CNY")||ISStringEqualToString(_jydStr, @"USD")) {
            
            _isJYDOrBZ = YES;
            
        } else {
            
           _isJYDOrBZ = NO;
        }
        [self.priceTypeBtn setTitle:selectedItems[0] forState:UIControlStateNormal];
    }];
}
//选择总计还是单价
- (IBAction)priceBtnClick2:(BTButton *)sender {
    
    [self resignFirstResponderUI];
    [LYLOptionPicker showOptionPickerInView:[[[UIApplication sharedApplication] delegate] window] dataSource:@[@[[APPLanguageService wyhSearchContentWith:@"zongjia"],[APPLanguageService wyhSearchContentWith:@"danjia"]]] determineChoose:^(NSArray *indexes, NSArray *selectedItems) {
        
        NSLog(@"%@,%@",indexes[0],selectedItems[0]);
        _priceTypeStr = selectedItems[0];
        [self.priceTypeBtn2 setTitle:selectedItems[0] forState:UIControlStateNormal];
    }];
}
//买入时间
- (IBAction)timeBtnClick:(UIButton *)sender {
    
    [self resignFirstResponderUI];
    HSDatePickerVC *vc = [[HSDatePickerVC alloc] init];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - HSDatePickerVCDelegate
- (void)datePicker:(HSDatePickerVC*)datePicker
          withYear:(NSString *)year
             month:(NSString *)month
               day:(NSString *)day hour:(NSString *)hour minute:(NSString *)minute
{
    NSLog(@"选择了   %@--%@--%@",year,month,day);
    _rqStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hour,minute];
    _timeL.text = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hour,minute];
    [self changeUIKitCollor];
    //_timeL.textColor = CFontColor3;
}
//交易所
- (IBAction)chooseJJSBtnClick:(BTButton *)sender {
    
    _isJYSOrQB = YES;
    [self.Btn1 setImage:IMAGE_NAMED(@"choose copy") forState:UIControlStateNormal];
    [self.Btn2 setImage:IMAGE_NAMED(@"choose") forState:UIControlStateNormal];
    if (ISNSStringValid(_jysStr)) {
        
      //[self.jysOrQBBtn setTitle:_jysStr forState:UIControlStateNormal];
        self.jysOrQBBtn.localTitle = @"jiaoyisuobeizhu";
        self.jysOrWalletL.text = _jysStr;
        
    } else {
        
        self.jysOrQBBtn.localTitle = @"jiaoyisuobeizhu";
        self.jysOrWalletL.text = [APPLanguageService wyhSearchContentWith:@"qingxuanze"];
    }
    [self changeUIKitCollor];
}
//钱包
- (IBAction)chooseQBBtnClick:(BTButton *)sender {
    
    _isJYSOrQB = NO;
    [self.Btn1 setImage:IMAGE_NAMED(@"choose") forState:UIControlStateNormal];
    [self.Btn2 setImage:IMAGE_NAMED(@"choose copy") forState:UIControlStateNormal];
    if (ISNSStringValid(_walletStr)) {
        
        //[self.jysOrQBBtn setTitle:_walletStr forState:UIControlStateNormal];
        self.jysOrQBBtn.localTitle = @"qianbaobeizhu";
        self.jysOrWalletL.text = _walletStr;
        
    } else {
        
        self.jysOrQBBtn.localTitle = @"qianbaobeizhu";
        self.jysOrWalletL.text = [APPLanguageService wyhSearchContentWith:@"qingxuanze"];
    }
    [self changeUIKitCollor];
}
//选择交易所或者钱包跳转
- (IBAction)chooseJYSOrQBClick:(BTButton *)sender {
    
    if (_isJYSOrQB) {//选择交易所
        
        NSDictionary *dic =@{@"title":@"xianhuo"};
        [AnalysisService alaysisExchange_search];
        [BTCMInstance presentViewControllerWithName:@"historySearch" andParams:dic animated:NO];
        
    } else {//填写钱包
        
        [BTCMInstance pushViewControllerWithName:@"BTChooseWallet" andParams:nil];
    }
}
//保存
-(void)saveBtnClick:(UIButton *)btn {
    
    [self resignFirstResponderUI];
     //UIButton *savaBtn = (UIButton *)[self.view viewWithTag:(123)];
    
    if (ISNSStringValid(_bzStr)&&ISNSStringValid(_rqStr)&&ISNSStringValid(_priceStr)&&ISNSStringValid(_numberStr)) {
    
        btn.enabled = NO;
        
        NSString *dealSourceInfo;
        if (ISNSStringValid(_exchangeCodeStr)&&ISNSStringValid(_walletStr)) {
            
            if (_isJYSOrQB) {
                
                dealSourceInfo = _exchangeCodeStr;
            } else {
                
                dealSourceInfo = _walletStr;
            }
        } else if (!ISNSStringValid(_exchangeCodeStr)&&!ISNSStringValid(_walletStr)){
            dealSourceInfo = @"";
        }else {
            
            if (ISNSStringValid(_exchangeCodeStr)) {
                
                if (_isJYSOrQB) {
                    
                   dealSourceInfo = _exchangeCodeStr;
                } else {
                    dealSourceInfo = @"";
                }
            }
            if (ISNSStringValid(_walletStr)) {
              
                if (!_isJYSOrQB) {
                   
                    dealSourceInfo = _walletStr;
                } else {
                    dealSourceInfo = @"";
                }
            }
        }
        
        //单价 限制最多为20万
        if(!ISStringEqualToString(_priceTypeStr, [APPLanguageService wyhSearchContentWith:@"zongjia"])){
            
            double price  = [_priceStr doubleValue];
            if(price >200000){
                [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"danjiabufuhe"] wait:YES];
                btn.enabled = YES;
                return;
            }
        }
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *date = [dateFormatter dateFromString:_rqStr];
        NSComparisonResult result = [date compare:[self getCurrentTime]];
        if(result == NSOrderedDescending){
            [MBProgressHUD showMessageIsWait:[APPLanguageService sjhSearchContentWith:@"timebufuhe"] wait:YES];
            btn.enabled = YES;
            return;
        }
        
        
        //法币类型
        NSInteger legalType ;
        NSString *kind;
        if(ISStringEqualToString(_jydStr, @"CNY")){
            legalType = 1;
            kind =_bzStr;
        }else if(ISStringEqualToString(_jydStr, @"USD")){
            legalType = 2;
            kind = _bzStr;
        }else{
            legalType = 0;
            kind = [NSString stringWithFormat:@"%@/%@",_bzStr,_jydStr];
        }
        
        

        if (self.editModel) {
            [BTShowLoading show];
            UpdateBookKeepingRequest *api = [[UpdateBookKeepingRequest alloc] initWithBuy:_isMROrMC currency:_isJYDOrBZ dealCount:_numberStr dealDate:_rqStr dealTotal:ISStringEqualToString(_priceTypeStr, [APPLanguageService wyhSearchContentWith:@"zongjia"])?_priceStr:@"0" dealUnitPrice:ISStringEqualToString(_priceTypeStr, [APPLanguageService wyhSearchContentWith:@"zongjia"])?@"0":_priceStr kind:kind legalType:legalType note:self.bzTV.text dealSource:_isJYSOrQB?1:2 dealSourceInfo:dealSourceInfo bookkeepingId:self.editModel.bookkeepingId.integerValue];
            api.isShowMessage = YES;
            [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
                [BTShowLoading hide];
                [AnalysisService alaysisIncome_add_succesd];
                [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"success"] wait:YES];
                [getUserCenter shareSuccseGetTanLiWithType:7 withTime:2];
                //发送通知 回到上一个页面的时候刷新数据 保持数据准确
               
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [BTCMInstance popViewController:nil];
                });
                [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_addJYTJSuccess object:nil userInfo:nil];
                if(self.returnParamsBlock){
                    self.returnParamsBlock(nil);
                }
             //self.savaBtn.enabled = YES;
            } failure:^(__kindof BTBaseRequest *request) {
                [BTShowLoading hide];
                btn.enabled = YES;
            }];
            
        }else {
            [BTShowLoading show];
            AddBookKeepingRequest *api = [[AddBookKeepingRequest alloc] initWithBuy:_isMROrMC currency:_isJYDOrBZ dealCount:_numberStr dealDate:_rqStr dealTotal:ISStringEqualToString(_priceTypeStr, [APPLanguageService wyhSearchContentWith:@"zongjia"])?_priceStr:@"0" dealUnitPrice:ISStringEqualToString(_priceTypeStr, [APPLanguageService wyhSearchContentWith:@"zongjia"])?@"0":_priceStr kind:kind legalType:legalType note:self.bzTV.text dealSource:_isJYSOrQB?1:2 dealSourceInfo:dealSourceInfo];
            api.isShowMessage = YES;
            [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
                [BTShowLoading hide];
                [AnalysisService alaysisIncome_add_succesd];
                [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"success"] wait:YES];
                [getUserCenter shareSuccseGetTanLiWithType:7 withTime:2];
                //发送通知 回到上一个页面的时候刷新数据 保持数据准确
              
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [BTCMInstance popViewController:nil];
                });
                [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_addJYTJSuccess object:nil userInfo:nil];
                
                if(self.returnParamsBlock){
                      self.returnParamsBlock(nil);
                }
              
             
                
                //self.savaBtn.enabled = YES;
            } failure:^(__kindof BTBaseRequest *request) {
                [BTShowLoading hide];
                btn.enabled = YES;
            }];
            
        }
        
    }else {
        
        btn.enabled = YES;
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"xinxibuwanshan"] wait:YES];
    }
}
#pragma mark 接收通知
//选择币种通知
-(void)pushNSNotificationChooseJYDSuccess:(NSNotification *)notifi {
    CurrentcyModel *model = [notifi.userInfo objectForKey:@"model"];
    NSLog(@"%@",model.currencySimpleName);
    self.bzL.text = model.currencySimpleName;
    _bzStr        = model.currencySimpleName;
    [self changeUIKitCollor];
}
//选择交易所通知
-(void)chooseJYS:(NSNotification *)notifi {
    NSDictionary *dict = [notifi.userInfo objectForKey:@"dict"];
    //[self.jysOrQBBtn setTitle:dict[@"exchangeName"] forState:UIControlStateNormal];
    self.jysOrWalletL.text = dict[@"exchangeName"];
    _jysStr = dict[@"exchangeName"];
    _exchangeCodeStr = dict[@"exchangeCode"];
    [self changeUIKitCollor];
    
}
//钱包地址通知
-(void)pasteSuccess:(NSNotification *)notifi {
    //[self.jysOrQBBtn setTitle:notifi.userInfo[@"wallet"] forState:UIControlStateNormal];
    self.jysOrWalletL.text = notifi.userInfo[@"wallet"];
    _walletStr = notifi.userInfo[@"wallet"];
    [self changeUIKitCollor];
}
#pragma mark UITextViewDelegeta
//将要开始编辑是
-(void)textViewDidBeginEditing:(UITextView *)textView {
    
    self.placeL.hidden = self.bzTV.text.length > 0;
}
//正在编辑中
-(void)textViewDidChange:(UITextView *)textView {
    
    
    self.placeL.hidden = self.bzTV.text.length > 0;
    if ([self.bzTV.text length] > 100) {
        self.bzTV.text = [self.bzTV.text substringWithRange:NSMakeRange(0, 100)];
        [self.bzTV.undoManager removeAllActions];
        [self.bzTV becomeFirstResponder];
        return;
    }
}
#pragma mark UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == _priceTF) {
        
        _priceStr = textField.text;
        
    }
    if (textField == _numberTF) {
        
        _numberStr = textField.text;
    }
   
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    

    if (textField == _numberTF || textField == _priceTF) {
        
        //输入金额，只能输入数字和小数点，保留两位小数点且0放在首位
        if (range.length == 1 && string.length == 0) {
            return YES;
            
        }else if (textField.text.length >= 8&&!_isHaveDian) {
            
            textField.text = [textField.text substringToIndex:8];                return NO;
            
        }else if (textField.text.length >= 19&&_isHaveDian) {
            
            textField.text = [textField.text substringToIndex:19];                return NO;
            
        }else {
            
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
                            //                            if([textField.text isEqualToString:@"0.0"]){
                            //                                return NO;
                            //                            }
                            //能输入 很多0
                            NSRange ran=[textField.text rangeOfString:@"."];
                            int tt=(int)(range.location-ran.location);
                            
                            if (textField == _numberTF) {
                                
                                if (tt <= 6){//币的数量统一为6位小数
                                    return YES;
                                }else{
                                    return NO;
                                }
                            }else { //价格 要区分单价和总价
                                
                                //价格以法币计价
                                if (ISStringEqualToString(_jydStr, @"CNY")||ISStringEqualToString(_jydStr, @"USD")){
                                    if (tt <=2){
                                        return YES;
                                    }else{
                                        return NO;
                                    }
                                }else{
                                    if (tt <= 8){
                                        return YES;
                                    }else{
                                        return NO;
                                    }
                                }
                                
                                
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
                            
                            if (textField == _numberTF) {
                                
                                if (tt <= 6){//币的数量统一为6位小数
                                    return YES;
                                }else{
                                    return NO;
                                }
                            }else { //价格 要区分单价和总价
                                
                                //价格以法币计价
                                if (ISStringEqualToString(_jydStr, @"CNY")||ISStringEqualToString(_jydStr, @"USD")){
                                    if (tt <=2){
                                        return YES;
                                    }else{
                                        return NO;
                                    }
                                }else{
                                    if (tt <= 8){
                                        return YES;
                                    }else{
                                        return NO;
                                    }
                                }
                                
                                
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
    }
    
    return YES;
}
/**
 判断是不是九宫格
 @param string  输入的字符
 @return YES(是九宫格拼音键盘)
 */
-(BOOL)isNineKeyBoard:(NSString *)string
{
    NSString *other = @"➋➌➍➎➏➐➑➒";
    int len = (int)string.length;
    for(int i=0;i<len;i++)
    {
        if(!([other rangeOfString:string].location != NSNotFound))
            return NO;
    }
    return YES;
}

-(void)resignFirstResponderUI {
    
    [_priceTF  resignFirstResponder];
    [_numberTF resignFirstResponder];
    [_bzTV     resignFirstResponder];
    
}
-(void)changeUIKitCollor {
    
    [self.priceTF setValue:kHEXCOLOR(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [self.numberTF setValue:kHEXCOLOR(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    self.bzL.textColor = ISNSStringValid(_bzStr) ? FirstColor : ThirdColor;
    self.timeL.textColor = ISNSStringValid(_rqStr) ? FirstColor : ThirdColor;
    
    if (_isJYSOrQB) {
        self.jysOrWalletL.textColor = ISNSStringValid(_jysStr) ? FirstColor : ThirdColor;
    } else {
       self.jysOrWalletL.textColor = ISNSStringValid(_walletStr) ? FirstColor : ThirdColor;
    }
}
-(AddRecordNavView *)navView {
    
    if (!_navView) {
        
        _navView = [AddRecordNavView loadFromXib];
        _navView.frame = CGRectMake(0, 0, 160, 30);
        _navView.intrinsicContentSize = CGSizeMake(160, 30);
        ViewBorderRadius(_navView.sdtjBtn, 4, 1, kHEXCOLOR(0x108ee9));
        ViewBorderRadius(_navView.sqdrBtn, 4, 1, kHEXCOLOR(0x108ee9));
        _navView.middeL.backgroundColor = kHEXCOLOR(0x108ee9);
        [_navView.sdtjBtn setBackgroundColor:kHEXCOLOR(0x108ee9)];
        [_navView.sdtjBtn setTitleColor:kHEXCOLOR(0xffffff) forState:UIControlStateNormal];
        [_navView.sqdrBtn setBackgroundColor:kHEXCOLOR(0xffffff)];
        [_navView.sqdrBtn setTitleColor:kHEXCOLOR(0x108ee9) forState:UIControlStateNormal];
        [_navView.sdtjBtn addTarget:self action:@selector(navgationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navView.sqdrBtn addTarget:self action:@selector(navgationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navView;
}
-(void)navgationBtnClick:(UIButton *)btn {
    
    if (btn.tag == 111) {//手动添加
        
        [self.navView.sdtjBtn setBackgroundColor:kHEXCOLOR(0x108ee9)];
        [self.navView.sdtjBtn setTitleColor:kHEXCOLOR(0xffffff) forState:UIControlStateNormal];
        [self.navView.sqdrBtn setBackgroundColor:kHEXCOLOR(0xffffff)];
        [self.navView.sqdrBtn setTitleColor:kHEXCOLOR(0x108ee9) forState:UIControlStateNormal];
        self.mTableView.hidden = YES;
        [self addNavigationItemWithTitles:@[[APPLanguageService wyhSearchContentWith:@"sava"]] isLeft:NO target:self action:@selector(saveBtnClick:) tags:@[@(123)] whereVC:@"保存"];
    }else {//授权添加
        
        [self.navView.sqdrBtn setBackgroundColor:kHEXCOLOR(0x108ee9)];
        [self.navView.sqdrBtn setTitleColor:kHEXCOLOR(0xffffff) forState:UIControlStateNormal];
        [self.navView.sdtjBtn setBackgroundColor:kHEXCOLOR(0xffffff)];
        [self.navView.sdtjBtn setTitleColor:kHEXCOLOR(0x108ee9) forState:UIControlStateNormal];
        
        [self.view addSubview:self.mTableView];
        self.mTableView.hidden = NO;
        [AnalysisService alaysisMY_Asset_Authorization_import];
        self.navigationItem.rightBarButtonItem = nil;
    }
}
#pragma mark --Customer Accessor
-(UITableView*)mTableView{
    if(!_mTableView){
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 36, ScreenWidth, ScreenHeight-kTopHeight-36) style:[self tableViewStyle]];
        _mTableView.delegate=self;
        _mTableView.dataSource=self;
        if(IOS_VERSION >=11.0f){
            _mTableView.estimatedSectionHeaderHeight=0.0;
            _mTableView.estimatedSectionFooterHeight=0.0;
        }
        _mTableView.keyboardDismissMode =UIScrollViewKeyboardDismissModeOnDrag;
        _mTableView.showsVerticalScrollIndicator =NO;
        if([self nibNameOfCell].length>0){
            [_mTableView registerNib:[UINib nibWithNibName:[self nibNameOfCell] bundle:nil] forCellReuseIdentifier:[self cellIdentifier]];
        }
        _mTableView.separatorColor = SeparateColor;
        _mTableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        _mTableView.tableFooterView =footView;
    }
    return _mTableView;
}
-(NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSString*)nibNameOfCell{
    return @"JJSSQCell";
}
- (NSString*)cellIdentifier{
    return @"JJSSQCell";
}
- (UITableViewStyle)tableViewStyle{
    return UITableViewStylePlain;
}
#pragma mark- UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 48.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JJSSQCell *cell     = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifier]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.exchangeName   = self.dataArray[indexPath.row];
    return cell;
}

- (MenuHrizontal*)menuBtn{
    if(!_menuBtn){
        _menuBtn =[[MenuHrizontal alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 34.0f)];
        _menuBtn.delegate = self;
        _menuBtn.backgroundColor = isNightMode ?ViewContentBgColor :CWhiteColor;
//        _menuBtn.lineBtnArr =@[@{@"name": [APPLanguageService wyhSearchContentWith:@"mairu"]},@{@"name":[APPLanguageService wyhSearchContentWith:@"maichu"]},@{@"name": [APPLanguageService wyhSearchContentWith:@"shouquandaoru"]}];
//        [_menuBtn clickButtonAtIndex:0];
    }
    return _menuBtn;
}

- (void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex{
    if(aIndex == 2){
        self.mTableView.hidden = NO;
        [self.view bringSubviewToFront:self.mTableView];
        [AnalysisService alaysisMY_Asset_Authorization_import];
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        self.mTableView.hidden = YES;
        [self addNavigationItemWithTitles:@[[APPLanguageService wyhSearchContentWith:@"sava"]] isLeft:NO target:self action:@selector(saveBtnClick:) tags:@[@(123)] whereVC:@"保存"];
        //买入
        if(aIndex == 0){
            [MobClick event:@"income_buy"];
            _isMROrMC        = YES;
            self.timeTypeL.localText = @"mairushijian";
        }else{//卖出
            [MobClick event:@"income_sell"];
            _isMROrMC        = NO;
            self.timeTypeL.localText = @"maichushijian";
        }
    }
}

- (NSDate *)getCurrentTime{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    
    NSLog(@"---------- currentDate == %@",date);
    return date;
}

@end
