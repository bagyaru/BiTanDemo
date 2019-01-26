//
//  THFZXAndBKCell.h
//  淘海房
//
//  Created by admin on 2018/1/2.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THFZXAndBKObj.h"
@protocol THFZXAndBKCellDelegate <NSObject>

-(void)THFZXAndBKCellHeight:(CGFloat)height;
@end
typedef void(^InfoDetailLikeBlock)(void);
@interface THFZXAndBKCell : UITableViewCell<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *viewDS;
@property (weak, nonatomic) IBOutlet UIView *viewZan;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewZan;
@property (weak, nonatomic) IBOutlet BTLabel *labelZan;
@property (weak, nonatomic) id <THFZXAndBKCellDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *allUrlArray;
@property (nonatomic, copy)   InfoDetailLikeBlock detailLikeBlock;
@property (nonatomic, strong) THFZXAndBKObj *model;
@property (nonatomic,assign)  NSInteger bigType;
-(void)creatUIWith:(NSString *)str isOrNoFirst:(BOOL)isOrNoFirst model:(THFZXAndBKObj *)model bigType:(NSInteger)bigType;
@end
