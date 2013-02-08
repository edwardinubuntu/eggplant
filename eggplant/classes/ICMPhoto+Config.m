//
//  ICMPhoto+Config.m
//  eggplant
//
//  Created by Ben on 08/02/2013.
//

#import "ICMPhoto+Config.h"

@implementation ICMPhoto (Config)

+ (NSArray *)selectPhotosWithLargeURL:(NSString *)largeURL inManagedObjectContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
  fetchRequest.predicate = [NSPredicate predicateWithFormat:@"largeURL = %@", largeURL];

  NSError *error = nil;
  NSArray *foundPhotos = [context executeFetchRequest:fetchRequest error:&error];

  return foundPhotos;
}

+ (ICMPhoto *)photoWithResponseObject:(NSDictionary *)responseObject inManagedObjectContext:(NSManagedObjectContext *)context
{
  ICMPhoto *photo = nil;
  NSString *largeURL = [[responseObject objectForKey:@"large"] objectForKey:@"url"];
  NSArray *foundPhotos = [self selectPhotosWithLargeURL:largeURL inManagedObjectContext:context];

  switch ([foundPhotos count]) {
    case 0: {
      // photo not found, insert a new one
      photo = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                            inManagedObjectContext:context];
      photo.largeURL = largeURL;
      photo.mediumURL = [[responseObject objectForKey:@"medium"] objectForKey:@"url"];
      photo.smallURL = [[responseObject objectForKey:@"small"] objectForKey:@"url"];
      // MARK: not sure if original photo is square
      photo.squareURL = [[responseObject objectForKey:@"original"] objectForKey:@"url"];

      // save
      NSError *error = nil;
      [context save:&error];
      if (error != nil) {
        NIDPRINT(@"Error %@", [error localizedDescription]);
      }
    }
      break;

    case 1:
      photo = [foundPhotos lastObject];
      break;

    default:
      NIDPRINT(@"Error in Core Data");
      break;
  }

  return photo;
}

@end
