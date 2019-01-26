//
//  ShareCodeToFriend.m
//  BT
//
//  Created by apple on 2018/5/31.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShareCodeToFriend.h"
#import "ShareCodeView.h"

@implementation ShareCodeToFriend

+(UIImage*)getImageFromViewWithCode:(NSString*)codeStr reward:(NSInteger)reward{
    ShareCodeToFriend *shareCode = [ShareCodeToFriend new];
    ShareCodeView *codeView = [[ShareCodeView alloc] initWithCodeStr:codeStr reward:reward];
    
    //让视图有布局显示出来
    [codeView setNeedsLayout];
    [codeView layoutIfNeeded];
    codeView.height = codeView.scrollViewContentSizeH;
    [codeView setNeedsLayout];
    [codeView layoutIfNeeded];
    UIImage *img = [shareCode getImage:codeView height:codeView.scrollViewContentSizeH];
    return img;
}

- (UIImage *)getImage:(UIView *)view height:(CGFloat)height;
{
    //下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。
    //如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.width, height), NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
//    CGPoint savedContentOffset = scrollView.contentOffset;
//    CGRect savedFrame = view.frame;
////    scrollView.contentOffset = CGPointZero;
//    view.frame = CGRectMake(0, 0, savedFrame.frame.size.width, height);
//
//    [view.layer renderInContext: UIGraphicsGetCurrentContext()];
//    image = UIGraphicsGetImageFromCurrentImageContext();
//
//    scrollView.contentOffset = savedContentOffset;
//    scrollView.frame = savedFrame;
//    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)snapshotWithScrollView:(UIScrollView *)scrollView
{
    UIImage* image = nil;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, YES, [UIScreen mainScreen].scale);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        return image;
    }
    return nil;
}




@end
