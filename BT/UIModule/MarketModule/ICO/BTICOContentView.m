//
//  BTICOContentView.m
//  BT
//
//  Created by apple on 2018/8/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTICOContentView.h"
#import "BTICODetailItemView.h"

@interface BTICOContentView()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation BTICOContentView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 8.0f;
    self.bgView.layer.masksToBounds = NO;
    
    self.bgView.layer.shadowColor = rgba(0, 0, 0, 1).CGColor;
    self.bgView.layer.shadowOpacity = 0.05f;
    self.bgView.layer.shadowRadius = 6.0f;
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
}

- (void)setContent:(NSArray*)arr{
    for(UIView *view in self.bgView.subviews){
        [view removeFromSuperview];
    }
    
    for(NSInteger i =0; i<arr.count; i++){
        BTICODetailItemView *itemView = [BTICODetailItemView loadFromXib];
        itemView.frame = CGRectMake(0, 6+30*i, ScreenWidth - 30, 30);
        itemView.dict = arr[i];
        [self.bgView addSubview:itemView];
        
    }
}

@end
