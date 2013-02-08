//
//  EPWikiCell.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/19.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPWikiCell.h"

@implementation EPWikiCell

#define kCellHeight 460

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    _bookIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"book"]];
    [self.contentView addSubview:self.bookIconImageView];
    
    _seperateLineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hr"]];
    [self.contentView addSubview:self.seperateLineImageView];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGFloat imageSize = self.contentView.frame.size.width - 10 * 2;
  self.imageView.frame = CGRectMake(10, 10, imageSize, imageSize);
  
  CGFloat left = 15;
  CGFloat width = self.contentView.frame.size.width - left * 2;
  CGFloat top = self.imageView.frame.size.height + self.imageView.frame.origin.y + 10;
  
  [self.bookIconImageView sizeToFit];
  self.bookIconImageView.center = CGPointMake(left + self.bookIconImageView.frame.size.width / 2, top + self.bookIconImageView.frame.size.height / 2);
  
  self.textLabel.font = [UIFont boldSystemFontOfSize:22.f];
  self.textLabel.backgroundColor = [UIColor clearColor];
  self.textLabel.frame = CGRectMake(left + self.bookIconImageView.frame.size.width + left / 2, top + 5, width, self.textLabel.frame.size.height);
  
  self.seperateLineImageView.center = CGPointMake(self.contentView.frame.size.width / 2, self.textLabel.frame.origin.y + left * 2 + 10);
  
  self.detailTextLabel.backgroundColor = [UIColor clearColor];
  self.detailTextLabel.frame = CGRectMake(left, self.textLabel.frame.origin.y + left * 2 + 15, width, 65);
  
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
