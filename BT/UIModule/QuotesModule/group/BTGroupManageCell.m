//
//  BTGroupManageCell.m
//  BT
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTGroupManageCell.h"
#import "NewCreateGroupAlert.h"
#import "BTUpdateGroupReq.h"
#import "ComfirmAlertView.h"
#import "BTDeleteGroupRequest.h"

@interface BTGroupManageCell()

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLConstraint;

@property (weak, nonatomic) IBOutlet UIButton *reNameBtn;

@property (weak, nonatomic) IBOutlet UIButton *zhidingBtn;

@property (weak, nonatomic) IBOutlet UILabel *hintDescL;

@property (weak, nonatomic) IBOutlet UIImageView *indicatorV;


@end

@implementation BTGroupManageCell

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing: editing animated: YES];
    if (editing) {
        for (UIView * view in self.subviews) {
            if ([NSStringFromClass([view class]) rangeOfString: @"Reorder"].location != NSNotFound) {
                for (UIView * subview in view.subviews) {
                    if ([subview isKindOfClass: [UIImageView class]]) {
                        ((UIImageView *)subview).image = [UIImage imageNamed: @"bt_sorting"];
                        if(isNightMode){
                             subview.frame =CGRectMake(0, 0, 16, 18);
                        }else{
                             subview.frame =CGRectMake(0, 0, 12, 10);
                        }
                       
                    }
                }
            }
        }
    }
}

- (void)setModel:(BTGroupListModel *)model{
    if(model){
        _model = model;
        _nameL.text = model.groupName;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.deleteBtn.hidden = YES;
    self.reNameBtn.hidden = YES;
    
    self.hintDescL.hidden = YES;
    self.zhidingBtn.hidden =YES;
    
    self.nameLConstraint.constant = 15.0f;
    [AppHelper addSeparateLineWithParentView:self.contentView];
    [self.deleteBtn setImage:[UIImage imageNamed:@"edit_delete"] forState:UIControlStateNormal];
    [self.zhidingBtn setImage:[UIImage imageNamed:@"group_top"] forState:UIControlStateNormal];
    

}

- (void)setIsEdit:(BOOL)isEdit{
    if(isEdit){
        self.deleteBtn.hidden = NO;
        self.reNameBtn.hidden = NO;
        self.hintDescL.hidden = YES;
        self.zhidingBtn.hidden =NO;
        self.indicatorV.hidden =YES;
        self.nameLConstraint.constant = 44.0f;
    }else{
        self.deleteBtn.hidden = YES;
        self.reNameBtn.hidden = YES;
        self.hintDescL.hidden = YES;
        self.zhidingBtn.hidden =YES;
        self.indicatorV.hidden =NO;
        self.nameLConstraint.constant = 15.0f;
    }
}

- (void)setIsAllEdit:(BOOL)isAllEdit{
    if(isAllEdit){
        self.indicatorV.hidden = YES;
        self.hintDescL.hidden = NO;
        
    }else{
        self.indicatorV.hidden = NO;
        self.hintDescL.hidden = YES;
    }
    
}

- (IBAction)deleteAction:(id)sender {
    
    [ComfirmAlertView showWithTitle:@"确认删除分组？" Completion:^{
        BTDeleteGroupRequest *api = [[BTDeleteGroupRequest alloc]initWithGroupId:self.model.userGroupId];
        [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            if([self.delegate respondsToSelector:@selector(refreshData)]){
                [self.delegate refreshData];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:k_Notification_Refresh_After_Delete object:self.model];
            
        } failure:^(__kindof BTBaseRequest *request) {
            
        }];
        
    }];
}

//
- (IBAction)reNameAction:(id)sender {
    
    [NewCreateGroupAlert showWithModel:self.model completion:^(NSString *name) {
        
        BTUpdateGroupReq *api = [[BTUpdateGroupReq alloc] initWithGroupName:self.model.groupName newName:name];
        [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            if([self.delegate respondsToSelector:@selector(refreshData)]){
                [self.delegate refreshData];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:k_Notification_Refresh_After_Delete object:self.model];
        } failure:^(__kindof BTBaseRequest *request) {
            
            
        }];
    }];
}

- (IBAction)topAction:(id)sender {
    if (self.groupBlock) {
        self.groupBlock();
    }
}


@end
