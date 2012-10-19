//
//  EPSourceCell.h
//  eggplant
//
//  Created by Edward Chiang on 12/10/20.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CALayer.h>
#import "UILabel+VAlign.h"

@interface EPSourceCell : UITableViewCell

@property (nonatomic, strong) UILabel *sourceLabel;

+ (CGFloat)cellHeight;
+ (CGFloat)cellHeight:(NSString *)text detail:(NSString *)detail;

@end
