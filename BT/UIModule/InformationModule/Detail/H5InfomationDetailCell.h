//
//  H5InfomationDetailCell.h
//  BT
//
//  Created by admin on 2018/11/6.
//  Copyright © 2018 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "BTConfig.h"
#import "THFZXAndBKObj.h"
NS_ASSUME_NONNULL_BEGIN
@protocol THFZXAndBKCellDelegate <NSObject>

-(void)THFZXAndBKCellHeight:(CGFloat)height;

@end
typedef void(^InfoDetailLikeBlock)(void);
@interface H5InfomationDetailCell : UITableViewCell<WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *h5View;
@property (weak, nonatomic) IBOutlet UIView *viewDS;
@property (weak, nonatomic) IBOutlet UIView *viewZan;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewZan;
@property (weak, nonatomic) IBOutlet BTLabel *labelZan;
@property (weak, nonatomic) IBOutlet UIView *downView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downViewH;


@property (weak, nonatomic) id <THFZXAndBKCellDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *allUrlArray;
@property (nonatomic, copy)   InfoDetailLikeBlock detailLikeBlock;
@property (nonatomic, strong) THFZXAndBKObj *model;
@property (nonatomic,assign)  NSInteger bigType;
-(void)creatUIWith:(NSString *)str isOrNoFirst:(BOOL)isOrNoFirst model:(THFZXAndBKObj *)model bigType:(NSInteger)bigType;
@property(nonatomic,assign) BOOL isFinishLoading;
@end

NS_ASSUME_NONNULL_END
