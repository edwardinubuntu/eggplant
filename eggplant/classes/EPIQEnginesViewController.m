//
//  EPIQEnginesViewController.m
//  eggplant
//
//  Created by Anderson Lin on 12/10/20.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPIQEnginesViewController.h"

@interface EPIQEnginesViewController ()

@end

@implementation EPIQEnginesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      iqengines = [[IQE alloc] initWithParameters:IQESearchTypeRemoteSearch |
                   IQESearchTypeBarCode
                                           apiKey:IQE_APIKEY
                                        apiSecret:IQE_SECRET];
      
      iqengines.delegate = self;
      
      _loadingView = [[UIImageView alloc] initWithFrame:self.view.bounds];
      [self.loadingView setBackgroundColor:[UIColor clearColor]];
      self.loadingView.hidden = YES;
      [self.view addSubview:self.loadingView];
      
      _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
      self.loadingIndicator.center = self.loadingView.center;
      self.loadingIndicator.hidesWhenStopped = YES;
      [self.loadingIndicator stopAnimating];
      [self.view addSubview:self.loadingIndicator];
      

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
  CGRect rect = self.view.layer.bounds;
  iqengines.previewLayer.bounds = rect;
  iqengines.previewLayer.position = CGPointMake(CGRectGetMidX(rect),
                                                CGRectGetMidY(rect));
  
  [self.view.layer insertSublayer:iqengines.previewLayer atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [iqengines startCamera];
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  
  [iqengines stopCamera];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
  iqengines.delegate = nil;
  [iqengines stopCamera];
}

#pragma mark - IQEDelegate 
// Called when an image search has completed successfully.
// The type parameter indicates what type of image was detected.
// Results for the image search are contained in the results array parameter. The keys are listed below.
- (void) iqEngines:(IQE*)iqe didCompleteSearch:(IQESearchType)type withResults:(NSArray*)results forQID:(NSString*)qid{
  //[self.parentViewController dismissModalViewControllerAnimated:YES];
  NSLog(@"%@",results);
}

// Called when an image search has failed.
- (void) iqEngines:(IQE*)iqe failedWithError:(NSError*)error {

}

// Status changes for a particular query ID are returned with this message.
- (void) iqEngines:(IQE*)iqe statusDidChange:(IQEStatus)status forQID:(NSString*)qid {

}

// Called when a description becomes available for a barcode search type.
- (void) iqEngines:(IQE*)iqe didFindBarcodeDescription:(NSString*)desc forUPC:(NSString*)upc {

}

// Called in response to captureStillFrame:
- (void) iqEngines:(IQE*)iqe didCaptureStillFrame:(UIImage*)image {

  [self.loadingView setImage:image];
  self.loadingView.hidden = NO;
  [self.loadingIndicator startAnimating];
}

@end
