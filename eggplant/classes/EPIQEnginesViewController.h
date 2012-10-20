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
@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) UIImageView *loadingView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) UIButton *snapButton;
@property (nonatomic, strong) UIButton *closeButton;

@end


@protocol EPIQEnginesViewControllerDelegate <NSObject>

- (void)iqEnginesViewController:(EPIQEnginesViewController *)iqEnginesViewController didFinishWithLabels:(NSArray *)labelsArray;
@end