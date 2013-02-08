//
//  ICMUser.h
//  eggplant
//
//  Created by Ben on 08/02/2013.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ICMRecipe;

@interface ICMUser : NSManagedObject

@property (nonatomic, retain) NSNumber * dishesCount;
@property (nonatomic, retain) NSNumber * followersCount;
@property (nonatomic, retain) NSNumber * recipesCount;
@property (nonatomic, retain) NSNumber * facebookUID;
@property (nonatomic, retain) NSString * avatarURL;
@property (nonatomic, retain) NSString * blogURL;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * provider;
@property (nonatomic, retain) NSString * userDescription;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSSet *recipes;
@end

@interface ICMUser (CoreDataGeneratedAccessors)

- (void)addRecipesObject:(ICMRecipe *)value;
- (void)removeRecipesObject:(ICMRecipe *)value;
- (void)addRecipes:(NSSet *)values;
- (void)removeRecipes:(NSSet *)values;

@end
