//
//  MainView.m
//  TestMyCollectionView
//
//  Created by 刘文楠 on 7/19/16.
//  Copyright © 2016 Alanc Liu. All rights reserved.
//

#import "MainView.h"

@implementation MainView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithRed:30/255.0 green:30/255.0 blue:30/255.0 alpha:1.0];
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    NSLog(@"MainView drawRect");
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //步骤：
    /*
     一  创建颜色空间
     二  创建渐变
     三  设置裁剪区域
     四  绘制渐变
     五  释放对象
     */
    
    //绘制渐变
    
    //在计算机设置中，直接选择rgb即可，其他颜色空间暂时不用考虑。
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //1.创建渐变
    /*
     1.<#CGColorSpaceRef space#> : 颜色空间 rgb
     2.<#const CGFloat *components#> ： 数组 每四个一组 表示一个颜色 ｛r,g,b,a ,r,g,b,a｝
     3.<#const CGFloat *locations#>:表示渐变的开始位置
     
     */
    CGFloat components[8] = {52/255.0,52/255.0,52/255.0,1.0,30/255.0,30/255.0,30/255.0,1.0};
    CGFloat locations[2] = {0.0,1.0};
    
    CGGradientRef gradient=CGGradientCreateWithColorComponents(colorSpace, components, locations, 2);
    
    //绘制渐变
    /*
     参数：
     一 context
     二 gradient
     三 statCenter 起始中心点
     四 sartRadius 起始半径 指定为0  从圆心渐变  否则  中心位置不渐变
     五 endCenter  结束中心点（通常与起始专心点重合）
     六 endRadius  结束半径
     七 渐变填充方式
     
     */
    CGContextDrawRadialGradient(context, gradient, self.center, 0, self.center, self.frame.size.width/2,kCGGradientDrawsAfterEndLocation);
    
    //释放对象
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(gradient);
}

@end
