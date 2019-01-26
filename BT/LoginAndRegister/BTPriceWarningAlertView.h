//
//  BTPriceWarningAlertView.h
//  BT
//
//  Created by admin on 2018/11/28.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BTView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTPriceWarningAlertView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *zhangOrDieIV;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelContent;
@property (weak, nonatomic) IBOutlet UIImageView *anamationIV;

@property (nonatomic, strong)NSDictionary *dict;
@property (nonatomic, strong)NSString *title;
@end

NS_ASSUME_NONNULL_END
