//
//  DVPieCenterView.m
//  DVPieChart
//
//  Created by SmithDavid on 2018/2/27.
//  Copyright © 2018年 SmithDavid. All rights reserved.
//

#import "DVPieCenterView.h"

@interface DVPieCenterView ()

@property (strong, nonatomic) UIView *centerView;

@end

@implementation DVPieCenterView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        UIView *centerView = [[UIView alloc] init];
        centerView.backgroundColor = isNightMode? ViewContentBgColor :[UIColor whiteColor];
        [self addSubview:centerView];
        self.centerView = centerView;
    }
    
    return self;
}
//
- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.width * 0.5;
    self.layer.masksToBounds = true;
    self.centerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.centerView.layer.cornerRadius = self.centerView.frame.size.width * 0.5;
    self.centerView.layer.masksToBounds = true;
    self.nameLabel.frame = self.centerView.bounds;
}

@end
