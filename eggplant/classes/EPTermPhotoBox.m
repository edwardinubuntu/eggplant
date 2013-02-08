//
//  EPTermPhotoBox.m
//  eggplant
//
//  Created by Ben on 07/02/2013.
//

#import "EPTermPhotoBox.h"

@implementation EPTermPhotoBox

- (void)setup
{
  // positioning
  self.topMargin = 8;
  self.leftMargin = 8;

  // background
  self.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1];

  // shadow
  self.layer.shadowColor = [UIColor colorWithWhite:0.12 alpha:1].CGColor;
  self.layer.shadowOffset = CGSizeMake(0, 0.5);
  self.layer.shadowRadius = 1;
  self.layer.shadowOpacity = 1;
}

#pragma mark - Factories

+ (EPTermPhotoBox *)photoBoxForIndex:(NSInteger)index withSize:(CGSize)size imageURL:(NSString *)url
{
  // box with photo number tag
  EPTermPhotoBox *box = [EPTermPhotoBox boxWithSize:size];
  box.tag = index;

  // add a loading spinner
  UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
  spinner.center = CGPointMake(box.width / 2, box.height / 2);
  spinner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin
                           | UIViewAutoresizingFlexibleRightMargin
                           | UIViewAutoresizingFlexibleBottomMargin
                           | UIViewAutoresizingFlexibleLeftMargin;
  spinner.color = UIColor.lightGrayColor;
  [box addSubview:spinner];
  [spinner startAnimating];

  // do the photo loading async, because internets
  __weak id wbox = box;
  box.asyncLayoutOnce = ^{
    [wbox loadPhotoFromURL:url];
  };

  return box;
}

#pragma mark - Layout

- (void)layout
{
  [super layout];

  // speed up shadows
  self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

#pragma mark - Photo box loading

- (void)loadPhotoFromURL:(NSString *)url
{
  // fetch the remote photo
  NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];

  // do UI stuff back in UI land
  dispatch_async(dispatch_get_main_queue(), ^{

    // ditch the spinner
    UIActivityIndicatorView *spinner = self.subviews.lastObject;
    [spinner stopAnimating];
    [spinner removeFromSuperview];

    // failed to get the photo?
    if (!data) {
      self.alpha = 0.3;
      return;
    }

    // got the photo, so lets show it
    UIImage *image = [UIImage imageWithData:data];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.size = self.size;
    imageView.alpha = 0;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth
    | UIViewAutoresizingFlexibleHeight;

    // fade the image in
    [UIView animateWithDuration:0.2 animations:^{
      imageView.alpha = 1;
    }];
  });

}

@end
