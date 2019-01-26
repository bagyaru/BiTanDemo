//
//  THFPageControl.m
//  淘海房
//
//  Created by admin on 2017/8/25.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "THFPageControl.h"

@implementation THFPageControl


-(void)setCurrentPage:(NSInteger)currentPage {
    
    [super setCurrentPage:currentPage];
    
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        CGSize size;
        
        size.height = 2;
        
        size.width = 8;
        
        subview.layer.masksToBounds = NO;
        subview.layer.cornerRadius  = 0;
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                     
                                     size.width,size.height)];
        
        
        
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
