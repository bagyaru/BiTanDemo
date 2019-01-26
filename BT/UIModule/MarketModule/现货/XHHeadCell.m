//
//  XHHeadCell.m
//  BT
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "XHHeadCell.h"

@implementation XHHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
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

-(void)creatUIWithDict:(NSMutableDictionary *)dict {
    
    NSString *label = dict[@"label"];
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
    NSString *icon = SAFESTRING(dict[@"icon"]);
    NSString *str =  [getUserCenter getImageURLSizeWithWeight:46*2 andHeight:46*2];
    NSString *url =[NSString stringWithFormat:@"%@?%@",icon,str];
    NSString *imageUrl = [icon hasPrefix:@"http"]?icon:[NSString stringWithFormat:@"%@%@",PhotoImageURL,url];
    [self.imageV setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:[UIImage imageNamed:@"default_coin"]];
    NSString *rank = SAFESTRING(dict[@"rank"]);
    self.rank.text = [NSString stringWithFormat:@"NO.%@",rank];
    self.titleL.text = dict[@"title"];
    self.contentL.text = dict[@"content"];
    CGFloat height = 0.0;
    if (ISNSStringValid(dict[@"content"])) {
        
        [getUserCenter getLabelHight:self.contentL Float:4.0 AddImage:NO];
        
        height = [getUserCenter customGetContactHeight:dict[@"content"] FontOfSize:14 LabelMaxWidth:ScreenWidth-26 jianju:6.0];
    }
    
    
    if ([dict[@"isDetail"] boolValue]) {
        
        self.contentL.numberOfLines = 0;
        self.detailBtn.hidden = NO;
        self.detailBtn.localTitle = @"upDetail";
    } else {
        
        self.detailBtn.localTitle = @"changkanquanbu";
        NSLog(@"%.0f",height);
        if (height > 65) {
            
            self.detailBtn.hidden = NO;
            self.contentL.numberOfLines = 3;
            
        }else {
            
            self.detailBtn.hidden = YES;
            self.contentL.numberOfLines = 0;
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
