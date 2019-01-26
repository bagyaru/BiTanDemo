//
//  TabContentView.h
//  BT
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TabSwitchBlcok)(NSInteger index);

@interface TabContentView : UIView<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
/**
 page
 */
@property (nonatomic,strong)UIPageViewController *pageController;

/**
 内容页数组
 */
@property (nonatomic,strong)NSArray<UIViewController*> *controllers;
/**
 内容页数组
 */
@property (nonatomic,strong)TabSwitchBlcok tabSwitch;

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) UINavigationController *navController;


-(void)updateTab:(NSInteger)index;

-(void)configParam:(NSMutableArray<UIViewController*>*)controllers Index:(NSInteger)index block:(TabSwitchBlcok) tabSwitch;

@end
