//
//  XianHuoCell.m
//  BT
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "XianHuoCell.h"

@interface XianHuoCell ()

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tag1W;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tag2W;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tag3W;

@end

@implementation XianHuoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.shadowColor = FirstColor.CGColor;
    self.bgView.layer.shadowOpacity = 0.06f;
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.tipLabel.text = [APPLanguageService wyhSearchContentWith:@"biaoqian"];
    self.tag1L.layer.cornerRadius = 2.0f;
    self.tag1L.layer.masksToBounds = YES;
    self.tag2L.layer.cornerRadius = 2.0f;
    self.tag2L.layer.masksToBounds = YES;
    self.tag3L.layer.cornerRadius = 2.0f;
    self.tag3L.layer.masksToBounds = YES;
    self.tag1L.backgroundColor = MainBg_Color;
    self.tag2L.backgroundColor = MainBg_Color;
    self.tag3L.backgroundColor = MainBg_Color;
}

-(void)creatUIWith:(XianHuoMainObj *)obj {
    
    
    NSString *label = obj.exchangeLabel;
    if(label.length == 0){
        self.tag1L.hidden = YES;
        self.tag2L.hidden = YES;
        self.tag3L.hidden = YES;
        
    }else{
        self.tag1L.hidden = NO;
        self.tag2L.hidden = NO;
        self.tag3L.hidden = NO;
        NSArray *arr = [label componentsSeparatedByString:@"、"];
        if(arr.count == 1){
            self.tag2L.hidden = YES;
            self.tag3L.hidden = YES;
            self.tag1L.text = [arr firstObject];
        }else if(arr.count == 2){
            self.tag3L.hidden = YES;
            self.tag1L.text = [arr firstObject];
            self.tag2L.text = [arr objectAtIndex:1];
        }else{
            self.tag1L.text = [arr firstObject];
            self.tag2L.text = [arr objectAtIndex:1];
            self.tag3L.text = [arr lastObject];
        }
        CGRect rect1 = [self calculateSizeWithFont:12 Text:self.tag1L.text];
        CGRect rect2 = [self calculateSizeWithFont:12 Text:self.tag2L.text];
        CGRect rect3 = [self calculateSizeWithFont:12 Text:self.tag3L.text];
        
        self.tag1W.constant = rect1.size.width + 15;
        self.tag2W.constant = rect2.size.width + 15;
        self.tag3W.constant = rect3.size.width + 15;
        
    }
    obj.icon = SAFESTRING(obj.icon);
    NSString *icon = obj.icon;
    NSString *str =  [getUserCenter getImageURLSizeWithWeight:36*2 andHeight:36*2];
    NSString *url =[NSString stringWithFormat:@"%@?%@",icon,str];
    NSString *imageUrl = [obj.icon hasPrefix:@"http"]?obj.icon:[NSString stringWithFormat:@"%@%@",PhotoImageURL,url];
    [self.imageV setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"default_coin"]];
    
    self.titleL.text = obj.exchangeName;
    self.contentL.text = obj.exchangeAbstract;
    self.jiaoyiduiL.text = obj.tradePairAmount > 0 ? [NSString stringWithFormat:@"%ld",obj.tradePairAmount] : [APPLanguageService wyhSearchContentWith:@"zanwushuju"];;
    self.guojiaL.text = obj.countryName;
    self.paimingL.text = [NSString stringWithFormat:@"NO.%ld",obj.ranking];
    if (kIsCNY) {
        
        if (obj.turnoverCNY >= YI) {
            
            self.chengjiaoliangL.text = [NSString stringWithFormat:@"¥%.2f%@",obj.turnoverCNY/YI,[APPLanguageService sjhSearchContentWith:@"yi"]];
        }else if (obj.turnoverCNY > 0 && obj.turnoverCNY < YI){
            
            self.chengjiaoliangL.text = [NSString stringWithFormat:@"¥%.2f%@",obj.turnoverCNY/WAN,[APPLanguageService sjhSearchContentWith:@"wan"]];
        }else {
            
            self.chengjiaoliangL.text = [APPLanguageService wyhSearchContentWith:@"zanwushuju"];
        }
    } else {
        
        if (obj.turnoverUSD >= YI) {
            
            self.chengjiaoliangL.text = [NSString stringWithFormat:@"$%.2f%@",obj.turnoverUSD/YI,[APPLanguageService sjhSearchContentWith:@"yi"]];
        }else if (obj.turnoverUSD > 0 && obj.turnoverUSD < YI){
            
            self.chengjiaoliangL.text = [NSString stringWithFormat:@"$%.2f%@",obj.turnoverUSD/WAN,[APPLanguageService sjhSearchContentWith:@"wan"]];
        }else {
            
            self.chengjiaoliangL.text = [APPLanguageService wyhSearchContentWith:@"zanwushuju"];
        }
    }
    ////
    self.tagL.text =SAFESTRING(obj.exchangeLabel);
    //self.starView.currentScore = 4.0f;
//    self.starView.hidden = YES;
}



- (CGRect)calculateSizeWithFont:(NSInteger)Font Text:(NSString *)Text{
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:Font]};
    CGRect size = [Text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height)
                                     options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attr
                                     context:nil];
    return size;
}

@end
