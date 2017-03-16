//
//  ZWContentView.m
//  NetSDK
//
//  Created by RobertZhang on 2017/3/16.
//  Copyright © 2017年 ZhangWei. All rights reserved.
//

#import "ZWContentView.h"

static NSString *cellID = @"ZWContentViewCell";

@interface ZWContentView () <UICollectionViewDelegate, UICollectionViewDataSource> {
    CGFloat startOffsetX;
    BOOL isForbidScrollDelegate;
}

@property (nonatomic, strong) NSArray <UIViewController *> *childVCs;
@property (nonatomic, strong) UIViewController *parentViewController;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ZWContentView


- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    // 记录需要禁止执行代理方法
    isForbidScrollDelegate = YES;
    // 滚动正确的位置
    CGFloat offsetX = currentIndex * self.collectionView.bounds.size.width;
    [self.collectionView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
    
}

- (instancetype)initWithFrame:(CGRect)frame childVCs:(NSArray<UIViewController *> *)childVCs parentViewController:(UIViewController *)parentViewController {
    self = [super initWithFrame:frame];
    if (self) {
        self.childVCs = childVCs;
        self.parentViewController = parentViewController;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    // 将所有的子控制器添加父控制器中
    for (UIViewController *childVC in self.childVCs) {
        [self.parentViewController addChildViewController:childVC];
    }
    // 添加UICollectionView,用于在Cell中存放控制器的View
    [self addSubview:self.collectionView];
    self.collectionView.frame = self.bounds;
}





#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.childVCs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UIViewController *childVC = self.childVCs[indexPath.item];
    childVC.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:childVC.view];

    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    isForbidScrollDelegate = NO;
    startOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isForbidScrollDelegate) {
        return;
    }
    CGFloat progress = 0;
    NSInteger sourceIndex = 0;
    NSInteger targetIndex = 0;
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    
    if (currentOffsetX > startOffsetX) { // 左滑
        
        progress = currentOffsetX / scrollViewW - floor(currentOffsetX/ scrollViewW);
        sourceIndex = (NSInteger)(currentOffsetX / scrollViewW);
        targetIndex = sourceIndex + 1;
        if (targetIndex >= self.childVCs.count) {
            targetIndex = self.childVCs.count - 1;
        }
        if (currentOffsetX - startOffsetX == scrollViewW) {
            progress = 1;
            targetIndex = sourceIndex;
        }
    } else { // 右滑
        progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));
        targetIndex = (NSInteger)(currentOffsetX / scrollViewW);
        sourceIndex = targetIndex + 1;
        if (sourceIndex >= self.childVCs.count) {
            sourceIndex = self.childVCs.count - 1;
        }
    }
    [self.delegate contentView:progress sourceIndex:sourceIndex targetIndex:targetIndex];
}


#pragma mark - 懒加载

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = self.bounds.size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollsToTop = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    }
    return _collectionView;
}


@end
