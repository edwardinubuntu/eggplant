//
//  ICMRecipe+Config.m
//  eggplant
//
//  Created by Ben on 08/02/2013.
//

#import "ICMRecipe+Config.h"
#import "ICMUser+Config.h"
#import "ICMPhoto+Config.h"

@implementation ICMRecipe (Config)

+ (NSArray *)selectRecipesWithRecipeObjectID:(NSInteger)objectID inManagedObjectContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *searchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([self class])];
  searchRequest.predicate = [NSPredicate predicateWithFormat:@"recipeObjectID = %d", objectID];

  NSError *error = nil;
  NSArray *foundRecipes = [context executeFetchRequest:searchRequest error:&error];

  return foundRecipes;
}

+ (ICMRecipe *)recipeWithResponseObject:(NSDictionary *)responseObject inManagedObjectContext:(NSManagedObjectContext *)context
{
  ICMRecipe *recipe = nil;
  NSInteger objectID = [[responseObject objectForKey:@"id"] integerValue];
  NSArray *foundRecipes = [self selectRecipesWithRecipeObjectID:objectID inManagedObjectContext:context];

  switch ([foundRecipes count]) {
    case 0: {
      // recipe not found, create a new one
      recipe = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class])
                                             inManagedObjectContext:context];
      recipe.recipeObjectID = [NSNumber numberWithInteger:objectID];

      recipe.name = [responseObject objectForKey:@"name"];
      recipe.recipeDescription = [responseObject objectForKey:@"description"];
      recipe.tips = [responseObject objectForKey:@"tips"];
      recipe.url = [responseObject objectForKey:@"url"];

      // setup statistics
      NSInteger favoritesCount = [[responseObject objectForKey:@"favorites_count"] integerValue];
      NSInteger likesCont = [[responseObject objectForKey:@"likes_count"] integerValue];
      NSInteger dishesCount = [[responseObject objectForKey:@"dishes_count"] integerValue];
      NSInteger viewsCount = [[responseObject objectForKey:@"views_count"] integerValue];
      float ranking = [[responseObject objectForKey:@"dishes_count"] floatValue];
      BOOL hasDoneByLoginUser = [[responseObject objectForKey:@"done_by_login_user"] isEqualToString:@"yes"];
      BOOL isFavoritedByUser = [[responseObject objectForKey:@"favorited_by_login_user"] isEqualToString:@"yes"];

      recipe.favoritesCount = [NSNumber numberWithInteger:favoritesCount];
      recipe.likesCount = [NSNumber numberWithInteger:likesCont];
      recipe.dishesCount = [NSNumber numberWithInteger:dishesCount];
      recipe.viewsCount = [NSNumber numberWithInteger:viewsCount];
      recipe.ranking = [NSNumber numberWithFloat:ranking];
      recipe.hasDoneByLoginUser = [NSNumber numberWithBool:hasDoneByLoginUser];
      recipe.isFavoritedByUser = [NSNumber numberWithBool:isFavoritedByUser];

      // link user
      // MARK: responseObject does not contain facebookUID, use username for practice
      NSDictionary *userObject = [responseObject objectForKey:@"user"];
      recipe.user = [ICMUser userWithResponseObject:userObject inManagedObjectContext:context];

      // TODO: link photos
      NSDictionary *photoObject = [responseObject objectForKey:@"cover_pictures"];
      ICMPhoto *photo = [ICMPhoto photoWithResponseObject:photoObject inManagedObjectContext:context];
      [recipe addPhotosObject:photo];

      // save
      NSError *error = nil;
      [context save:&error];
      if (error != nil) {
        NIDPRINT(@"Error %@", [error localizedDescription]);
      }
    }
      break;

    case 1:
      recipe = [foundRecipes lastObject];
      break;
 
    default:
      NIDPRINT(@"Error with recipe objectID in Core Data");
      break;
  }

  return recipe;
}

@end
