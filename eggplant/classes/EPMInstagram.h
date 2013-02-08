//
//  EPMInstagram.h
//  eggplant
//
//  Created by Ben on 08/02/2013.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EPMImage;

@interface EPMInstagram : NSManagedObject

@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *images;
@end

@interface EPMInstagram (CoreDataGeneratedAccessors)

- (void)addImagesObject:(EPMImage *)value;
- (void)removeImagesObject:(EPMImage *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
