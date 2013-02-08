//
//  ICMStep.h
//  eggplant
//
//  Created by Ben on 08/02/2013.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ICMRecipe;

@interface ICMStep : NSManagedObject

@property (nonatomic, retain) ICMRecipe *recipe;

@end
