//
//  DVPieChart.m
//  DVPieChart
//
//  Created by SmithDavid on 2018/2/26.
//  Copyright © 2018年 SmithDavid. All rights reserved.
//

#import "BTCoinDistriPieChart.h"
#import "DVFoodPieModel.h"
#import "DVPieCenterView.h"
#import "UIColor+expanded.h"


#define COLOR_ARRAY @[\
[UIColor colorWithHexString:@"3A99DE" andAlpha:1.0],\
[UIColor colorWithHexString:@"F99E5E" andAlpha:1.0],\
[UIColor colorWithHexString:@"72D555" andAlpha:1.0],\
[UIColor colorWithHexString:@"F2C74D" andAlpha:1.0],\
[UIColor colorWithHexString:@"F2C74D" andAlpha:0.8],\
[UIColor colorWithHexString:@"F2C74D" andAlpha:0.6],\
[UIColor colorWithHexString:@"F2C74D" andAlpha:0.4],\
]

#define CHART_MARGIN 50

@interface BTCoinDistriPieChart ()

@property (nonatomic, strong) NSMutableArray *modelArray;
@property (nonatomic, strong) NSMutableArray *colorArray;

@end


@implementation BTCoinDistriPieChart

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = isNightMode?ViewContentBgColor:CWhiteColor;
    }
    return self;
}

- (void)draw {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setNeedsDisplay];
}


-(void)drawRect:(CGRect)rect{
    CGPoint center =  CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    CGFloat radius = 70 / 2; //
    CGFloat start = M_PI *3 / 2;
    CGFloat angle = 0;
    CGFloat end = start;
    
    if (self.dataArray.count == 0) {
        end = start + M_PI * 2;
        UIColor *color = COLOR_ARRAY.firstObject;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:start endAngle:end clockwise:true];
        [color set];
        //添加一根线到圆心
        [path addLineToPoint:center];
        [path fill];
        
    } else {
        self.modelArray = [NSMutableArray array];
        self.colorArray = [NSMutableArray array];
        for (int i = 0; i < self.dataArray.count; i++) {
            DVFoodPieModel *model = self.dataArray[i];
            CGFloat percent = model.afterRate;
            UIColor *color;
            if(i>=COLOR_ARRAY.count){
                color = [UIColor blackColor];
            }else{
                color= COLOR_ARRAY[i];
            }
           
            start = end;
            angle = percent * M_PI * 2;
            end = start + angle;
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:start endAngle:end clockwise:true];
            [color set];
            
            //添加一根线到圆心
            [path addLineToPoint:center];
            [path fill];
        }
    }
    // 在中心添加label
    DVPieCenterView *centerView = [[DVPieCenterView alloc] init];
    centerView.frame = CGRectMake(0, 0, 40, 40);
    
    CGRect frame = centerView.frame;
    frame.origin = CGPointMake(self.frame.size.width * 0.5 - frame.size.width * 0.5, self.frame.size.height * 0.5 - frame.size.width * 0.5);
    centerView.frame = frame;
    centerView.center = center;
    [self addSubview:centerView];
}

@end

