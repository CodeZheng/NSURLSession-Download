//
//  CycleView.m
//  NSURLSession-Download
//
//  Created by admin on 21/11/2016.
//  Copyright © 2016 admin. All rights reserved.
//

#import "CycleView.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
@interface CycleView ()
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@end


@implementation CycleView

+ (CycleView *)sharedCycleViewWithWidth:(CGFloat)width {
    static CycleView *cv = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cv = [[CycleView alloc]initWithFrame:CGRectMake((kScreenWidth - width) / 2, 148, width, width)];
        cv.backgroundColor = [UIColor clearColor];
        [cv addSubview:cv.progressLabel];
    });
    return cv;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        self.progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
        _progressLabel.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    }
    return _progressLabel;
}

- (void)drawProgress:(CGFloat)progress {
    NSLog(@"label Progress = %.2f",progress);
    _progressLabel.text = [NSString stringWithFormat:@"%.2f%%",progress*100];
    self.progress = progress;
    _progressLayer.opacity = 0;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    NSLog(@"view progress = %f",self.progress);
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2); //中心点
    CGFloat radius = 100; //圆半径
    CGFloat startA = - M_PI_2; //圆起点位置
    CGFloat endA = -M_PI_2 + M_PI * 2 * self.progress;
    //获取环形路径(画一个圆形，填充色透明，设置现况宽度为10，这样就获得了一个圆形
    _progressLayer = [CAShapeLayer layer];//创建一个track shape layer
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor = [UIColor clearColor].CGColor;//填充色为无色
    _progressLayer.strokeColor = [UIColor redColor].CGColor;//指定path的渲染颜色,这里可以设置任意不透明颜色
    _progressLayer.opacity = 1;//背景颜色的透明度
    _progressLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
    _progressLayer.lineWidth = 10;//线的宽度
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];//贝塞尔曲线用来构建圆形
    _progressLayer.path = path.CGPath;//把path传给layer由layer进行相应的渲染
    [self.layer addSublayer:_progressLayer];
    
    
    //生成渐变色
    CALayer *gradientLayer = [CALayer layer];
    
    //左侧渐变色
    CAGradientLayer *leftLayer = [CAGradientLayer layer];
    leftLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height); //分段设置渐变色
    leftLayer.locations = @[@0.3,@0.8,@1];
    leftLayer.colors = @[(id)[UIColor blueColor].CGColor,(id)[UIColor greenColor].CGColor];
    [gradientLayer addSublayer:leftLayer];
    
    //右侧渐变色
    CAGradientLayer *rightLayer = [CAGradientLayer layer];
    rightLayer.frame = CGRectMake(self.bounds.size.width / 2, 0, self.bounds.size.width / 2, self.bounds.size.height);
    rightLayer.locations = @[@0.3,@0.8,@1];
    rightLayer.colors = @[(id)[UIColor blueColor].CGColor,(id)[UIColor greenColor].CGColor];
    [gradientLayer addSublayer:rightLayer];
    
    [gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:gradientLayer];
//    CGContextSetLineWidth(ctx, 10); //设置线条宽度
//    [[UIColor blueColor] setStroke]; //设置画笔颜色
//    
//    CGContextAddPath(ctx, path.CGPath); //把路径添加到上下文
//    
//    CGContextStrokePath(ctx); //渲染
}

@end
