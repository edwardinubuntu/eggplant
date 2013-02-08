//
//  ICMUser+Config.m
//  eggplant
//
//  Created by Ben on 08/02/2013.
//

#import "ICMUser+Config.h"

@implementation ICMUser (Config)

+ (NSArray *)selectUsersWithFacebookUID:(NSInteger)facebookUID inManagedObjectContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
  fetchRequest.predicate = [NSPredicate predicateWithFormat:@"facebookUID = %d", facebookUID];

  NSError *error = nil;
  NSArray *foundUsers = [context executeFetchRequest:fetchRequest error:&error];

  return foundUsers;
}

+ (NSArray *)selectUsersWithUserName:(NSString *)username inManagedObjectContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
  fetchRequest.predicate = [NSPredicate predicateWithFormat:@"username = %@", username];

  NSError *error = nil;
  NSArray *foundUsers = [context executeFetchRequest:fetchRequest error:&error];

  return foundUsers;
}

+ (ICMUser *)userWithResponseObject:(NSDictionary *)responseObject inManagedObjectContext:(NSManagedObjectContext *)context
{
  ICMUser *user = nil;

  // MARK: responseObject does not contain facebookUID, use username for practice
  NSString *username = [responseObject objectForKey:@"username"];
  NSArray *foundUsers = [self selectUsersWithUserName:username inManagedObjectContext:context];

  switch ([foundUsers count]) {
    case 0: {
      // user not found, insert a new one
      user = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                           inManagedObjectContext:context];
      user.username = username;
      user.nickname = [responseObject objectForKey:@"nickname"];
      user.avatarURL = [responseObject objectForKey:@"avatar_image_url"];

      // save
      NSError *error = nil;
      [context save:&error];
      if (error != nil) {
        NIDPRINT(@"Error %@", [error localizedDescription]);
      }
    }
      break;

    case 1:
      user = [foundUsers lastObject];
      // TODO: update contents
      break;

    default:
      NIDPRINT(@"Error in Core Data");
      break;
  }

  return user;
}

@end
