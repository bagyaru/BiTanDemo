//
//  ShareCodeView.h
//  BT
//
//  Created by apple on 2018/5/31.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareCodeView : UIView

-(instancetype)initWithCodeStr:(NSString *)codeStr reward:(NSInteger)reward;

@property (nonatomic,assign) CGFloat scrollViewContentSizeH;

@end
