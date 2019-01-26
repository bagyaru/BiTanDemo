//
//  SelectMemberWithSearchView.h
//  BT
//
//  Created by apple on 2018/10/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SelectMemberWithSearchView.h"
#import "SelectMemberCollectionCell.h"

@interface SelectMemberWithSearchView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *selectArray;

@end


@implementation SelectMemberWithSearchView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI {
    self.backgroundColor =  isNightMode ?ViewContentBgColor:CWhiteColor;;
    [self addSubview:self.collectionView];
    UIView *footView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:footView];
    footView.backgroundColor = ViewBGColor;
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(6);
    }];
}

#pragma mark -------- collectionview delegate/datasource --------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _selectArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectMemberCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SelectMemberCollectionCell class]) forIndexPath:indexPath];
    ConatctModel *model = _selectArray[indexPath.item];
    cell.model = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ConatctModel *model = _selectArray[indexPath.item];
    [_selectArray removeObject:model];
    if ([_delegate respondsToSelector:@selector(removeMemberFromSelectArray:indexPath:)]) {
        [_delegate removeMemberFromSelectArray:model indexPath:indexPath];
    }
    [self updateSubviewsLayout:_selectArray];
}

#pragma mark -------- method --------
- (void)updateSubviewsLayout:(NSMutableArray *)selelctArray {
    self.selectArray = selelctArray;
    [self.collectionView reloadData];
    if(self.selectArray.count >0){
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectArray.count - 1 inSection:0] atScrollPosition:(UICollectionViewScrollPositionRight) animated:YES];
    }
    [self layoutIfNeeded];
}
#pragma mark -------- lazy init --------
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(70, 80);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 15, ScreenWidth - 15, self.bounds.size.height - 41) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = isNightMode? ViewContentBgColor:CWhiteColor;
        [_collectionView registerNib:[UINib nibWithNibName:@"SelectMemberCollectionCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([SelectMemberCollectionCell class])];
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}


@end
