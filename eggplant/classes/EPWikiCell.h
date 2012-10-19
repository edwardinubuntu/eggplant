//
//  EPWikiCell.h
//  eggplant
//
//  Created by Edward Chiang on 12/10/19.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CALayer.h>

@interface EPWikiCell : UITableViewCell

@property (nonatomic, strong) UILabel *sourceLabel;

+ (CGFloat)cellHeight;

@end
