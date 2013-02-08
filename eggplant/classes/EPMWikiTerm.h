//
//  EPMWikiTerm.h
//  eggplant
//
//  Created by Ben on 08/02/2013.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EPMWikiLangLink;

@interface EPMWikiTerm : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *langLinks;
@end

@interface EPMWikiTerm (CoreDataGeneratedAccessors)

- (void)addLangLinksObject:(EPMWikiLangLink *)value;
- (void)removeLangLinksObject:(EPMWikiLangLink *)value;
- (void)addLangLinks:(NSSet *)values;
- (void)removeLangLinks:(NSSet *)values;

@end
