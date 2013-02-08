//
//  ICMIngredient.h
//  eggplant
//
//  Created by Ben on 08/02/2013.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ICMRecipe;

@interface ICMIngredient : NSManagedObject

@property (nonatomic, retain) NSNumber * ingredientObjectID;
@property (nonatomic, retain) NSString * group;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * quantity;
@property (nonatomic, retain) NSNumber * hasPurchased;
@property (nonatomic, retain) NSSet *recipes;
@end

@interface ICMIngredient (CoreDataGeneratedAccessors)

- (void)addRecipesObject:(ICMRecipe *)value;
- (void)removeRecipesObject:(ICMRecipe *)value;
- (void)addRecipes:(NSSet *)values;
- (void)removeRecipes:(NSSet *)values;

@end
