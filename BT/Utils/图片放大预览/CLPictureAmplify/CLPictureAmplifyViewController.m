//
//  CLPictureAmplifyViewController.m
//  CLPictureAmplify
//
//  Created by darren on 16/8/25.
//  Copyright © 2016年 shanku. All rights reserved.
//

#import "CLPictureAmplifyViewController.h"
#import "pictureCell.h"
static NSString *ID = @"cell";

@interface CLPictureAmplifyViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
@property (nonatomic,weak) UICollectionView *collectionView;

@property (nonatomic,strong) UILabel *textlable;
@end

@implementation CLPictureAmplifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kHEXCOLOR(0xF5F5F5);
    
    [self setupCollectionView];
}

- (void)setupCollectionView
{
    // 创建collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
    layout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.scrollEnabled = YES;
    collectionView.pagingEnabled = YES;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    [self.collectionView registerNib:[UINib nibWithNibName:@"pictureCell" bundle:nil] forCellWithReuseIdentifier:ID];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.touchIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    self.textlable = [[UILabel alloc] initWithFrame:CGRectZero];
    self.textlable.text = [NSString stringWithFormat:@"%ld/%ld",self.touchIndex+1,self.picArray.count];
    self.textlable.textAlignment  =NSTextAlignmentCenter;
    self.textlable.textColor = [UIColor whiteColor];
    self.textlable.font = [UIFont systemFontOfSize:16];
    self.textlable.backgroundColor = [UIColor blackColor];
    self.textlable.alpha = 0.5;
    self.textlable.layer.cornerRadius = 5.0f;
    self.textlable.layer.masksToBounds = YES;
    if (!self.hiddenTextLable) {
        [self.view addSubview:self.textlable];
        [self.textlable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(-20);
            make.centerX.equalTo(self.view);
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(50);
        }];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.picArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    pictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
//    cell.picImg = self.picArray[indexPath.row];
    id obj = self.picArray[indexPath.row];
    cell.imageUrl = obj;
    cell.clickCellImage = ^{
        KPostNotification(@"show_CustomTabBarView", nil);
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (int)(scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5) % self.picArray.count;
    self.textlable.text = [NSString stringWithFormat:@"%d/%ld",page+1,self.picArray.count];
}

@end
