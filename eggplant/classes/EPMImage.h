//
//  EPMImage.h
//  eggplant
//
//  Created by Ben on 08/02/2013.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EPMInstagram;

@interface EPMImage : NSManagedObject

@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSString * imageType;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) EPMInstagram *instagram;

@end
