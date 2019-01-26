//
//  BTICODetailItemView.m
//  BT
//
//  Created by apple on 2018/8/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTICODetailItemView.h"

@interface BTICODetailItemView()

@property (weak, nonatomic) IBOutlet BTLabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *contenL;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidthCons;

@end


@implementation BTICODetailItemView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.addBtn.layer.cornerRadius = 13.0f;
    self.addBtn.layer.masksToBounds = YES;
    self.addBtn.hidden = YES;
}

- (void)setDict:(NSDictionary *)dict{
    _dict = dict;
    if(dict){
        NSString *key = SAFESTRING(dict[@"key"]);
        NSString *chineseKey = SAFESTRING(dict[@"chineseKey"]);
        if([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]){
            self.titleL.text = chineseKey;
        }else{
            self.titleL.text = key;
        }
        
        self.contenL.text = SAFESTRING(dict[@"value"]);
        
        if([key isEqualToString:@"Whitelist "] ||[key isEqualToString:@"Know Your Customer (KYC) "]){
            NSString *str = [APPLanguageService sjhSearchContentWith:@"lijijiaru"];
            CGSize size = [self calculateSizeWithFont:12 Text:str].size;
            self.btnWidthCons.constant = size.width + 24;
            self.contenL.hidden = YES;
            self.addBtn.hidden = NO;
        }else{
            self.contenL.hidden = NO;
            self.addBtn.hidden = YES;
        }
        
    }
}

- (IBAction)click:(id)sender {
    NSString *key = SAFESTRING(self.dict[@"key"]);
//    key = [key stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([key isEqualToString:@"Whitelist "] ||[key isEqualToString:@"Know Your Customer (KYC) "]){
        NSString *value = SAFESTRING(self.dict[@"value"]);
        if(SAFESTRING(value).length >0){
            H5Node *node = [[H5Node alloc] init];
            node.webUrl = value;
            node.title = key;
            [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
        }
    }
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
