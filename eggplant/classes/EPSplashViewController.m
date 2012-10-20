//
//  EPSplashViewController.m
//  eggplant
//
//  Created by Anderson Lin on 12/10/21.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPSplashViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface EPSplashViewController ()

@end

@implementation EPSplashViewController

- (void)loadView {
  [super loadView];
  
  UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
  imgView1.backgroundColor = [UIColor clearColor];
  [imgView1 setImage:[UIImage imageNamed:EPRetina4Name(@"default-UI")]];
  imgView1.alpha = 1.0;
  [self.view addSubview:imgView1];
  
  UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
  imgView2.backgroundColor = [UIColor clearColor];
  [imgView2 setImage:[UIImage imageNamed:EPRetina4Name(@"default-bg")]];
  imgView2.alpha = 1.0;
  [self.view addSubview:imgView2];
  
  
  
  
  
  [UIView animateWithDuration:1.0 animations:^(void){
    imgView2.alpha = 0.0;
  } completion:^(BOOL finished){
    [UIView animateWithDuration:0.5 animations:^(void){
      
    } completion:NULL];
  }];
}

@end
