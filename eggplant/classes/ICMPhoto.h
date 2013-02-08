//
//  ICMPhoto.h
//  eggplant
//
//  Created by Ben on 08/02/2013.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ICMRecipe;

@interface ICMPhoto : NSManagedObject

@property (nonatomic, retain) NSString * largeURL;
@property (nonatomic, retain) NSString * mediumURL;
@property (nonatomic, retain) NSString * smallURL;
@property (nonatomic, retain) NSString * squareURL;
@property (nonatomic, retain) ICMRecipe *recipe;

@end
