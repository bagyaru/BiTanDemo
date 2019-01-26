//
//  AddRecordViewController.m
//  BT
//
//  Created by admin on 2018/3/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AddRecordViewController.h"
#import "LYLOptionPicker.h"
#import "LYLDatePicker.h"
#import "CurrentcyModel.h"
#import "AddBookKeepingRequest.h"
#import "LncomeStatisticsMainViewController.h"
#import "HSDatePickerVC.h"
#import "BTSearchService.h"
@interface AddRecordViewController ()<UITextFieldDelegate,HSDatePickerVCDelegate>{
    
    NSString *_jytStr;
    NSString *_rqStr;
    NSString *_sjStr;
    NSString *_priceStr;
    NSString *_numberStr;
    NSString *_priceTypeStr;
    NSString *_beizhuStr;
    BOOL      _isMROrMC;
    BOOL      _isJYDOrBZ;
}

@property (weak, nonatomic) IBOutlet UIButton *mairuBtn;
@property (weak, nonatomic) IBOutlet UIButton *maichuBtn;
@property (weak, nonatomic) IBOutlet UILabel *jydL;
@property (weak, nonatomic) IBOutlet UILabel *rqL;
@property (weak, nonatomic) IBOutlet UILabel *sjL;
@property (weak, nonatomic) IBOutlet UITextField *priceTF;
@property (weak, nonatomic) IBOutlet UIButton *choosePriceTypeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *choosePriceTypeBtnW;
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UITextField *beizhuTF;
@property (weak, nonatomic) IBOutlet UIButton *savaBtn;
@property (weak, nonatomic) IBOutlet UILabel *typeL1;
@property (weak, nonatomic) IBOutlet UILabel *typeL2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *savaBtnBottomConstraint;

@property (nonatomic, assign) BOOL isHaveDian;
@property (nonatomic, assign) BOOL isFirstZero;
@property (nonatomic, strong) NSMutableArray *jydArray;
@property (nonatomic, strong) NSDictionary *param;
@property (nonatomic, strong) NSString *kind;
@property (nonatomic, strong) NSString *whereVC;
@property (nonatomic, strong) BTLoadingView *loadingView;
@end

@implementation AddRecordViewController
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSNotification_chooseJYDSuccess
                                                  object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _jytStr       = @"";
    _rqStr        = @"";
    _sjStr        = @" 00:00";
    _priceStr     = @"";
    _numberStr    = @"";
    _beizhuStr    = @"";
    _priceTypeStr = @"/个";
    _isMROrMC     = YES;
    _priceTF.delegate = self;
    _numberTF.delegate = self;
    _beizhuTF.delegate = self;
    self.title = [APPLanguageService wyhSearchContentWith:@"tianjiajilu"];
    ViewBorderRadius(self.mairuBtn, 2, 1, [UIColor colorWithHexString:@"00bd9a"]);
    self.mairuBtn.backgroundColor = [UIColor colorWithHexString:@"e2f5f1"];
    ViewBorderRadius(self.maichuBtn, 2, 1, [UIColor colorWithHexString:@"A6ADB9"]);
    self.maichuBtn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.savaBtn.enabled = NO;
    self.savaBtn.backgroundColor = CGrayColor;
    //获取通知中心单例对象
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(pushNSNotificationChooseJYDSuccess:) name:NSNotification_chooseJYDSuccess object:nil];
    [[BTSearchService sharedService] fecthStocksTJJYWithSimpleName:self.kind ChineseName:self.kind result:^(NSArray *resultArray) {
        
        [self.jydArray addObjectsFromArray:resultArray];
    }];
    if (iPhoneX) {
        
        self.savaBtnBottomConstraint.constant = 34;
    }
}
-(void)pushNSNotificationChooseJYDSuccess:(NSNotification *)notifi {
    
    [self updateParams:notifi.userInfo];
}
+ (id)createWithParams:(NSDictionary *)params{
    AddRecordViewController *vc = [[AddRecordViewController alloc] init];
    vc.kind     = [params objectForKey:@"kind"];
    vc.whereVC  = [params objectForKey:@"whereVC"];
    return vc;
}

- (void)updateParams:(NSDictionary *)params{
    self.param = params;
    CurrentcyModel *model = [self.param objectForKey:@"model"];
    NSLog(@"%@",model.currencySimpleName);
    if (ISStringEqualToString(_priceTypeStr, @"总计")) {
        
        if (ISNSStringValid(model.currencySimpleNameRelation)) {
            
            _jytStr = [NSString stringWithFormat:@"%@/%@",model.currencySimpleName,model.currencySimpleNameRelation];
            _jydL.text = [NSString stringWithFormat:@"%@/%@",model.currencySimpleName,model.currencySimpleNameRelation];
            //_priceTypeStr = [NSString stringWithFormat:@"%@/个",model.currencySimpleNameRelation];
            _isJYDOrBZ = NO;
        }else {
            
            _jytStr = [NSString stringWithFormat:@"%@",model.currencySimpleName];
            _jydL.text = [NSString stringWithFormat:@"%@",model.currencySimpleName];
            //_priceTypeStr = [NSString stringWithFormat:@"%@/个",model.currencySimpleName];
            _isJYDOrBZ = YES;
        }
        _choosePriceTypeBtnW.constant = 50;
        NSArray *a = [_jytStr componentsSeparatedByString:@"/"];
        if (a.count == 2) {
            
            [_choosePriceTypeBtn setTitle:[NSString stringWithFormat:@"%@",a[1]] forState:UIControlStateNormal];
            
        } else {
            
            [_choosePriceTypeBtn setTitle:[NSString stringWithFormat:@"%@",a[0]] forState:UIControlStateNormal];
        }
        [_choosePriceTypeBtn setTitleColor:CFontColor3 forState:UIControlStateNormal];
    } else {
        
        if (ISNSStringValid(model.currencySimpleNameRelation)) {
            
            _jytStr = [NSString stringWithFormat:@"%@/%@",model.currencySimpleName,model.currencySimpleNameRelation];
            _jydL.text = [NSString stringWithFormat:@"%@/%@",model.currencySimpleName,model.currencySimpleNameRelation];
            //_priceTypeStr = [NSString stringWithFormat:@"%@/个",model.currencySimpleNameRelation];
            _isJYDOrBZ = NO;
        }else {
            
            _jytStr = [NSString stringWithFormat:@"%@",model.currencySimpleName];
            _jydL.text = [NSString stringWithFormat:@"%@",model.currencySimpleName];
            //_priceTypeStr = [NSString stringWithFormat:@"%@/个",model.currencySimpleName];
            _isJYDOrBZ = YES;
        }
        _choosePriceTypeBtnW.constant = 60;
        NSArray *a = [_jytStr componentsSeparatedByString:@"/"];
        if (a.count == 2) {
            
            [_choosePriceTypeBtn setTitle:[NSString stringWithFormat:@"%@/个",a[1]] forState:UIControlStateNormal];
            
        } else {
            
            [_choosePriceTypeBtn setTitle:[NSString stringWithFormat:@"%@/个",a[0]] forState:UIControlStateNormal];
        }
        [_choosePriceTypeBtn setTitleColor:CFontColor3 forState:UIControlStateNormal];
    }
    _jydL.textColor = CFontColor3;
    [self checkSavaBtnSelected];
}

//买入
- (IBAction)mairuBtnClicl:(UIButton *)sender {
    
    ViewBorderRadius(self.mairuBtn, 2, 1, [UIColor colorWithHexString:@"00bd9a"]);
    self.mairuBtn.backgroundColor = [UIColor colorWithHexString:@"e2f5f1"];
    ViewBorderRadius(self.maichuBtn, 2, 1, [UIColor colorWithHexString:@"A6ADB9"]);
    self.maichuBtn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.typeL1.text = @"买入价格";
    self.typeL2.text = @"买入数量";
    _isMROrMC        = YES;
    [self checkSavaBtnSelected];
}
//卖出
- (IBAction)maichuBtnClick:(UIButton *)sender {
    
    ViewBorderRadius(self.maichuBtn, 2, 1, [UIColor colorWithHexString:@"ff6960"]);
    self.maichuBtn.backgroundColor = [UIColor colorWithHexString:@"fcecec"];
    ViewBorderRadius(self.mairuBtn, 2, 1, [UIColor colorWithHexString:@"A6ADB9"]);
    self.mairuBtn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    self.typeL1.text = @"卖出价格";
    self.typeL2.text = @"卖出数量";
    _isMROrMC        = NO;
    [self checkSavaBtnSelected];
}
//添加交易对
- (IBAction)jydBtnClick:(UIButton *)sender {
    
    [self resignFirstResponderUI];
    [BTCMInstance pushViewControllerWithName:@"ChooseJYD" andParams:@{@"resultArray":self.jydArray}];
}
//添加日期
- (IBAction)rqBtnClick:(UIButton *)sender {
    [self resignFirstResponderUI];
    [LYLDatePicker sharedDatePicker].type = 1;
    HSDatePickerVC *vc = [[HSDatePickerVC alloc] init];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - HSDatePickerVCDelegate
- (void)datePicker:(HSDatePickerVC*)datePicker
          withYear:(NSString *)year
             month:(NSString *)month
               day:(NSString *)day
{
    NSLog(@"选择了   %@--%@--%@",year,month,day);
    _rqStr = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    _rqL.text = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];;
    _rqL.textColor = CFontColor3;
    [self checkSavaBtnSelected];
}
//添加时间
- (IBAction)sjBtnClick:(UIButton *)sender {
    [self resignFirstResponderUI];
    [LYLDatePicker sharedDatePicker].type = 2;
    [LYLDatePicker showDateDetermineChooseInView:[[[UIApplication sharedApplication] delegate] window] determineChoose:^(NSString *dateString) {
        NSLog(@"%@",dateString);
        _sjStr = [NSString stringWithFormat:@" %@",dateString];
        _sjL.text = dateString;
        _sjL.textColor = CFontColor3;
        [self checkSavaBtnSelected];
    }];
}
//选中买入价格类型（单个/总计）
- (IBAction)choosePriceTypeBtnClick:(UIButton *)sender {
    [self resignFirstResponderUI];
    [LYLOptionPicker showOptionPickerInView:[[[UIApplication sharedApplication] delegate] window] dataSource:@[@[@"总计",@"单个"]] determineChoose:^(NSArray *indexes, NSArray *selectedItems) {
        
        NSLog(@"%@,%@",indexes[0],selectedItems[0]);
        [self checkSavaBtnSelected];
        
        if (ISStringEqualToString(selectedItems[0], @"总计")) {
            
            _choosePriceTypeBtnW.constant = 50;
            if (ISNSStringValid(_jytStr)) {
                
                NSArray *a = [_jytStr componentsSeparatedByString:@"/"];
                if (a.count == 2) {
                    
                    [_choosePriceTypeBtn setTitle:[NSString stringWithFormat:@"%@",a[1]] forState:UIControlStateNormal];
                    
                } else {
                    
                    [_choosePriceTypeBtn setTitle:[NSString stringWithFormat:@"%@",a[0]] forState:UIControlStateNormal];
                }
            } else {
                
                [_choosePriceTypeBtn setTitle:@"总计" forState:UIControlStateNormal];
            }
            _priceTypeStr = @"总计";
            [_choosePriceTypeBtn setTitleColor:CFontColor3 forState:UIControlStateNormal];
        } else {
            
            if (ISNSStringValid(_jytStr)) {
                
                _choosePriceTypeBtnW.constant = 60;
                NSArray *a = [_jytStr componentsSeparatedByString:@"/"];
                if (a.count == 2) {
                  
                     [_choosePriceTypeBtn setTitle:[NSString stringWithFormat:@"%@/个",a[1]] forState:UIControlStateNormal];
                    
                } else {
                    
                    [_choosePriceTypeBtn setTitle:[NSString stringWithFormat:@"%@/个",a[0]] forState:UIControlStateNormal];
                }
            } else {
                
                _choosePriceTypeBtnW.constant = 20;
                 [_choosePriceTypeBtn setTitle:@"/个" forState:UIControlStateNormal];
            }
            _priceTypeStr = @"/个";
            [_choosePriceTypeBtn setTitleColor:CFontColor3 forState:UIControlStateNormal];
        }
    }];
}

//立即添加
- (IBAction)savaBtnClick:(UIButton *)sender {
    
    [self resignFirstResponderUI];
    if (ISNSStringValid(_jytStr)&&ISNSStringValid(_rqStr)&&ISNSStringValid(_priceStr)&&ISNSStringValid(_numberStr)) {
        self.savaBtn.enabled = NO;
        [self.loadingView showLoading];
//        AddBookKeepingRequest *api = [[AddBookKeepingRequest alloc] initWithBuy:_isMROrMC currency:_isJYDOrBZ dealCount:_numberStr dealDate:[NSString stringWithFormat:@"%@%@",_rqStr,_sjStr] dealTotal:ISStringEqualToString(_priceTypeStr, @"总计")?_priceStr:@"0" dealUnitPrice:ISStringEqualToString(_priceTypeStr, @"总计")?@"0":_priceStr kind:_isJYDOrBZ?_kind:_jytStr legalType:_isJYDOrBZ?(ISStringEqualToString(_jytStr, @"CNY")?1:2):0 note:_beizhuStr];
//        [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
//            
//            [AnalysisService alaysisIncome_add_succesd];
//            [MBProgressHUD showMessageIsWait:@"添加成功" wait:YES];
//            //发送通知 回到上一个页面的时候刷新数据 保持数据准确
//            [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_addJYTJSuccess object:nil userInfo:nil];
//            if (ISStringEqualToString(self.whereVC, @"详情")) {
//               
//                [BTCMInstance popViewController:nil];
//            } else {
//                
//                [BTCMInstance dismissViewController];
//            }
//            
//            //self.savaBtn.enabled = YES;
//        } failure:^(__kindof BTBaseRequest *request) {
//    
//            self.savaBtn.enabled = YES;
//        }];
    }else {
        
        [MBProgressHUD showMessageIsWait:@"条件不全" wait:YES];
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
    if (textField == _beizhuTF) {
        
        _beizhuStr = textField.text;
    }
    [self checkSavaBtnSelected];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //[self checkChoosePriceTypeBtnColorChange];
    [self checkSavaBtnSelected];
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
                            NSRange ran=[textField.text rangeOfString:@"."];
                            int tt=(int)(range.location-ran.location);
                            
                            if (textField == _numberTF) {
                                
                                if (tt <= 3){
                                    return YES;
                                }else{
                                    return NO;
                                }
                            }else {
                                
                                if (tt <= 8){
                                    return YES;
                                }else{
                                    return NO;
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
                               
                                if (tt <= 3){
                                    return YES;
                                }else{
                                    return NO;
                                }
                            }else {
                                
                                if (tt <= 8){
                                    return YES;
                                }else{
                                    return NO;
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
    
    if (textField == _beizhuTF) {
        
        if (range.length == 1 && string.length == 0) {
            
            return YES;
        }else if (_beizhuTF.text.length >= 10) {
            
            _beizhuTF.text = [textField.text substringToIndex:10];
            return NO;
        }else {
            if(![string isEqualToString:@" "]){
                return YES;
            }
            /* 如果不是右對齊，直接返回YES，不做處理 */
            if (textField.textAlignment != NSTextAlignmentRight) {
                return YES;
            }
            
            /* 在右對齊的情況下*/
            // 如果string是@""，說明是刪除字元（剪切刪除操作），則直接返回YES，不做處理
            // 如果把這段刪除，在刪除字元時游標位置會出現錯誤
            if ([string isEqualToString:@""]) {
                return YES;
            }
            
            //判断键盘是不是九宫格键盘
            if ([self isNineKeyBoard:string] ){
                return YES;
            }
            
            
            /* 在輸入單個字元或者粘貼內容時做如下處理，已確定游標應該停留的正確位置，
             沒有下段從字元中間插入或者粘貼游標位置會出錯 */
            // 首先使用 non-breaking space 代替預設輸入的@“ ”空格
            string = [string stringByReplacingOccurrencesOfString:@" "
                                                       withString:@"\u00a0"];
            textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                                     withString:string];
            //確定輸入或者粘貼字元後游標位置
            UITextPosition *beginning = textField.beginningOfDocument;
            UITextPosition *cursorLoc = [textField positionFromPosition:beginning
                                                                 offset:range.location+string.length];
            // 選中文本起使位置和結束為止設置同一位置
            UITextRange *textRange = [textField textRangeFromPosition:cursorLoc
                                                           toPosition:cursorLoc];
            // 選中字元範圍（由於textRange範圍的起始結束位置一樣所以並沒有選中字元）
            [textField setSelectedTextRange:textRange];
            
            return NO;
            
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
    
    [_priceTF resignFirstResponder];
    [_numberTF resignFirstResponder];
    [_beizhuTF resignFirstResponder];
}
-(void)checkChoosePriceTypeBtnColorChange {
    
    ISNSStringValid(_priceTF.text)?[_choosePriceTypeBtn setTitleColor:CFontColor3 forState:UIControlStateNormal]:[_choosePriceTypeBtn setTitleColor:CGrayColor forState:UIControlStateNormal];
}
//检查条件是否选择完整
-(void)checkSavaBtnSelected {
    
    if (ISNSStringValid(_jytStr)&&ISNSStringValid(_rqStr)&&ISNSStringValid(_priceStr)&&ISNSStringValid(_numberStr)) {
        
        self.savaBtn.enabled = YES;
        self.savaBtn.backgroundColor = CBlackColor;
        
    }else {
        
        self.savaBtn.enabled = NO;
        self.savaBtn.backgroundColor = CGrayColor;
    }
}
-(NSMutableArray *)jydArray {
    
    if (!_jydArray) {
        
        _jydArray = [[NSMutableArray alloc] init];
    }
    
    return _jydArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
