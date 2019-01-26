//
//  BTIndexDetailSelectView.h
//  BT
//
//  Created by admin on 2018/6/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"

@interface BTIndexDetailSelectView : BTView

@property (weak, nonatomic) IBOutlet UILabel *IndexProfileL;
@property (weak, nonatomic) IBOutlet BTLabel *typeL;
@property (nonatomic,strong) NSString *indexProfileStr;
-(CGFloat)getHeight;
@end
