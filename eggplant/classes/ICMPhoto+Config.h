//
//  ICMPhoto+Config.h
//  eggplant
//
//  Created by Ben on 08/02/2013.
//

#import "ICMPhoto.h"

@interface ICMPhoto (Config)

+ (NSArray *)selectPhotosWithLargeURL:(NSString *)largeURL
                inManagedObjectContext:(NSManagedObjectContext *)context;

+ (ICMPhoto *)photoWithResponseObject:(NSDictionary *)responseObject
               inManagedObjectContext:(NSManagedObjectContext *)context;

@end
