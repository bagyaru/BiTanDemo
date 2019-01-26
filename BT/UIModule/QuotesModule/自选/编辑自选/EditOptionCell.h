//
//  EditOptionCell.h
//  BT
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemModel.h"

typedef void(^TopHandleBlock)(void);
typedef void(^SelectHandleBlock)(void);

@interface EditOptionCell : UITableViewCell

@property (nonatomic, strong) NSString *title;

@property (nonatomic, copy) TopHandleBlock topHandle;
@property (nonatomic, copy) SelectHandleBlock selectHandle;


@property (nonatomic, strong) ItemModel *itemModel;


@end
