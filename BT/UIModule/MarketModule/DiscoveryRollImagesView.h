//
//  MKRollImagesView.h
//  YangDongXi
//
//  Created by cocoa on 15/4/10.
//  Copyright (c) 2015年 cocoa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiscoveryRollImagesView;
@protocol DiscoveryRollImagesViewDelegate <NSObject>

@optional
- (void)rollImagesView:(DiscoveryRollImagesView *)rollView didClickIndex:(NSInteger)index;

@end


@interface DiscoveryRollImagesView : UIView

@property (nonatomic, weak) id<DiscoveryRollImagesViewDelegate> delegate;

@property (nonatomic, strong) NSArray *bannerUrls;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, strong) UIImage *placeHolderImage;

@property (nonatomic, strong) NSArray *titles;

- (void)autoRollEnable:(BOOL)enable;

@end
