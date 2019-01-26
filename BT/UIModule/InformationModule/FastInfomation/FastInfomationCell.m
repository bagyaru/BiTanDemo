//
//  FastInfomationCell.m
//  BT
//
//  Created by admin on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FastInfomationCell.h"

@implementation FastInfomationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self.backV, 10);
    self.backV.backgroundColor = isNightMode ? [UIColor colorWithHexString:@"373C45"] : [UIColor colorWithHexString:@"E4F4FF"];
    ViewBorderRadius(self.shareBtn, 12, 1, BtnBorderColor);
    self.imageViewRound.image = IMAGE_NAMED(@"小点");
}
-(void)creatUIWith:(FastInfomationObj *)obj {
    
    self.timeL.text = [getUserCenter minutestimeWithTimeIntervalString:obj.issueDate];
    CGFloat height = 0.0;
    if ([obj.content containsString:@"【"] && [obj.content containsString:@"】"]) {
        
        NSRange startRange = [obj.content rangeOfString:@"【"];
        NSRange endRange = [obj.content rangeOfString:@"】"];
        NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
        NSString *titleResult = [obj.content substringWithRange:range];
        NSString *contentResult = [[obj.content substringFromIndex:endRange.location] stringByReplacingOccurrencesOfString:@"】" withString:@""];
        NSLog(@"%@ %@",titleResult,contentResult);
        self.titleL.text    = titleResult;
        [getUserCenter setLabelSpace:self.titleL withValue:titleResult withFont:FONT(PF_MEDIUM, 16) withHJJ:6.0 withZJJ:0.0];
        self.contentL.text = contentResult;
        [getUserCenter setLabelSpace:self.contentL withValue:contentResult withFont:FONT(PF_REGULAR, 16) withHJJ:6.0 withZJJ:0.0];
        height = [getUserCenter getSpaceLabelHeight:contentResult withFont:FONT(PF_REGULAR, 16) withWidth:ScreenWidth-50 withHJJ:6.0 withZJJ:0.0];
    }else {
        
        self.titleL.text    = @"";
        self.contentL.text = obj.content;
        [getUserCenter setLabelSpace:self.contentL withValue:obj.content withFont:FONT(PF_REGULAR, 16) withHJJ:6.0 withZJJ:0.0];
        height = [getUserCenter getSpaceLabelHeight:obj.content withFont:FONT(PF_REGULAR, 16) withWidth:ScreenWidth-50 withHJJ:6.0 withZJJ:0.0];
        
    }
    
    if (obj.IsOrNoLookDetail) {
        
        self.contentL.numberOfLines = 0;
        self.detailBtn.hidden = NO;
        self.detailBtn.localTitle = @"upDetail";
        
    } else {
        
        self.detailBtn.localTitle = @"downDetail";
        if (height > 110) {
            
            self.detailBtn.hidden = NO;
            self.contentL.numberOfLines = 4;
            
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

@end
