//
//  EPInstagramTagsMediaModel.m
//  eggplant
//
//  Created by Edward Chiang on 12/10/19.
//  Copyright (c) 2012年 Polydice Inc. All rights reserved.
//

#import "EPInstagramTagsMediaModel.h"

@implementation EPInstagramTagsMediaModel

- (id)init {
  if (self = [super init]) {
    _instagrams = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)loadMore:(BOOL)more didFinishLoad:(requestDidFinishLoadBolck)requestDidFinishLoad loadWithError:(requestLoadWithErrorBlock)requestLoadWithError {
  
  if (!more) {
    [self.instagrams removeAllObjects];
  }
  
  NSMutableString *path = [[NSMutableString alloc] init];
  [path appendFormat:@"v1/tags/%@/media/recent", [self.keyword encodeString:NSUTF8StringEncoding]];
  [path appendFormat:@"?client_id=%@", kINSTAGRAM_APP_CLIENT_ID];
  
  __block EPInstagramTagsMediaModel *tempSelf = self;
  if (!self.isLoading) {
    self.isLoading = YES;
    
    NIDPRINT(@"EPInstagramTagsMediaModel getPath: %@", path);
    
    [[EPRESTClient sharedInstgramClient] getPath:path parameters:[[NSMutableDictionary alloc] init] success:^(AFHTTPRequestOperation *operation, id responseObject) {
      tempSelf.isLoading = NO;
      tempSelf.isLoaded = YES;
      
      NIDPRINT(@"EPInstagramTagsMediaModel: %@", responseObject);
      
      NSArray *data = [responseObject objectForKey:@"data"];
      for (NSDictionary *eachData in data) {
        EPInstagram *instagram = [[EPInstagram alloc] init];
        instagram.link = [eachData objectForKey:@"link"];
        
        NSDictionary *images = [eachData objectForKey:@"images"];
        
        for (NSString *imageKey in [images keyEnumerator].allObjects) {
          
          NSDictionary *eachImageDict = [images objectForKey:imageKey];
          EPImage *image = [[EPImage alloc] init];
          image.height = [[eachImageDict objectForKey:@"height"] intValue];
          image.width = [[eachImageDict objectForKey:@"width"] intValue];
          image.url = [NSURL URLWithString:@"url"];
          if (imageKey) {
            image.imageType = EPImageTypeLowResolution;
          }
          if (imageKey) {
            image.imageType = EPImageTypeStandardResolution;
          }
          if (imageKey) {
            image.imageType = EPImageTypeThumbnail;
          }
          
          [tempSelf.instagrams addObject:image];
        }
      }
      
      requestDidFinishLoad();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      tempSelf.isLoading = NO;
      tempSelf.isLoaded = YES;
      requestLoadWithError(error);
    }];
  }
}

@end
