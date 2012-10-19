//
//  EPAttributedSourceCell.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/20.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPAttributedSourceCell.h"
#import "NSAttributedString+NimbusAttributedLabel.h"
#import "NSAttributedString+HTML.h"

@implementation EPAttributedSourceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    
    self.textLabel.hidden = YES;
    self.detailTextLabel.hidden = YES;
    
    _titleAttributedLabel = [[NIAttributedLabel alloc] init];
    self.titleAttributedLabel.numberOfLines = 1;
    [self.contentView addSubview:self.titleAttributedLabel];
    
    _detailAttributedLabel = [[NIAttributedLabel alloc] init];
    [self.contentView addSubview:self.detailAttributedLabel];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGFloat imageSize = 0;
  self.imageView.frame = CGRectZero;
  
  CGFloat width = self.contentView.frame.size.width - 10 * 2;
  CGFloat left = imageSize + 10;
  self.textLabel.backgroundColor = [UIColor clearColor];
  self.textLabel.frame = CGRectMake(left, 10.f, width, self.textLabel.frame.size.height);
  
  self.titleAttributedLabel.frame = CGRectMake(left, 10.f, width, self.titleAttributedLabel.frame.size.height);
  self.titleAttributedLabel.attributedString = [[NSAttributedString alloc] initWithHTMLData:[self.textLabel.text dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
  self.titleAttributedLabel.font = [UIFont boldSystemFontOfSize:16.f];
  [self.titleAttributedLabel sizeToFit];
  
  self.detailTextLabel.backgroundColor = [UIColor clearColor];
  self.detailTextLabel.frame = CGRectMake(left, self.titleAttributedLabel.frame.origin.y + self.titleAttributedLabel.frame.size.height + 10, width, 65);
  
  self.detailAttributedLabel.attributedString = [[NSAttributedString alloc] initWithHTMLData:[self.detailTextLabel.text dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
  self.detailAttributedLabel.frame = self.detailTextLabel.frame;
  
  self.sourceLabel.frame = CGRectMake(left, self.detailTextLabel.frame.origin.y + self.detailTextLabel.frame.size.height, width, 16.f);
}

+ (CGFloat)cellHeight:(NSString *)text detail:(NSString *)detail {
  
  NIAttributedLabel *titleAttributedLabel = [[NIAttributedLabel alloc] init];
  titleAttributedLabel.attributedString = [[NSAttributedString alloc] initWithHTMLData:[text dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
  titleAttributedLabel.font = [UIFont boldSystemFontOfSize:16.f];
  titleAttributedLabel.frame = CGRectMake(10, 10.f, 320 - 10 * 2, titleAttributedLabel.frame.size.height);
  [titleAttributedLabel sizeToFit];
  
  return 110 + titleAttributedLabel.frame.size.height;
}

@end
