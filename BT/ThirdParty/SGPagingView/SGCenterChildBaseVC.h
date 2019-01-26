//
//  SGCenterChildBaseVC.h
//  SGPageViewExample
//
//  Created by apple on 2017/6/15.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "RootViewController.h"

@protocol SGCenterChildBaseVCDelegate <NSObject>

- (void)personalCenterChildBaseVCScrollViewDidScroll:(UIScrollView *)scrollView;
@end

@interface SGCenterChildBaseVC : RootViewController

@property (nonatomic, weak) id<SGCenterChildBaseVCDelegate> delegatePersonalCenterChildBaseVC;

@end
