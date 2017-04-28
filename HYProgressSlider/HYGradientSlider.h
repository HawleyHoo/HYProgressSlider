//
//  HYGradientSlider.h
//  ChartDemo
//
//  Created by 胡杨 on 2017/2/10.
//  Copyright © 2017年 net.fitcome.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HYGradientSliderDelegate <NSObject>

@optional
- (void)progressSliderDidValueChanged:(CGFloat)value;

@end

@interface HYGradientSlider : UIControl

@property (nonatomic, assign) CGFloat minimumValue;
@property (nonatomic, assign) CGFloat maximumValue;
@property (nonatomic, assign) CGFloat currentValue;

@property (nonatomic, weak) id<HYGradientSliderDelegate>delegate;

@end
