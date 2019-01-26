//
//  Y_KlineDateView.m
//  BT
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "Y_KlineDateView.h"
#import "UIColor+Y_StockChart.h"
#import "Y_StockChartGlobalVariable.h"

@implementation Y_KlineDateView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if(self.needDrawKLineModels.count == 0) return;
    __block CGPoint lastDrawDatePoint = CGPointZero;//fix
    
    [self.needDrawKLinePositionModels enumerateObjectsUsingBlock:^(Y_KLinePositionModel * _Nonnull positionModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGPoint point = positionModel.ClosePoint;
        //日期
        NSString *dateStr = self.needDrawKLineModels[idx].Date;
        //时间
        CGFloat width = [dateStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10]} context:nil].size.width;
        if(point.x < 2){
            point.x = 0;
        }
        CGPoint drawDatePoint = CGPointMake(point.x , 4);
        
        //to do
        if(CGPointEqualToPoint(lastDrawDatePoint, CGPointZero) || point.x - lastDrawDatePoint.x > 60 ){
            
            if(self.isFullScreen){
                if(point.x >= ((iPhoneX? ScreenHeight - 50 :ScreenHeight) - 30 - width)){
                    point.x = ((iPhoneX? ScreenHeight - 50 :ScreenHeight) - 30 - width);
                    drawDatePoint.x = point.x;
                }
            }else{
                if(point.x >= (ScreenWidth - 30 - width)){
                    point.x = (ScreenWidth - 30 - width);
                    drawDatePoint.x = point.x;
                }
            }
            
//            }else{
                [dateStr drawAtPoint:drawDatePoint withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10],NSForegroundColorAttributeName : [UIColor assistTextColor]}];
                lastDrawDatePoint = drawDatePoint;
//            }
            
        }
    }];
}

- (void)draw{
    [self setNeedsDisplay];
}
@end
