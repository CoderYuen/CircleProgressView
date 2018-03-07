//
//  CircleView.m
//  bbbbbb
//
//  Created by BabyFinancial on 15/12/23.
//  Copyright (c) 2015年 BabyFinancial. All rights reserved.
//

#import "CircleView.h"
#import "POP.h"
#import "UIColor+Ext.h"

#define ProgressViewWidth 19.0f

@interface CircleView ()

@property(nonatomic, strong) CAShapeLayer *circleLayer;
@property(nonatomic, strong) UIView *progressView;
@property(nonatomic, strong) UILabel *progressLabel;
@property(nonatomic, assign) CGFloat circleRadius;
@property(nonatomic, assign) CGRect circleRect;

@end

@implementation CircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addCircleLayer];
        [self addProgressView];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
        [self addCircleLayer];
        [self addProgressView];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    POPAnimatableProperty *property = [POPAnimatableProperty propertyWithName:@"layerStrokeAnimationValue" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.writeBlock = ^(id obj, const CGFloat values[]) {
            NSLog(@"-----%f,%@",values[0],[obj class]);
            [obj setStrokeEnd:values[0]];
            [self setProgressViewCentWithStrokeEnd:values[0]];
            [self setProgressLabelTextWithStrokeEnd:values[0]];
        };
//        prop.readBlock = ^(id obj, CGFloat values[]) {
//        
//            values[0] = [obj strokeEnd];
////             NSLog(@"+++++%f",values[0]);
//        } ;
    }];
    
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    animation.fromValue = @(0);
    animation.toValue = @(progress);
    animation.duration = 2.0f;
    animation.property = property;
    [self.circleLayer pop_addAnimation:animation forKey:@"layerStrokeAnimation"];
}

- (void)addCircleLayer
{
    CGFloat lineWidth = 6.f;
    self.circleRadius = CGRectGetWidth(self.bounds)/2 - lineWidth/2 - ProgressViewWidth/2;
    self.circleRect = CGRectMake((lineWidth+ProgressViewWidth)/2, (lineWidth+ProgressViewWidth)/2, self.circleRadius * 2, self.circleRadius * 2);
    
    // 背景layer
    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    bgLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.circleRect cornerRadius:self.circleRadius].CGPath;
    bgLayer.strokeColor = [UIColor colorWithHex:0xcccccc].CGColor;
    bgLayer.fillColor = nil;
    bgLayer.lineWidth = lineWidth;
    
    [self.layer addSublayer:bgLayer];
    
    // 进度layer
    self.circleLayer = [CAShapeLayer layer];
    self.circleLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.circleRect cornerRadius:self.circleRadius].CGPath;
    self.circleLayer.strokeColor = [UIColor colorWithHex:0xe1524b].CGColor;
    self.circleLayer.fillColor = nil;
    self.circleLayer.lineWidth = lineWidth;
    self.circleLayer.strokeEnd = 0.0f;
    
    [self.layer addSublayer:self.circleLayer];
}

- (void)addProgressView
{
    // 进展指示View
    self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ProgressViewWidth, ProgressViewWidth)];
    self.progressView.layer.masksToBounds = YES;
    self.progressView.layer.cornerRadius = self.progressView.bounds.size.width/2;
//    self.progressView.center = self.center;
    NSLog(@"%@",NSStringFromCGPoint(self.center));
    self.progressView.backgroundColor = [UIColor colorWithHex:0xe1524b];
    [self setProgressViewCentWithStrokeEnd:0.0f];
    [self addSubview:self.progressView];
    
    // 进展指示Label
    self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.progressView.bounds.size.width, self.progressView.bounds.size.height)];
    self.progressLabel.font = [UIFont systemFontOfSize:8.0f];
    self.progressLabel.textColor = [UIColor whiteColor];
    [self setProgressLabelTextWithStrokeEnd:0.0f];
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.adjustsFontSizeToFitWidth = YES;
    [self.progressView addSubview:self.progressLabel];
}

- (void)setProgressViewCentWithStrokeEnd:(CGFloat)strokeEnd
{
    CGFloat x = CGRectGetMidX(self.circleRect) + self.circleRadius * cos((360.0f*strokeEnd-90.0f)*M_PI/180.0f);
    CGFloat y = CGRectGetMidY(self.circleRect) + self.circleRadius * sin((360.0f*strokeEnd-90.0f)*M_PI/180.0f);
    self.progressView.center = CGPointMake(x, y);
//    NSLog(@"-------------%@",NSStringFromCGPoint(CGPointMake(x, y)));
}

- (void)setProgressLabelTextWithStrokeEnd:(CGFloat)strokeEnd
{
    int progress = (int)(round(strokeEnd * 100.0f));
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d%%", progress]];
    [attrString addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:7.0]
                       range:NSMakeRange(attrString.length-1, 1)];
    self.progressLabel.attributedText = attrString;
}

@end
