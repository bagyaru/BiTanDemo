//
//  HistorySearchCell.m
//  BT
//
//  Created by apple on 2018/1/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HistorySearchCell.h"
#import "BTSearchService.h"

@interface HistorySearchCell ()

@property (nonatomic, assign) CGFloat heightCell;

@end

@implementation HistorySearchCell{
    UIButton *priBtn;
    CGFloat totalWidth;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    [self createView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)shareInstance{
    static HistorySearchCell *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cell = [[UINib nibWithNibName:NSStringFromClass([HistorySearchCell class]) bundle:nil] instantiateWithOwner:self options:nil][0];
    });
    return cell;
}

+ (CGFloat)cellHeight{
    HistorySearchCell *cell = [self shareInstance];
    return cell.heightCell;
//    return self.cellHeight;
}

- (void)createView{
    NSArray *arr;
    
    if (self.type < 1  && [BTConfigureService shareInstanceService].hotSearchArray.count > 0) {
        
        if (self.section == 1) {//热门搜索
            
            arr = [BTConfigureService shareInstanceService].hotSearchArray;
        } else {//历史搜索
            
            arr = [[BTSearchService sharedService] readHistorySearch];
        }
        
    } else {
        
        switch (self.type) {
            case 0:
                arr = [[BTSearchService sharedService] readHistorySearch];
                break;
            case 1:
                arr = [[BTSearchService sharedService] readHistoryXianhuoSearch];
                break;
            case 2:
                arr = [[BTSearchService sharedService] readHistoryQihuoSearch];
                break;
            case 3:
                
                arr = [[BTSearchService sharedService] readHistorySYTJSearch];
                break;
            default:
                break;
        }
    }
    totalWidth = 0;
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    for (NSInteger i = 0;i < (arr.count > HotSearchAndHistoryMax ? HotSearchAndHistoryMax :arr.count);i++) {
//        NSString *str = arr[i];
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.tag = 500 + i;
//        [btn addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
//        btn.titleLabel.font = MediumFont;
//        ViewRadius(btn, 15.0f);
//        [btn setTitleColor:CGrayColor forState:UIControlStateNormal];
//        btn.backgroundColor = CSearchBarColor;
//        [btn setTitle:str forState:UIControlStateNormal];
//        [self.contentView addSubview:btn];
//        btn.frame = CGRectMake( 10 + ( 10 + (ScreenWidth - 50) / 4.0)  * (i % 4), 20 +(20 + 30) * (i / 4), (ScreenWidth - 50) / 4.0, 30);
//    }
//
//    UIButton *lastBtn = [self.contentView viewWithTag:(arr.count > HotSearchAndHistoryMax ? HotSearchAndHistoryMax :arr.count) - 1 + 500];
//    self.heightCell = lastBtn.frame.origin.y + lastBtn.frame.size.height + 20;
//    if (self.heightCell < 70) {
//        self.heightCell = 70;
//    }
    
    UIButton *listButton;
    __block float buttonRight;
    for (int i = 0; i < (arr.count > HotSearchAndHistoryMax ? HotSearchAndHistoryMax :arr.count); i++) {
        NSString *title = arr[i];
        CGFloat titleW = [self labelAutoCalculateRectWith:title FontSize:14 MaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + 20;
        UIButton *button = [UIButton new];
        button.tag = 500 + i;
        ViewRadius(button, 4.0f);
        if(self.section == 1){
            button.backgroundColor = isNightMode?ViewBGNightColor:kHEXCOLOR(0xEEF8FF);
            [button setTitleColor:MainBg_Color forState:UIControlStateNormal];
        }else{
            button.backgroundColor = isNightMode?ViewBGNightColor: kHEXCOLOR(0xF5F5F5);
            [button setTitleColor:kHEXCOLOR(0x777777) forState:UIControlStateNormal];
        }
        [button setTitle:title forState:UIControlStateNormal];
       
        [button addTarget:self action:@selector(clickedBtn:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = FONTOFSIZE(14.0f);
        [self.contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (listButton) {
                //当前按钮右侧坐标
                buttonRight = buttonRight + 10 + titleW;
                if (buttonRight > ScreenWidth) {
                    make.top.mas_equalTo(listButton.mas_bottom).offset(10);
                    make.left.mas_equalTo(15);
                    buttonRight = 15 + titleW;
                }else{
                    make.top.mas_equalTo(listButton.mas_top).offset(0);
                    make.left.mas_equalTo(listButton.mas_right).offset(10);
                }
            }else{
                make.top.mas_equalTo(12);
                make.left.mas_equalTo(15);
                buttonRight = 15 + titleW;
            }
            make.size.mas_equalTo(CGSizeMake(titleW, 28));
        }];
        listButton = button;
    }
}


- (void)clickedBtn:(UIButton *)btn{
    if (self.searchBlock) {
        self.searchBlock(btn.currentTitle);
    }
}

- (CGSize)labelAutoCalculateRectWith:(NSString *)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    labelSize.height = ceil(labelSize.height);
    labelSize.width = ceil(labelSize.width);
    return labelSize;
}


@end
