//
//  BTSearchBarView.m
//  BT
//
//  Created by apple on 2018/5/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTSearchBarView.h"
#import "SearchResult.h"

@interface BTSearchBarView ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *searchBartextField;

//搜索的数组结果
@property (nonatomic,strong) NSMutableArray *searchDataArray;

@property (nonatomic,copy) SearchResultBlock resultBlock;

@end

@implementation BTSearchBarView

-(NSMutableArray *)searchDataArray{
    if (!_searchDataArray) {
        _searchDataArray = [NSMutableArray array];
    }
    return _searchDataArray;
}

-(NSMutableArray *)allDataArray{
    if (!_allDataArray) {
        _allDataArray = [NSMutableArray array];
    }
    return _allDataArray;
}
-(NSMutableArray *)countryDataArray{
    if (!_countryDataArray) {
        _countryDataArray = [NSMutableArray array];
    }
    return _countryDataArray;
}
-(NSMutableArray *)hotCountryDataArray{
    if (!_hotCountryDataArray) {
        _hotCountryDataArray = [NSMutableArray array];
    }
    return _hotCountryDataArray;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    //背景界面
    UIView *searchBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self addSubview:searchBgView];
    searchBgView.backgroundColor = [UIColor whiteColor];
    
    self.searchBartextField = [[UITextField alloc] initWithFrame:CGRectMake(RELATIVE_WIDTH(15), RELATIVE_WIDTH(10), ScreenWidth - RELATIVE_WIDTH(30), RELATIVE_WIDTH(30))];
    [searchBgView addSubview:self.searchBartextField];
    self.searchBartextField.backgroundColor = ViewBGColor;
    ViewRadius(self.searchBartextField, RELATIVE_WIDTH(4));
    self.searchBartextField.delegate = self;
    
    //左边suos
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, RELATIVE_WIDTH(52), self.searchBartextField.height)];
    [leftBtn setImage:[UIImage imageNamed:@"main_search"] forState:UIControlStateNormal];
    self.searchBartextField.leftView = leftBtn;
    self.searchBartextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchBartextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchBartextField.textColor = FirstColor;
    //默认提示文字
    self.searchBartextField.placeholder = @"搜索";
    [self.searchBartextField setValue:ThirdColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.searchBartextField setValue:[UIFont systemFontOfSize:RELATIVE_WIDTH(12)] forKeyPath:@"_placeholderLabel.font"];
    [self.searchBartextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    NSString *path;
    if ([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]) {
            path = [[NSBundle mainBundle] pathForResource:@"countryCodeCH" ofType:@"plist"];
    }else{
        path = [[NSBundle mainBundle] pathForResource:@"countryCodeEN" ofType:@"plist"];
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray *keyArr = [[dic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    for (NSString *key in keyArr) {
        [self.allDataArray addObject:dic[key]];
    }
    
    self.hotCountryDataArray = self.allDataArray.firstObject;
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self.allDataArray subarrayWithRange:NSMakeRange(1, self.allDataArray.count-1)]];
    for (int i = 0; i<array.count; i++) {
        [self.countryDataArray addObjectsFromArray:array[i]];
    } 
    
}

-(void)textFieldDidChange:(UITextField*)textField{
    UITextRange *selectedRange = [textField markedTextRange];
    if (selectedRange == nil || selectedRange.empty) {
        NSLog(@"++++++text+++%@++++",textField.text);
        
        if (textField.text.length>0) {
            self.isSearch = YES;
        }else{
            self.isSearch = NO;
        }
        
       self.searchDataArray =  [SearchResult getSearchResultBySearchText:textField.text dataArray:self.countryDataArray];
        
        if (self.resultBlock) {
            self.resultBlock(self.searchDataArray);
        }
        
    }
    
}

-(void)getSearchResult:(SearchResultBlock)block{
   self.resultBlock = block;
}

//
//- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    self.isSearch = YES;
//}
//
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    
//}



@end
