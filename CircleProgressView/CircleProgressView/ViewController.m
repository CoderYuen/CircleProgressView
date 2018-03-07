//
//  ViewController.m
//  CircleProgressView
//
//  Created by zdjt on 2018/3/7.
//  Copyright © 2018年 zdjt. All rights reserved.
//

#import "ViewController.h"
#import "CircleView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet CircleView *circleView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.circleView setProgress:0.5f];
    
}


@end
