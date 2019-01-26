//
//  InfomationNavagationView.h
//  BT
//
//  Created by admin on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"

@interface InfomationNavagationView : BTView
@property (weak, nonatomic) IBOutlet BTButton *houseBtn;
@property (weak, nonatomic) IBOutlet BTButton *infoMationBtn;
@property (weak, nonatomic) IBOutlet BTButton *baikeBtn;



@property (weak, nonatomic) IBOutlet UILabel *lineL1;
@property (weak, nonatomic) IBOutlet UILabel *lineL2;
@property (weak, nonatomic) IBOutlet UILabel *lineL3;

@property(nonatomic, assign) CGSize intrinsicContentSize;
@end
