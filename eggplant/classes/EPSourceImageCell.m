//
//  EPSourceImageCell.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/20.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPSourceImageCell.h"

@implementation EPSourceImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.textLabel.hidden = YES;
    
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGFloat imageSize = self.contentView.frame.size.width - 10 * 2;
  self.imageView.frame = CGRectMake(10, 10, imageSize, imageSize);
  
  CGFloat left = 10.f;
  CGFloat width = self.contentView.frame.size.width - 10 * 2;
  self.textLabel.backgroundColor = [UIColor clearColor];
  self.textLabel.frame = CGRectMake(left, self.imageView.frame.size.height + self.imageView.frame.origin.y + 5, width, self.textLabel.frame.size.height);
  
  self.detailTextLabel.backgroundColor = [UIColor clearColor];
  if (NIIsStringWithAnyText(self.detailTextLabel.text)) {
    self.detailTextLabel.frame = CGRectMake(left, self.textLabel.frame.origin.y + 20, width, 65);
  } else {
    self.detailTextLabel.frame = CGRectMake(left, self.textLabel.frame.origin.y + 20, width, 10);
  }
  
  self.sourceLabel.textAlignment = UITextAlignmentRight;
  self.sourceLabel.frame = CGRectMake(self.contentView.frame.size.width - 100 - 10, self.imageView.frame.size.height + self.imageView.frame.origin.y + 5, 100, 16.f);
}

+ (CGFloat)cellHeight {
  return 370;
}

+ (CGFloat)cellHeight:(NSString *)text detail:(NSString *)detail {
  return 370;
}

@end
