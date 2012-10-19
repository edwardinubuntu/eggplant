//
//  EBICookCell.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/19.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPICookCell.h"

@implementation EPICookCell

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGFloat imageSize = 48.f;
  self.imageView.frame = CGRectMake(self.contentView.frame.size.width - 10 - imageSize, 10, imageSize, imageSize);
  
  CGFloat width = self.contentView.frame.size.width - imageSize - 10 * 3;
  CGFloat left = 10;
  self.textLabel.backgroundColor = [UIColor clearColor];
  self.textLabel.frame = CGRectMake(left, 10.f, width, self.textLabel.frame.size.height);
  [self.textLabel sizeToFit];
  
  self.detailTextLabel.backgroundColor = [UIColor clearColor];
  if (NIIsStringWithAnyText(self.detailTextLabel.text)) {
    self.detailTextLabel.frame = CGRectMake(left, self.textLabel.frame.origin.y + self.textLabel.frame.size.height, width, 65);
  } else {
    self.detailTextLabel.frame = CGRectMake(left, self.textLabel.frame.origin.y + self.textLabel.frame.size.height, width, 10);
  }
  
  self.sourceLabel.frame = CGRectMake(left, self.detailTextLabel.frame.origin.y + self.detailTextLabel.frame.size.height, width, 16.f);
}

@end
