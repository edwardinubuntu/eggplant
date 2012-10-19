//
//  UILabel+VAlign.m
//  iCook
//
//  Created by Edward Chiang on 12/7/17.
//  Copyright (c) 2012年 Polydice, Inc. All rights reserved.
//

#import "UILabel+VAlign.h"

@implementation UILabel (VAlign)

- (void) setVerticalAlignmentTop {
  CGSize textSize = [self.text sizeWithFont:self.font
                          constrainedToSize:self.frame.size
                              lineBreakMode:self.lineBreakMode];
  
  CGRect textRect = CGRectMake(self.frame.origin.x,
                               self.frame.origin.y,
                               self.frame.size.width,
                               textSize.height);
  [self setFrame:textRect];
  [self setNeedsDisplay];
}

@end
