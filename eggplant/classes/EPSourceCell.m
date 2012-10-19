//
//  EPSourceCell.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/20.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPSourceCell.h"

@implementation EPSourceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.cornerRadius = 5.0;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.imageView.layer.shadowOffset = CGSizeMake(2, 2);
    self.imageView.layer.shouldRasterize = YES;
    self.imageView.layer.shouldRasterize = [[UIScreen mainScreen] scale];
    
    self.detailTextLabel.numberOfLines = 3;
    [self.detailTextLabel setVerticalAlignmentTop];
    
    _sourceLabel = [[UILabel alloc] init];
    self.sourceLabel.textColor = [UIColor colorWithHue:0.571 saturation:0.872 brightness:0.859 alpha:1];
    self.sourceLabel.backgroundColor = [UIColor clearColor];
    self.sourceLabel.font = [UIFont systemFontOfSize:12.f];
    self.sourceLabel.highlightedTextColor = self.detailTextLabel.highlightedTextColor;
    [self.contentView addSubview:self.sourceLabel];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.imageView.image = nil;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGFloat imageSize = 48.f;
  self.imageView.frame = CGRectMake(10, 10, imageSize, imageSize);
  
  CGFloat width = self.contentView.frame.size.width - imageSize - 10 * 3;
  CGFloat left = imageSize + 10 * 2;
  self.textLabel.backgroundColor = [UIColor clearColor];
  self.textLabel.frame = CGRectMake(left, 10.f, width, self.textLabel.frame.size.height);
  
  self.detailTextLabel.backgroundColor = [UIColor clearColor];
  self.detailTextLabel.frame = CGRectMake(left, self.textLabel.frame.origin.y + 20, width, 65);
  
  self.sourceLabel.frame = CGRectMake(left, self.detailTextLabel.frame.origin.y + self.detailTextLabel.frame.size.height, width, 16.f);
}

+ (CGFloat)cellHeight {
  return 130;
}

+ (CGFloat)cellHeight:(NSString *)text detail:(NSString *)detail {
  if (!NIIsStringWithAnyText(detail)) {
    return 70;
  }
  return 130;
}

@end
