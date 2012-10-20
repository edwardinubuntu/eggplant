//
//  EPWikiCell.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/19.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPWikiCell.h"

@implementation EPWikiCell

#define kCellHeight 440

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGFloat imageSize = self.contentView.frame.size.width - 10 * 2;
  self.imageView.frame = CGRectMake(10, 10, imageSize, imageSize);
  
  CGFloat width = self.contentView.frame.size.width - 10 * 2;
  CGFloat left = 10;
  self.textLabel.backgroundColor = [UIColor clearColor];
  self.textLabel.frame = CGRectMake(left, self.imageView.frame.size.height + self.imageView.frame.origin.y + 5, width, self.textLabel.frame.size.height);
  
  self.detailTextLabel.backgroundColor = [UIColor clearColor];
  self.detailTextLabel.frame = CGRectMake(left, self.textLabel.frame.origin.y + 20, width, 65);
  
  self.sourceLabel.frame = CGRectMake(left, self.detailTextLabel.frame.origin.y + self.detailTextLabel.frame.size.height, width, 16.f);
}

+ (CGFloat)cellHeight {
  return kCellHeight;
}

+ (CGFloat)cellHeight:(NSString *)text detail:(NSString *)detail {
  if (!NIIsStringWithAnyText(detail)) {
    return kCellHeight -60;
  }
  return kCellHeight;
}

@end
