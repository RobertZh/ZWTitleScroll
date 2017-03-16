//
//  ZWTitleView.m
//  NetSDK
//
//  Created by RobertZhang on 2017/3/16.
//  Copyright © 2017年 ZhangWei. All rights reserved.
//

#import "ZWTitleView.h"

@interface ZWTitleView() {
    NSInteger currentIndex;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *scrollLine;
@property (nonatomic, strong) NSMutableArray <UILabel *> *titleLabels;
@property (nonatomic, strong) NSArray <NSString *> *titles;

@end

@implementation ZWTitleView

#define kScrollLineH 2

#define kNormalRed 43
#define kNormalGreen 43
#define kNormalBlue 43

#define kSelectedRed 236
#define kSelectedGreen 102
#define kSelectedBlue 23

#define kNormalColor [UIColor colorWithRed:kNormalRed/255.0 green:kNormalGreen/255.0 blue:kNormalBlue/255.0 alpha:1]
#define kSelectedColor [UIColor colorWithRed:kSelectedRed/255.0 green:kSelectedGreen/255.0 blue:kSelectedBlue/255.0 alpha:1]

// 创建对象
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles {
    self = [super initWithFrame:frame];
    if (self) {
        self.titles = titles;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.scrollView];
    
    [self setupTitleLabels];
    [self setupBottomLineAndScrollLine];
}

- (void)setupTitleLabels {
    CGFloat labelW = self.bounds.size.width / self.titles.count;
    CGFloat labelH = self.bounds.size.height - kScrollLineH;
    CGFloat labelY = 0;
    
    for (int i = 0; i < self.titles.count; i++) {
        // 创建label并设置属性
        UILabel *label = [UILabel new];
        label.text = self.titles[i];
        label.tag = i + 678;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = kNormalColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake(i * labelW, labelY, labelW, labelH);
        
        // 添加label
        [self.scrollView addSubview:label];
        [self.titleLabels addObject:label];
        
        // 添加手势
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTitleLabel:)];
        [label addGestureRecognizer:tapGR];   
    }
}


- (void)setupBottomLineAndScrollLine {
    // 添加底线
    UIView *bottomLine = [UIView new];
    CGFloat lineH = 0.5;
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    bottomLine.frame = CGRectMake(0, self.bounds.size.height - lineH, self.bounds.size.width, lineH);
    
    UILabel *firstLabel = [self.titleLabels firstObject];
    if (firstLabel) {
        firstLabel.textColor = kSelectedColor;
        // 设置scrollLine
        [self.scrollView addSubview:self.scrollLine];
        self.scrollLine.frame = CGRectMake(firstLabel.frame.origin.x, self.bounds.size.height - kScrollLineH, firstLabel.bounds.size.width, kScrollLineH);
    }
    
}

// 点击titleLabel
- (void)clickTitleLabel:(UITapGestureRecognizer *)tap {
    UILabel *currentLabel = (UILabel *)tap.view;
    if (currentLabel.tag - 678 == currentIndex) { // 如果重复点击, 返回
        return;
    }
    UILabel *oldLabel = self.titleLabels[currentIndex];
    currentLabel.textColor = kSelectedColor;
    oldLabel.textColor = kNormalColor;
    currentIndex = currentLabel.tag - 678;
    CGFloat scrollLineX = currentIndex * self.scrollLine.frame.size.width;
    [UIView animateWithDuration:0.15 animations:^{
        CGRect frame = self.scrollLine.frame;
        frame.origin.x = scrollLineX;
        self.scrollLine.frame = frame;
    }];
    // 通知代理
    [self.delegate titleViewSelectedIndex:currentIndex];
}

- (void)setTitleWithProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex {
    // 取出sourceLabel/targetLabel
    UILabel *sourceLabel = self.titleLabels[sourceIndex];
    UILabel *targetLabel = self.titleLabels[targetIndex];
    
    // 处理滑块的逻辑
    CGFloat moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x;
    CGFloat moveX = moveTotalX * progress;
    CGRect scrollLineFrame = self.scrollLine.frame;
    scrollLineFrame.origin.x = sourceLabel.frame.origin.x + moveX;
    self.scrollLine.frame = scrollLineFrame;
    
    // 颜色的渐变
    CGFloat redColorDelta = kSelectedRed - kNormalRed;
    CGFloat greenColorDelta = kSelectedGreen - kNormalGreen;
    CGFloat blueColorDelta = kSelectedBlue - kNormalBlue;
    
    // 设置sourceLabel色差
    sourceLabel.textColor = [UIColor colorWithRed:(kSelectedRed - redColorDelta * progress)/255.0 green:(kSelectedGreen - greenColorDelta * progress)/255.0 blue:(kSelectedBlue - blueColorDelta * progress)/255.0 alpha:1];
    // 设置targetLabel色差
    targetLabel.textColor = [UIColor colorWithRed:(kNormalRed + redColorDelta * progress)/255.0 green:(kNormalGreen + greenColorDelta * progress)/255.0 blue:(kNormalBlue + blueColorDelta * progress)/255.0 alpha:1];
    
    currentIndex = targetIndex;
    
}

#pragma mark - 懒加载

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.bounces = NO;
    }
    
    return _scrollView;
}

- (NSMutableArray<UILabel *> *)titleLabels {
    if (!_titleLabels) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}

- (UIView *)scrollLine {
    if (!_scrollLine) {
        _scrollLine = [UIView new];
        _scrollLine.backgroundColor = kSelectedColor;
    }
    
    return _scrollLine;
}


@end
