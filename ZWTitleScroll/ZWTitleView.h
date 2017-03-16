//
//  ZWTitleView.h
//  NetSDK
//
//  Created by RobertZhang on 2017/3/16.
//  Copyright © 2017年 ZhangWei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZWTitleViewDelegate <NSObject>

- (void)titleViewSelectedIndex:(NSInteger)selectedIndex;

@end

@interface ZWTitleView : UIView

@property (nonatomic, weak) id <ZWTitleViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;
- (void)setTitleWithProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex;

@end
