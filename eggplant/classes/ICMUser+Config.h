//
//  ICMUser+Config.h
//  eggplant
//
//  Created by Ben on 08/02/2013.
//

#import "ICMUser.h"

@interface ICMUser (Config)

+ (NSArray *)selectUsersWithFacebookUID:(NSInteger)facebookUID
                      inManagedObjectContext:(NSManagedObjectContext *)context;

+ (ICMUser *)userWithResponseObject:(NSDictionary *)responseObject
             inManagedObjectContext:(NSManagedObjectContext *)context;

@end
