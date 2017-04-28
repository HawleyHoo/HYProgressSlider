//
//  ViewController.m
//  HYProgressSlider
//
//  Created by 胡杨 on 2017/4/28.
//  Copyright © 2017年 net.fitcome.www. All rights reserved.
//

#import "ViewController.h"
#import "HYGradientSlider.h"



@interface ViewController ()<HYGradientSliderDelegate>

@property (nonatomic, weak) HYGradientSlider *gradientSlider;

@property (nonatomic, weak) UISlider *slider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    HYGradientSlider *gradientSlider = [[HYGradientSlider alloc] initWithFrame:CGRectMake(10, 36, 300, 300)];
    self.gradientSlider = gradientSlider;
    CGPoint sliderCenter = gradientSlider.center;
    sliderCenter.x = self.view.center.x;
    gradientSlider.center = sliderCenter;
    gradientSlider.minimumValue = 0;
    gradientSlider.maximumValue = 100.0;
    gradientSlider.currentValue = 60.6;
    gradientSlider.delegate = self;
    [self.view addSubview:gradientSlider];
    
    UISlider *slider1 = [[UISlider alloc] initWithFrame:CGRectMake(20, 400, 300, 20)];
    self.slider = slider1;
    slider1.minimumValue = gradientSlider.minimumValue;
    slider1.maximumValue = gradientSlider.maximumValue;
    slider1.value = gradientSlider.currentValue;
    [slider1 addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider1];
    
}

- (void)sliderValueChanged:(UISlider *)slider {
    self.gradientSlider.currentValue = slider.value;
    NSLog(@" %f", slider.value);
}

#pragma mark ---HYGradientSliderDelegate
- (void)progressSliderDidValueChanged:(CGFloat)value {
    self.slider.value = value;
    NSLog(@" %f", value);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
