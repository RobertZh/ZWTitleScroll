//
//  ViewController.m
//  ZWTitleScroll
//
//  Created by RobertZhang on 2017/3/16.
//  Copyright © 2017年 ZhangWei. All rights reserved.
//

#import "ViewController.h"
#import "ZWTitleView.h"
#import "ZWContentView.h"

@interface ViewController () <ZWTitleViewDelegate, ZWContentViewDelegate>
@property (nonatomic, strong) ZWTitleView *titleView;
@property (nonatomic, strong) ZWContentView *contentView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = self.titleView;
    [self.view addSubview:self.contentView];
}

#pragma mark - ZWTitleViewDelegate
- (void)titleViewSelectedIndex:(NSInteger)selectedIndex {
    self.contentView.currentIndex = selectedIndex;
}

#pragma mark - ZWContentViewDelegate
- (void)contentView:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex {
    
    [self.titleView setTitleWithProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
}

#pragma mark - 懒加载
- (ZWTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[ZWTitleView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 80, 44) titles:@[@"标题A", @"标题B", @"标题C", @"标题D"]];
        _titleView.delegate = self;
    }
    return _titleView;
}

- (ZWContentView *)contentView {
    if (!_contentView) {
        
        CGFloat contentH = self.view.bounds.size.height - 64 - 44;
        CGRect contentFrame = CGRectMake(0, 64, self.view.bounds.size.width, contentH);
        UIViewController *vc0 = [UIViewController new];
        vc0.view.backgroundColor = [UIColor redColor];
        UIViewController *vc1 = [UIViewController new];
        vc1.view.backgroundColor = [UIColor yellowColor];
        UIViewController *vc2 = [UIViewController new];
        vc2.view.backgroundColor = [UIColor blueColor];
        UIViewController *vc3 = [UIViewController new];
        vc3.view.backgroundColor = [UIColor greenColor];
        
        
        NSArray *childVCs = @[vc0, vc1, vc2, vc3];
        _contentView = [[ZWContentView alloc] initWithFrame:contentFrame childVCs:childVCs parentViewController:self];
        _contentView.delegate = self;
    }
    
    return _contentView;
}


@end
