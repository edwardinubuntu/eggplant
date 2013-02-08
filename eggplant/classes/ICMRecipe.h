//
//  ICMRecipe.h
//  eggplant
//
//  Created by Ben on 08/02/2013.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ICMIngredient, ICMPhoto, ICMStep, ICMUser;

@interface ICMRecipe : NSManagedObject

@property (nonatomic, retain) NSNumber * commentsCount;
@property (nonatomic, retain) NSNumber * dishesCount;
@property (nonatomic, retain) NSNumber * favoritesCount;
@property (nonatomic, retain) NSNumber * likesCount;
@property (nonatomic, retain) NSNumber * recipeObjectID;
@property (nonatomic, retain) NSNumber * viewsCount;
@property (nonatomic, retain) NSNumber * facebookObjectID;
@property (nonatomic, retain) NSNumber * ranking;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * recipeDescription;
@property (nonatomic, retain) NSString * tips;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * hasDoneByLoginUser;
@property (nonatomic, retain) NSNumber * isFavoritedByUser;
@property (nonatomic, retain) ICMUser *user;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) NSSet *ingredients;
@property (nonatomic, retain) NSSet *steps;
@end

@interface ICMRecipe (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(ICMPhoto *)value;
- (void)removePhotosObject:(ICMPhoto *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

- (void)addIngredientsObject:(ICMIngredient *)value;
- (void)removeIngredientsObject:(ICMIngredient *)value;
- (void)addIngredients:(NSSet *)values;
- (void)removeIngredients:(NSSet *)values;

- (void)addStepsObject:(ICMStep *)value;
- (void)removeStepsObject:(ICMStep *)value;
- (void)addSteps:(NSSet *)values;
- (void)removeSteps:(NSSet *)values;

@end
