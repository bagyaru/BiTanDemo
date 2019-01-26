//
//  FastInfoShareView.m
//  BT
//
//  Created by apple on 2018/7/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FastInfoShareView.h"
#import "NSDate+Extent.h"

@interface FastInfoShareView()
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *contenL;
@property (weak, nonatomic) IBOutlet UIImageView *indicatorImagev;
@property (weak, nonatomic) IBOutlet UIImageView *headImageV;
@property (weak, nonatomic) IBOutlet UIImageView *kx_imageV;
@property (weak, nonatomic) IBOutlet UIImageView *footImageV;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewFootWeiZi;
@end

@implementation FastInfoShareView

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)setObj:(FastInfomationObj *)obj{
    _obj = obj;
    if ([obj.content containsString:@"【"] && [obj.content containsString:@"】"]) {
        NSRange startRange = [obj.content rangeOfString:@"【"];
        NSRange endRange = [obj.content rangeOfString:@"】"];
        NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
        NSString *titleResult = [obj.content substringWithRange:range];
        NSString *contentResult = [[obj.content substringFromIndex:endRange.location] stringByReplacingOccurrencesOfString:@"】" withString:@""];
        NSLog(@"%@ %@",titleResult,contentResult);
        
        self.titleL.text = titleResult;
        [getUserCenter setLabelSpace:self.titleL withValue:titleResult withFont:FONT(@"PingFangSC-Medium", 20) withHJJ:4.0 withZJJ:0.0];
        
        self.contenL.text = contentResult;
        [getUserCenter setLabelSpace:self.contenL withValue:contentResult withFont:FONTOFSIZE(14) withHJJ:8.0 withZJJ:0.0];
    }else {
        
        self.titleL.text = @"";
        self.contenL.text = obj.content;
        [getUserCenter setLabelSpace:self.contenL withValue:obj.content withFont:FONTOFSIZE(14) withHJJ:8.0 withZJJ:0.0];
    }
    NSString *dateStr =[NSDate getTimeStrFromInterval:SAFESTRING(obj.issueDate) andFormatter:@"yyyy/MM/dd HH:mm EEEE"];
    self.timeL.text = dateStr;
    
    if ([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]) {
        self.headImageV.image = [UIImage imageNamed:@"KXShare_Head_en"];
        self.imageViewFootWeiZi.image = [UIImage imageNamed:@"KXShare_Foot_WeiZi_en"];
    }else{
        self.headImageV.image = [UIImage imageNamed:@"KXShare_Head_cn"];
        self.imageViewFootWeiZi.image = [UIImage imageNamed:@"KXShare_Foot_WeiZi_cn"];
    }
}


@end
