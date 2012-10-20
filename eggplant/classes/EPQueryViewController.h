//
//  EPQueryViewController.h
//  eggplant
//
//  Created by Edward Chiang on 12/10/20.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EPQueryViewController : UIViewController

- (id)initWithKeyword:(NSString *)keyword;

@property (nonatomic, strong) NSString *keyword;

@end
