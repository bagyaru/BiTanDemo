//
//  THFZXPageC.m
//  淘海房
//
//  Created by admin on 2017/8/25.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "THFZXPageC.h"

@implementation THFZXPageC

-(void)setCurrentPage:(NSInteger)currentPage {
    
    [super setCurrentPage:currentPage];
    
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        CGSize size;
        
        size.height = 8;
        
        size.width = 8;
        subview.layer.masksToBounds = YES;
        subview.layer.cornerRadius  = 4;
        subview.layer.borderColor =[UIColor whiteColor].CGColor;
        subview.layer.borderWidth =1.0f;
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                     
                                     size.width,size.height)];
        
        
        
    }
    
}
//设置 空心圆
- (void)setNumberOfPages:(NSInteger)numberOfPages{
    [super setNumberOfPages:numberOfPages];
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        subview.layer.borderColor =[UIColor whiteColor].CGColor;
        subview.layer.borderWidth =1.0f;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
