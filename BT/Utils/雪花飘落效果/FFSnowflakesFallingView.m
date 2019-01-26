//
//  FFSnowflakesFallingView.m
//  CollectionsOfExample
//
//  Created by mac on 16/7/30.
//  Copyright © 2016年 chenfanfang. All rights reserved.
//

#import "FFSnowflakesFallingView.h"
#import "BTLoginAndRrgisterView.h"
@interface FFSnowflakesFallingView (){
    
    CADisplayLink *_link;
}

/** 背景图片imageView */
@property (nonatomic, strong) UIImageView *bgImageView;

/** 雪花图片的名称 */
@property (nonatomic, copy) NSString *snowImgName;

/** 跳过按钮 */
@property (nonatomic, strong) UIButton *TG_Button;

/** 点击图片回调block */
@property (nonatomic,copy) void (^clickImg)(NSString *url);
@end

@implementation FFSnowflakesFallingView

+ (instancetype)snowflakesFallingViewWithBackgroundImageName:(NSString *)bgImageName snowImageName:(NSString *)snowImageName frame:(CGRect)frame clickImg:(void (^)(NSString *))block{
    FFSnowflakesFallingView *view = [[FFSnowflakesFallingView alloc] initWithFrame:frame];
    view.bgImageView.image = [UIImage imageNamed:bgImageName];
    view.snowImgName = snowImageName;
    view.clickImg = block;
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        
        //添加背景图片的imageView
        self.bgImageView = [[UIImageView alloc] init];
        self.bgImageView.frame = self.bounds;
        self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.bgImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToTL)];
        [self.bgImageView addGestureRecognizer:tap];
        
        //跳过按钮
        CGFloat btnW = 60;
        CGFloat btnH = 28;
        self.TG_Button = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - btnW - 15, kStatusBarHeight+10, btnW, btnH)];
        [self.TG_Button addTarget:self action:@selector(TGButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.TG_Button setTitle:[APPLanguageService wyhSearchContentWith:@"tiaoguo"] forState:UIControlStateNormal];
        self.TG_Button.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.TG_Button setTitleColor:kHEXCOLOR(0x111210) forState:UIControlStateNormal];
        ViewBorderRadius(self.TG_Button, 2, 0.5, kHEXCOLOR(0x111210));
        self.TG_Button.tag = 1;
    
        BTLoginAndRrgisterView *loginV = [BTLoginAndRrgisterView loadFromXib];
        loginV.frame = CGRectMake(0, ScreenHeight-40-(kTabBarHeight-10), ScreenWidth, 40);
        ViewBorderRadius(loginV.dengLuBtn, 4, 1, kHEXCOLOR(0x111210));
        ViewBorderRadius(loginV.zhuCeBtn, 4, 1, kHEXCOLOR(0x111210));
        [loginV.zhuCeBtn addTarget:self action:@selector(TGButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [loginV.dengLuBtn addTarget:self action:@selector(TGButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.bgImageView];
        [self addSubview:self.TG_Button];
        [self addSubview:loginV];
    }
    return self;
}
//点击图片回调
-(void)pushToTL {
    
    if (_clickImg) {
        _clickImg(@"");
    }
}
-(void)TGButtonClick:(UIButton *)btn {
    
    if (_clickImg) {
        _clickImg([NSString stringWithFormat:@"%ld",btn.tag]);
    }
}
/** 开始下雪 */
- (void)beginSnow {
    //启动定时器，使得一直调用setNeedsDisplay从而被动调用 - (void)drawRect:(CGRect)rect
    //不能手动调用 - (void)drawRect:(CGRect)rect
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)drawRect:(CGRect)rect {
    //控制雪花最多的个数
    if (self.subviews.count > 70) {
        
        [_link invalidate];
         _link = nil;
        return;
    }
    
    //雪花的宽度
    int width = arc4random() % 40;
    while (width < 20) {
        width = arc4random() % 40;
    }
    //雪花的速度
    int speed = arc4random() % 15;
    while (speed < 5) {
        speed = arc4random() % 15;
    }
    

    //雪花起点y
    int startY = - (arc4random() % 200);
    //雪花起点x
    int startX = arc4random() % (int)[UIScreen mainScreen].bounds.size.width;
    //雪花终点x
    int endX = arc4random() % (int)[UIScreen mainScreen].bounds.size.width;
    
    int xhImage = arc4random() % 5;
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"币%d",xhImage]]];
    imageView.frame = CGRectMake(startX, startY, width, width);
    
    [self addSubview:imageView];
    
    [UIView animateWithDuration:speed animations:^{
        //设置雪花最终的frame
        imageView.frame = CGRectMake(startX, [UIScreen mainScreen].bounds.size.height, width, width);
        //设置雪花的旋转
        //imageView.transform = CGAffineTransformRotate(imageView.transform, M_PI );
        //设置雪花透明度，使得雪花快落地的时候像快消失的一样
        //imageView.alpha = 0.3;
    } completion:^(BOOL finished) {
        //完成动画，就将雪花的imageView给移除掉
        [imageView removeFromSuperview];
    }];
    
}


@end
