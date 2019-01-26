//
//  AddRecordNavView.h
//  BT
//
//  Created by admin on 2018/5/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuotosNavView : UIView


@property (weak, nonatomic) IBOutlet BTButton *globalBtn;

@property (weak, nonatomic) IBOutlet BTButton *exchangeBtn;

@property (weak, nonatomic) IBOutlet UILabel *middeL;

@property(nonatomic, assign) CGSize intrinsicContentSize;
@end
