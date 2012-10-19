//
//  ICPhoto.h
//  iCook
//
//  Created by Edward Chiang on 12/8/8.
//  Copyright (c) 2012年 Polydice, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICPhoto : NSObject <NSCoding>

@property (nonatomic, strong) NSURL *mediumURL;
@property (nonatomic, strong) NSURL *squareURL;
@property (nonatomic, strong) NSURL *smallURL;
@property (nonatomic, strong) NSURL *largeURL;

@end
