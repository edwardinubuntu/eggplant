//
//  EPIQEnginesViewController.h
//  eggplant
//
//  Created by Anderson Lin on 12/10/20.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQE.h"

@interface EPIQEnginesViewController : UIViewController <IQEDelegate> {
  IQE* iqengines;

}

@property (nonatomic, strong) UIImageView *loadingView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;

@end
