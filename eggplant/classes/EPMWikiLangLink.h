//
//  EPMWikiLangLink.h
//  eggplant
//
//  Created by Ben on 08/02/2013.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EPMWikiTerm;

@interface EPMWikiLangLink : NSManagedObject

@property (nonatomic, retain) NSString * lang;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) EPMWikiTerm *term;

@end
