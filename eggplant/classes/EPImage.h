//
//  EPImage.h
//  eggplant
//
//  Created by Edward Chiang on 12/10/19.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
  EPImageTypeLowResolution,
  EPImageTypeStandardResolution,
  EPImageTypeThumbnail
} EPImageType;

@interface EPImage : NSObject

@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, assign) EPImageType imageType;

@end
