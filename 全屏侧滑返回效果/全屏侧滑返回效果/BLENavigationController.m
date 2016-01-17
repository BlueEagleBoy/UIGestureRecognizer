//
//  BLENavigationController.m
//  全屏侧滑返回效果
//
//  Created by BlueEagleBoy on 16/1/17.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "BLENavigationController.h"

@interface BLENavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation BLENavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取系统自带的滑动手势的监听对象target
    id  target = self.interactivePopGestureRecognizer.delegate;
    
    //自定义一个全屏滑动手势 设置监听着为target 触发方法为系统的触发方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:target action:@selector(handleNavigationTransition:)];
 
    //设置代理
    pan.delegate = self;
    
    //添加个导航控制器
    [self.view addGestureRecognizer:pan];
    
    //关闭系统的侧滑手势
    self.interactivePopGestureRecognizer.enabled = NO;
  
}

//手势的代理方法，只要触发手势就会调用该方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    //只有非根控制器才可以触发滑动手势
    if (self.childViewControllers.count == 1) {
        
        return NO;
    }
    
    return  YES;
}




@end
