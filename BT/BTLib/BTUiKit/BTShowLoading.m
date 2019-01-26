//
//  BTShowLoading.m
//  BT
//
//  Created by apple on 2018/5/29.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTShowLoading.h"

@interface BTShowLoading()

@property (nonatomic, strong) UIImageView *imageViewLoading;

@end

@implementation BTShowLoading


+ (CGRect)frameOfAlert{
    return CGRectMake(0, 0, 108, 108);
}

- (void)createView{
    self.viewControl.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    self.imageViewLoading = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading_0"]];
    NSMutableArray *loadingImages = @[].mutableCopy;
    for (NSInteger i = 0; i < 49; i++) {
        [loadingImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"loading_%ld",i]]];
    }
    [self.imageViewLoading setAnimationImages:loadingImages];
    [self.imageViewLoading setAnimationDuration:loadingImages.count * 0.1];
    [self.imageViewLoading setAnimationRepeatCount:0];
    self.imageViewLoading.frame = self.bounds;
    [self addSubview:self.imageViewLoading];
}

+ (void)show{
    BTShowLoading *loading = [[BTShowLoading alloc] initWithFrame:[self frameOfAlert]];
    [loading.imageViewLoading startAnimating];
    [loading show];
    
}

- (void)__hide{
    
}

+ (void)hide{
    BTShowLoading *loading =(BTShowLoading*)[self HUDForView:[UIApplication sharedApplication].keyWindow];
    [loading.imageViewLoading stopAnimating];
    [loading removeFromSuperview];
    [loading.viewControl removeFromSuperview];
    
}

+ (UIView*)HUDForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (BTShowLoading *)subview;
        }
    }
    return nil;
}

@end
