//
//  BTIndexDetailSelectView.m
//  BT
//
//  Created by admin on 2018/6/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTIndexDetailSelectView.h"

@implementation BTIndexDetailSelectView

-(void)setIndexProfileStr:(NSString *)indexProfileStr {
    
    _indexProfileStr = indexProfileStr;
    
    [getUserCenter setLabelSpace:self.IndexProfileL withValue:indexProfileStr withFont:[UIFont systemFontOfSize:12] withHJJ:4.0 withZJJ:0.0];
    
}
-(CGFloat)getHeight {
    
    CGFloat Height = [getUserCenter getSpaceLabelHeight:_indexProfileStr withFont:[UIFont systemFontOfSize:12] withWidth:ScreenWidth-30 withHJJ:4.0 withZJJ:0.0]+140;
    return Height;
}
@end
