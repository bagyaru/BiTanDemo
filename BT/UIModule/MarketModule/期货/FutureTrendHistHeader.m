//
//  FutureTrendHistHeader.m
//  BT
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FutureTrendHistHeader.h"

@interface FutureTrendHistHeader()

@property (weak, nonatomic) IBOutlet UILabel *duoIndicatorL;
@property (weak, nonatomic) IBOutlet UILabel *kongIndicatorL;

@end

@implementation FutureTrendHistHeader

- (void)awakeFromNib{
    [super awakeFromNib];
    self.duoIndicatorL.layer.cornerRadius = 5.0f;
    self.duoIndicatorL.layer.masksToBounds = YES;
    self.kongIndicatorL.layer.cornerRadius = 5.0f;
    self.kongIndicatorL.layer.masksToBounds = YES;
    
    
}

@end
