//
//  TopicDetailHeadView.m
//  BT
//
//  Created by admin on 2018/4/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "TopicDetailHeadView.h"

@implementation TopicDetailHeadView

-(void)setDict:(NSDictionary *)dict {
    _dict = dict;
    ViewRadius(self.buttonlHotRecommend, 10);
    self.buttonlHotRecommend.hidden = ![dict[@"hotRecommend"] boolValue];
    if (![dict[@"hotRecommend"] boolValue]) {
        self.buttonHotRecommendW.constant = 0;
        self.left.constant = 0;
    }
    self.dOuStr = [APPLanguageService wyhSearchContentWith:@"zhankai"];
    //[self.topIV sd_setImageWithURL:[NSURL URLWithString:dict[@"imgUrl"]] placeholderImage:[UIImage imageNamed:@"Mask_lis"]];
    [self.topIV setImageWithURL:[NSURL URLWithString:dict[@"imgUrl"]] placeholder:[UIImage imageNamed:@"Mask_list"]];
    self.topIV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.topIV addGestureRecognizer:tap];
    self.numberL.text = [NSString stringWithFormat:@"%@%@  %@%@",[[DigitalHelperService transformWith:[dict[@"viewCount"] doubleValue]] hasSuffix:@".00"] ? [[DigitalHelperService transformWith:[dict[@"viewCount"] doubleValue]] stringByReplacingOccurrencesOfString:@".00" withString:@""] : [DigitalHelperService transformWith:[dict[@"viewCount"] doubleValue]],[APPLanguageService wyhSearchContentWith:@"renliulan"],[[DigitalHelperService transformWith:[dict[@"commentCount"] doubleValue]] hasSuffix:@".00"] ? [[DigitalHelperService transformWith:[dict[@"commentCount"] doubleValue]] stringByReplacingOccurrencesOfString:@".00" withString:@""] : [DigitalHelperService transformWith:[dict[@"commentCount"] doubleValue]],[APPLanguageService wyhSearchContentWith:@"tiaopinglun"]];
    self.titleL.text = dict[@"title"];
    self.contentL.text = dict[@"content"];
    
    [getUserCenter setLabelSpace:self.titleL withValue:dict[@"title"] withFont:FONT(PF_MEDIUM, 20) withHJJ:8.0 withZJJ:0.0];
    
    [getUserCenter setLabelSpace:self.contentL withValue:dict[@"content"] withFont:FONT(PF_REGULAR, 16) withHJJ:8.0 withZJJ:0.0];
    
    CGFloat height = 0.0;
    height = [getUserCenter getSpaceLabelHeight:dict[@"title"] withFont:FONT(PF_MEDIUM, 20) withWidth:ScreenWidth-15-(self.left.constant+self.buttonHotRecommendW.constant+15) withHJJ:8.0 withZJJ:0.0];
    self.titleConstrainat.constant = height;
    
    CGFloat height1 = [getUserCenter getSpaceLabelHeight:dict[@"content"] withFont:FONT(PF_REGULAR, 16) withWidth:ScreenWidth-30 withHJJ:8.0 withZJJ:0.0]+1;
    if (height1 > 70) {
        
        self.contentConstrainat.constant = 70;
        self.dOuBtn.hidden = NO;
    }else {
        
        self.contentConstrainat.constant = height1;
        self.dOuBtnConstrainat.constant  = 0;
        self.dOuBtn.hidden = YES;
    }
    NSLog(@"%.2f  %.2f",height,height1);
    
}
-(CGFloat)getHeadViewHeight {
    
    CGFloat height = [getUserCenter getSpaceLabelHeight:self.dict[@"title"] withFont:FONT(PF_MEDIUM, 20) withWidth:ScreenWidth-15-(self.left.constant+self.buttonHotRecommendW.constant+15) withHJJ:8.0 withZJJ:0.0];
    
    CGFloat height1 = [getUserCenter getSpaceLabelHeight:self.dict[@"content"] withFont:FONT(PF_REGULAR, 16) withWidth:ScreenWidth-30 withHJJ:8.0 withZJJ:0.0]+1;
    if (ISStringEqualToString(self.dOuStr, [APPLanguageService wyhSearchContentWith:@"zhankai"])) {
        
        if (height1 > 70) {
            
            height1 = 70;
        }
    }
    NSLog(@"%.2f  %.2f",height,height1);
    return height+height1+self.dOuBtnConstrainat.constant;
}
// 展开/收起
- (IBAction)downOrUpBtn:(UIButton *)sender {
    
   
    CGFloat height1 = [getUserCenter getSpaceLabelHeight:self.dict[@"content"] withFont:FONT(PF_REGULAR, 16) withWidth:ScreenWidth-30 withHJJ:8.0 withZJJ:0.0]+1;
    if (ISStringEqualToString(self.dOuStr, [APPLanguageService wyhSearchContentWith:@"zhankai"])) {
        self.dOuStr = [APPLanguageService wyhSearchContentWith:@"shouqi"];
        self.contentConstrainat.constant = height1;
    }else {
        self.dOuStr = [APPLanguageService wyhSearchContentWith:@"zhankai"];
        if (height1 > 70) {
            
            self.contentConstrainat.constant = 70;
        }else {
            
            self.contentConstrainat.constant = height1;
        }
    }
    NSLog(@"%@",self.dOuStr);
    [sender setTitle:self.dOuStr forState:UIControlStateNormal];
    if (self.dOuBlack) {
        
        self.dOuBlack();
    }
}
//打赏
- (IBAction)dashangBtnClick:(UIButton *)sender {
    [MobClick event:@"taolun_detail_dasahng"];
    [getUserCenter ExceptionalAuthorsWithID:[self.dict[@"infoID"] integerValue] andType:4];
}

- (void)tap{
    NSMutableArray *images = @[].mutableCopy;
    NSString *url = SAFESTRING(_dict[@"imgUrl"]);
    if(url.length > 0){
        [images addObject:url];
    }
    if(images.count >0){
        [getUserCenter PreviewImageSCreatPhotoBrowserVCWithImages:images andIndexPath:0];
    }
}

@end
