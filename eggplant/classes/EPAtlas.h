//
//  EPAtlas.h
//  eggplant
//
//  Created by Edward Chiang on 12/10/14.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPAtlas : NSObject

@end

#pragma mark - API

#define kYAHOO_APP_ID @".IaL2_jV34FArnSEV2rwNa6iJaqfESTf22j.YwzyoKgMEBzjYw.UpxOLyPzQZgw-"
#define kYAHOO_BASE_URL @"http://tw.knowledge.yahooapis.com/"
#define kWIKI_BASE_URL  @"wikipedia.org"
#define kINSTAGRAM_BASE_URL @"https://api.instagram.com/"
#define kINSTAGRAM_APP_CLIENT_ID  @"f9a6be62fe9f413daf81f25b98acd456"
#define kICOOK_BASE_URL @"https://icook.tw/api/v1/"
#define kTRANSLATE_BASE_URL @"http://translate.google.com/translate_a/"
#define kTRANSLATE_PARAMATER_FORMAT @"t?client=t&en=zh-TW&sl=en&tl=zh-TW&ie=UTF-8&oe=UTF-8&multires=1&otf=1&pc=1&trs=1&ssel=3&tsel=6&sc=1&text=%@"   //%@ as term
#define kTRANSLATE_PARAMATER_SRC_TARGET_FORMAT @"t?client=t&%@=%@&sl=%@&tl=%@&ie=UTF-8&oe=UTF-8&multires=1&otf=1&pc=1&trs=1&ssel=3&tsel=6&sc=1&text=%@"   //%@ as term

#pragma mark - Category

#define kCategoryPlant  @"植物學"
#define kCategoryCook  @"料理食譜"
#define kCategoryIngredient @"食材"

typedef enum {
  EPQueryTypeCamera,
  EPQueryTypeInput,
} EPQueryType;

#define IQE_APIKEY @"ddbfa0211be24f188c1db4b93fccc9ba" // IQ Engines API key string.
#define IQE_SECRET @"38c6cd51624f4fa39dccf906b94b0c8d" // IQ Engines secret string.
