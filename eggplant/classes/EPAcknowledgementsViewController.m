//
//  ICAcknowledgementsViewController.m
//  iCook
//
//  Created by Chih-Wei Lee on 8/24/12.
//  Copyright (c) 2012 Polydice, Inc. All rights reserved.
//

#import "EPAcknowledgementsViewController.h"

@interface EPAcknowledgementsViewController ()

@end

@implementation EPAcknowledgementsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = NSLocalizedString(@"Setting Acknowledgements", @"Acknowledgements");
  }
  return self;
}

#pragma mark - UIViewController

- (void)loadView {
  [super loadView];
  
  UITextView *textView = [[UITextView alloc] initWithFrame:self.view.bounds];
  textView.text = [NSString stringWithContentsOfFile:NIPathForBundleResource([NSBundle mainBundle], @"Pods-Acknowledgements.markdown") encoding:NSUTF8StringEncoding error:nil];
  textView.editable = NO;
  textView.autoresizingMask = UIViewAutoresizingFlexibleDimensions;
  [self.view addSubview:textView];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
