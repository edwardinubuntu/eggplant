//
//  EPMYKnowledge.h
//  eggplant
//
//  Created by Ben on 08/02/2013.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EPMYKnowledge : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSDate * askDate;

@end
