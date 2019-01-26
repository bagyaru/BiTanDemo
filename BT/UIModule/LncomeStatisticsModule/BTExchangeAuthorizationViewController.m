//
//  BTExchangeAuthorizationViewController.m
//  BT
//
//  Created by admin on 2018/5/29.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTExchangeAuthorizationViewController.h"
#import "BTExchangeModel.h"
#import "MMScanViewController.h"
#import "BTSearchService.h"

#import "PCNetworkClient+Account.h"
#import "SYYHuobiNetHandler.h"
#import "OKexRequestApi.h"

#import "BTUserExchangeAccountApi.h"
#import "BTShowLoading.h"

#import "BTMyCoinRewardRequest.h"
#import "BTExchangeTanliReq.h"
@interface BTExchangeAuthorizationViewController ()

@property (weak, nonatomic) IBOutlet BTLabel *exchangeL;
@property (weak, nonatomic) IBOutlet BTTextField *keyTF;
@property (weak, nonatomic) IBOutlet BTTextField *secretTF;
@property (weak, nonatomic) IBOutlet BTLabel *smL;
@property (weak, nonatomic) IBOutlet UIButton *sqBtn;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;

@property (nonatomic, strong) NSMutableArray *hbArr1;
@property (nonatomic, strong) NSMutableArray *hbArr2;
@property (nonatomic, assign) BOOL isHb1;
@property (nonatomic, assign) BOOL isHb2;

@property (nonatomic,strong)BTExchangeModel *detailModel;
@end

@implementation BTExchangeAuthorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ViewBGColor;
    ViewRadius(self.sqBtn, 4);
    self.title = [APPLanguageService wyhSearchContentWith:@"tianjiashouquan"];
    [getUserCenter setLabelSpace:self.smL withValue:self.smL.text withFont:SYSTEMFONT(12) withHJJ:5.0 withZJJ:0.0];
    self.detailModel = self.parameters[@"model"];
    self.exchangeL.text = self.detailModel.exchangeName;
    self.keyTF.text     = self.detailModel.exchangeKey;
    self.secretTF.text  = self.detailModel.exchangeSecret;
    // Do any additional setup after loading the view from its nib.
    
    [self.keyTF setValue:SecondColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.secretTF setValue:SecondColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.btn1 setImage:[UIImage imageNamed:@"ic_erweima"] forState:UIControlStateNormal];
     [self.btn2 setImage:[UIImage imageNamed:@"ic_erweima"] forState:UIControlStateNormal];
    
}
//选交易所
- (IBAction)chooseJJSBtnClcik:(UIButton *)sender {
}
//二维码
- (IBAction)QrCodeBtnClcik:(UIButton *)sender {
    
    MMScanViewController *scanVc = [[MMScanViewController alloc] initWithQrType:MMScanTypeAll onFinish:^(NSString *result, NSError *error) {
        if (error) {
            NSLog(@"error: %@",error);
            [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"saomiaoshibai"] wait:YES];
        } else {
            NSLog(@"扫描结果：%@",result);
            [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"saomiaochenggong"] wait:YES];
            if (sender.tag == 333) {
                
                self.keyTF.text = result;
            } else {
                
                self.secretTF.text = result;
            }
        }
    }];
    [self.navigationController pushViewController:scanVc animated:YES];
}
//授权
- (IBAction)sqBtnClick:(UIButton *)sender {
    
    if (ISNSStringValid(self.keyTF.text)&&ISNSStringValid(self.secretTF.text)) {
        self.detailModel.exchangeKey      = [self searchDeletewhitespaceWithString:self.keyTF.text];
        self.detailModel.exchangeSecret   = [self searchDeletewhitespaceWithString:self.secretTF.text];
        self.detailModel.isOrNoAuthorized = YES;
        
        [self requestWithType:self.detailModel.exchangeCode apiKey:self.detailModel.exchangeKey apiSecret:self.detailModel.exchangeSecret];
        
    }else {
        
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"xinxibuwanshan"] wait:YES];
    }
}
- (NSString *)searchDeletewhitespaceWithString:(NSString *)text{
    if (text.length == 0) {
        return text;
    }
    NSString *searchText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    return searchText;
}
- (void)saveKeyData{
    [[BTSearchService sharedService] writeExchangeAuthorized:self.detailModel];
    [AppHelper saveApiKey:self.detailModel.exchangeKey withExchangeCode:self.detailModel.exchangeCode];
    [AppHelper saveApiSecret:self.detailModel.exchangeSecret withExchangeCode:self.detailModel.exchangeCode];
}

- (void)requestWithType:(NSString*)type apiKey:(NSString*)apiKey apiSecret:(NSString*)apiSecret{
    if([type isEqualToString:@"binance"]){
        [self bianceRequestAccount:apiKey apiSecret:apiSecret];
    }
    if([type isEqualToString:@"huobi.pro"]){
        [AppHelper saveApiKey:self.detailModel.exchangeKey withExchangeCode:self.detailModel.exchangeCode];
        [AppHelper saveApiSecret:self.detailModel.exchangeSecret withExchangeCode:self.detailModel.exchangeCode];
        [self hbRequestAccount:apiKey apiSecret:apiSecret];
    }
    if([type isEqualToString:@"okex"]){
        [self okexRequestAccount:apiKey apiSecret:apiSecret];
    }
}

//币安
- (void)bianceRequestAccount:(NSString*)apiKey apiSecret:(NSString*)apiSecret{
    [BTShowLoading show];
    [PCNetworkClient accountInfoWithApiKey:apiKey apiSecert:apiSecret completion:^(NSError *error, id responseObj) {
        
        [BTShowLoading hide];
        if(!error){
            [self saveKeyData];
            if([responseObj isKindOfClass:[NSDictionary class]]){
                NSArray *balances = responseObj[@"balances"];
                if([balances isKindOfClass:[NSArray class]]){
                    if(balances.count == 0){
                        return ;
                    }
                    [self authrozeExchangeTanLi];
                    // 逻辑处理
                    NSMutableArray *mutaData =@[].mutableCopy;
                    for(NSDictionary *dict in balances){
                        
                        double count = [SAFESTRING(dict[@"free"]) doubleValue];
                        if(count != 0){
                            NSDictionary *params =@{
                                                    @"count":SAFESTRING(dict[@"free"]),
                                                    @"kind":[SAFESTRING(dict[@"asset"]) uppercaseString]
                                                    };
                            
                            [mutaData addObject:params];
                        }
                        
                    }
                    
                    [self uploadToServer:mutaData];
                }
            }
        }else{
             [MBProgressHUD showMessageIsWait: [APPLanguageService sjhSearchContentWith:@"netfail"] wait:YES];
            
        }
    }];
}

//火币
- (void)hbRequestAccount:(NSString*)apiKey apiSecret:(NSString*)apiSecret{
    [BTShowLoading show];
    [SYYHuobiNetHandler requestAccountsWithTag:nil succeed:^(id respondObject) {
        [BTShowLoading hide];
        if([respondObject isKindOfClass:[NSDictionary class]]){
            NSString *status = SAFESTRING(respondObject[@"status"]);
            if([status isEqualToString:@"error"]){
                [MBProgressHUD showMessageIsWait:SAFESTRING(respondObject[@"err-msg"]) wait:YES];
                return;
            }
            
            [self saveKeyData];
            [self authrozeExchangeTanLi];
            NSArray *data =respondObject[@"data"];
            if(data.count == 1){
                NSDictionary *info = [data firstObject];
                NSString *mId = SAFESTRING(info[@"id"]);
                
                [AppHelper saveApiAccountId:mId];
                [SYYHuobiNetHandler requestAccountBalanceWithTag:nil accountId:mId succeed:^(id respondObject) {
                    if([respondObject isKindOfClass:[NSDictionary class]]){
                        NSDictionary *data =respondObject[@"data"];
                        NSArray *list = data[@"list"];
                        if(![list isKindOfClass:[NSArray class]]) return;
                        if(list.count>0){
                            
                            // 逻辑处理
                            NSMutableArray *mutaData =@[].mutableCopy;
                            for(NSDictionary *dict in list){
                                NSString* type = SAFESTRING(dict[@"type"]);
                                if([type isEqualToString:@"trade"]){
                                    
                                    double count = [SAFESTRING(dict[@"balance"]) doubleValue];
                                    if(count != 0){
                                        
                                        
                                        NSDictionary *params =@{
                                                                @"count":SAFESTRING(dict[@"balance"]),
                                                                @"kind":[SAFESTRING(dict[@"currency"]) uppercaseString]
                                                                };
                                        
                                        [mutaData addObject:params];
                                    }
                                }
                            }
                            
                            [self uploadToServer:mutaData];
                        }
                    }
                    
                    
                } failed:^(id error) {
                    
                    
                }];
                
            }
            
            if(data.count >1){
                [self processData:data];
            }
        }
        
        
    } failed:^(id error) {
        [BTShowLoading hide];
         [MBProgressHUD showMessageIsWait: [APPLanguageService sjhSearchContentWith:@"netfail"] wait:YES];
    }];
}

- (void)processData:(NSArray*)data{
    
    if(data.count>1){
        
        _hbArr1 = @[].mutableCopy;
        _hbArr2 = @[].mutableCopy;
        NSDictionary *info = [data firstObject];
        NSString *mId = SAFESTRING(info[@"id"]);
        [AppHelper saveApiAccountId:mId];
        
        NSDictionary *info1 =[data lastObject];
        NSString *mID1 = SAFESTRING(info1[@"id"]);
        [AppHelper saveHbApiAccountId:mID1];
        
        [SYYHuobiNetHandler requestAccountBalanceWithTag:nil accountId:mId  succeed:^(id respondObject) {
            if([respondObject isKindOfClass:[NSDictionary class]]){
                NSDictionary *data =respondObject[@"data"];
                NSArray *list = data[@"list"];
                if(![list isKindOfClass:[NSArray class]]) return;
                if(list.count>0){
                    // 逻辑处理
                    for(NSDictionary *dict in list){
                        NSString* type = SAFESTRING(dict[@"type"]);
                        if([type isEqualToString:@"trade"]){
                            
                            double count = [SAFESTRING(dict[@"balance"]) doubleValue];
                            if(count != 0){
                                
                                NSDictionary *params =@{
                                                        @"count":SAFESTRING(dict[@"balance"]),
                                                        @"kind":[SAFESTRING(dict[@"currency"]) uppercaseString]
                                                        };
                                
                                [_hbArr1 addObject:params];
                            }
                        }
                    }
                    _isHb1 = _hbArr1.count>0;
                    if(_isHb1&&_isHb2){
                        NSArray * arr =[self concatFirstArr:_hbArr1 secondArray:_hbArr2];
                        [self uploadToServer:arr];
                    }
                }
                
                
                
            }
        } failed:^(id error) {
            
        }];
        
        [SYYHuobiNetHandler requestAccountBalanceWithTag:nil accountId:mID1  succeed:^(id respondObject) {
            if([respondObject isKindOfClass:[NSDictionary class]]){
                NSDictionary *data =respondObject[@"data"];
                NSArray *list = data[@"list"];
                if(![list isKindOfClass:[NSArray class]]) return;
                if(list.count>0){
                    
                    for(NSDictionary *dict in list){
                        NSString* type = SAFESTRING(dict[@"type"]);
                        if([type isEqualToString:@"trade"]){
                            
                            double count = [SAFESTRING(dict[@"balance"]) doubleValue];
                            if(count != 0){
                                
                                NSDictionary *params =@{
                                                        @"count":SAFESTRING(dict[@"balance"]),
                                                        @"kind":[SAFESTRING(dict[@"currency"]) uppercaseString]
                                                        };
                                
                                [_hbArr2 addObject:params];
                            }
                        }
                    }
                    
                    _isHb2 = _hbArr2.count>0;
                    
                    if(_isHb1&&_isHb2){
                        NSArray * arr =[self concatFirstArr:_hbArr1 secondArray:_hbArr2];
                        [self uploadToServer:arr];
                    }
                }
            }
            
            
            
        } failed:^(id error) {
            
        }];
    }
}

//合并数组
- (NSArray*)concatFirstArr:(NSArray*)firstArr secondArray:(NSArray*)secondArr{
   NSMutableArray *arrData = @[].mutableCopy;
    [arrData addObjectsFromArray:firstArr];
    [arrData addObjectsFromArray:secondArr];
    
    NSArray *sortArray =
    [arrData sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDictionary *dic1 = (NSDictionary*)obj1;
        NSDictionary *dic2 = (NSDictionary*)obj2;
        
        NSString *name1 = dic1[@"kind"];
        NSString *name2 = dic2[@"kind"];
        return [name1 compare:name2];
        
    }];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    NSDictionary *firstInfo = sortArray.firstObject;
    __block NSString *referenceName = firstInfo[@"kind"];
    __block double totalFee = 0.00;
    
    [sortArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *userInfo = (NSDictionary*)obj;
        NSString *name = userInfo[@"kind"];
        double price = [userInfo[@"count"] doubleValue];
        if ([referenceName isEqualToString:name]) {
            //名称相同 累加价格
            totalFee += price;
        }else {
            //名称不同 将价格保存到新数组中
            [arr addObject:@{@"kind":referenceName,@"count":SAFESTRING(@(totalFee).p8fString)}];
            
            
            //同时重置全局变量
            totalFee = price;
            referenceName = name;
        }
    }];
    //最后一组数据必定会跳出循环，因此在循环结束时加到数组中
    [arr addObject:@{@"kind":referenceName,@"count":SAFESTRING(@(totalFee).p8fString)}];
    return arr;
}

- (void)uploadToServer:(NSArray*)data{
    [AppHelper saveExchangeData:data withExchangeCode:self.detailModel.exchangeCode];
    NSDictionary *params =@{
                            @"bookkeeptingExchangeCurrencyVOList":data,
                            @"exchange":SAFESTRING(self.detailModel.exchangeCode)
                            };
    
    BTUserExchangeAccountApi *api  =[[BTUserExchangeAccountApi alloc] initWithAccountData:@[params]];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if(request.data&&[request.data isKindOfClass:[NSDictionary class]]){
            NSArray *exchangeVOList = request.data[@"exchangeVOList"];
            if(exchangeVOList.count>0){
                [AppHelper saveExchangeTotalInfo:exchangeVOList.firstObject withEXCode:self.detailModel.exchangeCode];
            }
        }
        
        if([self.detailModel.exchangeCode isEqualToString:@"binance"]) [AnalysisService alaysisComplete_the_Authorization_bian];
        if([self.detailModel.exchangeCode isEqualToString:@"huobi.pro"]) [AnalysisService alaysisComplete_the_Authorization_huobi];
        if([self.detailModel.exchangeCode isEqualToString:@"okex"]) [AnalysisService alaysisComplete_the_Authorization_OKex];
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"shouquanchenggong"] wait:YES];
        [BTCMInstance popViewController:nil];
        [[NSNotificationCenter  defaultCenter] postNotificationName:NSNotification_HiddenAssets object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificatin_Refresh_Exchange_Tasks object:nil];
        
    } failure:^(__kindof BTBaseRequest *request) {
        
        [MBProgressHUD showMessageIsWait: [APPLanguageService sjhSearchContentWith:@"netfail"] wait:YES];
        
    }];
    
    
}

- (void)okexRequestAccount:(NSString*)apiKey apiSecret:(NSString*)apiSecret{
    
    //apiKey = @"38ff8669-cc12-4a2f-b532-721920f1dba2";
    // apiSecret = @"A4202E8D954D113660B9A6975B1C448C";
    [BTShowLoading show];
    [OKexRequestApi accountWithApiKey:apiKey apiSecret:apiSecret succeed:^(id respondObject) {
        [BTShowLoading hide];
        if(respondObject&&[respondObject isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = (NSDictionary*)respondObject;
            if(SAFESTRING(dict[@"error_code"]).length) {
                [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"shouquanshibai"] wait:YES];
                return ;
            }
            
          
            [self saveKeyData];//保存关键数据
            [self authrozeExchangeTanLi];
            id info = respondObject[@"info"];
            if([info isKindOfClass:[NSDictionary class]]){
                id value = info[@"funds"];
                if([value isKindOfClass:[NSDictionary class]]){
                    NSDictionary *free = value[@"free"];
                    
                    //数据处理
                    NSMutableArray *dataArr = @[].mutableCopy;
                    for(NSString *key in free.allKeys){
                        
                        double count = [SAFESTRING(free[key]) doubleValue];
                        if(count !=0){
                            
                            NSDictionary *dict= @{
                                                  @"kind":SAFESTRING([key uppercaseString]),
                                                  @"count":SAFESTRING(free[key])
                                                  };
                            [dataArr addObject:dict];
                        }
                    }
                    [self uploadToServer:dataArr];
                }
            }
        }
        
        
    } failed:^(id error) {
        [BTShowLoading hide];
        [MBProgressHUD showMessageIsWait: [APPLanguageService sjhSearchContentWith:@"netfail"] wait:YES];
        
    }];
    
}

- (void)authrozeExchangeTanLi{
   [getUserCenter shareSuccseGetTanLiWithType:9 withTime:2];
}

@end
