//
//  EPTermsStorageManager.h
//  eggplant
//
//  Created by Edward Chiang on 12/10/18.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPInformation.h"

@interface EPTermsStorageManager : NSObject {
@private
  NSString *_filePath;
}

+ (EPTermsStorageManager *)defaultManager;

@property (nonatomic, strong) NSMutableDictionary *termsFromDefault;
@property (nonatomic, strong) EPInformation *informationFromUserSaved;

- (void)load;
- (void)save;

@end
