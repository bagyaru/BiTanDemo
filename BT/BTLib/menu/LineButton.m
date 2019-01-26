//
//  LineButton.m
//  Chonps
//
//  Created by tangshilei on 17/8/10..
//  Copyright © 2016年 mc. All rights reserved.
//

#import "LineButton.h"

@interface LineButton (){
    UIView *view;
}
@end

@implementation LineButton
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if(selected){
        view =[[UIView alloc]initWithFrame:CGRectZero];
        [self addSubview:view];
        CGFloat width = [self calculateSizeWithFont:14 Text:self.currentTitle].size.width;
        view.backgroundColor = kHEXCOLOR(0x108ee9);
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.mas_equalTo(width + 6);
            make.height.mas_equalTo(2);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }else{
        if(view){
            [view removeFromSuperview];
        }
    }
    
}

-(CGRect)calculateSizeWithFont:(NSInteger)Font Text:(NSString *)Text{
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:Font]};
    CGRect size = [Text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height)
                                     options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attr
                                     context:nil];
    return size;
}
@end
