//
//  CycleView.h
//  NSURLSession-Download
//
//  Created by admin on 21/11/2016.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleView : UIView

@property (nonatomic, strong) UILabel *progressLabel;

@property (nonatomic) CGFloat progress;

- (void)drawProgress:(CGFloat)progress;

+ (CycleView *)sharedCycleViewWithWidth:(CGFloat)width;

@end
