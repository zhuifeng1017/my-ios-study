//
//  MZMyView1.m
//  MyTestAll
//
//  Created by  on 12-7-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MZMyView1.h"

@implementation MZMyView1

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
 
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ref);//这里提到一个很重要的概念叫路径（path），其实就是告诉画板环境，我们要开始画了，你记下。
    CGContextMoveToPoint(ref, 0, 0);//画线需要我解释吗？不用了吧？就是两点确定一条直线了。
    CGContextAddLineToPoint(ref, 100,100);
    CGFloat redColor[4]={1.0,0,0,1.0};
    CGContextSetStrokeColor(ref, redColor);//设置了一下当前那个画笔的颜色。画笔啊！你记着我前面说的windows画图板吗？
    CGContextStrokePath(ref);//告诉画板，对我移动的路径用画笔画一下。
    CGContextClosePath(ref);
    
    
    
    

   // CGContexten
    
//    CGContextRef context=UIGraphicsGetCurrentContext();
//    //建立一个颜色梯度对象
//    CGGradientRef myGradient;
//    CGColorSpaceRef myColorSpace;
//    size_t locationCount = 3;
//    CGFloat locationList[] = {0.0, 0.1, 1.0};
//    CGFloat colorList[] = {
//        1.0, 0.0, 0.5, 1.0, //red, green, blue, alpha 
//        1.0, 0.0, 1.0, 1.0, 
//        0.3, 0.5, 1.0, 1.0
//    };
//    myColorSpace = CGColorSpaceCreateDeviceRGB();
//    myGradient = CGGradientCreateWithColorComponents(myColorSpace, colorList, 
//                                                     locationList, locationCount);//核心的函数就是这个，要搞清渐变一些量化的东西了。
//    
//    CGPoint startPoint, endPoint;
//    startPoint.x = 0;
//    startPoint.y = 0;
//    endPoint.x = CGRectGetMaxX(self.bounds);
//    endPoint.y = CGRectGetMaxY(self.bounds);
//    CGContextDrawLinearGradient(context, myGradient, startPoint, endPoint,0);//这是绘制的，你可以通过裁剪来完成特定形状的过渡。
//    CGColorSpaceRelease(myColorSpace);
//    CGGradientRelease(myGradient);
    
}


@end
