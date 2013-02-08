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
      
      

    }
    return self;
}

- (void)loadView {
  [super loadView];
  _loadingView = [[UIImageView alloc] initWithFrame:self.view.bounds];
  [self.loadingView setBackgroundColor:[UIColor clearColor]];
  self.loadingView.hidden = YES;
  [self.view addSubview:self.loadingView];
  
  _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
  self.loadingIndicator.center = self.loadingView.center;
  self.loadingIndicator.hidesWhenStopped = YES;
  [self.loadingIndicator stopAnimating];
  [self.view addSubview:self.loadingIndicator];
  
  _bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44.f, 320.f, 44.f)];
  self.bottomBar.backgroundColor = [UIColor clearColor];
  [self.view addSubview:self.bottomBar];
  
  _snapButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
 
  _snapButton.layer.cornerRadius = 7.f;
  _snapButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
  _snapButton.layer.borderWidth = 3.f;
  [self.snapButton setImage:[UIImage imageNamed:@"86-camera"] forState:UIControlStateNormal];

  self.snapButton.frame = CGRectMake(0, 0, 70, 44);
  self.snapButton.center = CGPointMake( self.bottomBar.center.x,  self.bottomBar.center.y-20);
  [self.snapButton addTarget:self action:@selector(onSnapButton:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.snapButton];
  
  _closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  _closeButton.layer.cornerRadius = 7.f;
  _closeButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
  _closeButton.layer.borderWidth = 3.f;
  [_closeButton setTitle:@"X" forState:UIControlStateNormal];
  [_closeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
  [_closeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
  self.closeButton.frame = CGRectMake(20, self.view.frame.size.height-64, 44, 44);
  [self.closeButton addTarget:self action:@selector(onCloseButton:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.closeButton];
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

- (void)onSnapButton:(id)sender
{
  [iqengines captureStillFrame];
}

- (void)onCloseButton:(id)sender
{
  [self dismissModalViewControllerAnimated:YES];
}



#pragma mark - IQEDelegate
// Called when an image search has completed successfully.
// The type parameter indicates what type of image was detected.
// Results for the image search are contained in the results array parameter. The keys are listed below.
- (void) iqEngines:(IQE*)iqe didCompleteSearch:(IQESearchType)type withResults:(NSArray*)results forQID:(NSString*)qid{
  if (type == IQESearchTypeRemoteSearch) {
    NSLog(@"Result:%@",results);
    
    NSMutableArray *labelsArray = [NSMutableArray array];
    for (NSDictionary* termDictionary in results) {
      if ([[[termDictionary objectForKey:@"labels"] componentsSeparatedByString:@" "] count] > 1) {
        NSString *firstTerm = [[[termDictionary objectForKey:@"labels"] componentsSeparatedByString:@" "] objectAtIndex:0];
        [labelsArray addObject:firstTerm];
      } else {
        [labelsArray addObject:[termDictionary objectForKey:@"labels"]];
      }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(iqEnginesViewController:didFinishWithLabels:)]) {
      [self.delegate iqEnginesViewController:self didFinishWithLabels:labelsArray];
    }
    
    [self dismissModalViewControllerAnimated:YES];
  }
  
  
}

// Called when an image search has failed.
- (void) iqEngines:(IQE*)iqe failedWithError:(NSError*)error {
  self.loadingView.hidden = YES;
  [self.loadingIndicator stopAnimating];
  self.snapButton.enabled = YES;
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
  self.snapButton.enabled = NO;
  NSString* qid = [iqengines searchWithImage:image];
  NSLog(@"QID:%@",qid);
}


@end
