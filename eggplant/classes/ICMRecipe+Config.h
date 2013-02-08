//
//  ICMRecipe+Config.h
//  eggplant
//
//  Created by Ben on 08/02/2013.
//

#import "ICMRecipe.h"

@interface ICMRecipe (Config)

+ (NSArray *)selectRecipesWithRecipeObjectID:(NSInteger)objectID
                      inManagedObjectContext:(NSManagedObjectContext *)context;

+ (ICMRecipe *)recipeWithResponseObject:(NSDictionary *)responseObject
                 inManagedObjectContext:(NSManagedObjectContext *)context;

@end
