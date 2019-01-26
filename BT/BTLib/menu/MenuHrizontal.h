
#import <UIKit/UIKit.h>

#import "MyScrollView.h"
#define NOMALKEY   @"normalKey"
#define HEIGHTKEY  @"helightKey"
#define TITLEKEY   @"titleKey"
#define TITLEWIDTH @"titleWidth"
#define TOTALWIDTH @"totalWidth"


@protocol MenuHrizontalDelegate <NSObject>

@optional
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex;
@end
@interface MenuHrizontal : UIView
{
    NSMutableArray        *mButtonArray;
    NSMutableArray        *mItemInfoArray;
    MyScrollView          *mScrollView;
    float                 mTotalWidth;
}

@property (nonatomic,assign) id <MenuHrizontalDelegate> delegate;

@property(nonatomic,strong)NSArray *lineBtnArr;



- (void)cleanButtons;
#pragma mark 初始化菜单
- (id)initWithFrame:(CGRect)frame ;

#pragma mark 选中某个button
-(void)clickButtonAtIndex:(NSInteger)aIndex;

#pragma mark 改变第几个button为选中状态，不发送delegate
-(void)changeButtonStateAtIndex:(NSInteger)aIndex;

@end
