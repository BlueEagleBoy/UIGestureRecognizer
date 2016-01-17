# UIGestureRecognizer

###前言
此次文章讲述的是如果改变系统的侧滑返回效果，实现全屏滑动返回效果。
效果如图：

![](http://upload-images.jianshu.io/upload_images/1469808-887461e5a5914174.jpg?imageMogr2/auto-orient/strip)

接下来看我们是如何是如何实现全屏侧滑。

**一、首先自定义导航控制器。**

目的：在自定义导航控制器中实现全屏侧滑。

**二、分析导航控制器侧滑功能**

效果：导航控制器默认自带了侧滑功能，当用户在界面的左边滑动的时候，就会有侧滑功能，但是默认的侧滑功能只能在控制器的最左侧开始滑动。
效果如图：

![](http://upload-images.jianshu.io/upload_images/1469808-00ae9ebaba30a4e5.jpg?imageMogr2/auto-orient/strip)

分析：当用户在界面左侧拖动，就会触发滑动手势方法。并且有滑动返回功能，说明系统手势触发的方法已经实现了滑动返回功能。

问题：为什么说系统手势实现了滑动返回功能。
因为：

* 创建滑动手势对象的时候需要有对象监听，当触发手势的时候并会有触发监听方法。
* 当用户在界面左边滑动，就会发现有返回功能，并触发了target的action方法，说明系统是在action方法中实现了返回功能。

**三、实现全屏滑动功能分析**

* 在自定义导航控制器中打印系统自带的滑动手势（系统自带的滑动手势为：interactivePopGestureRecognizer）


```
- (void)viewDidLoad {
    [super viewDidLoad];
    //打印系统自带的滑动手势
    NSLog(@"%@",self.interactivePopGestureRecognizer);
    
```

打印结果图片：

![](http://upload-images.jianshu.io/upload_images/1469808-e5840cf27fe72675.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

* 由以上结果可知：
* 1.系统自带的手势是：`UIScreenEdgePanGestureRecognizer`
* 2.手势的监听者为：`_UINavigationInteractiveTransition`
* 3.监听方法为：`handleNavigationTransition:`

分析：

* 由系统自带的手势可以看出系统自带的手势范围职能在屏幕的周围。所以系统的滑动效果，只能实现侧边滑动。
	
**四、如何实现全屏滑动功能**

* 给自己的导航控制器添加一个滑动手势。手势的监听着也是系统的手势监听着。调用方法为系统手势触发的方法。这样就能实现触发全屏手势，实现滑动返回的效果。
* `如何拿到系统自带的target对象？`
  action方法名已经知道了，而且系统肯定在target对象实现了，只要拿到target对象，就可以调用这个方法。
* 通过打印系统自带的滑动手势的代理。发现正好是`_UINavigationInteractiveTransition对象`，因此我猜测这个代理对象就是target对象。只要拿到它，就可以拿到系统自带的滑动手势的target对象。


```
//打印系统自带的滑动手势代理对象
NSLog(@"%@",self.interactivePopGestureRecognizer.delegate);
```

* 全屏滑动代码实现

```
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


```

