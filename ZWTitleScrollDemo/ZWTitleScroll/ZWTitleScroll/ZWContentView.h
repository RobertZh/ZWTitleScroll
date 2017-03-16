//
//  ZWContentView.h
//  NetSDK
//
//  Created by RobertZhang on 2017/3/16.
//  Copyright © 2017年 ZhangWei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZWContentViewDelegate <NSObject>

- (void)contentView:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex;

@end

@interface ZWContentView : UIView

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, weak) id <ZWContentViewDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame childVCs:(NSArray <UIViewController *> *)childVCs parentViewController:(UIViewController *)parentViewController;

@end
