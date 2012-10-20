//
//  EPQueryViewController.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/20.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPQueryViewController.h"

@interface EPQueryViewController ()

@end

@implementation EPQueryViewController

#define kTableViewFrameSizeHeight 380.f
#define kTableViewFrameSizeWidth 280.f

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithKeyword:(NSString *)keyword{
  if (self = [self initWithNibName:nil bundle:nil]) {
    self.keyword = keyword;
  }
  return self;
}

-(void)loadView {
  [super loadView];
  self.view.frame = CGRectMake(0, 0, kTableViewFrameSizeWidth, kTableViewFrameSizeHeight);
  self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
